Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.siberianet.ru ([89.105.136.7])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wmn@siberianet.ru>) id 1K5q1e-00017R-FO
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 00:39:43 +0200
Received: from mail.siberianet.ru (mail.siberianet.ru [89.105.136.7])
	by mail.siberianet.ru (Postfix) with ESMTP id 6651A1DE44A
	for <linux-dvb@linuxtv.org>; Tue, 10 Jun 2008 06:39:06 +0800 (KRAST)
Received: from pppoe-192-5.siberianet.ru (pppoe-192-5.siberianet.ru
	[172.31.192.5])
	by mail.siberianet.ru (Postfix) with ESMTP id C9C7E1DE1DF
	for <linux-dvb@linuxtv.org>; Tue, 10 Jun 2008 06:39:05 +0800 (KRAST)
To: linux-dvb@linuxtv.org
Content-Disposition: inline
From: Wmn <wmn@siberianet.ru>
Date: Tue, 10 Jun 2008 06:32:22 +0800
MIME-Version: 1.0
Message-Id: <200806100632.23804.wmn@siberianet.ru>
Subject: [linux-dvb] Scan does not tune to transponder and scans only on
	previously tuned frontend
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello.

I have got CR+CL+KUHV LNB on the DVB-S dish looking to the Yamal 201 at 90*, and there are 3 different cables go down to my server from that dish (one cable to one lnb type).
When i am trying to scan channels  from "4084 R 2500" it does not scan, but it scans perfectly from "4042 R 8681".

And when i am szapping to some channel from 4084 it is scanning fine too at the same time (but polarization is dumped wrong for some reason which i can not understand)!

Szap shows very good parameters of signal (too good to be true i think:):
sat 0, frequency = 4084 MHz V, symbolrate 2500000, vpid = 0x0000, apid = 0x1001
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 03 | signal 97.79% | snr 43.95% | ber 00000000 | unc 00000000 |
status 03 | signal 100.00% | snr 58.75% | ber 00000000 | unc 00000000 |
status 1f | signal 100.00% | snr 70.75% | ber 00000113 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 100.00% | snr 71.66% | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 100.00% | snr 72.57% | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 100.00% | snr 72.45% | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 100.00% | snr 71.90% | ber 00000000 | unc 00000000 | FE_HAS_LOCK

Here is output from scan when i am trying to scan to previously tuned frontend:
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
0x0000 0x0015: pmt_pid 0x0be4 NetService -- SILVER (running)
0x0000 0x0016: pmt_pid 0x0be7 NetService -- Record-2 (running)
0x0000 0x0019: pmt_pid 0x0bfa NetService -- Business FM (running)
0x0000 0x001a: pmt_pid 0x0bfc NetService -- 107-8 (running)
0x0000 0x001b: pmt_pid 0x0bfe NetService -- Pomestnoe (running)
0x0000 0x001c: pmt_pid 0x0c00 NetService -- Resurs-2 (running)
0x0000 0x001d: pmt_pid 0x0c02 NetService -- DOPO*HOE (running)
0x0000 0x001e: pmt_pid 0x0c04 NetService -- Energia (running)
0x0000 0x0020: pmt_pid 0x0c08 NetService -- Avtoradio (running)
0x0000 0x0023: pmt_pid 0x0c1a NetService -- Shanson (running)
0x0000 0x0024: pmt_pid 0x0be2 NetService -- Radio Alla (running)
0x0000 0x0025: pmt_pid 0x0be5 NetService -- Mayak (running)
0x0000 0x0027: pmt_pid 0x0be3 NetService -- Radio Record (running)
0x0000 0x002a: pmt_pid 0x0be6 NetService -- FINAM FM (running)
0x0000 0x0039: pmt_pid 0x0be0 NetService -- Humor FM (running)
0x0000 0x003a: pmt_pid 0x0be1 NetService -- G.2 (running)
Network Name 'NetworkService'
dumping lists (16 services)
SILVER:4084:h:S90.0E:22500:0:4097:0:0:21:0:0:0
Record-2:4084:h:S90.0E:22500:0:4099:0:0:22:0:0:0
Business FM:4084:h:S90.0E:22500:0:4130:0:0:25:0:0:0
107-8:4084:h:S90.0E:22500:0:4136:0:0:26:0:0:0
DOPO*HOE:4084:h:S90.0E:22500:0:4168:0:0:29:0:0:0
Energia:4084:h:S90.0E:22500:0:4122:0:0:30:0:0:0
Avtoradio:4084:h:S90.0E:22500:0:4200:0:0:32:0:0:0
Shanson:4084:h:S90.0E:22500:0:4108:0:0:35:0:0:0
Radio Alla:4084:h:S90.0E:22500:0:4106:0:0:36:0:0:0
Mayak:4084:h:S90.0E:22500:0:4212:0:0:37:0:0:0
FINAM FM:4084:h:S90.0E:22500:0:4104:0:0:42:0:0:0
G.2:4084:h:S90.0E:22500:0:4102:0:0:58:0:0:0
Radio Record:4084:h:S90.0E:22500:0:4154:0:0:39:0:0:0
Humor FM:4084:h:S90.0E:22500:0:4151:0:0:57:0:0:0
Pomestnoe:4084:h:S90.0E:22500:0:4150:0:0:27:0:0:0
Resurs-2:4084:h:S90.0E:22500:0:4160:0:0:28:0:0:0
Done.

