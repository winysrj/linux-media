Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:60225 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaASRUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 12:20:50 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so2592773eaj.21
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 09:20:48 -0800 (PST)
Received: from [127.0.0.1] (abue54.neoplus.adsl.tpnet.pl. [83.8.176.54])
        by mx.google.com with ESMTPSA id j46sm45264143eew.18.2014.01.19.09.20.47
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 19 Jan 2014 09:20:48 -0800 (PST)
Message-ID: <52DC096E.2000208@gmail.com>
Date: Sun, 19 Jan 2014 18:20:46 +0100
From: Marcin Rudzki <m.k.rudzki@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: dvb-usb-dib0700-1.20.fw Issues.
References: <CAC5ubeBq5TSO6UMubE=La8BLktOzy1_1rzR1EothtQ3A14GNbA@mail.gmail.com> <CAC5ubeDhqXYd_c3k30pOSR=Qewp-UJ_Qft9NVkWs-ZWVg6HNMw@mail.gmail.com>
In-Reply-To: <CAC5ubeDhqXYd_c3k30pOSR=Qewp-UJ_Qft9NVkWs-ZWVg6HNMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all

I confirm that there is an issue with dvb_usb_dib0700.ko.

I have Terratec Cinergy DT XS Diversity stick.

So far I've been using modules from kernel coming from Ubuntu (11.04 LTS 
previously, now 12.04 LTS with kernel 3.2.0-58-generic-pae) without 
issues. I'm using MythTV for watching and recording  TV shows.
Few days ago I've bought DVBSky S952 which has drivers based in v4l 
tree. After compiling modules for DVBSky my Terratec DVB-T stick become 
unusable, mostly it can not change channel (no lock) when using MythTV 
0.25+fixes.

Just to be sure that this isuue is related to v4l tree, not only to 
DVBSky version, I've pulled v4l from git and compiled. Below you can 
find the output:
kamikac@MediaServer:~$ dmesg|grep -i dvb
[   10.803975] dvb-usb: found a 'Terratec Cinergy DT XS Diversity' in 
cold state, will try to load a firmware
[   11.425645] dvb-usb: downloading firmware from file 
'dvb-usb-dib0700-1.20.fw'
[   12.288157] dvb-usb: found a 'Terratec Cinergy DT XS Diversity' in 
warm state.
[   12.288430] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[   12.288523] DVB: registering new adapter (Terratec Cinergy DT XS 
Diversity)
[   12.514515] usb 1-1: DVB: registering adapter 4 frontend 0 (DiBcom 
7000PC)...
[   12.678135] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[   12.678266] DVB: registering new adapter (Terratec Cinergy DT XS 
Diversity)
[   12.825514] usb 1-1: DVB: registering adapter 5 frontend 0 (DiBcom 
7000PC)...
[   13.012272] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/rc/rc0/input2
[   13.012386] rc0: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/rc/rc0
[   13.013494] dvb-usb: schedule remote query interval to 50 msecs.
[   13.013503] dvb-usb: Terratec Cinergy DT XS Diversity successfully 
initialized and connected.
[   13.013735] usbcore: registered new interface driver dvb_usb_dib0700

First scan output:
kamikac@MediaServer:~$ scan -x 0 -a 4 -t 1 /usr/share/dvb/dvb-t/pl-Poznan
scanning /usr/share/dvb/dvb-t/pl-Poznan
using '/dev/dvb/adapter4/frontend0' and '/dev/dvb/adapter4/demux0'
initial transponder 490000000 0 9 9 3 1 4 0
initial transponder 522000000 0 9 9 3 1 4 0
initial transponder 618000000 0 9 9 3 1 4 0
 >>> tune to: 
490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x0003: pmt_pid 0x0065 EmiTel -- Polsat (running)
0x0000 0x0004: pmt_pid 0x00c9 EmiTel -- TVN (running)
0x0000 0x0005: pmt_pid 0x012d EmiTel -- TV4 (running)
0x0000 0x0006: pmt_pid 0x0191 EmiTel -- TV Puls (running)
0x0000 0x0017: pmt_pid 0x01f5 EmiTel -- TVN Siedem (running)
0x0000 0x0018: pmt_pid 0x0259 EmiTel -- PULS 2 (running)
0x0000 0x0019: pmt_pid 0x02bd EmiTel -- TV6 (running)
0x0000 0x001a: pmt_pid 0x0321 EmiTel -- Polsat Sport News (running)
Network Name 'EmiTel'
 >>> tune to: 
