Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52630 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2AKMYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 07:24:46 -0500
Received: by werm1 with SMTP id m1so465887wer.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 04:24:44 -0800 (PST)
Message-ID: <4F0D7F89.9020309@gmail.com>
Date: Wed, 11 Jan 2012 13:24:41 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Mihai Dobrescu <msdobrescu@gmail.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Hauppauge HVR-930C problems
References: <CALJK-QhGrjC9K8CasrUJ-aisZh8U_4-O3uh_-dq6cNBWUx_4WA@mail.gmail.com> <4EE9AA21.1060101@gmail.com> <CALJK-QjxDpC8Y_gPXeAJaT2si_pRREiuTW=T8CWSTxGprRhfkg@mail.gmail.com> <4EEAFF47.5040003@gmail.com> <CALJK-Qhpk7NtSezrft_6+4FZ7Y35k=41xrc6ebxf2DzEH6KCWw@mail.gmail.com> <4EECB2C2.8050701@gmail.com> <4EECE392.5080000@gmail.com> <CALJK-QjChFbX7NH0qNhvaz=Hp8JfKENJMsLOsETiYO9ZyV_BOg@mail.gmail.com> <4EEDB060.7070708@gmail.com> <4EF747C7.10001@gmail.com> <4F0C4E59.6050503@gmail.com> <CALJK-QiZS1BOzgZz_r1J9rKCHJ0tSgPxAin8g8f8wg3=W76rGA@mail.gmail.com>
In-Reply-To: <CALJK-QiZS1BOzgZz_r1J9rKCHJ0tSgPxAin8g8f8wg3=W76rGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/12 20:30, Mihai Dobrescu wrote:
> Hello,
>
> Just compiled the latest again, but still no difference.
> kaffeine doesn't see any source in channels dialog, two devices are in
> 'Configure Television' dialog: DRXK DVB-C - device not connected - as
> Device 1 and DRXK DVB-C DVB-T as Device 2. Concerning the last one, no
> source is selected, as I am in Romania, which is not in the list
> scan_w finds nothing.
>
> What should I do next?
>
> Regards, Mike.

Mike,

I did some more w_scan and dvbscan tests with the last three releases, 
that is,

http://linuxtv.org/downloads/drivers/linux-media-2012-01-07.tar.bz2,
http://linuxtv.org/downloads/drivers/linux-media-2012-01-08.tar.bz2,
and
http://linuxtv.org/downloads/drivers/linux-media-2012-01-11.tar.bz2

respectively. Using 2012-01-11 scanning don't work and using 2012-01-08 
scanning sort-of works but I need to use 2011-01-07 first, unload it, 
install 2011-01-08, load it (without rebooting) and then I can scan with 
2011-01-08.

w_scan finds significantly fewer channels with the default settings [1] 
than dvbscan [2]. However, I discovered that if I increase the filter 
timout for w_scan then I find much more channels. Try something like,

lin-tv media_build # w_scan -fc -t 3 -Q 1 -S 0 -c NO

The -t, -Q and -S parameters are so called "expert" paramaters (check 
the w_scan man page). Leave out the -Q and -S parameters if you don't 
know the symbol rate and modulation type.

To test it do something like:

lin-tv ~ # cd /usr/src
lin-tv src # git clone git://linuxtv.org/media_build.git
lin-tv src # cd media_build

Then edit the linux/Makefile and change

LATEST_TAR := 
http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
LATEST_TAR_MD5 := 
http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5

to

LATEST_TAR := 
http://linuxtv.org/downloads/drivers/linux-media-2012-01-07.tar.bz2
LATEST_TAR_MD5 := 
http://linuxtv.org/downloads/drivers/linux-media-2012-01-07.tar.bz2.md5

Then build, install, and reload the drivers.

lin-tv media_build # ./build
lin-tv media_build # make unload
lin-tv media_build # make install
lin-tv media_build # make load

You can also try scanning with MythTV. You only need a starting freq 
(and perhaps modulation type, for example I use QAM256). If you have a 
PVR-decoder, maybe you can find the freq. etc info there?

/Fredrik

[1]

lin-tv media_build # w_scan -fc -c NO
w_scan version 20111011 (compiled for DVB API 5.2)
using settings for NORWAY
DVB cable
DVB-C
frontend_type DVB-C, channellist 7
output format vdr-1.6
WARNING: could not guess your codepage. Falling back to 'UTF-8'
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
         /dev/dvb/adapter0/frontend0 -> DVB-C "DRXK DVB-C DVB-T": good :-)
Using DVB-C frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.5
frontend 'DRXK DVB-C DVB-T' supports
INVERSION_AUTO
QAM_AUTO not supported, trying QAM_64 QAM_256.
FEC_AUTO
FREQ (47.00MHz ... 865.00MHz)
SRATE (0.870MBd ... 11.700MBd)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
searching QAM64...
73000: sr6900 (time: 00:00) sr6875 (time: 00:03)
81000: sr6900 (time: 00:05) sr6875 (time: 00:08)
113000: sr6900 (time: 00:10) sr6875 (time: 00:13)
121000: sr6900 (time: 00:15) sr6875 (time: 00:18)
129000: sr6900 (time: 00:20) sr6875 (time: 00:23)
137000: sr6900 (time: 00:26) sr6875 (time: 00:28)
145000: sr6900 (time: 00:31) sr6875 (time: 00:33)
153000: sr6900 (time: 00:36) sr6875 (time: 00:38)
161000: sr6900 (time: 00:41) sr6875 (time: 00:43)
169000: sr6900 (time: 00:46) sr6875 (time: 00:48)
314000: sr6900 (time: 00:51) sr6875 (time: 00:53)
322000: sr6900 (time: 00:56) sr6875 (time: 00:59)

<snip>

