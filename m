Return-path: <linux-media-owner@vger.kernel.org>
Received: from m2.nyi.net ([66.111.12.252]:35157 "EHLO m.nyi.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbeKZEA1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Nov 2018 23:00:27 -0500
Received: from [10.50.51.99] (urchin.nyi.net [64.147.100.2])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: viktor.savchenko@nyi.net)
        by m.nyi.net (Postfix) with ESMTPSA id D3BC310882D
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2018 11:47:22 -0500 (EST)
From: Viktor Savchenko <viktor.savchenko@nyi.net>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_5DC49CCF-F5EE-41BA-9573-0C2B82C96B67"
Reply-To: viktor.savchenko@uapeer.eu
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: cx23885 crash when 2 or more OTA PCIE tuners installed
Message-Id: <025DC864-29E4-4693-92A8-FC28F07F1B7D@nyi.net>
Date: Sun, 25 Nov 2018 11:47:22 -0500
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail=_5DC49CCF-F5EE-41BA-9573-0C2B82C96B67
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi. I found your email in dmesg for bug reports.
I=E2=80=99m using Hauppauge quadHD PCIE tuner, recently bought a second =
one and I=E2=80=99ve installed them in the same PC, running Ubuntu 18. =
After 5-10 minutes, PC became slow and I have found a flooding messages =
in sysclog, indicating a driver from =E2=80=9Cmediatree=E2=80=9D =
crashed.
If I take out one tuner, it=E2=80=99s stable. Can=E2=80=99t work with 2 =
or more. I=E2=80=99ve reached out to Hauppauge, but they say that it=E2=80=
=99s not their responsibility and I have to let the developer know. =
Please fix it. Thank you.

Victor.



--Apple-Mail=_5DC49CCF-F5EE-41BA-9573-0C2B82C96B67
Content-Disposition: attachment;
	filename=dmesg.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable

Nov 24 17:41:02 tvbuntu kernel: [    4.999910] WARNING: You are using an =
experimental version of the media stack.
Nov 24 17:41:02 tvbuntu kernel: [    4.999910]  As the driver is =
backported to an older kernel, it doesn't offer
Nov 24 17:41:02 tvbuntu kernel: [    4.999910]  enough quality for its =
usage in production.
Nov 24 17:41:02 tvbuntu kernel: [    4.999910]  Use it with care.
Nov 24 17:41:02 tvbuntu kernel: [    4.999910] Latest git patches =
(needed if you report a bug to linux-media@vger.kernel.org):
Nov 24 17:41:02 tvbuntu kernel: [    4.999910]  =
3c4a737267e89aafa6308c6c456d2ebea3fcd085 media: ov5640: fix frame =
interval enumeration
Nov 24 17:41:02 tvbuntu kernel: [    4.999910]  =
2bbc46e811f0d40ed92ff9c104fce6618049f726 media: v4l-common: Make =
v4l2_find_nearest_size more sparse-friendly
Nov 24 17:41:02 tvbuntu kernel: [    4.999910]  =
41cb1c739dcddf9905a5a3e3da9429b89cd5c616 media: ov5640: adjust xclk_max
Nov 24 17:41:02 tvbuntu kernel: [    5.032595] rndis_host 2-1.4:1.0 =
enx000dfe7e332b: renamed from eth1
Nov 24 17:41:02 tvbuntu kernel: [    5.040854] cx23885: cx23885 driver =
version 0.0.4 loaded
Nov 24 17:41:02 tvbuntu kernel: [    5.040978] cx23885: CORE cx23885[0]: =
subsystem: 0070:6a18, board: Hauppauge WinTV-QuadHD-ATSC =
[card=3D57,autodetected]
Nov 24 17:41:02 tvbuntu kernel: [    5.148258] rndis_host 2-1.5:1.0 =
enx000dfe7e3315: renamed from eth2
Nov 24 17:41:02 tvbuntu kernel: [    5.180294] rndis_host 2-1.3:1.0 =
enx000dfe7e3173: renamed from eth0
Nov 24 17:41:02 tvbuntu kernel: [    5.386530] tveeprom: Hauppauge model =
165100, rev B4I6, serial# 4036040101
Nov 24 17:41:02 tvbuntu kernel: [    5.386531] tveeprom: MAC address is =
00:0d:fe:91:15:a5
Nov 24 17:41:02 tvbuntu kernel: [    5.386532] tveeprom: tuner model is =
SiLabs Si2157 (idx 186, type 4)
Nov 24 17:41:02 tvbuntu kernel: [    5.386533] tveeprom: TV standards =
NTSC(M) ATSC/DVB Digital (eeprom 0x88)
Nov 24 17:41:02 tvbuntu kernel: [    5.386533] tveeprom: audio processor =
is CX23888 (idx 40)
Nov 24 17:41:02 tvbuntu kernel: [    5.386534] tveeprom: decoder =
processor is CX23888 (idx 34)
Nov 24 17:41:02 tvbuntu kernel: [    5.386535] tveeprom: has no radio, =
has IR receiver, has no IR transmitter
Nov 24 17:41:02 tvbuntu kernel: [    5.386535] cx23885: cx23885[0]: =
hauppauge eeprom: model=3D165100
Nov 24 17:41:02 tvbuntu kernel: [    5.402647] cx25840 9-0044: cx23888 =
A/V decoder found @ 0x88 (cx23885[0])