Here is content of initial tuning data file for scan:
S 4084000 R 2500000 AUTO
and here is line from channels file for szap:
SILVER:4084:v:S0.0W:2500::4097:0:0:21:0:0:0

Here is output of scan utility when i was trying to scan on did not tuned frontend:
...when i was going to get output from scan it returned me some interesting results (first time from many hours of different tries):
scanning ./YAMAL_CR4084
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 4084000 R 2500000 9
>>> tune to: 4084:v:0:2500
0x0000 0x0015: pmt_pid 0x0be4 NetService -- SILVER (running)
0x0000 0x0016: pmt_pid 0x0be7 NetService -- Record-2 (running)
0x0000 0x0019: pmt_pid 0x0bfa NetService -- Business FM (running)
0x0000 0x001a: pmt_pid 0x0bfc NetService -- 107-8 (running)
0x0000 0x001b: pmt_pid 0x0bfe NetService -- Pomestnoe (running)
0x0000 0x001c: pmt_pid 0x0c00 NetService -- Resurs-2 (running)
0x0000 0x001d: pmt_pid 0x0c02 NetService -- DOPO*HOE (running)
0x0000 0x001e: pmt_pid 0x0c04 NetService -- Energia (running)
0x0000 0x0020: pmt_pid 0x0c08 NetService -- Avtoradio (running)
0x0000 0x0023: pmt_pid 0x0c1a NetService -- Shanson (running)
0x0000 0x0024: pmt_pid 0x0be2 NetService -- Radio Alla (running)
0x0000 0x0025: pmt_pid 0x0be5 NetService -- Mayak (running)
0x0000 0x0027: pmt_pid 0x0be3 NetService -- Radio Record (running)
0x0000 0x002a: pmt_pid 0x0be6 NetService -- FINAM FM (running)
0x0000 0x0039: pmt_pid 0x0be0 NetService -- Humor FM (running)
0x0000 0x003a: pmt_pid 0x0be1 NetService -- G.2 (running)
Network Name 'NetworkService'
>>> tune to: 11514:h:0:7600
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 22 Invalid argument
>>> tune to: 11514:h:0:7600
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 22 Invalid argument
>>> tune to: 12073:h:0:5500
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 22 Invalid argument
>>> tune to: 12073:h:0:5500
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 22 Invalid argument
>>> tune to: 11111:h:0:2500
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 22 Invalid argument
>>> tune to: 11111:h:0:2500
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 22 Invalid argument
dumping lists (16 services)
SILVER:4084:h:0:22500:0:4097:21
Record-2:4084:h:0:22500:0:4099:22
Business FM:4084:h:0:22500:0:4130:25
107-8:4084:h:0:22500:0:4136:26
DOPO*HOE:4084:h:0:22500:0:4168:29
Energia:4084:h:0:22500:0:4122:30
Avtoradio:4084:h:0:22500:0:4200:32
Shanson:4084:h:0:22500:0:4108:35
Radio Alla:4084:h:0:22500:0:4106:36
Mayak:4084:h:0:22500:0:4212:37
FINAM FM:4084:h:0:22500:0:4104:42
G.2:4084:h:0:22500:0:4102:58
Radio Record:4084:h:0:22500:0:4154:39
Humor FM:4084:h:0:22500:0:4151:57
Pomestnoe:4084:h:0:22500:0:4150:27
Resurs-2:4084:h:0:22500:0:4160:28
Done.

...and then lots of such messages again:
scanning ./YAMAL_CR4084
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 4084000 R 2500000 9
>>> tune to: 4084:v:0:2500
WARNING: >>> tuning failed!!!
>>> tune to: 4084:v:0:2500 (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.


Why is scan trying to tune to Ku-H at some moment? Don't really understand that...
Any ideas?

---
Thanks,
Wmn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
