Return-path: <linux-media-owner@vger.kernel.org>
Received: from forwards4.yandex.ru ([77.88.32.20]:46365 "EHLO
	forwards4.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbZEWPBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 11:01:34 -0400
Received: from webmail105.yandex.ru (webmail105.yandex.ru [95.108.131.131])
	by forwards4.yandex.ru (Yandex) with ESMTP id 22DEB4C53FD
	for <linux-media@vger.kernel.org>; Sat, 23 May 2009 18:48:24 +0400 (MSD)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by webmail105.yandex.ru (Yandex) with ESMTP id 148DDC283C3
	for <linux-media@vger.kernel.org>; Sat, 23 May 2009 18:48:24 +0400 (MSD)
From: Vladimir Geroy <geroin22@yandex.ru>
To: linux-media@vger.kernel.org
Subject: Can't scan or add channels with new version of driver
MIME-Version: 1.0
Message-Id: <34981243090103@webmail105.yandex.ru>
Date: Sat, 23 May 2009 18:48:23 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using driver v4l-dvb changeset befor 11017  http://linuxtv.org/hg/v4l-dvb/rev/c2e9ae022ea7 my configuration work fine, but when I try to update for new version changeset 11018 or newly, I can't scan or add channels in all TV views or players.

My configuration:

Ubuntu 9.04 x86_64
Linux 2.6.28-11-generic
Compro VideoMate E650F


Work fine with the v4l-dvb changeset 11017  http://linuxtv.org/hg/v4l-dvb/rev/c2e9ae022ea7

dmesg

[   13.400319] Linux video capture interface: v2.00
[   13.584724] cx23885 driver version 0.0.1 loaded
[   13.585254] ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
[   13.585266] cx23885 0000:04:00.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
[   13.585421] CORE cx23885[0]: subsystem: 1858:e800, board: Compro VideoMate E650F [card=13,insmod option]
[   13.661794] HDA Intel 0000:00:09.0: power state changed by ACPI to D0
[   13.662212] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   13.662217] HDA Intel 0000:00:09.0: PCI INT A -> Link[AAZA] -> GSI 22 (level, low) -> IRQ 22
[   13.662264] HDA Intel 0000:00:09.0: setting latency timer to 64
[   13.769137] cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   13.769936] cx23885_dvb_register() allocating 1 frontend(s)
[   13.769943] cx23885[0]: cx23885 based dvb card
[   13.836235] xc2028 1-0061: creating new instance
[   13.836241] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   13.836249] DVB: registering new adapter (cx23885[0])
[   13.836255] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   13.837169] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   13.837180] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xef600000
[   13.837188] cx23885 0000:04:00.0: setting latency timer to 64

w_scan version 20081106
Info: using DVB adapter auto detection.
   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
frontend Zarlink ZL10353 DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
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
490000: 
498000: 
506000: 
514000: 
522000: 
530000: 
538000: 
546000: 
554000: 
562000: 
570000: 
578000: 
586000: 
594000: 
602000: 
610000: 
618000: 
626000: 
634000: signal ok (I999B8C999D999M999T999G999Y999)
642000: 
650000: signal ok (I999B8C999D999M999T999G999Y999)
658000: 
666000: 
674000: 
682000: 
690000: 
698000: 
706000: 
714000: signal ok (I999B8C999D999M999T999G999Y999)
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
818000: signal ok (I999B8C999D999M999T999G999Y999)
826000: 
834000: 
842000: 
850000: 
858000: 
tune to: :634000:I999B8C999D999M999T999G999Y999:T:27500:
Network Name 'CONCERN RRT'
     UT-1(ERA PRODUCTION)
     K1(ERA PRODUCTION)
     RADA(ERA PRODUCTION)
     TV KYIV(ERA PRODUCTION)
tune to: :650000:I999B8C999D999M999T999G999Y999:T:27500:
Network Name 'EXPRESS-INFORM'
copying transponder info (650000)
     5 KANAL(KRRT)
     MEGASPORT(KRRT)
     TONIS(KRRT)
     OTV(KRRT)
     ICTV(KRRT)