Nov 24 17:41:02 tvbuntu kernel: [    6.090478] cx25840 9-0044: loaded =
v4l-cx23885-avcore-01.fw firmware (16382 bytes)

Nov 24 17:41:02 tvbuntu kernel: [    6.181943] cx23885: cx23885[0]: =
registered device video0 [v4l2]
Nov 24 17:41:02 tvbuntu kernel: [    6.181980] cx23885: cx23885[0]: =
registered device vbi0
Nov 24 17:41:02 tvbuntu kernel: [    6.182063] cx23885: cx23885[0]: =
alsa: registered ALSA audio device
Nov 24 17:41:02 tvbuntu kernel: [    6.182065] cx23885: =
cx23885_dvb_register() allocating 1 frontend(s)
Nov 24 17:41:02 tvbuntu kernel: [    6.182066] cx23885: cx23885[0]: =
cx23885 based dvb card
Nov 24 17:41:02 tvbuntu kernel: [    6.182067] cx23885: dvb_register(): =
board=3D57 port=3D1

Nov 24 17:41:03 tvbuntu kernel: [    6.433222] cx23885: dvb_register(): =
QUADHD_ATSC analog setup
Nov 24 17:41:03 tvbuntu kernel: [    6.433224] dvbdev: DVB: registering =
new adapter (cx23885[0])
Nov 24 17:41:03 tvbuntu kernel: [    6.433226] cx23885 0000:03:00.0: =
DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3306A VSB/QAM =
Frontend)...
Nov 24 17:41:03 tvbuntu kernel: [    6.433441] cx23885: =
cx23885_dvb_register() allocating 1 frontend(s)
Nov 24 17:41:03 tvbuntu kernel: [    6.433442] cx23885: cx23885[0]: =
cx23885 based dvb card
Nov 24 17:41:03 tvbuntu kernel: [    6.433443] cx23885: dvb_register(): =
board=3D57 port=3D2
Nov 24 17:41:03 tvbuntu kernel: [    6.440395] si2157 8-0062: Silicon =
Labs Si2147/2148/2157/2158 successfully attached
Nov 24 17:41:03 tvbuntu kernel: [    6.440408] dvbdev: DVB: registering =
new adapter (cx23885[0])
Nov 24 17:41:03 tvbuntu kernel: [    6.440410] cx23885 0000:03:00.0: =
DVB: registering adapter 1 frontend 0 (LG Electronics LGDT3306A VSB/QAM =
Frontend)...
Nov 24 17:41:03 tvbuntu kernel: [    6.440626] cx23885: =
cx23885_dev_checkrevision() Hardware revision =3D 0xd0
Nov 24 17:41:03 tvbuntu kernel: [    6.440631] cx23885: cx23885[0]/0: =
found at 0000:03:00.0, rev: 4, irq: 17, latency: 0, mmio: 0xe1600000
Nov 24 17:41:03 tvbuntu kernel: [    6.440760] cx23885: CORE cx23885[1]: =
subsystem: 0070:6b18, board: Hauppauge WinTV-QuadHD-ATSC =
[card=3D57,autodetected]

