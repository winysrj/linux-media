Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <burns.me.uk@googlemail.com>) id 1KbdVf-0003Mu-1u
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 17:46:09 +0200
Received: by gxk13 with SMTP id 13so7630667gxk.17
	for <linux-dvb@linuxtv.org>; Fri, 05 Sep 2008 08:45:32 -0700 (PDT)
Message-ID: <b4057d410809050845q3de41b2an8ba05cca041b4e12@mail.gmail.com>
Date: Fri, 5 Sep 2008 16:45:32 +0100
From: "Andy Burns" <linuxtv.lists@burns.me.uk>
To: "Glenn McGrath" <glenn.l.mcgrath@gmail.com>, linux-dvb@linuxtv.org
In-Reply-To: <141058d50809041923y1ae6c77dla276541fe55c8678@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <141058d50809030655i680f7937o3aa657601d1910a0@mail.gmail.com>
	<48BE98CC.1080600@linuxtv.org>
	<141058d50809032204o7b8a70d9jc3fa64b4e2f9ef3@mail.gmail.com>
	<b4057d410809040207n685bb5eejb20d6ace653a2798@mail.gmail.com>
	<141058d50809041923y1ae6c77dla276541fe55c8678@mail.gmail.com>
Subject: Re: [linux-dvb] Fine tuning app ?
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

2008/9/5 Glenn McGrath <glenn.l.mcgrath@gmail.com>:

> And does w_scan work for you, or does it fail to detect the channel
> like it does for me ?

Seems OK, here's my verbose output, though my local transmitter
(Waltham) uses a zero offset for all muxes.

# ./w_scan -X -v -v
w_scan version 20080815
Info: using DVB adapter auto detection.
   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_
frontend Philips TDA10046H DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO not supported, trying HIERARCHY_NONE.
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
177500:
184500:
191500:
198500:
205500:
212500:
219500:
226500:
474000:
482000:
490000: signal ok (I999B8C999D999M999T999G999Y0)
498000:
506000:
514000: signal ok (I999B8C999D999M999T999G999Y0)
522000:
530000:
538000:
546000:
554000:
562000:
570000: signal ok (I999B8C999D999M999T999G999Y0)
578000:
586000:
594000:
602000:
610000:
618000:
626000:
634000:
642000: signal ok (I999B8C999D999M999T999G999Y0)
650000:
658000:
666000: signal ok (I999B8C999D999M999T999G999Y0)
674000:
682000:
690000:
698000: no signal(0x00)
706000:
714000:
722000:
730000:
738000:
746000:
754000:
762000:
770000:
778000:
786000:
794000:
802000:
810000:
818000:
826000:
834000:
842000:
850000:
858000:
tune to:
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x01
----------no signal----------
tune to:  (no signal)
>>> tuning status == 0x01
>>> tuning status == 0x1f
PAT
PMT 0x0116 for service 0x20a1
  DSM-CC U-N Messages : PID 0x0802
  AUDIO     : PID 0x0259
  DSM-CC U-N Messages : PID 0x080a
  VIDEO     : PID 0x0258
  SUBTITLING: PID 0x025b
  DSM-CC U-N Messages : PID 0x08cc
  DSM-CC U-N Messages : PID 0x08cb
  AUDIO     : PID 0x025a
PMT 0x010e for service 0x20fa
  DSM-CC U-N Messages : PID 0x0802
  VIDEO     : PID 0x024e
  AUDIO     : PID 0x024f
  AUDIO     : PID 0x0250
  SUBTITLING: PID 0x0251
  DSM-CC U-N Messages : PID 0x08cc
  DSM-CC U-N Messages : PID 0x08cb
  DSM-CC U-N Messages : PID 0x08ce
PMT 0x0109 for service 0x2100
  DSM-CC U-N Messages : PID 0x0802
  VIDEO     : PID 0x0305
  AUDIO     : PID 0x0306
  AUDIO     : PID 0x0307
  SUBTITLING: PID 0x0308
  DSM-CC U-N Messages : PID 0x08cc
  DSM-CC U-N Messages : PID 0x08cb
  DSM-CC U-N Messages : PID 0x08cf
