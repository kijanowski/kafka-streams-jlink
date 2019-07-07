package ks.jlink;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.kstream.Consumed;
import org.apache.kafka.streams.kstream.Produced;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

public class App {

    private final static Logger log = LoggerFactory.getLogger(App.class);


    public static void main(String[] args) {
        log.info("starting Kafka Streams Application");

        Properties config = new Properties();
        config.put(StreamsConfig.APPLICATION_ID_CONFIG, "ks-jlink-app-id");
        config.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "host.docker.internal:9092");
        config.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        config.put(StreamsConfig.COMMIT_INTERVAL_MS_CONFIG, 100);
        config.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, 10);

        StreamsBuilder builder = new StreamsBuilder();

        builder
          .stream("inJlinkTopic", Consumed.with(Serdes.String(), Serdes.String()))
          .peek((key, value) -> log.info("Received message: {}", value))
          .filter((key, value) -> "PASS".equals(value))
          .to("outJlinkTopic", Produced.with(Serdes.String(), Serdes.String()));

        KafkaStreams streams = new KafkaStreams(builder.build(), config);
        streams.start();

        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                streams.close();
                log.info("Stream stopped");
            } catch (Exception exc) {
                log.error("Got exception while executing shutdown hook: ", exc);
            }
        }));
    }
}