Nov 24 17:41:03 tvbuntu kernel: [    6.786460] tveeprom: Hauppauge model =
165101, rev B4I6, serial# 4036040101
Nov 24 17:41:03 tvbuntu kernel: [    6.786462] tveeprom: MAC address is =
00:0d:fe:91:15:a5
Nov 24 17:41:03 tvbuntu kernel: [    6.786463] tveeprom: tuner model is =
SiLabs Si2157 (idx 186, type 4)
Nov 24 17:41:03 tvbuntu kernel: [    6.786464] tveeprom: TV standards =
NTSC(M) ATSC/DVB Digital (eeprom 0x88)
Nov 24 17:41:03 tvbuntu kernel: [    6.786465] tveeprom: audio processor =
is CX23888 (idx 40)
Nov 24 17:41:03 tvbuntu kernel: [    6.786465] tveeprom: decoder =
processor is CX23888 (idx 34)
Nov 24 17:41:03 tvbuntu kernel: [    6.786466] tveeprom: has no radio
Nov 24 17:41:03 tvbuntu kernel: [    6.786466] cx23885: cx23885[1]: =
hauppauge eeprom: model=3D165101
Nov 24 17:41:03 tvbuntu kernel: [    6.788285] cx25840 12-0044: cx23888 =
A/V decoder found @ 0x88 (cx23885[1])=

--Apple-Mail=_5DC49CCF-F5EE-41BA-9573-0C2B82C96B67
Content-Disposition: attachment;
	filename=fail_dump.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="fail_dump.txt"
Content-Transfer-Encoding: quoted-printable