Info: filter timeout pid 0x0011
PMT 0x0104 for service 0x20c0
  VIDEO     : PID 0x0b0a
  AUDIO     : PID 0x0b0b
  AUDIO     : PID 0x0b0d
  SUBTITLING: PID 0x0b0c
  DSM-CC U-N Messages : PID 0x0802
  DSM-CC U-N Messages : PID 0x08cc
  DSM-CC U-N Messages : PID 0x08cb
  DSM-CC U-N Messages : PID 0x08cd
PMT 0x011a for service 0x2243
  AUDIO     : PID 0x026d
  DSM-CC U-N Messages : PID 0x0888
PMT 0x0102 for service 0x2048
  VIDEO     : PID 0x0202
  AUDIO     : PID 0x028c
  AUDIO     : PID 0x0296
  SUBTITLING: PID 0x0403
  DSM-CC U-N Messages : PID 0x0802
  DSM-CC U-N Messages : PID 0x0803
  DSM-CC U-N Messages : PID 0x08cc
  DSM-CC U-N Messages : PID 0x08cb
Info: filter timeout pid 0x011c
Info: filter timeout pid 0x0107
Info: filter timeout pid 0x0105
Info: filter timeout pid 0x010d
Info: filter timeout pid 0x010b
Info: filter timeout pid 0x0114
Info: filter timeout pid 0x0110
Info: filter timeout pid 0x0010
tune to:
>>> tuning status == 0x01
>>> tuning status == 0x1f
PAT
PMT 0x011d for service 0x3e80
  DSM-CC U-N Messages : PID 0x1b9c
PMT 0x0115 for service 0x3d00
  VIDEO     : PID 0x1971
  AUDIO     : PID 0x1972
PMT 0x0104 for service 0x3ea0
  VIDEO     : PID 0x1ab1
  AUDIO     : PID 0x1ab2
  AUDIO     : PID 0x1ab3
  SUBTITLING: PID 0x1ab6
Info: filter timeout pid 0x0011
PMT 0x010b for service 0x3940
  AUDIO     : PID 0x18b2
  DSM-CC U-N Messages : PID 0x18b8
  DSM-CC U-N Messages : PID 0x18a8
PMT 0x0101 for service 0x3242
  VIDEO     : PID 0x1781
  AUDIO     : PID 0x1782
  AUDIO     : PID 0x1783
  SUBTITLING: PID 0x1786
  DSM-CC U-N Messages : PID 0x1bad
  DSM-CC U-N Messages : PID 0x1bae
PMT 0x010a for service 0x3900
  AUDIO     : PID 0x18a2
  DSM-CC U-N Messages : PID 0x18a9
  DSM-CC U-N Messages : PID 0x18a8
PMT 0x0113 for service 0x3280
  VIDEO     : PID 0x1a11
  AUDIO     : PID 0x1a12
  AUDIO     : PID 0x1a13
  SUBTITLING: PID 0x1a16
Info: filter timeout pid 0x0122
Info: filter timeout pid 0x0120
Info: filter timeout pid 0x011c
Info: filter timeout pid 0x0106
Info: filter timeout pid 0x0114
Info: filter timeout pid 0x010e
Info: filter timeout pid 0x0105
Info: filter timeout pid 0x0117
Info: filter timeout pid 0x0121
Info: filter timeout pid 0x0124
Info: filter timeout pid 0x0112
Info: filter timeout pid 0x0103
Info: filter timeout pid 0x011b
Info: filter timeout pid 0x010c
Info: filter timeout pid 0x0118
Info: filter timeout pid 0x0010
tune to:
>>> tuning status == 0x01
>>> tuning status == 0x1f
PAT
PMT 0x02c6 for service 0x4c00
  VIDEO     : PID 0x00cb
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x013a
  ISO/IEC 13818-6 Sections (any type, including private data) : PID 0x013b
  AUDIO     : PID 0x0197
  AUDIO     : PID 0x0198
  SUBTITLING: PID 0x025b
PMT 0x02ca for service 0x4280
  VIDEO     : PID 0x00cd
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x014a
  ISO/IEC 13818-6 Sections (any type, including private data) : PID 0x014b
  AUDIO     : PID 0x01a5
  SUBTITLING: PID 0x025d
PMT 0x02ce for service 0x4900
  AUDIO     : PID 0x01b7
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x014f
PMT 0x02bd for service 0x4180
  unknown private data: PID 0x00ca
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x0138
  ISO/IEC 13818-6 Sections (any type, including private data) : PID 0x0139
  unknown private data: PID 0x0193
  unknown private data: PID 0x0194
  unknown private data: PID 0x0195
  unknown private data: PID 0x0196
