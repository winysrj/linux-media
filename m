Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:56967 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbZG3UW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 16:22:27 -0400
Received: by qyk34 with SMTP id 34so1108769qyk.33
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2009 13:22:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <41092.94.179.232.217.1248973470.metamail@webmail.meta.ua>
References: <41092.94.179.232.217.1248973470.metamail@webmail.meta.ua>
Date: Thu, 30 Jul 2009 16:22:24 -0400
Message-ID: <303a8ee30907301322p658dd59eya90586c9507978f2@mail.gmail.com>
Subject: Re: What happen with driver cx23885?
From: Michael Krufky <mkrufky@kernellabs.com>
To: geroin22@meta.ua
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/7/30 <geroin22@meta.ua>
>
> Hi Michael
> I have tv card (Compro VideoMate E800) on cx23885 chipset, it work good
> (only DVB-T part) when i using driver v4l-dvb changeset till 11017
> http://linuxtv.org/hg/v4l-dvb/rev/c2e9ae022ea7, but when I try to update
> for new version changeset 11018 or newly, I can't scan or add channels in
> all TV views or players.when i used štip . If you know how correct it
> answed me.
>
> P.S. Sorry for my english
>
> My system
> Ubuntu 9.04 x86_64
> Linux 2.6.28-11-generic
>
> Not working can't add new channels with the last v4l-dvb changeset 12345
> http://linuxtv.org/hg/v4l-dvb/rev/ee6cf88cb5d3
> dmesg
> [ š 14.138166] cx23885 driver version 0.0.2 loaded
> [ š 14.138769] ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
> [ š 14.138785] cx23885 0000:04:00.0: PCI INT A -> Link[APC8] -> GSI 16
> (level, low) -> IRQ 16
> [ š 14.138963] CORE cx23885[0]: subsystem: 1858:e800, board: Compro
> VideoMate E650F [card=13,insmod option]
> [ š 14.227800] synaptics was reset on resume, see synaptics_resume_reset
> if you have trouble on resume
> [ š 14.322688] HDA Intel 0000:00:09.0: power state changed by ACPI to D0
> [ š 14.323201] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [ š 14.323209] HDA Intel 0000:00:09.0: PCI INT A -> Link[AAZA] -> GSI 22
> (level, low) -> IRQ 22
> [ š 14.323296] HDA Intel 0000:00:09.0: setting latency timer to 64
> [ š 14.336415] cx25840 2-0044: cx25 š0-21 found @ 0x88 (cx23885[0])
> [ š 14.340488] cx25840 2-0044: firmware: requesting v4l-cx23885-avcore-01.fw
> [ š 15.010428] cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw firmware
> (16382 bytes)
> [ š 15.016339] cx23885_dvb_register() allocating 1 frontend(s)
> [ š 15.016344] cx23885[0]: cx23885 based dvb card
> [ š 15.100946] xc2028 1-0061: creating new instance
> [ š 15.100950] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> [ š 15.100956] DVB: registering new adapter (cx23885[0])
> [ š 15.100960] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
> DVB-T)...
> [ š 15.101656] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [ š 15.101667] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
> latency: 0, mmio: 0xef600000
> [ š 15.101674] cx23885 0000:04:00.0: setting latency timer to 64
>
> scan -cv
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> dumping lists (0 services)
> Done.
>
> ~/.tzap$ scan metv > channels.conf
> scanning metv
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 634000000 0 9 9 6 2 4 4
> initial transponder 650000000 0 2 2 3 1 0 0
> initial transponder 714000000 0 9 9 6 2 4 4
> initial transponder 818000000 0 9 9 6 2 4 4
> >>> tune to:
> 634000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010
> >>> tune to:
> 650000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010
> >>> tune to:
> 714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010
> >>> tune to:
> 818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010
> dumping lists (0 services)
> Done.
>
> w_scan version 20081106
> Info: using DVB adapter auto detection.
> š Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> frontend Zarlink ZL10353 DVB-T supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> 177500:
> 184500:
> 191500:
> 198500:
> 205500:
> 212500:
> 219500:
> 226500:
> 474000:
> 482000:
> 490000:
> 498000:
> 506000:
> 514000:
> 522000:
> 530000:
> 538000:
> 546000:
> 554000:
> 562000:
> 570000:
> 578000:
> 586000:
> 594000:
> 602000:
> 610000:
> 618000:
> 626000:
> 634000: signal ok (I999B8C999D999M999T999G999Y999)
> 642000:
> 650000: signal ok (I999B8C999D999M999T999G999Y999)
> 658000:
> 666000:
> 674000:
> 682000:
> 690000:
> 698000:
> 706000:
> 714000: signal ok (I999B8C999D999M999T999G999Y999)
> 722000:
> 730000:
> 738000:
> 746000:
> 754000:
> 762000:
> 770000:
> 778000:
> 786000:
> 794000:
> 802000:
> 810000:
> 818000: signal ok (I999B8C999D999M999T999G999Y999)
> 826000:
> 834000:
> 842000:
> 850000:
> 858000:
> tune to: :634000:I999B8C999D999M999T999G999Y999:T:27500:
> Info: filter timeout pid 0x0011
> Info: filter timeout pid 0x0000
> Info: filter timeout pid 0x0010
> tune to: :650000:I999B8C999D999M999T999G999Y999:T:27500:
> Info: filter timeout pid 0x0011
> Info: filter timeout pid 0x0000
> Info: filter timeout pid 0x0010
> tune to: :714000:I999B8C999D999M999T999G999Y999:T:27500:
> Info: filter timeout pid 0x0011
> Info: filter timeout pid 0x0000
> Info: filter timeout pid 0x0010
> tune to: :818000:I999B8C999D999M999T999G999Y999:T:27500:
> Info: filter timeout pid 0x0011
> Info: filter timeout pid 0x0000
> Info: filter timeout pid 0x0010
> dumping lists (0 services)
> Done.
>
>
> Work fine with the v4l-dvb changeset 11017
> http://linuxtv.org/hg/v4l-dvb/rev/c2e9ae022ea7
>
> dmesg
>
> [ š 13.400319] Linux video capture interface: v2.00
> [ š 13.584724] cx23885 driver version 0.0.1 loaded
> [ š 13.585254] ACPI: PCI Interrupt Link [APC8] enabled at IRQ 16
> [ š 13.585266] cx23885 0000:04:00.0: PCI INT A -> Link[APC8] -> GSI 16
> (level, low) -> IRQ 16
> [ š 13.585421] CORE cx23885[0]: subsystem: 1858:e800, board: Compro
> VideoMate E650F [card=13,insmod option]
> [ š 13.661794] HDA Intel 0000:00:09.0: power state changed by ACPI to D0
> [ š 13.662212] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [ š 13.662217] HDA Intel 0000:00:09.0: PCI INT A -> Link[AAZA] -> GSI 22
> (level, low) -> IRQ 22
> [ š 13.662264] HDA Intel 0000:00:09.0: setting latency timer to 64
> [ š 13.769137] cx25840' 2-0044: cx25 š0-21 found @ 0x88 (cx23885[0])
> [ š 13.769936] cx23885_dvb_register() allocating 1 frontend(s)
> [ š 13.769943] cx23885[0]: cx23885 based dvb card
> [ š 13.836235] xc2028 1-0061: creating new instance
> [ š 13.836241] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> [ š 13.836249] DVB: registering new adapter (cx23885[0])
> [ š 13.836255] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
> DVB-T)...
> [ š 13.837169] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [ š 13.837180] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
> latency: 0, mmio: 0xef600000
> [ š 13.837188] cx23885 0000:04:00.0: setting latency timer to 64
>
> w_scan version 20081106
> Info: using DVB adapter auto detection.
> š Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> frontend Zarlink ZL10353 DVB-T supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> 177500:
> 184500:
> 191500:
> 198500:
> 205500:
> 212500:
> 219500:
> 226500:
> 474000:
> 482000:
> 490000:
> 498000:
> 506000:
> 514000:
> 522000:
> 530000:
> 538000:
> 546000:
> 554000:
> 562000:
> 570000:
> 578000:
> 586000:
> 594000:
> 602000:
> 610000:
> 618000:
> 626000:
> 634000: signal ok (I999B8C999D999M999T999G999Y999)
> 642000:
> 650000: signal ok (I999B8C999D999M999T999G999Y999)
> 658000:
> 666000:
> 674000:
> 682000:
> 690000:
> 698000:
> 706000:
> 714000: signal ok (I999B8C999D999M999T999G999Y999)
> 722000:
> 730000:
> 738000:
> 746000:
> 754000:
> 762000:
> 770000:
> 778000:
> 786000:
> 794000:
> 802000:
> 810000:
> 818000: signal ok (I999B8C999D999M999T999G999Y999)
> 826000:
> 834000:
> 842000:
> 850000:
> 858000:
> tune to: :634000:I999B8C999D999M999T999G999Y999:T:27500:
> Network Name 'CONCERN RRT'
> š š UT-1(ERA PRODUCTION)
> š š K1(ERA PRODUCTION)
> š š RADA(ERA PRODUCTION)
> š š TV KYIV(ERA PRODUCTION)
> tune to: :650000:I999B8C999D999M999T999G999Y999:T:27500:
> Network Name 'EXPRESS-INFORM'
> copying transponder info (650000)
> š š 5 KANAL(KRRT)
> š š MEGASPORT(KRRT)
> š š TONIS(KRRT)
> š š OTV(KRRT)
> š š ICTV(KRRT)
> tune to: :714000:I999B8C999D999M999T999G999Y999:T:27500:
> Network Name 'UDTVN'
> š š MEGASPORT (TEST)(UDTVN)
> š š KULTURA (TEST)(UDTVN)
> š š INTER (TEST)(UDTVN)
> š š FOOTBALL (TEST)(UDTVN)
> š š M2 (TEST)(UDTVN)
> š š KDRTRK (TEST)(UDTVN)
> š š MUSICBOX (TEST)(UDTVN)
> š š TBi (TEST)(UDTVN)
> š š NTN(UDTVN)
> š š GUMOR TV (TEST)(UDTVN)
> tune to: :818000:I999B8C999D999M999T999G999Y999:T:27500:
> š š GAMMA(GAMMA CONSULTING)
> š š M2(GAMMA CONSULTING)
> š š M1(GAMMA CONSULTING)
> š š RUMUSIC(GAMMA CONSULTING)
> š š NEWS_ONE(GAMMA CONSULTING)
> Network Name 'Gamma consulting'
> dumping lists (24 services)
> UT-1:634000:I999B8C999D999M999T999G999Y999:T:27500:4111:4112=UKR:0:0:1:0:0:0
> K1:634000:I999B8C999D999M999T999G999Y999:T:27500:4121:4122:0:0:2:0:0:0
> RADA:634000:I999B8C999D999M999T999G999Y999:T:27500:4131:4132=ukr:0:0:3:0:0:0
> TV KYIV:634000:I999B8C999D999M999T999G999Y999:T:27500:4141:4142:0:0:4:0:0:0
> 5 KANAL:650000:I999B8C23D23M64T8G32Y0:T:27500:4311:4312=ukr:0:0:1:8259:43:0
> MEGASPORT:650000:I999B8C23D23M64T8G32Y0:T:27500:4321:4322:0:0:2:8259:43:0
> TONIS:650000:I999B8C23D23M64T8G32Y0:T:27500:4331+4339:4332:0:0:3:8259:43:0
> OTV:650000:I999B8C23D23M64T8G32Y0:T:27500:4341:4342:0:0:4:8259:43:0
> ICTV:650000:I999B8C23D23M64T8G32Y0:T:27500:4351:4352:0:0:5:8259:43:0
> MEGASPORT
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1011:1012=ukr:0:0:1:0:0:0
> KULTURA
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1021:1022=ukr:0:0:2:0:0:0
> INTER
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1031:1032=ukr:0:0:3:0:0:0
> FOOTBALL
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1041:1042=ukr:0:0:4:0:0:0
> M2
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1051:1052=ukr:0:0:5:0:0:0
> KDRTRK
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1061:1062=ukr:0:0:6:0:0:0
> MUSICBOX
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1071:1072=ukr:0:0:7:0:0:0
> TBi
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1081:1082=ukr:0:0:8:0:0:0
> NTN:714000:I999B8C999D999M999T999G999Y999:T:27500:1091:1092=ukr:0:0:9:0:0:0
> GUMOR TV
> (TEST):714000:I999B8C999D999M999T999G999Y999:T:27500:1101:1102=ukr:0:0:10:0:0:0
> GAMMA:818000:I999B8C999D999M999T999G999Y999:T:27500:100:101=rus:0:0:1:0:0:0
> M2:818000:I999B8C999D999M999T999G999Y999:T:27500:110:111=rus:0:0:2:0:0:0
> M1:818000:I999B8C999D999M999T999G999Y999:T:27500:130:131=rus:0:0:3:0:0:0
> RUMUSIC:818000:I999B8C999D999M999T999G999Y999:T:27500:120:121=rus:0:0:4:0:0:0
> NEWS_ONE:818000:I999B8C999D999M999T999G999Y999:T:27500:140:141=ukr:0:0:5:0:0:0
> Done.
>
> ______________________________
> íÏÑ ÐÏÞÔÁ ÖÉ×ÅÔ ÎÁ íÅÔÅ http://webmail.meta.ua
>


In the future, please email the mailing list (cc added) rather that
emailing me directly.š If you really want to email a developer
directly, please at least CC the mailing list.

This is a known issue that has already been repaired.š The fix is in
the following tree, merge request to the master development repository
is still pending.

http://kernellabs.com/hg/~stoth/hvr1700/

Regards,

Mike
