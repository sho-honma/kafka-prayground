TOPIC_NAME        := sample-topic
PORT              := 9092
CONSUMER_GROUP    := G1

.PHONY: setup_topics
.PHONY: check_topics
.PHONY: setup_producer
.PHONY: setup_consumer
.PHONY: check_offsets

setup_topics:
	docker exec -it cli bash -c "\
	kafka-topics.sh \
		--bootstrap-server broker:$(PORT) \
		--create --topic $(TOPIC_NAME) \
		--partitions 3 --replication-factor 1 \
	"

check_topics:
	docker exec -it broker bash -c "\
	kafka-topics.sh \
		--bootstrap-server broker:$(PORT) \
		--describe --topic $(TOPIC_NAME) \
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

check_offsets:
	docker exec -it broker bash -c "\
	kafka-consumer-groups.sh \
	   --bootstrap-server broker:$(PORT) \
	   --describe \
	   --group $(CONSUMER_GROUP) \
	"