858000: sr6900 (time: 06:36) sr6875 (time: 06:39)
searching QAM256...
73000: sr6900 (time: 06:41) sr6875 (time: 06:44)
81000: sr6900 (time: 06:47) sr6875 (time: 06:49)
113000: sr6900 (time: 06:52) sr6875 (time: 06:54)
121000: sr6900 (time: 06:57) sr6875 (time: 06:59)
129000: sr6900 (time: 07:02) sr6875 (time: 07:04)
137000: sr6900 (time: 07:07) sr6875 (time: 07:09)
145000: sr6900 (time: 07:12) sr6875 (time: 07:15)
153000: sr6900 (time: 07:17) sr6875 (time: 07:20)
161000: sr6900 (time: 07:22) sr6875 (time: 07:25)
169000: sr6900 (time: 07:27) sr6875 (time: 07:30)
314000: sr6900 (time: 07:32) (time: 07:33)
sr6875 (time: 07:34)
322000: sr6900 (time: 07:37) (time: 07:38)
sr6875 (time: 07:39)
330000: sr6900 (time: 07:42) (time: 07:43)
sr6875 (time: 07:44)
338000: sr6900 (time: 07:46) (time: 07:48)
sr6875 (time: 07:49)
346000: sr6900 (time: 07:51) (time: 07:52)
sr6875 (time: 07:53)
354000: sr6900 (time: 07:56) (time: 07:57)
sr6875 (time: 07:58)
362000: sr6900 (time: 08:01) (time: 08:02)
sr6875 (time: 08:03)
370000: sr6900 (time: 08:05) (time: 08:06)
sr6875 (time: 08:07)
378000: sr6900 (time: 08:10) (time: 08:11)
sr6875 (time: 08:12)
386000: sr6900 (time: 08:15) (time: 08:16)
sr6875 (time: 08:17)
394000: sr6900 (time: 08:19) sr6875 (time: 08:22)
402000: sr6900 (time: 08:25) sr6875 (time: 08:27)
410000: sr6900 (time: 08:30) sr6875 (time: 08:32)
418000: sr6900 (time: 08:35) sr6875 (time: 08:37)
426000: sr6900 (time: 08:40) sr6875 (time: 08:42)
434000: sr6900 (time: 08:45) sr6875 (time: 08:47)
442000: sr6900 (time: 08:50) sr6875 (time: 08:52)
450000: sr6900 (time: 08:55) sr6875 (time: 08:58)
458000: sr6900 (time: 09:00) sr6875 (time: 09:03)
466000: sr6900 (time: 09:05) sr6875 (time: 09:08)
474000: sr6900 (time: 09:10) sr6875 (time: 09:13)
482000: sr6900 (time: 09:15) sr6875 (time: 09:18)
490000: sr6900 (time: 09:20) sr6875 (time: 09:23)
498000: sr6900 (time: 09:26) sr6875 (time: 09:28)
506000: sr6900 (time: 09:31) sr6875 (time: 09:33)
514000: sr6900 (time: 09:36) sr6875 (time: 09:38)
522000: sr6900 (time: 09:41) sr6875 (time: 09:43)
530000: sr6900 (time: 09:46) sr6875 (time: 09:48)
538000: sr6900 (time: 09:51) sr6875 (time: 09:53)
546000: sr6900 (time: 09:56) sr6875 (time: 09:59)
554000: sr6900 (time: 10:01) sr6875 (time: 10:04)
562000: sr6900 (time: 10:06) sr6875 (time: 10:09)
570000: sr6900 (time: 10:11) sr6875 (time: 10:14)
578000: sr6900 (time: 10:16) sr6875 (time: 10:19)
586000: sr6900 (time: 10:21) sr6875 (time: 10:24)
594000: sr6900 (time: 10:26) sr6875 (time: 10:29)
602000: sr6900 (time: 10:32) (time: 10:33) signal ok:
         QAM_256  f = 602000 kHz S6900C999
WARNING: section too short: network_id == 0x0056, section_length == 876, 
descriptors_loop_len == 874
610000: sr6900 (time: 10:44) sr6875 (time: 10:47)
618000: sr6900 (time: 10:49) sr6875 (time: 10:52)
626000: sr6900 (time: 10:54) sr6875 (time: 10:57)
634000: sr6900 (time: 11:00) sr6875 (time: 11:02)
642000: sr6900 (time: 11:05) sr6875 (time: 11:07)
650000: sr6900 (time: 11:10) sr6875 (time: 11:12)
658000: sr6900 (time: 11:15) sr6875 (time: 11:17)
666000: sr6900 (time: 11:20) sr6875 (time: 11:22)
674000: sr6900 (time: 11:25) sr6875 (time: 11:27)
682000: sr6900 (time: 11:30) sr6875 (time: 11:33)
690000: sr6900 (time: 11:35) sr6875 (time: 11:38)
698000: sr6900 (time: 11:40) sr6875 (time: 11:43)
706000: sr6900 (time: 11:45) sr6875 (time: 11:48)
714000: sr6900 (time: 11:50) sr6875 (time: 11:53)
722000: sr6900 (time: 11:55) sr6875 (time: 11:58)
730000: sr6900 (time: 12:00) sr6875 (time: 12:03)
738000: sr6900 (time: 12:06) sr6875 (time: 12:08)
746000: sr6900 (time: 12:11) sr6875 (time: 12:13)
754000: sr6900 (time: 12:16) sr6875 (time: 12:18)
762000: sr6900 (time: 12:21) sr6875 (time: 12:23)
770000: sr6900 (time: 12:26) sr6875 (time: 12:28)
778000: sr6900 (time: 12:31) sr6875 (time: 12:34)
786000: sr6900 (time: 12:36) sr6875 (time: 12:39)
794000: sr6900 (time: 12:41) sr6875 (time: 12:44)
802000: sr6900 (time: 12:46) sr6875 (time: 12:49)
810000: sr6900 (time: 12:51) sr6875 (time: 12:54)
818000: sr6900 (time: 12:56) sr6875 (time: 12:59)
826000: sr6900 (time: 13:01) sr6875 (time: 13:04)
834000: sr6900 (time: 13:07) sr6875 (time: 13:09)
842000: sr6900 (time: 13:12) sr6875 (time: 13:14)
850000: sr6900 (time: 13:17) sr6875 (time: 13:19)
858000: sr6900 (time: 13:22) sr6875 (time: 13:24)
tune to: QAM_256  f = 602000 kHz S6900C999
(time: 13:27)   service = CORE SI ((null))
         service = XSI_Data ((null))
         service = TV11 ((null))
         service = TV 2 Filmkanalen (Viasat)
         service = Ticket ((null))
         service = MTV NO ((null))
         service = Viasat History ((null))
         service = Viasat Sport Baltic ((null))
         service = Sjuan ((null))
         service = TV4 Film ((null))
         service = Viasat Nature East ((null))
