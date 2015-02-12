if [ -f run.sh]
then
rm run.sh
fi
cat >run.sh <<EOF
#!/bin/bash
echo "DB_PORT_3306_TCP_ADDR"
env
echo \$DB_PORT
echo \$DB_PORT_3306_TCP_ADDR
socat TCP-LISTEN:23306 TCP:\$DB_PORT_3306_TCP_ADDR:3306 &
#socat TCP-LISTEN:3306 TCP:172.17.0.33:3306 &
env
#cd tmsservice
mvn clean install -Dmaven.repo.local=/myrepo
EOF
if [ -f Dockerfile ]
then 
rm Dockerfile
fi
cat >Dockerfile <<EOF
FROM dockerfile/java:oracle-java7
run apt-get update
run apt-get -y install maven
run apt-get -y install socat
ADD . /tms2
WORKDIR /tms2
#CMD ["mvn","clean","install","-Dmaven.repo.local=/myrepo"]
CMD ["sh","run.sh"]
EOF
ls
docker build -t aadebuger/tms2 .
docker rm -f tms2d || echo "hello"
docker run --rm --name=tms2d --link=mysql0:db -v /home/vagrant/myrepo:/myrepo --rm aadebuger/tms2