522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x0001: pmt_pid 0x0065 EmiTel -- TVP1 HD (running)
0x0000 0x001b: pmt_pid 0x012d EmiTel -- ESKA TV (running)
0x0000 0x001c: pmt_pid 0x0191 EmiTel -- TTV (running)
0x0000 0x001d: pmt_pid 0x01f5 EmiTel -- POLO TV (running)
0x0000 0x001e: pmt_pid 0x0259 EmiTel -- ATM Rozrywka (running)
0x0000 0x002d: pmt_pid 0x00c9 EmiTel -- TVP2 (running)
0x0000 0x0023: pmt_pid 0x0dad EmiTel -- TVP Info (running)
Network Name 'Emitel'
 >>> tune to: 
618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x002c: pmt_pid 0x0065 EmiTel -- TVP1 (running)
0x0000 0x0002: pmt_pid 0x00c9 EmiTel -- TVP2 HD (running)
0x0000 0x0012: pmt_pid 0x0709 EmiTel -- TVP Poznan (running)
0x0000 0x001f: pmt_pid 0x0c1d EmiTel -- TVP Kultura (running)
0x0000 0x0021: pmt_pid 0x0ce5 EmiTel -- TVP Polonia (running)
0x0000 0x0022: pmt_pid 0x0d49 EmiTel -- TVP Rozrywka (running)
0x0000 0x0020: pmt_pid 0x0c81 EmiTel -- TVP Historia (running)
Network Name 'NW 04 WIE'
 >>> tune to: 
690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
 >>> tune to: 
690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=818000000
 >>> tune to: 
818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 
818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=794000000
 >>> tune to: 
794000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 
794000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=770000000
 >>> tune to: 
770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
^CERROR: interrupted by SIGINT, dumping partial result...
dumping lists (22 services)
Polsat:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:102:103:3
TVN:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:202:203:4
TV4:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:302:303:5
TV 
Puls:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:402:403:6
TVN 
Siedem:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:502:503:23
PULS 
2:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:602:603:24
TV6:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:702:703:25
Polsat Sport 
News:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:802:803:26
TVP1 
HD:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:102:103:1
ESKA 
TV:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:302:303:27
TTV:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:402:403:28
POLO 
TV:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:502:503:29
ATM 
Rozrywka:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:602:603:30
TVP 
Info:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3502:3503:35
TVP2:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:202:203:45
TVP1:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:102:103:44
TVP2 
HD:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:202:203:2
TVP 
Poznan:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:1802:1803:18
TVP 
Kultura:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:402:403:31
TVP 
Polonia:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:602:603:33
TVP 
Rozrywka:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:3402:3403:34
TVP 
Historia:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:502:503:32
Done.

Second scan output:
kamikac@MediaServer:~$ scan -x 0 -a 4 -t 1 /usr/share/dvb/dvb-t/pl-Poznan
scanning /usr/share/dvb/dvb-t/pl-Poznan
using '/dev/dvb/adapter4/frontend0' and '/dev/dvb/adapter4/demux0'
initial transponder 490000000 0 9 9 3 1 4 0
initial transponder 522000000 0 9 9 3 1 4 0
initial transponder 618000000 0 9 9 3 1 4 0
 >>> tune to: 
490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x0001: pmt_pid 0x0065 EmiTel -- TVP1 HD (running)
0x0000 0x001b: pmt_pid 0x012d EmiTel -- ESKA TV (running)
0x0000 0x001c: pmt_pid 0x0191 EmiTel -- TTV (running)
0x0000 0x001d: pmt_pid 0x01f5 EmiTel -- POLO TV (running)
0x0000 0x001e: pmt_pid 0x0259 EmiTel -- ATM Rozrywka (running)
0x0000 0x002d: pmt_pid 0x00c9 EmiTel -- TVP2 (running)
0x0000 0x0023: pmt_pid 0x0dad EmiTel -- TVP Info (running)
Network Name 'Emitel'
 >>> tune to: 