WARNING: section too short: network_id == 0x0056, section_length == 876, 
descriptors_loop_len == 874
dumping lists (9 services)
TV11;(null):602000:M256:C:6900:6001:6002:6006:90f:6000:0:0:0
TV 2 Filmkanalen;Viasat:602000:M256:C:6900:6011:6012:6016:90f:6010:0:0:0
Ticket;(null):602000:M256:C:6900:6021:6022:0:90f:6020:0:0:0
Viasat Nature 
East;(null):602000:M256:C:6900:6031:6034,6032=cze,6035=rus,6033=eng,6036=pol:6131:90f,93e:6030:0:0:0
MTV NO;(null):602000:M256:C:6900:6041:6042:6046:90f:6040:0:0:0
Viasat 
History;(null):602000:M256:C:6900:6051:6052,6053=swe,6054=nor,6055=dan,6057=cze,6059=rus,6088=eng,6458=hun:6056:90f:6050:0:0:0
Viasat Sport 
Baltic;(null):602000:M256:C:6900:6061:6062,6063=est,6064=lav:0:90f:6060:0:0:0
Sjuan;(null):602000:M256:C:6900:6081:6082:6086:90f:6080:0:0:0
TV4 Film;(null):602000:M256:C:6900:6091:6092:6096:90f:6090:0:0:0
Done.

[2]

lin-tv media_build # dvbscan -x 0 -fc /usr/share/dvb/dvb-c/no-Oslo-Get
scanning /usr/share/dvb/dvb-c/no-Oslo-Get
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 241000000 6900000 0 5
initial transponder 272000000 6900000 0 5
initial transponder 280000000 6900000 0 5
initial transponder 290000000 6900000 0 5
initial transponder 298000000 6900000 0 5
initial transponder 306000000 6900000 0 5
initial transponder 314000000 6900000 0 5
initial transponder 322000000 6900000 0 5
initial transponder 330000000 6900000 0 5
initial transponder 338000000 6900000 0 5
initial transponder 346000000 6900000 0 5
initial transponder 354000000 6900000 0 5
initial transponder 362000000 6900000 0 5
initial transponder 370000000 6900000 0 5
initial transponder 378000000 6900000 0 5
initial transponder 386000000 6900000 0 5
initial transponder 394000000 6900000 0 5
initial transponder 410000000 6900000 0 5
initial transponder 442000000 6952000 0 5
initial transponder 482000000 6900000 0 5
initial transponder 498000000 6900000 0 5
 >>> tune to: 241000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
0x0000 0x0026: pmt_pid 0x0270 Get -- CANAL9 (running)
0x0000 0x00b3: pmt_pid 0x0b40 (null) -- BBC HD (running)
0x0000 0x0c23: pmt_pid 0x01b0 (null) -- Silver HD (running)
0x0000 0x0c2c: pmt_pid 0x00d0 Get -- SVT1 HD (running)
Network Name 'Get.'
 >>> tune to: 272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0065 0x00a4: pmt_pid 0x0000 Get -- NRK1 Nordnytt (running)
0x0065 0x00a5: pmt_pid 0x0000 Get -- NRK1 Møre og Romsdal (running)
0x0065 0x00a6: pmt_pid 0x0000 Get -- NRK1 Nordland (running)
0x0065 0x00a7: pmt_pid 0x0000 Get -- TVA (running)
0x0065 0x00a8: pmt_pid 0x0000 Get -- TKTV (running)
0x0065 0x0001: pmt_pid 0x0000 Get -- NRK1 (running)
0x0065 0x0002: pmt_pid 0x0000 Get -- NRK2 (running)
0x0065 0x0003: pmt_pid 0x0000 Get -- TV2 (running)
0x0065 0x0004: pmt_pid 0x0000 Get -- TVNORGE (running)
0x0065 0x0005: pmt_pid 0x0000 Get -- TV3 (running)
0x0065 0x0018: pmt_pid 0x0190 Get -- Get Infokanal (running)
0x0065 0x006f: pmt_pid 0x0700 Get -- TV8 Asker&Bærum (running)
0x0065 0x0070: pmt_pid 0x0000 Get -- TV NORD (running)
0x0065 0x0071: pmt_pid 0x0000 Get -- TV Østfold (running)
0x0065 0x0072: pmt_pid 0x0000 Get -- TVNORGE/TV Haugaland (running)
0x0065 0x0073: pmt_pid 0x0000 Get -- TV8 Buskerud (running)
0x0065 0x0074: pmt_pid 0x0000 Get -- TVNORGE (running)
0x0065 0x0075: pmt_pid 0x0000 Get -- TVN /TV Aftenbladet (running)
0x0065 0x0078: pmt_pid 0x010a Get -- NRK1 Østafjells (running)
0x0065 0x007c: pmt_pid 0x0000 Get -- NRK1 Midtnytt (running)
0x0065 0x007d: pmt_pid 0x0000 Get -- TV Vest (running)
0x0065 0x007e: pmt_pid 0x0000 Get -- NRK1 Vestlandsrevyen (running)
0x0065 0x007f: pmt_pid 0x0000 Get -- NRK1 Rogaland (running)
0x0065 0x0080: pmt_pid 0x0000 Get -- NRK1 Sørlandet (running)
0x0065 0x0081: pmt_pid 0x0000 Get -- TV Haugaland (running)
0x0065 0x0082: pmt_pid 0x0000 Get -- NRK1 Østfold (running)
0x0065 0x0087: pmt_pid 0x0880 Get -- TV8 Follo (running)
0x0065 0x0089: pmt_pid 0x08a0 Get -- TV8 Romerike (running)
0x0065 0x008a: pmt_pid 0x0000 Get -- 3net Infokanal (running)
0x0065 0x008b: pmt_pid 0x0000 Get -- TV8 Sunnmøre (running)
0x0065 0x0091: pmt_pid 0x0100 Get -- NRK1 (running)
0x0065 0x0092: pmt_pid 0x0930 Get -- NRK2 (running)
0x0065 0x0093: pmt_pid 0x0940 Get -- TV2 (running)
0x0065 0x0094: pmt_pid 0x0950 Get -- TVNORGE (running)
0x0065 0x0095: pmt_pid 0x0960 Get -- TV3 (running)
0x0065 0x009e: pmt_pid 0x0000 Get -- Kanal opphørt (not running)
0x0065 0x009f: pmt_pid 0x0000 Get -- TVNORGE (running)
0x0065 0x00a3: pmt_pid 0x0000 Get -- NRK1 Østnytt (running)
Network Name 'Get.'
 >>> tune to: 280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0066 0x0166: pmt_pid 0x0111 Get -- NRK Alltid klassisk (running)