tune to: :714000:I999B8C999D999M999T999G999Y999:T:27500:
Network Name 'UDTVN'
     MEGASPORT (TEST)(UDTVN)
     KULTURA (TEST)(UDTVN)
     INTER (TEST)(UDTVN)
     FOOTBALL (TEST)(UDTVN)
     M2 (TEST)(UDTVN)
     KDRTRK (TEST)(UDTVN)
     MUSICBOX (TEST)(UDTVN)
     TBi (TEST)(UDTVN)
     NTN(UDTVN)
     GUMOR TV (TEST)(UDTVN)
tune to: :818000:I999B8C999D999M999T999G999Y999:T:27500:
     GAMMA(GAMMA CONSULTING)
     M2(GAMMA CONSULTING)
     M1(GAMMA CONSULTING)
     RUMUSIC(GAMMA CONSULTING)
     NEWS_ONE(GAMMA CONSULTING)
Network Name 'Gamma consulting'
dumping lists (24 services)
UT-1:634000:I999B8C999D999M999T999G999Y999:T:27500:4111:4112=UKR:0:0:1:0:0:0
K1:634000:I999B8C999D999M999T999G999Y999:T:27500:4121:4122:0:0:2:0:0:0
RADA:634000:I999B8C999D999M999T999G999Y999:T:27500:4131:4132=ukr:0:0:3:0:0:0
TV KYIV:634000:I999B8C999D999M999T999G999Y999:T:27500:4141:4142:0:0:4:0:0:0
5 KANAL:650000:I999B8C23D23M64T8G32Y0:T:27500:4311:4312=ukr:0:0:1:8259:43:0
MEGASPORT:650000:I999B8C23D23M64T8G32Y0:T:27500:4321:4322:0:0:2:8259:43:0
TONIS:650000:I999B8C23D23M64T8G32Y0:T:27500:4331+4339:4332:0:0:3:8259:43:0
OTV:650000:I999B8C23D23M64T8G32Y0:T:27500:4341:4342:0:0:4:8259:43:0
ICTV:650000:I999B8C23D23M64T8G32Y0:T:27500:4351:4352:0:0:5:8259:43:0
MEGASPORT (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1011:1012=ukr:0:0:1:0:0:0
KULTURA (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1021:1022=ukr:0:0:2:0:0:0
INTER (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1031:1032=ukr:0:0:3:0:0:0
FOOTBALL (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1041:1042=ukr:0:0:4:0:0:0
M2 (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1051:1052=ukr:0:0:5:0:0:0
KDRTRK (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1061:1062=ukr:0:0:6:0:0:0
MUSICBOX (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1071:1072=ukr:0:0:7:0:0:0
TBi (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1081:1082=ukr:0:0:8:0:0:0
NTN:714000:I999B8C999D999M999T999G999Y999:T:27500:1091:1092=ukr:0:0:9:0:0:0
GUMOR TV (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1101:1102=ukr:0:0:10:0:0:0
GAMMA:818000:I999B8C999D999M999T999G999Y999:T:27500:100:101=rus:0:0:1:0:0:0
M2:818000:I999B8C999D999M999T999G999Y999:T:27500:110:111=rus:0:0:2:0:0:0
M1:818000:I999B8C999D999M999T999G999Y999:T:27500:130:131=rus:0:0:3:0:0:0
RUMUSIC:818000:I999B8C999D999M999T999G999Y999:T:27500:120:121=rus:0:0:4:0:0:0
NEWS_ONE:818000:I999B8C999D999M999T999G999Y999:T:27500:140:141=ukr:0:0:5:0:0:0
Done.

Not working with v4l-dvb changeset 11018  http://linuxtv.org/hg/v4l-dvb/rev/526aa050c3d8

dmesg

[   13.583498] cx23885 driver version 0.0.1 loaded
[   13.584290] ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
[   13.584309] cx23885 0000:04:00.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
[   13.584502] CORE cx23885[0]: subsystem: 1858:e800, board: Compro VideoMate E650F [card=13,insmod option]
[   13.710505] HDA Intel 0000:00:09.0: power state changed by ACPI to D0
[   13.710925] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   13.710930] HDA Intel 0000:00:09.0: PCI INT A -> Link[AAZA] -> GSI 22 (level, low) -> IRQ 22
[   13.710979] HDA Intel 0000:00:09.0: setting latency timer to 64
[   13.761782] cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   13.762480] cx23885_dvb_register() allocating 1 frontend(s)
[   13.762486] cx23885[0]: cx23885 based dvb card
[   13.822046] xc2028 1-0061: creating new instance
[   13.822050] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   13.822056] DVB: registering new adapter (cx23885[0])
[   13.822060] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   13.822573] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   13.822581] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xef600000
[   13.822588] cx23885 0000:04:00.0: setting latency timer to 64

w_scan version 20081106
Info: using DVB adapter auto detection.
   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
frontend Zarlink ZL10353 DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
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
490000: 
498000: 
506000: 
514000: 
522000: 
530000: 
538000: 
546000: 
554000: 
562000: 
570000: 
578000: 
586000: 
594000: 
602000: 
610000: 
618000: 
626000: 
634000: 
642000: 
650000: 
658000: 
666000: 
674000: 
682000: 
690000: 
698000: 
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
ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!
dumping lists (0 services)
Done.


Not working can't add new channels with the last v4l-dvb changeset 11824  http://linuxtv.org/hg/v4l-dvb/rev/315bc4b65b4f

dmesg

[   13.636367] cx23885 driver version 0.0.2 loaded
[   13.637099] ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
[   13.637117] cx23885 0000:04:00.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
[   13.637316] CORE cx23885[0]: subsystem: 1858:e800, board: Compro VideoMate E650F [card=13,insmod option]
[   13.762876] HDA Intel 0000:00:09.0: power state changed by ACPI to D0
[   13.763296] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   13.763301] HDA Intel 0000:00:09.0: PCI INT A -> Link[AAZA] -> GSI 22 (level, low) -> IRQ 22
[   13.763351] HDA Intel 0000:00:09.0: setting latency timer to 64
[   13.816992] cx25840 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   13.821025] cx25840 2-0044: firmware: requesting v4l-cx23885-avcore-01.fw
[   14.328671] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:09.0/input/input5
[   14.468886] cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
[   14.474795] cx23885_dvb_register() allocating 1 frontend(s)
[   14.474799] cx23885[0]: cx23885 based dvb card
[   14.551275] xc2028 1-0061: creating new instance
[   14.551278] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   14.551285] DVB: registering new adapter (cx23885[0])
[   14.551288] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   14.551859] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   14.551867] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xef600000
[   14.551874] cx23885 0000:04:00.0: setting latency timer to 64

w_scan version 20081106
Info: using DVB adapter auto detection.
   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
frontend Zarlink ZL10353 DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
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
490000: 
498000: 
506000: 
514000: 
522000: 
530000: 
538000: 
546000: 
554000: 
562000: 
570000: 
578000: 
586000: 
594000: 
602000: 
610000: 
618000: 
626000: 
634000: signal ok (I999B8C999D999M999T999G999Y999)
642000: 
650000: signal ok (I999B8C999D999M999T999G999Y999)
658000: 
666000: 
674000: 
682000: 
690000: 
698000: 
706000: 
714000: signal ok (I999B8C999D999M999T999G999Y999)
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
818000: signal ok (I999B8C999D999M999T999G999Y999)
826000: 
834000: 
842000: 
850000: 
858000: 
tune to: :634000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to: :650000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to: :714000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
tune to: :818000:I999B8C999D999M999T999G999Y999:T:27500:
Info: filter timeout pid 0x0011
Info: filter timeout pid 0x0000
Info: filter timeout pid 0x0010
dumping lists (0 services)
Done.

P.S. Sorry for my english
