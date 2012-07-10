Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46446 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab2GJHFG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 03:05:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SoUVM-0000OX-TI
	for linux-media@vger.kernel.org; Tue, 10 Jul 2012 09:05:04 +0200
Received: from bws20.neoplus.adsl.tpnet.pl ([83.29.242.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 09:05:04 +0200
Received: from acc.for.news by bws20.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 09:05:04 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: pctv452e
Date: Tue, 10 Jul 2012 08:39:03 +0200
Message-ID: <79vsc9-dte.ln1@wuwek.kopernik.gliwice.pl>
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl> <4FF77C1B.50406@iki.fi> <l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl> <4FF97DF8.4080208@iki.fi> <n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl> <4FFA996D.9010206@iki.fi> <scerc9-bm6.ln1@wuwek.kopernik.gliwice.pl> <4FFB172A.2070009@iki.fi> <4FFB1900.6010306@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4FFB1900.6010306@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.07.2012 19:46, Antti Palosaari wrote:
>>
>> # tune to channel:
>> szap -r "CHANNEL NAME"
> -r option is important here as it routes stream to /dev/dvb/adapter0/dvr0

done

>> # dump channels from tuned multiplex (if you don't have that command
>> just skip):
>> scandvb -c

marx@wuwek:~/zmaz$ scan -c
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
0x0000 0x10d7: pmt_pid 0x0104 TVN -- TVN (running, scrambled)
0x0000 0x10d8: pmt_pid 0x0105 TVN -- TVN 24 (running, scrambled)
0x0000 0x10d9: pmt_pid 0x0106 TVN -- TVN Siedem (running, scrambled)
0x0000 0x10da: pmt_pid 0x0107 TVN -- nSport (running, scrambled)
0x0000 0x10dc: pmt_pid 0x0109 TVN -- Mango 24 (running)
0x0000 0x10dd: pmt_pid 0x010a ITI -- TTV (running, scrambled)
0x0000 0x10de: pmt_pid 0x010b TVN -- TVN Meteo (running, scrambled)
0x0000 0x10df: pmt_pid 0x010c TVN -- TVN Turbo (running, scrambled)
0x0000 0x10e0: pmt_pid 0x010d TVN -- TVN Style (running, scrambled)
0x0000 0x10e1: pmt_pid 0x010e TVN -- Test (running, scrambled)
0x0000 0x10e2: pmt_pid 0x010f TVN -- TVN CNBC (running, scrambled)
0x0000 0x10ed: pmt_pid 0x0118 TVN -- Test_Radio (running)
0x0000 0x3aca: pmt_pid 0x0101 TVN -- Upload (running)
dumping lists (13 services)
TVN                      (0x10d7) 01: PCR == V   V 0x0200 A 0x028a (pol) 
TT 0x0240 AC3 0x028b SUB 0x1771
TVN 24                   (0x10d8) 01: PCR == V   V 0x0201 A 0x0294 (pol) 
0x0295 (org) SUB 0x177c
TVN Siedem               (0x10d9) 01: PCR == V   V 0x0202 A 0x029e (pol) 
TT 0x0242 AC3 0x029f SUB 0x1772
nSport                   (0x10da) 01: PCR == V   V 0x0203 A 0x02a8 (pol)
Mango 24                 (0x10dc) 01: PCR == V   V 0x0205 A 0x02bc (pol) 
TT 0x0245
TTV                      (0x10dd) 01: PCR == V   V 0x0206 A 0x02c6 (pol) 
TT 0x0246 AC3 0x02c7
TVN Meteo                (0x10de) 01: PCR == V   V 0x0207 A 0x02d0 (pol) 
0x02d1 (org) SUB 0x1782
TVN Turbo                (0x10df) 01: PCR == V   V 0x0208 A 0x02da (pol) 
TT 0x0247 AC3 0x02db SUB 0x1773
TVN Style                (0x10e0) 01: PCR == V   V 0x0209 A 0x02e4 (pol) 
TT 0x0248 AC3 0x02e5 SUB 0x1774
Test                     (0x10e1) 01: PCR == V   V 0x020a A 0x02ee (pol) 
TT 0x0249
TVN CNBC                 (0x10e2) 01: PCR == V   V 0x020b A 0x02f8 (pol)
Test_Radio               (0x10ed) 02: PCR == A            A 0x0320 (eng)
Upload                   (0x3aca) 01: PCR 0x1fff
Done.



> Could be named as scan, dvbscan, scandvb....
>
>> # save tuned channel to file (lets say 20 second):
>> cat /dev/dvb/adapter0/dvr0 > test.ts

> actually seems like ffmpeg could read directly dvr0
> ffmpeg -i /dev/dvb/adapter0/dvr0
> takes ~20 seconds or so until results are shown

marx@wuwek:~/zmaz$ ffmpeg -i /dev/dvb/adapter0/dvr0
p11-kit: couldn't load module: 
/usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so: 
/usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so: cannot open 
shared object file: No such file or directory
ffmpeg version 0.8.3-6:0.8.3-4, Copyright (c) 2000-2012 the Libav developers
   built on Jun 26 2012 07:23:46 with gcc 4.7.1
*** THIS PROGRAM IS DEPRECATED ***
This program is only provided for compatibility and will be removed in a 
future release. Please use avconv instead.
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 5 got 6
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 0 got 1
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 2 got 3
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 5 got 6
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 15 got 0
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 7 got 8
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 11 got 12
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 13 got 14
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 7 got 8
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 15 got 0
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 4 got 5
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 10 got 11
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 2 got 4
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 5 got 3
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 11 got 12
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 14 got 15
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 1 got 2
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 10 got 11
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 1 got 2
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 3 got 1
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 7 got 9
[mpegts @ 0x8cd5900] Continuity check failed for pid 520 expected 10 got 9


>
>> # check if ffmpeg finds video and audio
>> ffmpeg -i test.ts
marx@wuwek:~/zmaz$ ffmpeg -i test.ts
p11-kit: couldn't load module: 
/usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so: 
/usr/lib/i386-linux-gnu/pkcs11/gnome-keyring-pkcs11.so: cannot open 
shared object file: No such file or directory
ffmpeg version 0.8.3-6:0.8.3-4, Copyright (c) 2000-2012 the Libav developers
   built on Jun 26 2012 07:23:46 with gcc 4.7.1
*** THIS PROGRAM IS DEPRECATED ***
This program is only provided for compatibility and will be removed in a 
future release. Please use avconv instead.
test.ts: Invalid data found when processing input


Should I still attach/upload somewhere this test.ts file?


I repeated above procedure for FTA channel:

wuwek:~# szap -n 51 -r
reading channels from file '/root/.szap/channels.conf'
zapping to 51 'Mango 24;TVN':
sat 0, frequency = 11393 MHz V, symbolrate 27500000, vpid = 0x0205, apid 
= 0x02bc sid = 0x0245
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 01e5 | snr 0043 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 01e5 | snr 0043 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK

wuwek:~# scan -c
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
0x0000 0x10d7: pmt_pid 0x0104 TVN -- TVN (running, scrambled)
0x0000 0x10d8: pmt_pid 0x0105 TVN -- TVN 24 (running, scrambled)
0x0000 0x10d9: pmt_pid 0x0106 TVN -- TVN Siedem (running, scrambled)
0x0000 0x10da: pmt_pid 0x0107 TVN -- nSport (running, scrambled)
0x0000 0x10dc: pmt_pid 0x0109 TVN -- Mango 24 (running)
0x0000 0x10dd: pmt_pid 0x010a ITI -- TTV (running, scrambled)
0x0000 0x10de: pmt_pid 0x010b TVN -- TVN Meteo (running, scrambled)
0x0000 0x10df: pmt_pid 0x010c TVN -- TVN Turbo (running, scrambled)
0x0000 0x10e0: pmt_pid 0x010d TVN -- TVN Style (running, scrambled)
0x0000 0x10e1: pmt_pid 0x010e TVN -- Test (running, scrambled)
0x0000 0x10e2: pmt_pid 0x010f TVN -- TVN CNBC (running, scrambled)
0x0000 0x10ed: pmt_pid 0x0118 TVN -- Test_Radio (running)
0x0000 0x3aca: pmt_pid 0x0101 TVN -- Upload (running)
dumping lists (13 services)
TVN                      (0x10d7) 01: PCR == V   V 0x0200 A 0x028a (pol) 
TT 0x0240 AC3 0x028b SUB 0x1771
TVN 24                   (0x10d8) 01: PCR == V   V 0x0201 A 0x0294 (pol) 
0x0295 (org) SUB 0x177c
TVN Siedem               (0x10d9) 01: PCR == V   V 0x0202 A 0x029e (pol) 
TT 0x0242 AC3 0x029f SUB 0x1772
nSport                   (0x10da) 01: PCR == V   V 0x0203 A 0x02a8 (pol)
Mango 24                 (0x10dc) 01: PCR == V   V 0x0205 A 0x02bc (pol) 
TT 0x0245
TTV                      (0x10dd) 01: PCR == V   V 0x0206 A 0x02c6 (pol) 
TT 0x0246 AC3 0x02c7
TVN Meteo                (0x10de) 01: PCR == V   V 0x0207 A 0x02d0 (pol) 
0x02d1 (org) SUB 0x1782
TVN Turbo                (0x10df) 01: PCR == V   V 0x0208 A 0x02da (pol) 
TT 0x0247 AC3 0x02db SUB 0x1773
TVN Style                (0x10e0) 01: PCR == V   V 0x0209 A 0x02e4 (pol) 
TT 0x0248 AC3 0x02e5 SUB 0x1774
Test                     (0x10e1) 01: PCR == V   V 0x020a A 0x02ee (pol) 
TT 0x0249
TVN CNBC                 (0x10e2) 01: PCR == V   V 0x020b A 0x02f8 (pol)
Test_Radio               (0x10ed) 02: PCR == A            A 0x0320 (eng)
Upload                   (0x3aca) 01: PCR 0x1fff
Done.

*** THIS PROGRAM IS DEPRECATED ***
This program is only provided for compatibility and will be removed in a 
future release. Please use avconv instead.
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 15 got 0
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 1 got 2
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 15 got 0
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 2 got 3
[mpegts @ 0x9376900] Continuity check failed for pid 700 expected 7 got 8
[mpegts @ 0x9376900] Continuity check failed for pid 700 expected 9 got 10
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 15 got 0
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 14 got 15
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 7 got 2
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 12 got 13
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 4 got 12
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 13 got 5
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 8 got 9
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 9 got 10
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 4 got 5
[mpegts @ 0x9376900] Continuity check failed for pid 700 expected 1 got 2
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 11 got 12
[mpegts @ 0x9376900] PES packet size mismatch
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 4 got 5
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 10 got 11
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 1 got 11
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 12 got 2
[mpegts @ 0x9376900] Continuity check failed for pid 700 expected 7 got 3
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 4 got 5
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 6 got 8
[mpegts @ 0x9376900] Continuity check failed for pid 700 expected 4 got 7
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 9 got 11
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 12 got 10
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 14 got 15
[mpegts @ 0x9376900] Continuity check failed for pid 700 expected 9 got 12
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 12 got 7
[mpegts @ 0x9376900] Continuity check failed for pid 517 expected 8 got 13


Marx