0x0066 0x0169: pmt_pid 0x010e Get -- NRK P1 (running)
0x0066 0x016a: pmt_pid 0x010b Get -- Scandinavian Sat Radio (running)
0x0066 0x0195: pmt_pid 0x0112 Get -- NRK Sami Radio (running)
0x0066 0x0196: pmt_pid 0x0116 Get -- NRK Folkemusikk (running)
0x0066 0x0197: pmt_pid 0x011c Get -- NRK Jazz (running)
0x0066 0x0198: pmt_pid 0x0119 Get -- NRK Super (running)
0x0066 0x0199: pmt_pid 0x011a Get -- NRK Gull (running)
0x0066 0xffdd: pmt_pid 0x1380 Get -- EPG DL HD PVR (running)
0x0066 0xffde: pmt_pid 0x1390 Get -- EPG DL HD Zapper (running)
0x0066 0xfffc: pmt_pid 0x1f50 (null) -- (null) (running)
0x0066 0xfffd: pmt_pid 0x1f60 (null) -- (null) (running)
0x0066 0x0006: pmt_pid 0x0070 Get -- Svensk TV1 (running)
0x0066 0x0007: pmt_pid 0x0080 Get -- Svensk TV2 (running)
0x0066 0x0008: pmt_pid 0x0090 Get -- Viasat 4 (running)
0x0066 0x000a: pmt_pid 0x00b0 Get -- TV2 Zebra (running)
0x0066 0x000f: pmt_pid 0x0100 Get -- MTV (running)
0x0066 0x0049: pmt_pid 0x04a0 Get -- Euronews (running)
0x0066 0x006b: pmt_pid 0x06c0 Get -- TV2 Nyhetskanalen (running)
0x0066 0x009b: pmt_pid 0x09c0 Get -- NRK Super/NRK 3 (running)
0x0066 0x009c: pmt_pid 0x09d0 Get -- FEM (running)
0x0066 0x0162: pmt_pid 0x010f Get -- NRK P2 (running)
0x0066 0x0163: pmt_pid 0x0110 Get -- NRK Petre (running)
0x0066 0x0164: pmt_pid 0x0115 Get -- NRK Alltid Nyheter (running)
0x0066 0x0165: pmt_pid 0x0114 Get -- NRK MP3 (running)
Network Name 'Get.'
 >>> tune to: 290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0067 0x0183: pmt_pid 0x0bd6 Get -- Ultimate Urban (running)
