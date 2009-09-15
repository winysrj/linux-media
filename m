Return-path: <linux-media-owner@vger.kernel.org>
Received: from dsl-202-173-134-75.nsw.westnet.com.au ([202.173.134.75]:55673
	"EHLO mail.lemonrind.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZIOKcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 06:32:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lemonrind.net (Postfix) with ESMTP id 808198133CB3
	for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 20:32:34 +1000 (EST)
Received: from mail.lemonrind.net ([127.0.0.1])
	by localhost (jasmin.receptiveit [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q9+X04EWeD9W for <linux-media@vger.kernel.org>;
	Tue, 15 Sep 2009 20:32:33 +1000 (EST)
Received: from [192.168.198.72] (unknown [192.168.198.72])
	(Authenticated sender: alex)
	by mail.lemonrind.net (Postfix) with ESMTPSA id D02758133CAD
	for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 20:32:33 +1000 (EST)
From: Alex Ferrara <alex@receptiveit.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Subject: HVR-2200 Australia DVB-T
Date: Tue, 15 Sep 2009 20:32:33 +1000
Message-Id: <CED52FAC-4C8D-416C-B00E-5662F1F63E85@receptiveit.com.au>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1076)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I decided to try a different card that is reported to work, so I  
bought myself a HVR-2200.

Drivers compiled cleanly. I extracted the firmware and the driver is  
loading well.  The second frontend is showing a little irregular in  
dmesg - (registering adapter 1 frontend -906461813), but otherwise it  
looks good.

Here is an extract out of dmesg
[   34.040118] saa7164_downloadimage() Image downloaded, booting...
[   34.150107] saa7164_downloadimage() Image booted successfully.
[   34.150134] starting firmware download(2)
[   36.490112] saa7164_downloadimage() Image downloaded, booting...
[   37.920114] saa7164_downloadimage() Image booted successfully.
[   37.920142] firmware download complete.
[   37.921063] saa7164[0]: i2c bus 0 registered
[   37.921109] saa7164[0]: i2c bus 1 registered
[   37.921146] saa7164[0]: i2c bus 2 registered
[   37.963260] tveeprom 0-0000: Hauppauge model 89619, rev D2F2,  
serial# 6346393
[   37.963262] tveeprom 0-0000: MAC address is 00-0D-FE-60-D6-99
[   37.963263] tveeprom 0-0000: tuner model is NXP 18271C2_716x (idx  
152, type 4)
[   37.963265] tveeprom 0-0000: TV standards PAL(B/G) NTSC(M) PAL(I)  
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[   37.963267] tveeprom 0-0000: audio processor is SAA7164 (idx 43)
[   37.963268] tveeprom 0-0000: decoder processor is SAA7164 (idx 40)
[   37.963269] tveeprom 0-0000: has radio
[   37.963270] saa7164[0]: Hauppauge eeprom: model=89619
[   38.059508] tda18271 1-0060: creating new instance
[   38.063981] TDA18271HD/C2 detected @ 1-0060
[   38.404874] DVB: registering new adapter (saa7164)
[   38.404876] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN  
DVB-T)...
[   38.433105] tda18271 2-0060: creating new instance
[   38.437225] TDA18271HD/C2 detected @ 2-0060
[   38.784613] tda18271: performing RF tracking filter calibration
[   41.427330] tda18271: RF tracking filter calibration complete
[   41.427482] DVB: registering new adapter (saa7164)
[   41.427484] DVB: registering adapter 1 frontend -906461813 (NXP  
TDA10048HN DVB-T)...
.......
[  292.106142] tda10048_firmware_upload: firmware uploaded
[  292.515795] tda18271: performing RF tracking filter calibration
[  295.157633] tda18271: RF tracking filter calibration complete
[  295.366049] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw 
)...
[  295.366052] i2c-adapter i2c-2: firmware: requesting dvb-fe-tda10048-1.0.fw
[  295.368132] tda10048_firmware_upload: firmware read 24878 bytes.
[  295.368134] tda10048_firmware_upload: firmware uploading
[  298.372533] tda10048_firmware_upload: firmware uploaded
[  371.811330] CE: hpet increasing min_delta_ns to 15000 nsec

Only problem is that I am only seeing channels from one transport.

