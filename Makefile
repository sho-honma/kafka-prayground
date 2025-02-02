TOPIC_NAME   := sample-topic
PORT         := 9092


.PHONY: setup_topics
.PHONY: check_topics
.PHONY: setup_producer
.PHONY: setup_consumer


setup_topics:
	kafka-topics.sh \
		--bootstrap-server broker:$(PORT) \
		--create --topic $(TOPIC_NAME) \
		--partitions 3 replication-factor 1

check_topics:
	kafka-topics.sh \
		--bootstrap-server broker:$(PORT) \
		--describe --topic $(TOPIC_NAME)

setup_producer:
	kafka-console-producer.sh \
		--broker-list broker:$(PORT) \
		--topic $(TOPIC_NAME)

setup_consumer:
	kafka-console-consumer.sh \
		--bootstrap-server broker:$(PORT) \
		--topic $(TOPIC_NAME) \
		--group G1 \
		--from-beginning