522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x0001: pmt_pid 0x0000 EmiTel -- TVP1 HD (running)
0x0000 0x001b: pmt_pid 0x0000 EmiTel -- ESKA TV (running)
0x0000 0x001c: pmt_pid 0x0000 EmiTel -- TTV (running)
0x0000 0x001d: pmt_pid 0x0000 EmiTel -- POLO TV (running)
0x0000 0x001e: pmt_pid 0x0000 EmiTel -- ATM Rozrywka (running)
0x0000 0x002d: pmt_pid 0x0000 EmiTel -- TVP2 (running)
0x0000 0x0023: pmt_pid 0x0000 EmiTel -- TVP Info (running)
Network Name 'Emitel'
 >>> tune to: 
618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
0x0000 0x002c: pmt_pid 0x0065 EmiTel -- TVP1 (running)
0x0000 0x0002: pmt_pid 0x00c9 EmiTel -- TVP2 HD (running)
0x0000 0x0012: pmt_pid 0x0709 EmiTel -- TVP Poznan (running)
0x0000 0x001f: pmt_pid 0x0c1d EmiTel -- TVP Kultura (running)
0x0000 0x0021: pmt_pid 0x0ce5 EmiTel -- TVP Polonia (running)
0x0000 0x0022: pmt_pid 0x0d49 EmiTel -- TVP Rozrywka (running)
0x0000 0x0020: pmt_pid 0x0c81 EmiTel -- TVP Historia (running)
Network Name 'NW 04 WIE'
 >>> tune to: 
746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
 >>> tune to: 
746000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=690000000
 >>> tune to: 
690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 
690000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE 
(tuning failed)
^CERROR: interrupted by SIGINT, dumping partial result...
dumping lists (21 services)
TVP1 
HD:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:102:103:1
ESKA 
TV:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:302:303:27
TTV:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:402:403:28
POLO 
TV:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:502:503:29
ATM 
Rozrywka:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:602:603:30
TVP 
Info:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:3502:3503:35
TVP2:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:202:203:45
TVP1 
HD:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:102:103:1
ESKA 
TV:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:302:303:27
TTV:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:402:403:28
POLO 
TV:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:502:503:29
ATM 
Rozrywka:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:602:603:30
TVP2:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:202:203:45
TVP 
Info:522000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:3502:3503:35
TVP1:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:102:103:44
TVP2 
HD:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:202:203:2
TVP 
Poznan:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:1802:1803:18
TVP 
Kultura:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:402:403:31
TVP 
Polonia:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:602:603:33
TVP 
Rozrywka:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:3402:3403:34
TVP 
Historia:618000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:502:503:32
Done.

First output is correct. Second has incorrect scan of second transponder 
(doubled first transponder).
Tuning test (using correct channels.conf):
kamikac@MediaServer:~$ tzap -a 4 -c ./channels.conf "TVP1 HD"
using '/dev/dvb/adapter4/frontend0' and '/dev/dvb/adapter4/demux0'
reading channels from file './channels.conf'
tuning to 490000000 Hz
video pid 0x0066, audio pid 0x0067
status 1f | signal 5573 | snr 00c7 | ber 001fffff | unc 00000016 | 
FE_HAS_LOCK
status 1f | signal 5576 | snr 00ff | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 558b | snr 010e | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 5583 | snr 00ef | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 54ff | snr 00f9 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 554b | snr 0103 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 558b | snr 00f5 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal 556f | snr 00f6 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK

When using MythTV first tuning is most of the time successfull, when 
trying to change channel I got this output on the "lock information": 
_L__ and after few second information that card couldn't lock.
No errors in dmesg during scan or tuning.

I've also tried to apply this patch 
https://patchwork.linuxtv.org/patch/13563/ as mentioned here 
http://code.mythtv.org/trac/ticket/10830. But without success.

I think you are making great job developing drivers for TV cards, 
unfortunately something went wrong and looks like dvb_usb_dib0700 module 
has been broken.