0x0067 0x0184: pmt_pid 0x0bc3 Get -- Hits (Germany) (running)
0x0067 0x0185: pmt_pid 0x0bc2 Get -- Schlager Greats (running)
0x0067 0x0186: pmt_pid 0x0bba Get -- Hits (Spain) (running)
0x0067 0x0187: pmt_pid 0x0bc1 Get -- Christmas (running)
0x0067 0x0188: pmt_pid 0x0bd3 Get -- World Carnival (running)
0x0067 0x0189: pmt_pid 0x0bbe Get -- Hits (France) (running)
0x0067 0x018a: pmt_pid 0x0bd8 Get -- Dance Floor (running)
0x0067 0x018b: pmt_pid 0x0bbb Get -- Hits (Nordic) (running)
0x0067 0x018c: pmt_pid 0x0bbd Get -- Hits (Italy) (running)
0x0067 0x018d: pmt_pid 0x0bbc Get -- Turk Musigi (running)
0x0067 0x018e: pmt_pid 0x0bb9 Get -- Classic Rock (running)
0x0067 0x018f: pmt_pid 0x0bb8 Get -- Rock n` Roll (running)
0x0067 0x0190: pmt_pid 0x0bdc Get -- The Alternative (running)
0x0067 0x0191: pmt_pid 0x0bcf Get -- Country Stars (running)
0x0067 0x0192: pmt_pid 0x0bd9 Get -- Magnificent 70s (running)
0x0067 0x0193: pmt_pid 0x0bd4 Get -- Reggae Beats (running)
0x0067 0x019a: pmt_pid 0x0000 Get -- NRK Extra (running)
0x0067 0x000c: pmt_pid 0x00d0 Get -- Travel (running)
0x0067 0x0011: pmt_pid 0x0120 Get -- Eurosport (running)
0x0067 0x0022: pmt_pid 0x0230 Get -- NRK1 Tegnspråk (running)
0x0067 0x0038: pmt_pid 0x0390 Get -- PlayboyTV (running)
0x0067 0x0039: pmt_pid 0x03a0 Get -- Viasat Nature & Crime (running)
0x0067 0x003e: pmt_pid 0x03f0 Get -- TV5 (running)
0x0067 0x0067: pmt_pid 0x0680 Get -- MAX (running)
0x0067 0x0069: pmt_pid 0x06a0 Get -- National Geographic (running)
0x0067 0x009a: pmt_pid 0x09b0 Get -- Star!/Showtime (running)
0x0067 0x00ba: pmt_pid 0x0bb0 Get -- TV2 Bliss (running)
0x0067 0x0167: pmt_pid 0x1680 Get -- Radio Norge (running)
0x0067 0x0168: pmt_pid 0x1690 Get -- P4 (running)
0x0067 0x016c: pmt_pid 0x0bdb Get -- Harder than... (running)
0x0067 0x016d: pmt_pid 0x0bcb Get -- Class. Orchestra (running)
0x0067 0x016e: pmt_pid 0x0bca Get -- Classical Calm (running)
0x0067 0x016f: pmt_pid 0x0bdf Get -- Total Hits (running)
0x0067 0x0170: pmt_pid 0x0bde Get -- Rock Anthems (running)
0x0067 0x0171: pmt_pid 0x0bdd Get -- Dinner Party (running)
0x0067 0x0172: pmt_pid 0x0bd7 Get -- Bass, Breaks and Beats (running)
0x0067 0x0173: pmt_pid 0x0bd5 Get -- Soul Classics (running)
0x0067 0x0174: pmt_pid 0x0bda Get -- Strictly 60s (running)
0x0067 0x0175: pmt_pid 0x0bd2 Get -- Jazz Classics (running)
0x0067 0x0176: pmt_pid 0x0bc0 Get -- Under a Groove (running)
Network Name 'Get.'
0x0067 0x0177: pmt_pid 0x0bc5 Get -- Cocktail Lounge (running)
0x0067 0x0178: pmt_pid 0x0bd0 Get -- Just Chillout (running)
0x0067 0x0179: pmt_pid 0x0bce Get -- Indie Classics (running)
0x0067 0x017a: pmt_pid 0x0bbf Get -- Revival (running)
0x0067 0x017b: pmt_pid 0x0bcd Get -- Got The Blues (running)
0x0067 0x017c: pmt_pid 0x0bcc Get -- Classical Greats (running)
0x0067 0x017d: pmt_pid 0x0bd1 Get -- Cool Jazz (running)
0x0067 0x017e: pmt_pid 0x0bc9 Get -- Killer 80s (running)
0x0067 0x017f: pmt_pid 0x0bc8 Get -- Nothing But 90s (running)
0x0067 0x0180: pmt_pid 0x0bc7 Get -- Silk (running)
0x0067 0x0181: pmt_pid 0x0bc6 Get -- Freedom (running)
0x0067 0x0182: pmt_pid 0x0bc4 Get -- All Day Party (running)
 >>> tune to: 298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0068 0x000d: pmt_pid 0x00e0 Get -- CNN International (running)
0x0068 0x000e: pmt_pid 0x00f0 Get -- Cartoon/TCM (running)
0x0068 0x0012: pmt_pid 0x0130 Get -- Discovery (running)
0x0068 0x0014: pmt_pid 0x0150 Get -- Disney Channel (running)
0x0068 0x001f: pmt_pid 0x0200 Get -- Canal+ Fotball (running)
0x0068 0x0034: pmt_pid 0x0350 Get -- TV2 SPORT 2 (running)
0x0068 0x0035: pmt_pid 0x0360 Get -- TV2 SPORT 3 (running)
0x0068 0x004a: pmt_pid 0x04b0 Get -- DR 1 (running)
0x0068 0x004b: pmt_pid 0x04c0 Get -- BBC World News (running)
0x0068 0x005b: pmt_pid 0x05c0 Get -- Voice TV (running)
0x0068 0x0064: pmt_pid 0x0000 Get -- BHT1 (running)
0x0068 0x0066: pmt_pid 0x0670 Get -- TV2 Filmkanalen (running)
Network Name 'Get.'
 >>> tune to: 306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0069 0x0194: pmt_pid 0x0000 Get -- Hallo Norge (running)
0x0069 0x01a9: pmt_pid 0x1b57 Get -- NRK P1 Oslo/Akershus (running)
0x0069 0x01aa: pmt_pid 0x1b56 Get -- NRK P1 Troms (running)
0x0069 0x01ab: pmt_pid 0x1b55 Get -- NRK P1 Nordland (running)
0x0069 0x01ac: pmt_pid 0x1b54 Get -- NRK P1 Trøndelag (running)
0x0069 0x01ad: pmt_pid 0x1b53 Get -- NRK P1 Møre og Romsdal (running)
0x0069 0x01ae: pmt_pid 0x1b52 Get -- NRK P1 Sogn og Fjordane (running)
0x0069 0x01af: pmt_pid 0x1b51 Get -- NRK P1 Hordaland (running)
0x0069 0x01b0: pmt_pid 0x1b50 Get -- NRK P1 Rogaland (running)
0x0069 0x01b1: pmt_pid 0x1b4f Get -- NRK P1 Sørlandet (running)
0x0069 0x01b2: pmt_pid 0x1b4e Get -- NRK P1 Hedmark/Oppland (running)
0x0069 0x01b3: pmt_pid 0x1b4d Get -- NRK P1 Telemark (running)
0x0069 0x01b4: pmt_pid 0x1b4c Get -- NRK P1 Østfold (running)
0x0069 0x01b5: pmt_pid 0x1b4b Get -- NRK P1 Buskerud (running)
0x0069 0x01b6: pmt_pid 0x1b4a Get -- NRK P1 Vestfold (running)
0x0069 0x01b7: pmt_pid 0x1b49 Get -- NRK P1 Finnmark (running)
0x0069 0x0015: pmt_pid 0x0160 Get -- BBC entertainment (running)
0x0069 0x002d: pmt_pid 0x02e0 Get -- TV Chile (running)
0x0069 0x0036: pmt_pid 0x0370 Get -- TV2 SPORT 5 (running)
0x0069 0x0037: pmt_pid 0x0380 Get -- TV2 SPORT 4 (running)
0x0069 0x0040: pmt_pid 0x0410 Get -- Canal+ Action (running)
0x0069 0x0042: pmt_pid 0x0430 Get -- TCM (running)
0x0069 0x0043: pmt_pid 0x0440 Get -- CNBC (running)
0x0069 0x0044: pmt_pid 0x0450 Get -- Canal+ Sport 2 (running)
0x0069 0x0045: pmt_pid 0x0460 Get -- God TV (running)
0x0069 0x005f: pmt_pid 0x0600 Get -- SF Kanalen (running)
0x0069 0x0062: pmt_pid 0x0630 Get -- TV8 Oslo (running)
0x0069 0x00a0: pmt_pid 0x0a10 Get -- Viasat Sport  (running)
0x0069 0x00a1: pmt_pid 0x0a20 Get -- Viasat Motor (running)
Network Name 'Get.'
 >>> tune to: 314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x006a 0x0013: pmt_pid 0x0140 Get -- Cartoon Network (running)
0x006a 0x001d: pmt_pid 0x01e0 Get -- ARY Digital (running)
0x006a 0x0021: pmt_pid 0x0220 Get -- Blue Hustler (running)
0x006a 0x002e: pmt_pid 0x02f0 Get -- TV1000 Action (running)
0x006a 0x0030: pmt_pid 0x0310 Get -- Motors TV (running)
0x006a 0x0041: pmt_pid 0x0420 Get -- Canal+ Hockey (running)
0x006a 0x0046: pmt_pid 0x0470 Get -- Fine Living Network (running)
0x006a 0x0047: pmt_pid 0x0480 Get -- Extreme Sports (running)
0x006a 0x0048: pmt_pid 0x0490 Get -- Animal Planet (running)
0x006a 0x006e: pmt_pid 0x06f0 Get -- Canal+ Family (running)
0x006a 0x0097: pmt_pid 0x0980 Get -- Viasat History (running)
0x006a 0x0098: pmt_pid 0x0990 Get -- France 24 (running)
0x006a 0x0099: pmt_pid 0x09a0 Get -- France 24 English (running)
Network Name 'Get.'
 >>> tune to: 322000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x006b 0x01a4: pmt_pid 0x0000 Get -- Lokal radio 1 (running)
0x006b 0x01a5: pmt_pid 0x0000 Get -- Lokal radio 2 (running)
0x006b 0x01a6: pmt_pid 0x0000 Get -- Lokal radio 3 (running)
0x006b 0x01a7: pmt_pid 0x0000 Get -- Lokal radio 4 (running)
0x006b 0x01a8: pmt_pid 0x0000 Get -- Lokal radio 5 (running)
0x006b 0x0c21: pmt_pid 0x01a0 (null) -- Canal+ First HD (running)
0x006b 0x0c26: pmt_pid 0x06b0 (null) -- Canal+ Sport HD (running)
Network Name 'Get.'
 >>> tune to: 330000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0076 0x00b5: pmt_pid 0x0b60 (null) -- MTV LIVE HD (running)
0x0076 0x00bb: pmt_pid 0x0bc0 (null) -- TVN HD (running)
0x0076 0x0c24: pmt_pid 0x0000 (null) -- Luxe TV HD (running)
0x0076 0x0c28: pmt_pid 0x0860 (null) -- TV1000 HD (running)
Network Name 'Get.'
 >>> tune to: 338000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0077 0x00b7: pmt_pid 0x0b80 Get -- TV2 Barcl. PL HD1 (running)
0x0077 0x00b8: pmt_pid 0x0b90 Get -- TV2 Barcl. PL HD2 (running)
0x0077 0x00b9: pmt_pid 0x0ba0 Get -- TV2 Barcl. PL HD3 (running)
Network Name 'Get.'
 >>> tune to: 346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x006c 0x0020: pmt_pid 0x0210 Get -- TV2 Danmark (running)
0x006c 0x0033: pmt_pid 0x0340 Get -- TV2 SPORT (running)
0x006c 0x004e: pmt_pid 0x04f0 Get -- TV1000 Drama (running)
0x006c 0x004f: pmt_pid 0x0500 Get -- TV1000 Family (running)
0x006c 0x0050: pmt_pid 0x0510 Get -- TV1000 Nordic (running)
0x006c 0x0051: pmt_pid 0x0520 Get -- TV1000 Classic (running)
0x006c 0x0052: pmt_pid 0x0530 Get -- VH1 (running)
0x006c 0x0053: pmt_pid 0x0540 Get -- TV Finland (running)
0x006c 0x0084: pmt_pid 0x0850 Get -- Canal+ Hits (running)
0x006c 0x0088: pmt_pid 0x0890 Get -- MTV Music (running)
0x006c 0x0090: pmt_pid 0x0910 Get -- VH1 Classic (running)
0x006c 0x0096: pmt_pid 0x0970 Get -- Viasat Golf (running)
Network Name 'Get.'
 >>> tune to: 354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x006d 0x006a: pmt_pid 0x06b0 Get -- Disney Junior (running)
0x006d 0x008e: pmt_pid 0x08f0 Get -- MTV Dance (running)
0x006d 0x0029: pmt_pid 0x02a0 Get -- Canal+ First (running)
0x006d 0x0032: pmt_pid 0x0330 Get -- TV1000 (running)
0x006d 0x003f: pmt_pid 0x0400 Get -- 3sat (running)
0x006d 0x004c: pmt_pid 0x04d0 Get -- Sky News (running)
0x006d 0x0054: pmt_pid 0x0550 Get -- Discovery Science (running)
0x006d 0x0055: pmt_pid 0x0560 Get -- Discovery World (running)
0x006d 0x0056: pmt_pid 0x0570 Get -- TLC Norge (running)
0x006d 0x0057: pmt_pid 0x0580 Get -- Nat Geo Wild (running)
0x006d 0x0058: pmt_pid 0x0590 Get -- Canal+ Series (running)
0x006d 0x005a: pmt_pid 0x05b0 Get -- Sony Entertainm. TV Asia (running)
0x006d 0x0063: pmt_pid 0x0640 Get -- Mezopotanya TV (running)
Network Name 'Get.'
 >>> tune to: 362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x006e 0x00a2: pmt_pid 0x0a30 Get -- Spice (running)
0x006e 0x0009: pmt_pid 0x00a0 Get -- Viasat Fotball (running)
0x006e 0x0016: pmt_pid 0x0170 Get -- Showtime (running)
0x006e 0x002c: pmt_pid 0x02d0 Get -- Adult Channel (running)
0x006e 0x0031: pmt_pid 0x0320 Get -- Viasat Explorer (running)
0x006e 0x005c: pmt_pid 0x05d0 Get -- BBC lifestyle (running)
0x006e 0x005d: pmt_pid 0x05e0 Get -- Eurosport 2 (running)
0x006e 0x005e: pmt_pid 0x05f0 Get -- Disney XD (running)
0x006e 0x0060: pmt_pid 0x0610 Get -- Canal+ Sport 3 (running)
0x006e 0x0068: pmt_pid 0x0690 Get -- Zone Reality (running)
0x006e 0x006d: pmt_pid 0x06e0 Get -- Viasat Hockey (running)
0x006e 0x0077: pmt_pid 0x0780 Get -- Silver (running)
0x006e 0x007b: pmt_pid 0x07c0 Get -- ESPN Classic Sports (running)
0x006e 0x009d: pmt_pid 0x09e0 Get -- Rikstoto Direkte (running)
Network Name 'Get.'
 >>> tune to: 370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x006f 0x0010: pmt_pid 0x0110 Get -- Svensk TV4 (running)
0x006f 0x0017: pmt_pid 0x0180 Get -- Star! (running)
0x006f 0x0019: pmt_pid 0x01a0 Get -- Rai Uno (running)
0x006f 0x001a: pmt_pid 0x01b0 Get -- Fashion TV (running)
0x006f 0x001b: pmt_pid 0x01c0 Get -- Das Erste (running)
0x006f 0x002b: pmt_pid 0x02c0 Get -- Bloomberg (running)
0x006f 0x004d: pmt_pid 0x04e0 Get -- Mezzo (running)
0x006f 0x0059: pmt_pid 0x05a0 Get -- Canal+ Emotion (running)
0x006f 0x0065: pmt_pid 0x0660 Get -- RTR Planeta (running)
0x006f 0x0079: pmt_pid 0x07a0 Get -- Al Jazeera International (running)
0x006f 0x0083: pmt_pid 0x0840 Get -- Canal+ Sport Extra (running)
0x006f 0x008f: pmt_pid 0x0900 Get -- MTV Hits (running)
Network Name 'Get.'
 >>> tune to: 378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0070 0x001c: pmt_pid 0x0810 Get -- TV Polonia (running)
0x0070 0x0024: pmt_pid 0x0250 Get -- Prime TV (running)
0x0070 0x0025: pmt_pid 0x0260 Get -- TVE International (running)
0x0070 0x0028: pmt_pid 0x0290 Get -- RTL (running)
0x0070 0x002a: pmt_pid 0x02b0 Get -- Zee TV (running)
0x0070 0x003a: pmt_pid 0x03b0 Get -- Nickelodeon (running)
0x0070 0x003b: pmt_pid 0x03c0 Get -- Al Jazeera (running)
0x0070 0x003d: pmt_pid 0x03e0 Get -- TRT Turk (running)
0x0070 0x0061: pmt_pid 0x0620 Get -- HRT1 (running)
0x0070 0x007a: pmt_pid 0x07b0 Get -- ESPN America (running)
0x0070 0x008c: pmt_pid 0x08d0 Get -- Visjon Norge (running)
0x0070 0x008d: pmt_pid 0x08e0 Get -- MTV ROCKS (running)
Network Name 'Get.'
 >>> tune to: 386000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x0071 0x0c27: pmt_pid 0x1fe0 (null) -- Discovery HD (running)
0x0071 0x0c29: pmt_pid 0x0870 (null) -- Viasat Sport HD (running)
0x0071 0x0c2a: pmt_pid 0x00b0 (null) -- Eurosport HD (running)
Network Name 'Get.'
 >>> tune to: 394000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 394000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 410000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 410000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 442000000:INVERSION_AUTO:6952000:FEC_AUTO:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0010
 >>> tune to: 482000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 482000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 498000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 498000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 140000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 140000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 264000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256
0x007a 0x006c: pmt_pid 0x06d0 Get -- TV 2 HD (running)
0x007a 0x00b6: pmt_pid 0x0b70 (null) -- NRK1 HD (running)
0x007a 0x00bc: pmt_pid 0x0bd0 (null) -- NRK2 HD (running)
0x007a 0x00bd: pmt_pid 0x0be0 (null) -- NRK3 HD (running)
Network Name 'Get.'
 >>> tune to: 594000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64
WARNING: >>> tuning failed!!!
 >>> tune to: 594000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_64 (tuning 
failed)
WARNING: >>> tuning failed!!!
dumping lists (259 services)
BBC HD:241000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2885:0:179
SVT1 HD:241000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:211:0:3116
Silver HD:241000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:439:433:3107
CANAL9:241000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:625:626:38
Get Infokanal:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:401:402:24
NRK2:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2354:2355:146
TV8 Follo:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2177:2178:135
TV8 Romerike:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2209:2210:137
TV2:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2369:2370:147
TV3:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2401:2402:149
[fffe]:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:65534
TV8 
Asker&Bærum:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1793:1794:111
TVNORGE:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2385:2386:148
NRK1 
Østafjells:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:512:640:120
NRK1:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:512:640:145
NRK1 Nordnytt:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:164
NRK1 Møre og 
Romsdal:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:165
NRK1 Nordland:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:166
TVA:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:167
TKTV:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:168
NRK1:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:1
NRK2:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:2
TV2:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:3
TVNORGE:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:4
TV3:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:5
TV NORD:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:112
TV Østfold:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:113
TVNORGE/TV 
Haugaland:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:114
TV8 Buskerud:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:115
TVNORGE:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:116
TVN /TV 
Aftenbladet:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:117
NRK1 Midtnytt:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:124
TV Vest:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:125
NRK1 
Vestlandsrevyen:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:126
NRK1 Rogaland:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:127
NRK1 Sørlandet:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:128
TV Haugaland:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:129
NRK1 Østfold:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:130
3net Infokanal:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:138
TV8 Sunnmøre:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:139
Kanal opphørt:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:158
TVNORGE:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:159
NRK1 Østnytt:272000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:163
Svensk TV1:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:113:114:6
TV2 
Nyhetskanalen:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1729:1730:107
Euronews:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1185:1190:73
[fffd]:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:65533
[fffc]:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:65532
NRK P2:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:701:354
NRK Petre:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:702:355
NRK Alltid 
Nyheter:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:707:356
NRK MP3:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:706:357
NRK Alltid 
klassisk:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:703:358
NRK P1:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:700:361
Scandinavian Sat 
Radio:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:672:362
NRK Sami Radio:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:704:405
NRK Folkemusikk:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:708:406
NRK Jazz:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:714:407
NRK Super:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:710:408
NRK Gull:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:711:409
EPG DL HD Zapper:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:65502
EPG DL HD PVR:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:65501
NRK Super/NRK 
3:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2498:2499:155
FEM:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2513:2514:156
Svensk TV2:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:129:130:7
Viasat 4:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:145:146:8
MTV:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:257:258:15
TV2 Zebra:280000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:177:178:10
NRK1 Tegnspråk:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:562:563:34
PlayboyTV:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:913:917:56
Viasat Nature & 
Crime:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:929:933:57
MAX:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1665:1666:103
TV5:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1009:1010:62
Star!/Showtime:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2481:2482:154
Radio Norge:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:5761:359
P4:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:5777:360
Harder than...:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3333:364
Class. 
Orchestra:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3349:365
Classical Calm:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3350:366
Total Hits:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3329:367
Rock Anthems:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3330:368
Dinner Party:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3331:369
Bass, Breaks and 
Beats:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3337:370
Soul Classics:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3339:371
Strictly 60s:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3334:372
Jazz Classics:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3342:373
Under a Groove:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3360:374
Cocktail Lounge:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3355:375
Just Chillout:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3344:376
Indie Classics:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3346:377
Revival:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3361:378
Got The Blues:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3347:379
Classical 
Greats:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3348:380
Cool Jazz:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3343:381
Killer 80s:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3351:382
Nothing But 90s:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3352:383
Silk:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3353:384
Freedom:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3354:385
All Day Party:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3356:386
Ultimate Urban:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3338:387
Hits (Germany):290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3357:388
Schlager Greats:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3358:389
Hits (Spain):290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3366:390
Christmas:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3359:391
World Carnival:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3341:392
Hits (France):290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3362:393
Dance Floor:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3336:394
Hits (Nordic):290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3365:395
Hits (Italy):290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3363:396
Turk Musigi:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3364:397
Classic Rock:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3367:398
Rock n` Roll:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3368:399
The Alternative:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3332:400
Country Stars:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3345:401
Magnificent 70s:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3335:402
Reggae Beats:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:3340:403
TV2 Bliss:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2993:2994:186
Eurosport:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:289:293:17
National 
Geographic:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1697:1698:105
Travel:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:209:210:12
NRK Extra:290000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:410
TV2 SPORT 2:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:849:850:52
TV2 SPORT 3:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:865:866:53
DR 1:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1201:1202:74
Voice TV:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1473:1474:91
Canal+ Fotball:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:513:514:31
TV2 
Filmkanalen:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1649:1650:102
CNN 
International:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:225:226:13
BBC World 
News:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1217:1218:75
Discovery:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:305:307:18
Cartoon/TCM:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:241:245:14
Disney Channel:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:337:341:20
BHT1:298000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:100
Viasat Sport 
:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2577:2578:160
Viasat Motor:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2593:2595:161
TV2 SPORT 4:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:897:898:55
TV8 Oslo:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1585:1586:98
TV2 SPORT 5:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:881:882:54
God TV:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1121:1122:69
NRK P1 
Oslo/Akershus:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8000:425
NRK P1 Troms:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8001:426
NRK P1 Nordland:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8002:427
NRK P1 
Trøndelag:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8003:428
NRK P1 Møre og 
Romsdal:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8004:429
NRK P1 Sogn og 
Fjordane:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8005:430
NRK P1 
Hordaland:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8006:431
NRK P1 Rogaland:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8007:432
NRK P1 
Sørlandet:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8008:433
NRK P1 
Hedmark/Oppland:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8009:434
NRK P1 Telemark:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8010:435
NRK P1 Østfold:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8011:436
NRK P1 Buskerud:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8012:437
NRK P1 Vestfold:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8013:438
NRK P1 Finnmark:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:8014:439
TV Chile:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:737:738:45
SF Kanalen:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1537:1538:95
TCM:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1073:1074:66
Canal+ Sport 
2:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1105:1107:68
CNBC:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1089:1090:67
BBC 
entertainment:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:353:354:21
Canal+ Action:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1041:1044:64
Hallo Norge:306000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:404
Cartoon Network:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:321:325:19
ARY Digital:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:482:483:29
Blue Hustler:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:545:546:33
Motors TV:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:785:786:48
Canal+ Hockey:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1057:1058:65
Canal+ 
Family:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1777:1781:110
Viasat 
History:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2433:2436:151
France 24:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2449:2450:152
France 24 
English:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2465:2466:153
Animal Planet:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1169:1170:72
TV1000 Action:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:753:757:46
Extreme 
Sports:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1153:1154:71
Fine Living 
Network:314000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1137:1138:70
Canal+ First 
HD:322000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:422:417:3105
Canal+ Sport 
HD:322000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1717:1716:3110
Lokal radio 1:322000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:420
Lokal radio 2:322000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:421
Lokal radio 3:322000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:422
Lokal radio 4:322000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:423
Lokal radio 5:322000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:424
MTV LIVE HD:330000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2915:2913:181
TV1000 HD:330000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2151:2148:3112
TVN HD:330000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:3011:3009:187
Luxe TV HD:330000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:3108
TV2 Barcl. PL 
HD2:338000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2963:2961:184
TV2 Barcl. PL 
HD1:338000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2947:2945:183
TV2 Barcl. PL 
HD3:338000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2979:2977:185
TV2 Danmark:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:529:530:32
TV2 SPORT:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:833:834:51
MTV Music:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2194:2195:136
Viasat Golf:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2417:2421:150
Canal+ Hits:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2129:2132:132
VH1 Classic:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2322:2323:144
TV Finland:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1345:1346:83
TV1000 Nordic:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1297:1301:80
TV1000 
Classic:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1313:1317:81
TV1000 Family:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1281:1285:79
TV1000 Drama:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1265:1267:78
VH1:346000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1329:1330:82
Canal+ First:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:673:677:41
TV1000:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:817:821:50
Mezopotanya 
TV:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1601:1602:99
Sky News:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1234:1235:76
Disney 
Junior:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1713:1718:106
MTV Dance:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2290:2291:142
Sony Entertainm. TV 
Asia:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1458:1459:90
TLC Norge:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1393:1394:86
3sat:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1025:1027:63
Canal+ Series:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1425:1429:88
Discovery 
World:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1377:1378:85
Discovery 
Science:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1361:1362:84
Nat Geo Wild:354000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1409:1410:87
Showtime:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:369:370:22
Viasat Explorer:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:801:804:49
Adult Channel:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:44
Viasat 
Hockey:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1761:1764:109
Spice:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2609:2612:162
Silver:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1921:1922:119
Disney XD:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1521:1525:94
Zone Reality:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1681:1682:104
BBC lifestyle:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1489:1490:92
Canal+ Sport 
3:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1553:1555:96
ESPN Classic 
Sports:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1985:1986:123
Rikstoto 
Direkte:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2529:2530:157
Eurosport 2:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1505:1510:93
Viasat Fotball:362000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:161:162:9
Svensk TV4:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:273:274:16
Star!:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:385:386:23
Rai Uno:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:417:418:25
Fashion TV:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:433:435:26
Das Erste:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:449:450:27
Bloomberg:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:705:706:43
MTV Hits:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2306:2307:143
Canal+ Sport Extra:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:0:0:131
Canal+ 
Emotion:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1441:1445:89
RTR Planeta:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1633:1634:101
Mezzo:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1249:1250:77
Al Jazeera 
International:370000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1953:1954:121
TVE 
International:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:609:610:37
Prime TV:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:593:594:36
TV Polonia:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2065:2066:28
RTL:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:657:658:40
Zee TV:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:689:690:42
Nickelodeon:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:945:948:58
TRT Turk:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:993:994:61
MTV ROCKS:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2274:2275:141
Al Jazeera:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:961:962:59
Visjon Norge:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2257:2258:140
ESPN America:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1969:1970:122
HRT1:378000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1569:1570:97
Eurosport HD:386000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:181:0:3114
Viasat Sport 
HD:386000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2162:0:3113
Discovery HD:386000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:8165:0:3111
TV 2 HD:264000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:1748:1745:108
NRK2 HD:264000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:3028:3025:188
NRK3 HD:264000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:3044:3041:189
NRK1 HD:264000000:INVERSION_AUTO:6900000:FEC_AUTO:QAM_256:2932:2929:182
Done.