I have seen that people that are reporting problems with this card  
usually have I2C errors in dmesg, which I don't have. The transport  
that I can tune, is working flawlessly, with all three channels on  
that transport giving a perfect picture and sound.

Here is my initial scanning data. I had to create it myself as I live  
in a rural area. I used a known working card to extract this (Dvico  
Dual Digital 4 PCI)

# Australia / Goulburn / Rocky Hill
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
# ABC
T 725500000 7MHz 3/4 3/4 QAM64 8k 1/16 NONE

# SBS
T 746500000 7MHz 2/3 2/3 QAM64 8k 1/8 NONE

# WIN
T 767500000 7MHz 3/4 3/4 QAM64 8k 1/16 NONE

# Prime
T 788500000 7MHz 3/4 3/4 QAM64 8k 1/16 NONE

# TEN
T 809500000 7MHz 3/4 3/4 QAM64 8k 1/16 NONE

Here is my channels.conf. Again, this was tuned on my known working  
PCI card.

ABC HDTV: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
516:0:672
ABC1 
: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
512:650:673
ABC2 
: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
513:651:674
ABC1 
: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
512:650:675
ABC3 
: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
512:650:676
ABC DiG Radio: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
0:690:678
ABC DiG Jazz: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
0:700:679
SBS ONE: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
161:81:849
SBS TWO: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
162:83:850
SBS  
3 
: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
161:81:851
SBS  
4 
: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
161:81:852
SBS HD: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
102:103:853
SBS Radio  
1 
: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
0:201:862
SBS Radio  
2 
: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
0:202:863
WIN TV Canberra: 
767500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:33:36:1
WIN TV HD: 
767500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:129:0:10
GO!: 
767500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:50:51:2
PRIME Canberra: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2374
PRIME HD: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2400
PRIME View  
1 
: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2401
PRIME View  
2 
: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2402
PRIME View  
3 
: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2403
SC10 Canberra: 
809500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
353:354:2055
One HD Canberra: 
809500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
1711:0:2087
SC Ten: 
809500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
353:354:2119

If I tune channel 10, it works perfectly

root@kaylee:~/.tzap# tzap "SC10 Canberra"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.tzap/channels.conf'
tuning to 809500000 Hz
video pid 0x0161, audio pid 0x0162
status 00 | signal d7d7 | snr 0059 | ber 0000ffff | unc 00000000 |
status 1f | signal e8e8 | snr 006d | ber 00001a17 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal f9f9 | snr 00a8 | ber 00000154 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal fcfc | snr 00c6 | ber 000000e6 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal fdfd | snr 00d7 | ber 00000146 | unc 00000000 |  
FE_HAS_LOCK

But other channels don't work quite as well. This happens on either / 
dev/dvb/adapter0 or /dev/dvb/adapter1.

root@kaylee:~/.tzap# vi channels.conf
root@kaylee:~/.tzap# tzap "SBS ONE"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.tzap/channels.conf'
tuning to 746500000 Hz
video pid 0x00a1, audio pid 0x0051
status 00 | signal 0f0f | snr 0007 | ber 0000ffff | unc 00000000 |
status 00 | signal d9d9 | snr 0058 | ber 0000ffff | unc 00000000 |
status 00 | signal d8d8 | snr 0056 | ber 0000ffff | unc 00000000 |
status 00 | signal d8d8 | snr 0056 | ber 0000ffff | unc 00000000 |
status 00 | signal dada | snr 0059 | ber 0000ffff | unc 00000000 |
root@kaylee:~/.tzap# tzap "ABC2"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.tzap/channels.conf'
tuning to 725500000 Hz
video pid 0x0201, audio pid 0x028b
status 00 | signal 0000 | snr 0005 | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
root@kaylee:~/.tzap# tzap "PRIME Canberra"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.tzap/channels.conf'
tuning to 788500000 Hz
video pid 0x0ab4, audio pid 0x0ab5
status 00 | signal 7c7c | snr 001c | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
root@kaylee:~/.tzap# tzap "WIN TV Canberra"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/root/.tzap/channels.conf'
tuning to 767500000 Hz
video pid 0x0021, audio pid 0x0024
status 00 | signal a9a9 | snr 002e | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |

Any help would be appreciated.

aF


