FROM openjdk:8-jdk-alpine

RUN apk update && apk -y add unzip wget

WORKDIR /home

RUN wget -O ner.zip http://nlp.stanford.edu/software/stanford-ner-2018-02-27.zip && \
    unzip ner.zip && \
    rm ner.zip && \
    mv stanford-ner-2018-02-27/stanford-ner.jar . && \
    rm -rf stanford-ner-2018-02-27

RUN wget -O models.jar http://nlp.stanford.edu/software/stanford-english-corenlp-2018-02-27-models.jar && \
    jar -xf models.jar && \
    rm models.jar && \
    mv edu/stanford/nlp/models/ner/english.all.3class.caseless.distsim.crf.ser.gz . && \
    rm -rf edu

ENV port=9000 outputFormat=inlineXML NERSERVER_DEBUG=True

EXPOSE $port

CMD java -mx1000m -cp stanford-ner.jar edu.stanford.nlp.ie.NERServer \
    -loadClassifier english.all.3class.caseless.distsim.crf.ser.gz \
    -port $port -outputFormat $outputFormat