Nov 24 18:21:36 tvbuntu kernel: [ 2440.066839] cx23885: cx23885[0]: mpeg =
risc op code error
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066853] cx23885: cx23885[0]: TS1 =
B - dma channel status dump
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066859] cx23885: cx23885[0]:   =
cmds: init risc lo   : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066865] cx23885: cx23885[0]:   =
cmds: init risc hi   : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066876] cx23885: cx23885[0]:   =
cmds: cdt base       : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066877] cx23885: cx23885[0]:   =
cmds: cdt size       : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066878] cx23885: cx23885[0]:   =
cmds: iq base        : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066879] cx23885: cx23885[0]:   =
cmds: iq size        : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066880] cx23885: cx23885[0]:   =
cmds: risc pc lo     : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066881] cx23885: cx23885[0]:   =
cmds: risc pc hi     : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066882] cx23885: cx23885[0]:   =
cmds: iq wr ptr      : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066883] cx23885: cx23885[0]:   =
cmds: iq rd ptr      : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066884] cx23885: cx23885[0]:   =
cmds: cdt current    : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066888] cx23885: cx23885[0]:   =
cmds: pci target lo  : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066889] cx23885: cx23885[0]:   =
cmds: pci target hi  : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066890] cx23885: cx23885[0]:   =
cmds: line / byte    : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066891] cx23885: cx23885[0]:   =
risc0:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066892] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066899] cx23885: cx23885[0]:   =
risc1:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066899] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066906] cx23885: cx23885[0]:   =
risc2:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066906] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066912] cx23885: cx23885[0]:   =
risc3:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066913] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066920] cx23885: cx23885[0]:   =
(0x00010630) iq 0:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066920] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066927] cx23885: cx23885[0]:   =
(0x00010634) iq 1:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066927] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066934] cx23885: cx23885[0]:   =
(0x00010638) iq 2:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066934] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066941] cx23885: cx23885[0]:   =
(0x0001063c) iq 3:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066941] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066948] cx23885: cx23885[0]:   =
(0x00010640) iq 4:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066948] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066954] cx23885: cx23885[0]:   =
(0x00010644) iq 5:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066954] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066961] cx23885: cx23885[0]:   =
(0x00010648) iq 6:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066961] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066968] cx23885: cx23885[0]:   =
(0x0001064c) iq 7:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066969] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066975] cx23885: cx23885[0]:   =
(0x00010650) iq 8:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066976] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066982] cx23885: cx23885[0]:   =
(0x00010654) iq 9:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066982] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066989] cx23885: cx23885[0]:   =
(0x00010658) iq a:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066989] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066996] cx23885: cx23885[0]:   =
(0x0001065c) iq b:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.066996] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067003] cx23885: cx23885[0]:   =
(0x00010660) iq c:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067003] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067010] cx23885: cx23885[0]:   =
(0x00010664) iq d:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067010] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067016] cx23885: cx23885[0]:   =
(0x00010668) iq e:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067016] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067023] cx23885: cx23885[0]:   =
(0x0001066c) iq f:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067023] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067028] cx23885: cx23885[0]: =
fifo: 0x00005000 -> 0x6000
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067029] cx23885: cx23885[0]: =
ctrl: 0x00010630 -> 0x10690
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067030] cx23885: cx23885[0]:   =
ptr1_reg: 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067031] cx23885: cx23885[0]:   =
ptr2_reg: 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067032] cx23885: cx23885[0]:   =
cnt1_reg: 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067033] cx23885: cx23885[0]:   =
cnt2_reg: 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067033] cx23885: cx23885[0]: mpeg =
risc op code error
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067037] cx23885: cx23885[0]: TS2 =
C - dma channel status dump
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067038] cx23885: cx23885[0]:   =
cmds: init risc lo   : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067039] cx23885: cx23885[0]:   =
cmds: init risc hi   : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067040] cx23885: cx23885[0]:   =
cmds: cdt base       : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067041] cx23885: cx23885[0]:   =
cmds: cdt size       : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067042] cx23885: cx23885[0]:   =
cmds: iq base        : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067043] cx23885: cx23885[0]:   =
cmds: iq size        : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067044] cx23885: cx23885[0]:   =
cmds: risc pc lo     : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067045] cx23885: cx23885[0]:   =
cmds: risc pc hi     : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067046] cx23885: cx23885[0]:   =
cmds: iq wr ptr      : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067047] cx23885: cx23885[0]:   =
cmds: iq rd ptr      : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067048] cx23885: cx23885[0]:   =
cmds: cdt current    : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067050] cx23885: cx23885[0]:   =
cmds: pci target lo  : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067051] cx23885: cx23885[0]:   =
cmds: pci target hi  : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067052] cx23885: cx23885[0]:   =
cmds: line / byte    : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067052] cx23885: cx23885[0]:   =
risc0:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067053] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067059] cx23885: cx23885[0]:   =
risc1:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067060] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067066] cx23885: cx23885[0]:   =
risc2:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067067] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067073] cx23885: cx23885[0]:   =
risc3:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067073] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067080] cx23885: cx23885[0]:   =
(0x00010670) iq 0:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067080] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067087] cx23885: cx23885[0]:   =
(0x00010674) iq 1:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067087] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067094] cx23885: cx23885[0]:   =
(0x00010678) iq 2:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067094] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067101] cx23885: cx23885[0]:   =
(0x0001067c) iq 3:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067101] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067108] cx23885: cx23885[0]:   =
(0x00010680) iq 4:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067108] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067115] cx23885: cx23885[0]:   =
(0x00010684) iq 5:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067115] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067129] cx23885: cx23885[0]:   =
(0x00010688) iq 6:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067129] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067136] cx23885: cx23885[0]:   =
(0x0001068c) iq 7:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067136] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067142] cx23885: cx23885[0]:   =
(0x00010690) iq 8:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067143] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067149] cx23885: cx23885[0]:   =
(0x00010694) iq 9:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067150] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067156] cx23885: cx23885[0]:   =
(0x00010698) iq a:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067156] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067163] cx23885: cx23885[0]:   =
(0x0001069c) iq b:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067163] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067168] cx23885: cx23885[0]:   =
(0x000106a0) iq c:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067169] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067176] cx23885: cx23885[0]:   =
(0x000106a4) iq d:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067177] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067199] cx23885: cx23885[0]:   =
(0x000106a8) iq e:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067199] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067206] cx23885: cx23885[0]:   =
(0x000106ac) iq f:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067206] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067211] cx23885: cx23885[0]: =
fifo: 0x00006000 -> 0x7000
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067212] cx23885: cx23885[0]: =
ctrl: 0x00010670 -> 0x106d0
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067214] cx23885: cx23885[0]:   =
ptr1_reg: 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067215] cx23885: cx23885[0]:   =
ptr2_reg: 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067215] cx23885: cx23885[0]:   =
cnt1_reg: 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067216] cx23885: cx23885[0]:   =
cnt2_reg: 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067217] cx23885: cx23885[0]: =
video risc op code error
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067218] cx23885: cx23885[0]: VID =
A - dma channel status dump
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067219] cx23885: cx23885[0]:   =
cmds: init risc lo   : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067220] cx23885: cx23885[0]:   =
cmds: init risc hi   : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067221] cx23885: cx23885[0]:   =
cmds: cdt base       : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067222] cx23885: cx23885[0]:   =
cmds: cdt size       : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067223] cx23885: cx23885[0]:   =
cmds: iq base        : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067224] cx23885: cx23885[0]:   =
cmds: iq size        : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067232] cx23885: cx23885[0]:   =
cmds: risc pc lo     : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067233] cx23885: cx23885[0]:   =
cmds: risc pc hi     : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067234] cx23885: cx23885[0]:   =
cmds: iq wr ptr      : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067235] cx23885: cx23885[0]:   =
cmds: iq rd ptr      : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067240] cx23885: cx23885[0]:   =
cmds: cdt current    : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067241] cx23885: cx23885[0]:   =
cmds: pci target lo  : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067242] cx23885: cx23885[0]:   =
cmds: pci target hi  : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067243] cx23885: cx23885[0]:   =
cmds: line / byte    : 0xffffffff
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067244] cx23885: cx23885[0]:   =
risc0:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067244] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067250] cx23885: cx23885[0]:   =
risc1:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067251] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067257] cx23885: cx23885[0]:   =
risc2:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067258] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067263] cx23885: cx23885[0]:   =
risc3:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067264] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067270] cx23885: cx23885[0]:   =
(0x000105b0) iq 0:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067271] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067277] cx23885: cx23885[0]:   =
(0x000105b4) iq 1:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067278] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067284] cx23885: cx23885[0]:   =
(0x000105b8) iq 2:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067285] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067291] cx23885: cx23885[0]:   =
(0x000105bc) iq 3:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067292] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067298] cx23885: cx23885[0]:   =
(0x000105c0) iq 4:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067299] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067305] cx23885: cx23885[0]:   =
(0x000105c4) iq 5:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067306] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067312] cx23885: cx23885[0]:   =
(0x000105c8) iq 6:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067312] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067319] cx23885: cx23885[0]:   =
(0x000105cc) iq 7:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067319] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067326] cx23885: cx23885[0]:   =
(0x000105d0) iq 8:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067326] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067333] cx23885: cx23885[0]:   =
(0x000105d4) iq 9:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067333] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067339] cx23885: cx23885[0]:   =
(0x000105d8) iq a:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067340] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067346] cx23885: cx23885[0]:   =
(0x000105dc) iq b:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067347] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067353] cx23885: cx23885[0]:   =
(0x000105e0) iq c:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067354] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067360] cx23885: cx23885[0]:   =
(0x000105e4) iq d:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067361] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067367] cx23885: cx23885[0]:   =
(0x000105e8) iq e:
Nov 24 18:21:36 tvbuntu kernel: [ 2440.067368] 0xffffffff [ INVALID sol =
eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=3D4095 ]=

--Apple-Mail=_5DC49CCF-F5EE-41BA-9573-0C2B82C96B67--
