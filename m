Return-path: <linux-media-owner@vger.kernel.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]:57632 "EHLO
	shogun.pilppa.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750860AbZAYXsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 18:48:52 -0500
Date: Mon, 26 Jan 2009 01:48:19 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: linux-media@vger.kernel.org
cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use scan-s2?
In-Reply-To: <c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org>
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de>
 <c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I also run it with "-5".
> I personaly don't like to use network advertisements (-n switch) since I
> don't trust them.
> I use a full frequency filled INI file.

Hi

It might be that the signal is not the best possible for me as I can only 
scan about 500 channels with scan by using a command:
./scan -o vdr -a 1 Astra-19.2E

In Astra-19.2E I have single line:
#Astra 1KR (19.2E) - 10743.75 H - DVB-S (QPSK) - 22000 5/6 - NID:1 - TID:1051
S 10743750 H 22000000 5/6

However, once scanned the channels like eurosport, arte, skynews, cnn 
international shows up just fine with vdr-1.6.0.

But if I try to use the same Astra-19.2E file with scan-s2, it can only 
find the channels from frequency 10743750 if I have stopped the "scan" 
after it had found those channels... If I let the scan to run in the end 
to other frequencies, then scan-s2 can not find anything...

./scan-s2 -a 1 -5 -n Astra-19.2E

Propably Klaus Schmidinger reported something related with his TT-3200 in
http://www.mail-archive.com/vdr@linuxtv.org/msg08493.html
I have however hvr-4000.

To prove how it goes, here is the tuning log for 4 different runs.
1) scan when allowed it to swich to other frequence after tuning 
channels from 10643750
2) scan-s2 run after that (no channels found)
3) scan when stopping it immediately after it has found channels from 
10643750
4) scan-s2 after that (now it found correctly all 5 channels that are 
repoted to be in 10543750, but failed to tune from other freqs)

1)
[lamikr@tinka scan]$ ./scan -a 1 Astra-19.2E
scanning Astra-19.2E
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
initial transponder 10743750 H 22000000 5
>>> tune to: 10743:h:0:22000
DVB-S IF freq is 993750
0x0000 0x7031: pmt_pid 0x0000 ARD -- EinsExtra (running)
0x0000 0x7032: pmt_pid 0x0000 ARD -- EinsFestival (running)
0x0000 0x7033: pmt_pid 0x0000 ARD -- EinsPlus (running)
0x0000 0x7034: pmt_pid 0x0000 ARD -- arte (running)
0x0000 0x7035: pmt_pid 0x0000 ARD -- Phoenix (running)
Network Name 'ASTRA'
>>> tune to: 12692:h:0:22000
DVB-S IF freq is 2092250
0x045d 0x32c9: pmt_pid 0x03e9 ORF -- ORF1 (running, scrambled)
0x045d 0x32ca: pmt_pid 0x03ea ORF -- ORF2 (running, scrambled)
0x045d 0x32cb: pmt_pid 0x03f3 ORF -- ORF2 W (running, scrambled)
0x045d 0x32cc: pmt_pid 0x03f4 ORF -- ORF2 N (running, scrambled)
0x045d 0x32cd: pmt_pid 0x03f5 ORF -- ORF2 B (running, scrambled)
0x045d 0x32ce: pmt_pid 0x03f6 ORF -- ORF2 O (running, scrambled)
0x045d 0x32cf: pmt_pid 0x03f7 ORF -- ORF2 S (running, scrambled)
0x045d 0x32d0: pmt_pid 0x03f8 ORF -- ORF2 T (running, scrambled)
0x045d 0x32d1: pmt_pid 0x03f9 ORF -- ORF2 V (running, scrambled)
0x045d 0x32d2: pmt_pid 0x03fa ORF -- ORF2 St (running, scrambled)
0x045d 0x32d3: pmt_pid 0x03fb ORF -- ORF2 K (running, scrambled)
0x045d 0x32d4: pmt_pid 0x03fc ATV+ -- ATV+ (running, scrambled)
0x045d 0x32d5: pmt_pid 0x03eb ORF -- HITRADIO OE3 (running)
0x045d 0x32d6: pmt_pid 0x03ec ORF -- ORF2E (running)
0x045d 0x32d9: pmt_pid 0x03ef arena -- Bundesliga 5 (not running, 
scrambled)
0x045d 0x32da: pmt_pid 0x03f0 arena -- Bundesliga 6 (not running, 
scrambled)
0x045d 0x3390: pmt_pid 0x04b0 ORF -- AlphaCrypt (running)
0x045d 0x339a: pmt_pid 0x04ba ORS -- Siemens Download (running)
0x045d 0x33a4: pmt_pid 0x0000 ORF -- VESTEL OAD2 (running)
0x045d 0x33ae: pmt_pid 0x04ce ORF -- VESTEL DOWNLOAD (running)
^CERROR: interrupted by SIGINT, dumping partial result...
dumping lists (25 services)
...

