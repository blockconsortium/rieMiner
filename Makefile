CFLAGS = -Wall -Wextra -std=c++17 -O3 -fno-pie -D CURL_STATICLIB -I incs/

LIBS   = -static -L libs/ -pthread -ljansson -lcurl -lcrypto -Wl,-Bstatic -lgmpxx -lgmp

all: rieMinerAnd

debug: CFLAGS += -g
debug: rieMinerAnd

rieMinerAnd: main.o Miner.o StratumClient.o GBTClient.o Client.o Stats.o tools.o
	$(CXX) $(CFLAGS) -s -o rieMinerAnd $^ $(LIBS)

main.o: main.cpp main.hpp Miner.hpp StratumClient.hpp GBTClient.hpp Client.hpp Stats.hpp tools.hpp
	$(CXX) $(CFLAGS) -c -o main.o main.cpp

Miner.o: Miner.cpp Miner.hpp
	$(CXX) $(CFLAGS) -c -o Miner.o Miner.cpp

StratumClient.o: StratumClient.cpp
	$(CXX) $(CFLAGS) -c -o StratumClient.o StratumClient.cpp

GBTClient.o: GBTClient.cpp
	$(CXX) $(CFLAGS) -c -o GBTClient.o GBTClient.cpp

Client.o: Client.cpp
	$(CXX) $(CFLAGS) -c -o Client.o Client.cpp

Stats.o: Stats.cpp
	$(CXX) $(CFLAGS) -c -o Stats.o Stats.cpp

tools.o: tools.cpp
	$(CXX) $(CFLAGS) -c -o tools.o tools.cpp

clean:
	rm -rf rieMinerAnd *.o