PMT 0x02cf for service 0x4780
  AUDIO     : PID 0x01b8
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x0150
PMT 0x02c4 for service 0x4700
  AUDIO     : PID 0x01b2
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x0143
PMT 0x02c2 for service 0x4680
  AUDIO     : PID 0x01b0
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x0142
PMT 0x02bf for service 0x4240
  VIDEO     : PID 0x00c9
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x0134
  DSM-CC U-N Messages : PID 0x0135
  ISO/IEC 13818-6 Sections (any type, including private data) : PID 0x0137
  AUDIO     : PID 0x0191
  AUDIO     : PID 0x0192
  SUBTITLING: PID 0x0259
PMT 0x02c3 for service 0x46c0
  AUDIO     : PID 0x01b1
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x0144
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x02c7
Info: filter timeout pid 0x02c9
Info: filter timeout pid 0x02c0
Info: filter timeout pid 0x02c5
Info: filter timeout pid 0x02cc
Info: filter timeout pid 0x02c8
Info: filter timeout pid 0x02c1
Info: filter timeout pid 0x02cd
Info: filter timeout pid 0x02be
PMT 0x02cb for service 0x4840
  AUDIO     : PID 0x01b4
  DSM-CC U-N Messages : PID 0x012d
  DSM-CC U-N Messages : PID 0x012e
  DSM-CC U-N Messages : PID 0x012f
  DSM-CC U-N Messages : PID 0x0130
  DSM-CC U-N Messages : PID 0x0131
  DSM-CC U-N Messages : PID 0x014c
Info: filter timeout pid 0x0010
tune to:
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
----------no signal----------
tune to:  (no signal)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x01
----------no signal----------
tune to:
>>> tuning status == 0x01
>>> tuning status == 0x1f
PAT
PMT 0x02ca for service 0x5a40
  AUDIO     : PID 0x076d
  DSM-CC U-N Messages : PID 0x076e
  DSM-CC U-N Messages : PID 0x0bb8
  ISO/IEC 13818-6 Sections (any type, including private data) : PID 0x0bba
  ISO/IEC 13818-6 Sections (any type, including private data) : PID 0x0bbb
  ISO/IEC 13818-6 Sections (any type, including private data) : PID 0x0bbd
  ISO/IEC 13818-6 Sections (any type, including private data) : PID 0x0bbe
PMT 0x02cc for service 0x5780
  DSM-CC U-N Messages : PID 0x025d
  DSM-CC U-N Messages : PID 0x025e
  DSM-CC U-N Messages : PID 0x0bb8
PMT 0x02cd for service 0x5c80
  DSM-CC U-N Messages : PID 0x0bc2
  DSM-CC U-N Messages : PID 0x0bc3
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x02bd
Info: filter timeout pid 0x02bf
Info: filter timeout pid 0x02c1
Info: filter timeout pid 0x02c8
Info: filter timeout pid 0x02cf
Info: filter timeout pid 0x02be
Info: filter timeout pid 0x02c2
PMT 0x02c0 for service 0x5700
  VIDEO     : PID 0x0191
  AUDIO     : PID 0x0192
  SUBTITLING: PID 0x0193
  AUDIO     : PID 0x0194
  DSM-CC U-N Messages : PID 0x0195
  DSM-CC U-N Messages : PID 0x0196
  DSM-CC U-N Messages : PID 0x0bb8
Info: filter timeout pid 0x02c9
Info: filter timeout pid 0x0010
dumping lists (66 services)
[2048]:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:514:652:8264
[20c0]:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:2826:2827:8384
[2100]:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:773:774:8448
[20fa]:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:590:591:8442
[20a1]:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:600:601:8353
[2243]:490000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:621:8771
[3242]:514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:6017:6018:12866
[3280]:514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:6673:6674:12928
[3900]:514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:6306:14592
[3940]:514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:6322:14656
[3d00]:514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:6513:6514:15616
[3ea0]:514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:6833:6834:16032
[4c00]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:203:407:19456
[4900]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:439:18688
[4840]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:436:18496
[4780]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:440:18304
[4700]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:434:18176
[46c0]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:433:18112
[4680]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:432:18048
[4280]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:205:421:17024
[4240]:570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:201:401:16960
[5a40]:666000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:0:1901:23104
[5700]:666000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_NONE:401:402:22272
Done.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