2) [lamikr@tinka scan-s2]$ ./scan-s2 -a 1 
/home/lamikr/dvb/apps/dvb-apps_20090126/util/scan/Astra-19.2E
API major 5, minor 0
scanning /home/lamikr/dvb/apps/dvb-apps_20090126/util/scan/Astra-19.2E
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
initial transponder DVB-S2 10743750 H 22000000 5/6 AUTO AUTO
initial transponder DVB-S  10743750 H 22000000 5/6 AUTO AUTO
----------------------------------> Using DVB-S2
>>> tune to: 10743:hC56S1:S0.0W:22000:
DVB-S IF freq is 993750
WARNING: >>> tuning failed!!!
>>> tune to: 10743:hC56S1:S0.0W:22000: (tuning failed)
DVB-S IF freq is 993750
WARNING: >>> tuning failed!!!
----------------------------------> Using DVB-S
>>> tune to: 10743:hC56S0:S0.0W:22000:
DVB-S IF freq is 993750
WARNING: >>> tuning failed!!!
>>> tune to: 10743:hC56S0:S0.0W:22000: (tuning failed)
DVB-S IF freq is 993750
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

3) [lamikr@tinka scan]$ ./scan -a 1 Astra-19.2E
scanning Astra-19.2E
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
initial transponder 10743750 H 22000000 5
>>> tune to: 10743:h:0:22000
DVB-S IF freq is 993750
0x0000 0x7031: pmt_pid 0x0064 ARD -- EinsExtra (running)
0x0000 0x7032: pmt_pid 0x00c8 ARD -- EinsFestival (running)
0x0000 0x7033: pmt_pid 0x012c ARD -- EinsPlus (running)
0x0000 0x7034: pmt_pid 0x0190 ARD -- arte (running)
0x0000 0x7035: pmt_pid 0x01f4 ARD -- Phoenix (running)
^X^CERROR: interrupted by SIGINT, dumping partial result...
dumping lists (5 services)
EinsExtra:10743:h:0:22000:101:102:28721
EinsFestival:10743:h:0:22000:201:202:28722
EinsPlus:10743:h:0:22000:301:302:28723
arte:10743:h:0:22000:401:402:28724
Phoenix:10743:h:0:22000:501:502:28725
Done.

4) [lamikr@tinka scan-s2]$ ./scan-s2 -a 1 
/home/lamikr/dvb/apps/dvb-apps_20090126/util/scan/Astra-19.2E
API major 5, minor 0
scanning /home/lamikr/dvb/apps/dvb-apps_20090126/util/scan/Astra-19.2E
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
initial transponder DVB-S2 10743750 H 22000000 5/6 AUTO AUTO
initial transponder DVB-S  10743750 H 22000000 5/6 AUTO AUTO
----------------------------------> Using DVB-S2
>>> tune to: 10743:hC56S1:S0.0W:22000:
DVB-S IF freq is 993750
>>> parse_section, section number 0 out of 0...!
service_id = 0x0
service_id = 0x7031
pmt_pid = 0x64
service_id = 0x7032
pmt_pid = 0xC8
service_id = 0x7033
pmt_pid = 0x12C
service_id = 0x7034
pmt_pid = 0x190
service_id = 0x7035
pmt_pid = 0x1F4
>>> parse_section, section number 0 out of 0...!
   VIDEO     : PID 0x012D
   AUDIO     : PID 0x012E
   TELETEXT  : PID 0x0130
   OTHER     : PID 0x0172 TYPE 0x05
   OTHER     : PID 0x0173 TYPE 0x0B
   OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
   VIDEO     : PID 0x00C9
   AUDIO     : PID 0x00CA
   TELETEXT  : PID 0x00CC
   OTHER     : PID 0x010E TYPE 0x05
   OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
   VIDEO     : PID 0x0065
   AUDIO     : PID 0x0066
   OTHER     : PID 0x00AA TYPE 0x05
   OTHER     : PID 0x00AB TYPE 0x0B
   OTHER     : PID 0x00AC TYPE 0x05
   OTHER     : PID 0x00AD TYPE 0x0B
   OTHER     : PID 0x00B0 TYPE 0x0C
   OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
   VIDEO     : PID 0x01F5
   AUDIO     : PID 0x01F6
   TELETEXT  : PID 0x01F8
   OTHER     : PID 0x0816 TYPE 0x05
   OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
   VIDEO     : PID 0x0191
   AUDIO     : PID 0x0192
   AUDIO     : PID 0x0193
   TELETEXT  : PID 0x0194
   OTHER     : PID 0x0816 TYPE 0x05
   OTHER     : PID 0x0818 TYPE 0x0B
>>> parse_section, section number 0 out of 0...!
0x041B 0x7031: pmt_pid 0x0064 ARD -- EinsExtra (running)
0x041B 0x7032: pmt_pid 0x00C8 ARD -- EinsFestival (running)
0x041B 0x7033: pmt_pid 0x012C ARD -- EinsPlus (running)
0x041B 0x7034: pmt_pid 0x0190 ARD -- arte (running)
0x041B 0x7035: pmt_pid 0x01F4 ARD -- Phoenix (running)
>>> parse_section, section number 1 out of 1...!
>>> parse_section, section number 0 out of 1...!
Network Name 'ASTRA'
dumping lists (5 services)
EinsExtra;ARD:10743:hC56M2S0:S19.2E:22000:101:102=ger:0:0:28721:1:1051:0
EinsFestival;ARD:10743:hC56M2S0:S19.2E:22000:201:202=ger:204:0:28722:1:1051:0
EinsPlus;ARD:10743:hC56M2S0:S19.2E:22000:301:302=ger:304:0:28723:1:1051:0
arte;ARD:10743:hC56M2S0:S19.2E:22000:401:402=ger,403=fra:404:0:28724:1:1051:0
Phoenix;ARD:10743:hC56M2S0:S19.2E:22000:501:502=ger:504:0:28725:1:1051:0
Done.

Mika