Maybe I should patch and recompile kernel too?

Best regards
Marcin

> I have tried this now on Debian 32 and 64 bit versions with no joy.
> The sticks are fine as they work on Windows 7 perfectly. Any advice?
>
> On 15 January 2014 20:02, Ray Image <imagemagic99@gmail.com> wrote:
>> I have tried a couple of USB sticks which use the
>> dvb-usb-dib0700-1.20.fw firmware in a number of machines running
>> different linux distros (CentOS, Debian and Raspbian) and I simply
>> can't get them to work. I have put dvb-usb-dib0700-1.20.fw in
>> /lib/firmware. Both USB sticks are recognised and loaded (see dmesg
>> below) but won't tune. I have a PCTV 290e which works perfectly.
>>
>> Can anyone please help?
>>
>> Dmesg for Nova-T (this device fails):
>> [  850.170729] usb 1-2: Product: Nova-T Stick
>> [  850.170730] usb 1-2: Manufacturer: Hauppauge
>> [  850.170731] usb 1-2: SerialNumber: 4027796501
>> [  850.181622] dvb-usb: found a 'Hauppauge Nova-T Stick' in cold
>> state, will try to load a firmware
>> [  850.185487] usb 1-2: firmware: agent loaded dvb-usb-dib0700-1.20.fw
>> into memory
>> [  853.291628] dib0700: firmware started successfully.
>> [  853.794138] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
>> [  853.794255] dvb-usb: will pass the complete MPEG2 transport stream
>> to the software demuxer.
>> [  853.795277] DVB: registering new adapter (Hauppauge Nova-T Stick)
>> [  854.350077] DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
>> [  854.359052] MT2060: successfully identified (IF1 = 1220)
>> [  854.999066] dvb-usb: Hauppauge Nova-T Stick successfully
>> initialized and connected.
>>
>> Dmesg for MyTV.t (this device fails):
>> [  505.753256] usb 1-1: Product: myTV.t
>> [  505.753257] usb 1-1: Manufacturer: Eskape Labs
>> [  505.753258] usb 1-1: SerialNumber: 4030928317
>> [  505.861413] dib0700: loaded with support for 21 different device-types
>> [  510.853328] dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in cold
>> state, will try to load a firmware
>> [  510.924679] usb 1-1: firmware: agent loaded dvb-usb-dib0700-1.20.fw
>> into memory
>> [  514.327591] dib0700: firmware started successfully.
>> [  514.830712] dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in warm state.
>> [  514.830796] dvb-usb: will pass the complete MPEG2 transport stream
>> to the software demuxer.
>> [  514.832785] DVB: registering new adapter (Hauppauge Nova-T MyTV.t)
>> [  515.335819] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
>> [  515.789061] DiB0070: successfully identified
>> [  515.789065] dvb-usb: Hauppauge Nova-T MyTV.t successfully
>> initialized and connected.
>> [  515.790175] usbcore: registered new interface driver dvb_usb_dib0700
>>
>> Dmesg for PCTV290e (this device works):
>> [  314.918928] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
>> (2013:024f, interface 0, class 0)
>> [  314.920018] em28xx #0: chip ID is em28174
>> [  315.251613] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
>> [  315.331134] Registered IR keymap rc-pinnacle-pctv-hd
>> [  315.331262] input: em28xx IR (em28xx #0) as
>> /devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/rc/rc0/input6
>> [  315.331726] rc0: em28xx IR (em28xx #0) as
>> /devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/rc/rc0
>> [  315.338297] em28xx #0: v4l2 driver version 0.1.3
>> [  315.408548] em28xx #0: V4L2 video device registered as video0
>> [  315.408572] usbcore: registered new interface driver em28xx
>> [  315.408573] em28xx driver loaded
>> [  315.510762] tda18271 0-0060: creating new instance
>> [  315.540382] TDA18271HD/C2 detected @ 0-0060
>> [  316.283833] tda18271 0-0060: attaching existing instance
>> [  316.283836] DVB: registering new adapter (em28xx #0)
>> [  316.283838] DVB: registering adapter 0 frontend 0 (Sony CXD2820R
>> (DVB-T/T2))...
>> [  316.284044] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
>> [  316.284947] em28xx #0: Successfully loaded em28xx-dvb
>> [  316.284950] Em28xx: Initialized (Em28xx dvb Extension) extension
>>
>> Output of scan for Nova-T and MyTV.t:
>> scanning /usr/share/dvb/dvb-t/uk-Hannington
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 706000000 0 3 9 1 0 0 0
>> initial transponder 650167000 0 2 9 3 0 0 0
>> initial transponder 626167000 0 2 9 3 0 0 0
>> initial transponder 674167000 0 3 9 1 0 0 0
>> initial transponder 658167000 0 3 9 1 0 0 0
>> initial transponder 634167000 0 3 9 1 0 0 0
>>>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 650167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 650167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 626167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 626167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 658167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 658167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 634167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 634167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>> ERROR: initial tuning failed
>> dumping lists (0 services)
>>
>>
>> Output of scan for PCTV290e:
>> root@debian:/dev/dvb# /usr/bin/scan /usr/share/dvb/dvb-t/uk-Hannington
>>> /home/pookerj/channels.conf
>> scanning /usr/share/dvb/dvb-t/uk-Hannington
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 706000000 0 3 9 1 0 0 0
>> initial transponder 650167000 0 2 9 3 0 0 0
>> initial transponder 626167000 0 2 9 3 0 0 0
>> initial transponder 674167000 0 3 9 1 0 0 0
>> initial transponder 658167000 0 3 9 1 0 0 0
>> initial transponder 634167000 0 3 9 1 0 0 0
>>>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 650167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 650167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 626167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 626167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 658167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> 0x0000 0x5740: pmt_pid 0x02c1 (null) -- E4+1 (running)
>> 8<---- SNIP! ---->8
>> 0x0000 0x5b00: pmt_pid 0x02e0 (null) -- Proud Dating (running)
>> Network Name 'Berks & North Hants'
>>>>> tune to: 634167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> 0x0000 0x3340: pmt_pid 0x0000 (null) -- QVC (running)
>> 8<---- SNIP! ---->8
>> 0x0000 0x3e90: pmt_pid 0x0000 (null) -- ITV3+1 (running)
>> Network Name 'Berks & North Hants'
>>>>> tune to: 658000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> 0x5040 0x5740: pmt_pid 0x02c1 (null) -- E4+1 (running)
>> 8<---- SNIP! ---->8
>> 0x5040 0x5b00: pmt_pid 0x02e0 (null) -- Proud Dating (running)
>> Network Name 'Berks & North Hants'
>>>>> tune to: 682000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> Network Name 'Berks & North Hants'
>> 0x6040 0x6440: pmt_pid 0x03e9 (null) -- 4Music (running)
>> 8<---- SNIP! ---->8
>> 0x6040 0x6f40: pmt_pid 0x0418 (null) -- Sonlife (running)
>>>>> tune to: 666000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> 0x1043 0x1043: pmt_pid 0x0064 (null) -- BBC ONE South (running)
>> 8<---- SNIP! ---->8
>> 0x1043 0x1c40: pmt_pid 0x0b54 (null) -- 302 (running)
>> Network Name 'Berks & North Hants'
>>>>> tune to: 642000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> 0x200f 0x204f: pmt_pid 0x06a4 (null) -- ITV (running)
>> 8<---- SNIP! ---->8
>> 0x200f 0x20c1: pmt_pid 0x05dc (null) -- Film4 (running)
>> Network Name 'Berks & North Hants'
>>>>> tune to: 634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
>> Network Name 'Berks & North Hants'
>> 0x3006 0x3340: pmt_pid 0x010b (null) -- QVC (running)
>> 8<---- SNIP! ---->8
>> 0x3006 0x3e90: pmt_pid 0x01ad (null) -- ITV3+1 (running)
>> dumping lists (170 services)
>> Done.
>>


---
Ta wiadomość e-mail jest wolna od wirusów i złośliwego oprogramowania, ponieważ ochrona avast! Antivirus jest aktywna.
http://www.avast.com

