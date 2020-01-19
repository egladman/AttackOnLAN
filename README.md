# AttackOnLAN

Proof of concept denial-of-service (DoS) utility intended to give a user an unfair competitive advantage in online multiplayer games. By over loading the target host with frivolous UDP requests at varying intervals we can momentarily increase latency and induce rubber banding. Similar results can be achieved with a physical lag switch.

> Rubber banding is a term that's used to refer to a player's random or sporadic jerky movement during a multiplayer game if they're experiencing high latency. This happens more in certain games than others, but it is most noticeable in FPSs or similar games with a large number of people per multiplayer server. It is particularly prevalent in MMOs - the large number of players means there are more cases of rubber banding; either the server is overloaded or players have high ping. When rubber banding occurs, the player's character appears to rebound forwards and backwards very jerkily, as the server tries to calculate their position based on the high latency data they're transmitting. It is called rubber banding because it looks like the character is caught in a rubber band, being pulled and bounced forwards and backwards, appearing to be in one position one moment, then teleporting several metres away the next.

<!-- https://gaming.stackexchange.com/questions/250261/what-is-rubber-banding -->

## Why I Wrote This

I got bored one night...

## Dependencies

- `hping3`

**Note: ** Only tested on Fedora

## How to Use

### Format
```
./flood.sh <host> <ports> <interval>
```

**Note:** `interval` is optional. The script will run indefinitely if an `interval` argument isn't passed in.

### Example
```
./flood.sh 192.168.0.258 53,88,500,3074,3544,4500 30
```
<!-- As per https://beta.support.xbox.com/help/Hardware-Network/connect-network/network-ports-used-xbox-live Xbox uses the following UDP ports -->

#### Explanation

Flood ip: `192.168.0.258` on ports: `53,88,500,3074,3544,4500` for `30` seconds

## Things to Consider

1. We're performing a denial-of-service attack with a very limited scope. Unlike other UDP flood implementations we aren't focused on staying anonymized since we own the local network, therefore we don't bother with spoofing the IP address in the UDP packet.

    > A UDP flood does not exploit any vulnerability. The aim of UDP floods is simply creating and sending large amount of UDP datagrams from spoofed IP’s to the target server. When a server receives this type of traffic, it is unable to process every request and it consumes its bandwidth with sending ICMP “destination unreachable” packets.

<!-- https://pentest.blog/how-to-perform-ddos-test-as-a-pentester/ -->


2. hping3 requires elevated privileges. So you'll need to run `flood.sh` with sudo. Otherwise the following will be returned:
```
[open_sockraw] socket(): Operation not permitted
[main] can't open raw socket
```

3. You can use nmap to list/discover IPs on your network: 
```
nmap -sn 192.168.1.0/24
```

## Disclaimer

Use of this software could lead to the report/ban of your game account since this is considered cheating. Use at your own risk. With that said it's difficult for game clients to discern the difference between malicious intent and a bad internet connection.

I've personally tested this project against the following games in **private** matches:

- Rocket League - Xbox One, Switch
- Modern Warfare - Xbox One
