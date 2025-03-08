TOPIC_NAME        := sample-topic
PORT              := 9092
CONSUMER_GROUP    := G1

.PHONY: setup_topics
.PHONY: check_offsets
.PHONY: check_topics
.PHONY: setup_producer
.PHONY: setup_consumer
.PHONY: setup_connecter


check_topics:
	docker exec -it broker bash -c "\
	kafka-topics.sh \
		--bootstrap-server broker:$(PORT) \
		--describe --topic $(TOPIC_NAME) \
	"

check_offsets:
	docker exec -it broker bash -c "\
	kafka-consumer-groups.sh \
	   --bootstrap-server broker:$(PORT) \
	   --describe \
	   --group $(CONSUMER_GROUP) \
	"

setup_topics:
	docker exec -it broker bash -c "\
	kafka-topics.sh \
		--bootstrap-server broker:$(PORT) \
		--create --topic $(TOPIC_NAME) \
		--partitions 3 --replication-factor 1 \
	"

setup_producer:
	docker exec -it broker bash -c "\
	kafka-console-producer.sh \
		--broker-list broker:$(PORT) \
		--topic $(TOPIC_NAME) \
	"

setup_consumer:
	docker exec -it broker bash -c "\
	kafka-console-consumer.sh \
		--bootstrap-server broker:$(PORT) \
		--topic $(TOPIC_NAME) \
		--group $(CONSUMER_GROUP) \
		--from-beginning \
	"

setup_connecter:
	docker exec -it kafka-connect bash -c '\
	curl -X POST -H "Content-Type: application/json" \
	    --data @/etc/kafka-connect/connect-s3-sink.json \
	    http://localhost:8083/connectors \
	'
