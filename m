Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:33589 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaAZQXO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 11:23:14 -0500
Received: by mail-we0-f176.google.com with SMTP id t61so4287949wes.21
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 08:23:13 -0800 (PST)
Received: from [192.168.0.104] (host86-142-106-19.range86-142.btcentralplus.com. [86.142.106.19])
        by mx.google.com with ESMTPSA id fm3sm18727582wib.8.2014.01.26.08.23.08
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 26 Jan 2014 08:23:10 -0800 (PST)
Message-ID: <52E5366A.807@googlemail.com>
Date: Sun, 26 Jan 2014 16:23:06 +0000
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <52DECF44.1070609@googlemail.com> <52DEDFCB.6010802@googlemail.com> <20140122115334.GA14710@minime.bse> <52DFC300.8010508@googlemail.com> <20140122135036.GA14871@minime.bse> <52E00AD0.2020402@googlemail.com> <20140123132741.GA15756@minime.bse> <52E1273F.90207@googlemail.com> <20140125152339.GA18168@minime.bse> <52E4EFBB.7070504@googlemail.com> <20140126125552.GA26918@minime.bse>
In-Reply-To: <20140126125552.GA26918@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/01/14 12:55, Daniel Glöckner wrote:
> On Sun, Jan 26, 2014 at 11:21:31AM +0000, Robert Longbottom wrote:
>> 0F0 000000F9 PLL_F_LO
>> 0F4 000000DC PLL_F_HI
>> 0F8 0000008E PLL_XCI
>
> The PLL is enabled and configured for a 28.63636MHz input clock.
> With the default board config these registers are not touched
> at all, so this must be a remnant of testing with another board
> number. Please repeat with pll=35,35,35,35 .

Ah, yes, sorry about that, it will be the result of me messing around 
trying different things in the hope I can stumble across something that 
works.

robert@quad ~ $ sudo rmmod bttv
robert@quad ~ $ sudo modprobe bttv pll=35,35,35,35
robert@quad ~ $ xawtv -c /dev/video0

robert@quad ~/dev/8604PW $ sudo ./dumpbt8xx /dev/video0 > dumpbt8xx.data

produces:

000 000000D7 DSTATUS
004 00000053 IFORM
008 00000000 TDEC
00C 000000D2 E_CROP
010 000000FE E_VDELAY_LO
014 000000E0 E_VACTIVE_LO
018 00000078 E_HDELAY_LO
01C 00000080 E_HACTIVE_LO
020 00000002 E_HSCALE_HI
024 000000AC E_HSCALE_LO
028 00000000 BRIGHT
02C 00000022 E_CONTROL
030 000000D8 CONTRAST_LO
034 00000000 SAT_U_LO
038 000000B5 SAT_V_LO
03C 00000000 HUE
040 00000000 E_SCLOOP
044 000000CF WC_UP
048 00000006 OFORM
04C 00000020 E_VSCALE_HI
050 00000000 E_VSCALE_LO
054 00000001 TEST
058 00000000 ARESET
060 0000007F ADELAY
064 00000072 BDELAY
068 00000081 ADC
06C 00000000 E_VTC
078 0000007F WC_DOWN
080 0000007F TGLB
084 00000000 TGCTRL
08C 000000D2 O_CROP
090 000000FE O_VDELAY_LO
094 000000E0 O_VACTIVE_LO
098 00000078 O_HDELAY_LO
09C 00000080 O_HACTIVE_LO
0A0 00000002 O_HSCALE_HI
0A4 000000AC O_HSCALE_LO
0AC 00000022 O_CONTROL
0B0 00000000 VTOTAL_LO
0B4 00000000 VTOTAL_HI
0C0 00000000 O_SCLOOP
0CC 00000020 O_VSCALE_HI
0D0 00000000 O_VSCALE_LO
0D4 00000000 COLOR_FMT
0D8 00000010 COLOR_CTL
0DC 00000003 CAP_CTL
0E0 000000FF VBI_PACK_SIZE
0E4 00000001 VBI_PACK_DEL
0E8 00000082 FCAP
0EC 00000000 O_VTC
0F0 00000000 PLL_F_LO
0F4 00000000 PLL_F_HI
0F8 00000000 PLL_XCI
0FC 00000000 DVSIF
100 0A00000C INT_STAT
104 000C0B13 INT_MASK
10C 0000C0AF GPIO_DMA_CTL
110 00000003 I2C
114 32734000 RISC_STRT_ADD
118 00000000 GPIO_OUT_EN
11C 00000000 GPIO_REG_INP
120 32734000 RISC_COUNT
200 000FFFFF GPIO_DATA

and /var/log/messages still fills up with timeouts

Jan 26 16:13:59 quad sudo:   robert : TTY=pts/1 ; PWD=/home/robert ; 
USER=root ; COMMAND=/sbin/modprobe bttv pll=35,35,35,35
Jan 26 16:13:59 quad sudo: pam_unix(sudo:session): session opened for 
user root by robert(uid=0)
Jan 26 16:13:59 quad kernel: [13524.035909] bttv: driver version 0.9.19 
loaded
Jan 26 16:13:59 quad kernel: [13524.035918] bttv: using 8 buffers with 
2080k (520 pages) each for capture
Jan 26 16:13:59 quad kernel: [13524.036015] bttv: Bt8xx card found (0)
Jan 26 16:13:59 quad kernel: [13524.036050] bttv: 0: Bt878 (rev 17) at 
0000:02:0c.0, irq: 16, latency: 32, mmio: 0xd5000000
Jan 26 16:13:59 quad kernel: [13524.036639] bttv: 0: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 26 16:13:59 quad kernel: [13524.082056] bttv: 0: tuner type unset
Jan 26 16:13:59 quad kernel: [13524.082366] bttv: 0: registered device 
video0
Jan 26 16:13:59 quad kernel: [13524.082418] bttv: 0: registered device vbi0
Jan 26 16:13:59 quad kernel: [13524.082447] bttv: 0: PLL can sleep, 
using XTAL (35468950)
Jan 26 16:13:59 quad kernel: [13524.086752] bttv: Bt8xx card found (1)
Jan 26 16:13:59 quad kernel: [13524.086804] bttv: 1: Bt878 (rev 17) at 
0000:02:0d.0, irq: 17, latency: 32, mmio: 0xd5002000
Jan 26 16:13:59 quad kernel: [13524.086933] bttv: 1: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 26 16:13:59 quad kernel: [13524.088195] tveeprom 5-0050: Huh, no 
eeprom present (err=-6)?
Jan 26 16:13:59 quad kernel: [13524.088206] bttv: 1: tuner type unset
Jan 26 16:13:59 quad kernel: [13524.088317] bttv: 1: registered device 
video1
Jan 26 16:13:59 quad kernel: [13524.088350] bttv: 1: registered device vbi1
Jan 26 16:13:59 quad kernel: [13524.088373] bttv: 1: PLL can sleep, 
using XTAL (35468950)
Jan 26 16:13:59 quad kernel: [13524.092691] bttv: Bt8xx card found (2)
Jan 26 16:13:59 quad kernel: [13524.092729] bttv: 2: Bt878 (rev 17) at 
0000:02:0e.0, irq: 18, latency: 32, mmio: 0xd5004000
Jan 26 16:13:59 quad kernel: [13524.092802] bttv: 2: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 26 16:13:59 quad kernel: [13524.093704] tveeprom 6-0050: Huh, no 
eeprom present (err=-6)?
Jan 26 16:13:59 quad kernel: [13524.093711] bttv: 2: tuner type unset
Jan 26 16:13:59 quad kernel: [13524.093854] bttv: 2: registered device 
video2
Jan 26 16:13:59 quad kernel: [13524.093904] bttv: 2: registered device vbi2
Jan 26 16:13:59 quad kernel: [13524.093932] bttv: 2: PLL can sleep, 
using XTAL (35468950)
Jan 26 16:13:59 quad kernel: [13524.102337] bttv: Bt8xx card found (3)
Jan 26 16:13:59 quad kernel: [13524.102364] bttv: 3: Bt878 (rev 17) at 
0000:02:0f.0, irq: 19, latency: 32, mmio: 0xd5006000
Jan 26 16:13:59 quad kernel: [13524.102405] bttv: 3: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 26 16:13:59 quad kernel: [13524.103488] tveeprom 7-0050: Huh, no 
eeprom present (err=-6)?
Jan 26 16:13:59 quad kernel: [13524.103493] bttv: 3: tuner type unset
Jan 26 16:13:59 quad kernel: [13524.103604] bttv: 3: registered device 
video3
Jan 26 16:13:59 quad kernel: [13524.103640] bttv: 3: registered device vbi3
Jan 26 16:13:59 quad kernel: [13524.103663] bttv: 3: PLL can sleep, 
using XTAL (35468950)
Jan 26 16:13:59 quad kernel: [13524.107845] bttv: Bt8xx card found (4)
Jan 26 16:13:59 quad kernel: [13524.107880] bttv: 4: Bt878 (rev 17) at 
0000:03:04.0, irq: 17, latency: 32, mmio: 0xd5100000
Jan 26 16:13:59 quad kernel: [13524.107955] bttv: 4: detected: IVC-200 
[card=102], PCI subsystem ID is 0000:a155
Jan 26 16:13:59 quad kernel: [13524.107957] bttv: 4: using: IVC-200 
[card=102,autodetected]
Jan 26 16:13:59 quad kernel: [13524.108285] bttv: 4: tuner absent
Jan 26 16:13:59 quad kernel: [13524.108408] bttv: 4: registered device 
video4
Jan 26 16:13:59 quad kernel: [13524.108463] bttv: 4: registered device vbi4
Jan 26 16:13:59 quad kernel: [13524.108489] bttv: 4: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.110761] bttv: 4: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.112678] bttv: 4: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.119032] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.121026] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.124310] bttv: Bt8xx card found (5)
Jan 26 16:13:59 quad kernel: [13524.124345] bttv: 5: Bt878 (rev 17) at 
0000:03:05.0, irq: 18, latency: 32, mmio: 0xd5102000
Jan 26 16:13:59 quad kernel: [13524.124427] bttv: 5: detected: IVC-200 
[card=102], PCI subsystem ID is 0001:a155
Jan 26 16:13:59 quad kernel: [13524.124431] bttv: 5: using: IVC-200 
[card=102,autodetected]
Jan 26 16:13:59 quad kernel: [13524.124678] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.124896] bttv: 5: tuner absent
Jan 26 16:13:59 quad kernel: [13524.126169] bttv: 5: registered device 
video5
Jan 26 16:13:59 quad kernel: [13524.126384] bttv: 5: registered device vbi5
Jan 26 16:13:59 quad kernel: [13524.126417] bttv: 5: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.128074] bttv: 5: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.129404] bttv: 5: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.137031] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.139017] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.140161] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.142092] bttv: Bt8xx card found (6)
Jan 26 16:13:59 quad kernel: [13524.142145] bttv: 6: Bt878 (rev 17) at 
0000:03:06.0, irq: 19, latency: 32, mmio: 0xd5104000
Jan 26 16:13:59 quad kernel: [13524.142235] bttv: 6: detected: IVC-200 
[card=102], PCI subsystem ID is 0002:a155
Jan 26 16:13:59 quad kernel: [13524.142239] bttv: 6: using: IVC-200 
[card=102,autodetected]
Jan 26 16:13:59 quad kernel: [13524.142869] bttv: 6: tuner absent
Jan 26 16:13:59 quad kernel: [13524.143129] bttv: 6: registered device 
video6
Jan 26 16:13:59 quad kernel: [13524.143339] bttv: 6: registered device vbi6
Jan 26 16:13:59 quad kernel: [13524.143527] bttv: 6: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.146175] bttv: 6: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.147895] bttv: 6: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.154042] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.157024] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.158269] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.158570] bttv: Bt8xx card found (7)
Jan 26 16:13:59 quad kernel: [13524.158603] bttv: 7: Bt878 (rev 17) at 
0000:03:07.0, irq: 16, latency: 32, mmio: 0xd5106000
Jan 26 16:13:59 quad kernel: [13524.158647] bttv: 7: detected: IVC-200 
[card=102], PCI subsystem ID is 0003:a155
Jan 26 16:13:59 quad kernel: [13524.158651] bttv: 7: using: IVC-200 
[card=102,autodetected]
Jan 26 16:13:59 quad kernel: [13524.159375] bttv: 7: tuner absent
Jan 26 16:13:59 quad kernel: [13524.159769] bttv: 7: registered device 
video7
Jan 26 16:13:59 quad kernel: [13524.160042] bttv: 7: registered device vbi7
Jan 26 16:13:59 quad kernel: [13524.160077] bttv: 7: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.162307] bttv: 7: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.166694] bttv: 7: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 26 16:13:59 quad kernel: [13524.171037] bttv: PLL set ok
Jan 26 16:13:59 quad kernel: [13524.173018] bttv: PLL set ok
Jan 26 16:13:59 quad sudo: pam_unix(sudo:session): session closed for 
user root
Jan 26 16:13:59 quad kernel: [13524.179815] bttv: PLL set ok
Jan 26 16:14:13 quad lircd-0.9.0[3480]: accepted new client on 
/var/run/lirc/lircd
Jan 26 16:14:13 quad lircd-0.9.0[3480]: initializing '/dev/input/event0'
Jan 26 16:14:14 quad kernel: [13538.816017] bttv: 0: timeout: drop=0 
irq=45/46, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:15 quad kernel: [13539.318063] bttv: 0: timeout: drop=0 
irq=70/71, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:15 quad kernel: [13539.825018] bttv: 0: timeout: drop=0 
irq=95/96, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:16 quad kernel: [13540.326011] bttv: 0: timeout: drop=0 
irq=120/121, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:16 quad kernel: [13540.828028] bttv: 0: timeout: drop=0 
irq=145/146, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:17 quad kernel: [13541.333011] bttv: 0: timeout: drop=0 
irq=171/172, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:17 quad kernel: [13541.837012] bttv: 0: timeout: drop=0 
irq=196/197, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:18 quad kernel: [13542.341019] bttv: 0: timeout: drop=0 
irq=221/222, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:18 quad kernel: [13542.843027] bttv: 0: timeout: drop=0 
irq=246/247, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:19 quad kernel: [13543.344018] bttv: 0: timeout: drop=0 
irq=271/272, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:19 quad kernel: [13543.847036] bttv: 0: timeout: drop=0 
irq=297/298, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:20 quad kernel: [13544.350017] bttv: 0: timeout: drop=0 
irq=322/323, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:20 quad kernel: [13544.851022] bttv: 0: timeout: drop=0 
irq=347/348, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:21 quad kernel: [13545.356026] bttv: 0: timeout: drop=0 
irq=372/373, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:21 quad kernel: [13545.858014] bttv: 0: timeout: drop=0 
irq=397/398, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:22 quad kernel: [13546.361019] bttv: 0: timeout: drop=0 
irq=422/423, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:22 quad kernel: [13546.863036] bttv: 0: timeout: drop=0 
irq=447/448, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:23 quad kernel: [13547.371021] bttv: 0: timeout: drop=0 
irq=473/474, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:23 quad kernel: [13547.874015] bttv: 0: timeout: drop=0 
irq=498/499, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:24 quad kernel: [13548.378025] bttv: 0: timeout: drop=0 
irq=523/524, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:24 quad kernel: [13548.879023] bttv: 0: timeout: drop=0 
irq=548/549, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:25 quad kernel: [13549.383034] bttv: 0: timeout: drop=0 
irq=574/575, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:25 quad kernel: [13549.884028] bttv: 0: timeout: drop=0 
irq=599/600, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:26 quad kernel: [13550.385014] bttv: 0: timeout: drop=0 
irq=624/625, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:26 quad kernel: [13550.887017] bttv: 0: timeout: drop=0 
irq=649/650, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:27 quad kernel: [13551.388034] bttv: 0: timeout: drop=0 
irq=674/675, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:27 quad kernel: [13551.889019] bttv: 0: timeout: drop=0 
irq=699/700, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:28 quad kernel: [13552.391016] bttv: 0: timeout: drop=0 
irq=724/725, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:28 quad kernel: [13552.892020] bttv: 0: timeout: drop=0 
irq=749/750, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:29 quad kernel: [13553.395023] bttv: 0: timeout: drop=0 
irq=774/775, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:29 quad kernel: [13553.898018] bttv: 0: timeout: drop=0 
irq=800/801, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:30 quad kernel: [13554.402015] bttv: 0: timeout: drop=0 
irq=825/826, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:30 quad kernel: [13554.907012] bttv: 0: timeout: drop=0 
irq=850/851, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:31 quad kernel: [13555.409016] bttv: 0: timeout: drop=0 
irq=875/876, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:31 quad kernel: [13555.913015] bttv: 0: timeout: drop=0 
irq=900/901, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:32 quad kernel: [13556.414019] bttv: 0: timeout: drop=0 
irq=925/926, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:32 quad kernel: [13556.917014] bttv: 0: timeout: drop=0 
irq=951/952, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:33 quad kernel: [13557.421027] bttv: 0: timeout: drop=0 
irq=976/977, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:33 quad kernel: [13557.925035] bttv: 0: timeout: drop=0 
irq=1001/1002, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:34 quad kernel: [13558.430019] bttv: 0: timeout: drop=0 
irq=1026/1027, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:34 quad kernel: [13558.931026] bttv: 0: timeout: drop=0 
irq=1051/1052, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:35 quad kernel: [13559.434016] bttv: 0: timeout: drop=0 
irq=1077/1078, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:35 quad kernel: [13559.935017] bttv: 0: timeout: drop=0 
irq=1102/1103, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:36 quad kernel: [13560.436013] bttv: 0: timeout: drop=0 
irq=1127/1128, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:36 quad kernel: [13560.940020] bttv: 0: timeout: drop=0 
irq=1152/1153, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:37 quad kernel: [13561.443013] bttv: 0: timeout: drop=0 
irq=1177/1178, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:37 quad kernel: [13561.947017] bttv: 0: timeout: drop=0 
irq=1202/1203, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:38 quad kernel: [13562.448027] bttv: 0: timeout: drop=0 
irq=1227/1228, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:38 quad kernel: [13562.949016] bttv: 0: timeout: drop=0 
irq=1252/1253, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:39 quad kernel: [13563.451012] bttv: 0: timeout: drop=0 
irq=1278/1279, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:39 quad kernel: [13563.952012] bttv: 0: timeout: drop=0 
irq=1303/1304, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:40 quad kernel: [13564.457017] bttv: 0: timeout: drop=0 
irq=1328/1329, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:40 quad kernel: [13564.960021] bttv: 0: timeout: drop=0 
irq=1353/1354, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:41 quad kernel: [13565.461013] bttv: 0: timeout: drop=0 
irq=1378/1379, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:41 quad kernel: [13565.965019] bttv: 0: timeout: drop=0 
irq=1403/1404, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:42 quad kernel: [13566.468021] bttv: 0: timeout: drop=0 
irq=1429/1430, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:42 quad kernel: [13566.970018] bttv: 0: timeout: drop=0 
irq=1454/1455, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:43 quad kernel: [13567.473023] bttv: 0: timeout: drop=0 
irq=1479/1480, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:43 quad kernel: [13567.975021] bttv: 0: timeout: drop=0 
irq=1504/1505, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:44 quad kernel: [13568.476031] bttv: 0: timeout: drop=0 
irq=1529/1530, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:44 quad kernel: [13568.977033] bttv: 0: timeout: drop=0 
irq=1554/1555, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:45 quad kernel: [13569.479018] bttv: 0: timeout: drop=0 
irq=1579/1580, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:45 quad kernel: [13569.982018] bttv: 0: timeout: drop=0 
irq=1604/1605, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:46 quad kernel: [13570.483024] bttv: 0: timeout: drop=0 
irq=1629/1630, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:46 quad kernel: [13570.984020] bttv: 0: timeout: drop=0 
irq=1655/1656, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:47 quad kernel: [13571.486020] bttv: 0: timeout: drop=0 
irq=1680/1681, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:47 quad kernel: [13571.987015] bttv: 0: timeout: drop=0 
irq=1705/1706, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:48 quad kernel: [13572.490016] bttv: 0: timeout: drop=0 
irq=1730/1731, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:48 quad kernel: [13572.991014] bttv: 0: timeout: drop=0 
irq=1755/1756, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:49 quad kernel: [13573.493009] bttv: 0: timeout: drop=0 
irq=1780/1781, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:49 quad kernel: [13573.996027] bttv: 0: timeout: drop=0 
irq=1805/1806, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:50 quad kernel: [13574.497013] bttv: 0: timeout: drop=0 
irq=1830/1831, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:50 quad kernel: [13575.001024] bttv: 0: timeout: drop=0 
irq=1856/1857, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:51 quad kernel: [13575.504030] bttv: 0: timeout: drop=0 
irq=1881/1882, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:51 quad kernel: [13576.007033] bttv: 0: timeout: drop=0 
irq=1906/1907, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:52 quad kernel: [13576.510022] bttv: 0: timeout: drop=0 
irq=1931/1932, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:52 quad kernel: [13577.011030] bttv: 0: timeout: drop=0 
irq=1956/1957, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:53 quad kernel: [13577.513019] bttv: 0: timeout: drop=0 
irq=1981/1982, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:53 quad kernel: [13578.014013] bttv: 0: timeout: drop=0 
irq=2006/2007, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:54 quad kernel: [13578.515011] bttv: 0: timeout: drop=0 
irq=2031/2032, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:54 quad kernel: [13579.018023] bttv: 0: timeout: drop=0 
irq=2057/2058, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:55 quad kernel: [13579.520020] bttv: 0: timeout: drop=0 
irq=2082/2083, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:55 quad kernel: [13580.022016] bttv: 0: timeout: drop=0 
irq=2107/2108, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:56 quad kernel: [13580.524013] bttv: 0: timeout: drop=0 
irq=2132/2133, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:56 quad kernel: [13581.025018] bttv: 0: timeout: drop=0 
irq=2157/2158, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:57 quad kernel: [13581.528028] bttv: 0: timeout: drop=0 
irq=2182/2183, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:57 quad kernel: [13582.031015] bttv: 0: timeout: drop=0 
irq=2210/2211, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:58 quad kernel: [13582.534017] bttv: 0: timeout: drop=0 
irq=2235/2236, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:58 quad kernel: [13583.037018] bttv: 0: timeout: drop=0 
irq=2260/2261, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:59 quad kernel: [13583.538011] bttv: 0: timeout: drop=0 
irq=2285/2286, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:14:59 quad kernel: [13584.041014] bttv: 0: timeout: drop=0 
irq=2310/2311, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:00 quad kernel: [13584.543028] bttv: 0: timeout: drop=0 
irq=2335/2336, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:00 quad kernel: [13585.044017] bttv: 0: timeout: drop=0 
irq=2360/2361, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:01 quad kernel: [13585.546018] bttv: 0: timeout: drop=0 
irq=2385/2386, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:01 quad cron[2348]: (robert) CMD 
(/home/robert/dev/routerMonitor/routerMonitor)
Jan 26 16:15:01 quad kernel: [13586.047014] bttv: 0: timeout: drop=0 
irq=2410/2411, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:02 quad kernel: [13586.549030] bttv: 0: timeout: drop=0 
irq=2435/2436, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:02 quad kernel: [13587.050031] bttv: 0: timeout: drop=0 
irq=2461/2462, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:03 quad kernel: [13587.555018] bttv: 0: timeout: drop=0 
irq=2486/2487, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:03 quad kernel: [13588.059022] bttv: 0: timeout: drop=0 
irq=2511/2512, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:04 quad kernel: [13588.567011] bttv: 0: timeout: drop=0 
irq=2536/2537, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:04 quad kernel: [13589.071017] bttv: 0: timeout: drop=0 
irq=2562/2563, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:05 quad kernel: [13589.574046] bttv: 0: timeout: drop=0 
irq=2587/2588, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:05 quad kernel: [13590.078020] bttv: 0: timeout: drop=0 
irq=2612/2613, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:06 quad kernel: [13590.589019] bttv: 0: timeout: drop=0 
irq=2637/2638, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:06 quad kernel: [13591.091009] bttv: 0: timeout: drop=0 
irq=2663/2664, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:07 quad kernel: [13591.592025] bttv: 0: timeout: drop=0 
irq=2688/2689, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:07 quad kernel: [13592.094015] bttv: 0: timeout: drop=0 
irq=2713/2714, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:08 quad kernel: [13592.596015] bttv: 0: timeout: drop=0 
irq=2738/2739, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:08 quad kernel: [13593.098015] bttv: 0: timeout: drop=0 
irq=2763/2764, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:09 quad kernel: [13593.603028] bttv: 0: timeout: drop=0 
irq=2788/2789, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:09 quad kernel: [13594.107016] bttv: 0: timeout: drop=0 
irq=2813/2814, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:10 quad kernel: [13594.609015] bttv: 0: timeout: drop=0 
irq=2838/2839, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:10 quad kernel: [13595.110020] bttv: 0: timeout: drop=0 
irq=2864/2865, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:11 quad kernel: [13595.613022] bttv: 0: timeout: drop=0 
irq=2889/2890, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:11 quad kernel: [13596.114025] bttv: 0: timeout: drop=0 
irq=2914/2915, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:12 quad kernel: [13596.618011] bttv: 0: timeout: drop=0 
irq=2939/2940, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:12 quad kernel: [13597.120015] bttv: 0: timeout: drop=0 
irq=2964/2965, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:13 quad kernel: [13597.624012] bttv: 0: timeout: drop=0 
irq=2989/2990, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:13 quad kernel: [13598.125017] bttv: 0: timeout: drop=0 
irq=3014/3015, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:14 quad kernel: [13598.627019] bttv: 0: timeout: drop=0 
irq=3039/3040, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:14 quad kernel: [13599.128015] bttv: 0: timeout: drop=0 
irq=3064/3065, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:15 quad kernel: [13599.633016] bttv: 0: timeout: drop=0 
irq=3090/3091, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:15 quad kernel: [13600.138018] bttv: 0: timeout: drop=0 
irq=3115/3116, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:16 quad kernel: [13600.642022] bttv: 0: timeout: drop=0 
irq=3140/3141, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:16 quad kernel: [13601.143025] bttv: 0: timeout: drop=0 
irq=3165/3166, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:17 quad kernel: [13601.644017] bttv: 0: timeout: drop=0 
irq=3190/3191, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:17 quad kernel: [13602.145017] bttv: 0: timeout: drop=0 
irq=3215/3216, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:18 quad kernel: [13602.649017] bttv: 0: timeout: drop=0 
irq=3240/3241, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:18 quad kernel: [13603.150018] bttv: 0: timeout: drop=0 
irq=3265/3266, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:19 quad kernel: [13603.651022] bttv: 0: timeout: drop=0 
irq=3291/3293, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:19 quad kernel: [13604.152024] bttv: 0: timeout: drop=0 
irq=3316/3318, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:20 quad kernel: [13604.658042] bttv: 0: timeout: drop=0 
irq=3341/3343, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:20 quad kernel: [13605.162023] bttv: 0: timeout: drop=0 
irq=3366/3368, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:21 quad kernel: [13605.666020] bttv: 0: timeout: drop=0 
irq=3391/3393, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:21 quad kernel: [13606.169032] bttv: 0: timeout: drop=0 
irq=3416/3418, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:22 quad kernel: [13606.672034] bttv: 0: timeout: drop=0 
irq=3442/3444, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:22 quad kernel: [13607.175014] bttv: 0: timeout: drop=0 
irq=3467/3469, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:23 quad kernel: [13607.678014] bttv: 0: timeout: drop=0 
irq=3492/3494, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:23 quad kernel: [13608.179014] bttv: 0: timeout: drop=0 
irq=3517/3519, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:24 quad kernel: [13608.681064] bttv: 0: timeout: drop=0 
irq=3542/3544, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:24 quad kernel: [13609.185029] bttv: 0: timeout: drop=0 
irq=3567/3569, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:25 quad kernel: [13609.687011] bttv: 0: timeout: drop=0 
irq=3592/3594, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:25 quad kernel: [13610.191019] bttv: 0: timeout: drop=0 
irq=3618/3620, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:26 quad kernel: [13610.693021] bttv: 0: timeout: drop=0 
irq=3643/3645, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:26 quad kernel: [13611.194028] bttv: 0: timeout: drop=0 
irq=3668/3670, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:27 quad kernel: [13611.695021] bttv: 0: timeout: drop=0 
irq=3693/3695, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:27 quad kernel: [13612.196014] bttv: 0: timeout: drop=0 
irq=3718/3720, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:28 quad kernel: [13612.700019] bttv: 0: timeout: drop=0 
irq=3743/3745, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:28 quad kernel: [13613.201015] bttv: 0: timeout: drop=0 
irq=3768/3770, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:29 quad kernel: [13613.703016] bttv: 0: timeout: drop=0 
irq=3793/3795, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:29 quad kernel: [13614.206016] bttv: 0: timeout: drop=0 
irq=3818/3820, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:30 quad kernel: [13614.709020] bttv: 0: timeout: drop=0 
irq=3843/3845, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:30 quad kernel: [13615.211036] bttv: 0: timeout: drop=0 
irq=3869/3871, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:31 quad kernel: [13615.717013] bttv: 0: timeout: drop=0 
irq=3894/3896, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:31 quad kernel: [13616.221017] bttv: 0: timeout: drop=0 
irq=3919/3921, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:32 quad kernel: [13616.726019] bttv: 0: timeout: drop=0 
irq=3944/3946, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:32 quad kernel: [13617.228029] bttv: 0: timeout: drop=0 
irq=3969/3971, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:33 quad kernel: [13617.729025] bttv: 0: timeout: drop=0 
irq=3994/3996, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:33 quad kernel: [13618.230013] bttv: 0: timeout: drop=0 
irq=4019/4021, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:34 quad kernel: [13618.733012] bttv: 0: timeout: drop=0 
irq=4045/4047, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:34 quad kernel: [13619.235016] bttv: 0: timeout: drop=0 
irq=4070/4072, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:35 quad kernel: [13619.736014] bttv: 0: timeout: drop=0 
irq=4095/4097, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:35 quad kernel: [13620.237020] bttv: 0: timeout: drop=0 
irq=4120/4122, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:36 quad kernel: [13620.740023] bttv: 0: timeout: drop=0 
irq=4145/4147, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:36 quad kernel: [13621.241026] bttv: 0: timeout: drop=0 
irq=4170/4172, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:37 quad kernel: [13621.744017] bttv: 0: timeout: drop=0 
irq=4195/4197, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:37 quad kernel: [13622.246021] bttv: 0: timeout: drop=0 
irq=4220/4222, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:38 quad kernel: [13622.749030] bttv: 0: timeout: drop=0 
irq=4245/4247, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:38 quad kernel: [13623.250018] bttv: 0: timeout: drop=0 
irq=4270/4272, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:39 quad kernel: [13623.754019] bttv: 0: timeout: drop=0 
irq=4296/4298, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:39 quad kernel: [13624.257020] bttv: 0: timeout: drop=0 
irq=4321/4323, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:40 quad kernel: [13624.759016] bttv: 0: timeout: drop=0 
irq=4346/4348, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:40 quad kernel: [13625.260021] bttv: 0: timeout: drop=0 
irq=4371/4373, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:41 quad kernel: [13625.761016] bttv: 0: timeout: drop=0 
irq=4396/4398, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:41 quad kernel: [13626.266031] bttv: 0: timeout: drop=0 
irq=4421/4423, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:42 quad kernel: [13626.767027] bttv: 0: timeout: drop=0 
irq=4446/4448, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:42 quad kernel: [13627.270027] bttv: 0: timeout: drop=0 
irq=4471/4473, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:43 quad kernel: [13627.772017] bttv: 0: timeout: drop=0 
irq=4497/4499, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:43 quad kernel: [13628.277018] bttv: 0: timeout: drop=0 
irq=4522/4524, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:44 quad kernel: [13628.782030] bttv: 0: timeout: drop=0 
irq=4547/4549, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:44 quad kernel: [13629.283021] bttv: 0: timeout: drop=0 
irq=4572/4574, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:45 quad kernel: [13629.793023] bttv: 0: timeout: drop=0 
irq=4598/4600, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:45 quad kernel: [13630.295023] bttv: 0: timeout: drop=0 
irq=4623/4625, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:46 quad kernel: [13630.797017] bttv: 0: timeout: drop=0 
irq=4648/4650, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:46 quad kernel: [13631.304029] bttv: 0: timeout: drop=0 
irq=4673/4675, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:47 quad kernel: [13631.809016] bttv: 0: timeout: drop=0 
irq=4698/4700, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:48 quad kernel: [13632.316012] bttv: 0: timeout: drop=0 
irq=4724/4726, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:48 quad kernel: [13632.818019] bttv: 0: timeout: drop=0 
irq=4749/4751, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:52 quad kernel: [13636.856015] bttv: 0: timeout: drop=0 
irq=4951/4953, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:53 quad kernel: [13637.359016] bttv: 0: timeout: drop=0 
irq=4976/4978, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:53 quad kernel: [13637.861018] bttv: 0: timeout: drop=0 
irq=5001/5003, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:54 quad kernel: [13638.366016] bttv: 0: timeout: drop=0 
irq=5026/5028, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:54 quad kernel: [13638.869018] bttv: 0: timeout: drop=0 
irq=5051/5053, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:55 quad kernel: [13639.370014] bttv: 0: timeout: drop=0 
irq=5076/5078, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:55 quad kernel: [13639.871015] bttv: 0: timeout: drop=0 
irq=5101/5103, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:56 quad kernel: [13640.377021] bttv: 0: timeout: drop=0 
irq=5127/5129, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:56 quad kernel: [13640.884035] bttv: 0: timeout: drop=0 
irq=5152/5154, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:57 quad kernel: [13641.388024] bttv: 0: timeout: drop=0 
irq=5177/5179, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:57 quad kernel: [13641.892016] bttv: 0: timeout: drop=0 
irq=5202/5204, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:58 quad kernel: [13642.394026] bttv: 0: timeout: drop=0 
irq=5228/5230, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:58 quad kernel: [13642.896028] bttv: 0: timeout: drop=0 
irq=5253/5255, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:59 quad kernel: [13643.397012] bttv: 0: timeout: drop=0 
irq=5278/5280, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:15:59 quad kernel: [13643.906026] bttv: 0: timeout: drop=0 
irq=5303/5305, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:00 quad kernel: [13644.409021] bttv: 0: timeout: drop=0 
irq=5328/5330, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:00 quad kernel: [13644.912031] bttv: 0: timeout: drop=0 
irq=5353/5355, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:01 quad kernel: [13645.413014] bttv: 0: timeout: drop=0 
irq=5379/5381, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:01 quad kernel: [13645.918043] bttv: 0: timeout: drop=0 
irq=5404/5406, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:02 quad kernel: [13646.426015] bttv: 0: timeout: drop=0 
irq=5429/5431, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:02 quad kernel: [13646.927033] bttv: 0: timeout: drop=0 
irq=5454/5456, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:03 quad kernel: [13647.428026] bttv: 0: timeout: drop=0 
irq=5479/5481, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:03 quad kernel: [13647.929023] bttv: 0: timeout: drop=0 
irq=5504/5506, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:03 quad sudo:   robert : TTY=pts/4 ; 
PWD=/home/robert/dev/8604PW ; USER=root ; COMMAND=./dumpbt8xx /dev/video0
Jan 26 16:16:03 quad sudo: pam_unix(sudo:session): session opened for 
user root by robert(uid=0)
Jan 26 16:16:03 quad sudo: pam_unix(sudo:session): session closed for 
user root
Jan 26 16:16:04 quad kernel: [13648.430022] bttv: 0: timeout: drop=0 
irq=5529/5531, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:04 quad kernel: [13648.933022] bttv: 0: timeout: drop=0 
irq=5555/5557, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:05 quad kernel: [13649.435023] bttv: 0: timeout: drop=0 
irq=5580/5582, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:05 quad kernel: [13649.938020] bttv: 0: timeout: drop=0 
irq=5605/5607, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:06 quad kernel: [13650.439027] bttv: 0: timeout: drop=0 
irq=5630/5632, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:06 quad kernel: [13650.943026] bttv: 0: timeout: drop=0 
irq=5655/5657, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:07 quad kernel: [13651.445020] bttv: 0: timeout: drop=0 
irq=5680/5682, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:07 quad kernel: [13651.948021] bttv: 0: timeout: drop=0 
irq=5705/5707, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:08 quad kernel: [13652.449015] bttv: 0: timeout: drop=0 
irq=5730/5732, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:08 quad kernel: [13652.951039] bttv: 0: timeout: drop=0 
irq=5755/5757, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:09 quad kernel: [13653.458021] bttv: 0: timeout: drop=0 
irq=5781/5783, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:09 quad kernel: [13653.962012] bttv: 0: timeout: drop=0 
irq=5806/5808, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:10 quad kernel: [13654.465027] bttv: 0: timeout: drop=0 
irq=5831/5833, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:10 quad kernel: [13654.967016] bttv: 0: timeout: drop=0 
irq=5856/5858, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:11 quad kernel: [13655.470017] bttv: 0: timeout: drop=0 
irq=5881/5883, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:11 quad kernel: [13655.972019] bttv: 0: timeout: drop=0 
irq=5906/5908, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:12 quad kernel: [13656.473018] bttv: 0: timeout: drop=0 
irq=5931/5933, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:12 quad kernel: [13656.974014] bttv: 0: timeout: drop=0 
irq=5957/5959, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:13 quad kernel: [13657.476014] bttv: 0: timeout: drop=0 
irq=5982/5984, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:13 quad kernel: [13657.979017] bttv: 0: timeout: drop=0 
irq=6007/6009, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:14 quad kernel: [13658.480015] bttv: 0: timeout: drop=0 
irq=6032/6034, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:14 quad kernel: [13658.981015] bttv: 0: timeout: drop=0 
irq=6057/6059, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:15 quad kernel: [13659.482012] bttv: 0: timeout: drop=0 
irq=6082/6084, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:15 quad kernel: [13659.983022] bttv: 0: timeout: drop=0 
irq=6107/6109, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:16 quad kernel: [13660.496017] bttv: 0: timeout: drop=0 
irq=6133/6135, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:16 quad kernel: [13660.999038] bttv: 0: timeout: drop=0 
irq=6158/6160, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:17 quad kernel: [13661.501018] bttv: 0: timeout: drop=0 
irq=6183/6185, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:17 quad kernel: [13662.003014] bttv: 0: timeout: drop=0 
irq=6208/6210, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:18 quad kernel: [13662.506017] bttv: 0: timeout: drop=0 
irq=6233/6235, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:18 quad kernel: [13663.007017] bttv: 0: timeout: drop=0 
irq=6258/6260, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:19 quad kernel: [13663.510022] bttv: 0: timeout: drop=0 
irq=6283/6285, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:19 quad kernel: [13664.011018] bttv: 0: timeout: drop=0 
irq=6308/6310, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:20 quad kernel: [13664.515029] bttv: 0: timeout: drop=0 
irq=6334/6336, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:20 quad kernel: [13665.017031] bttv: 0: timeout: drop=0 
irq=6359/6361, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:21 quad kernel: [13665.519028] bttv: 0: timeout: drop=0 
irq=6384/6386, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:21 quad kernel: [13666.021021] bttv: 0: timeout: drop=0 
irq=6409/6411, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:22 quad kernel: [13666.522019] bttv: 0: timeout: drop=0 
irq=6434/6436, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:22 quad kernel: [13667.024030] bttv: 0: timeout: drop=0 
irq=6459/6461, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:23 quad kernel: [13667.527041] bttv: 0: timeout: drop=0 
irq=6484/6486, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:23 quad kernel: [13668.034020] bttv: 0: timeout: drop=0 
irq=6510/6512, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:24 quad kernel: [13668.535011] bttv: 0: timeout: drop=0 
irq=6535/6537, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:24 quad kernel: [13669.040024] bttv: 0: timeout: drop=0 
irq=6560/6562, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:25 quad kernel: [13669.542018] bttv: 0: timeout: drop=0 
irq=6585/6587, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:25 quad kernel: [13670.045028] bttv: 0: timeout: drop=0 
irq=6610/6612, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:26 quad kernel: [13670.549023] bttv: 0: timeout: drop=0 
irq=6635/6637, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:26 quad kernel: [13671.053013] bttv: 0: timeout: drop=0 
irq=6660/6662, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:27 quad kernel: [13671.556014] bttv: 0: timeout: drop=0 
irq=6686/6688, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:27 quad kernel: [13672.058022] bttv: 0: timeout: drop=0 
irq=6711/6713, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:28 quad kernel: [13672.561018] bttv: 0: timeout: drop=0 
irq=6736/6738, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:28 quad kernel: [13673.066017] bttv: 0: timeout: drop=0 
irq=6761/6763, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:29 quad kernel: [13673.568026] bttv: 0: timeout: drop=0 
irq=6786/6788, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:29 quad kernel: [13674.071025] bttv: 0: timeout: drop=0 
irq=6811/6813, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:30 quad kernel: [13674.574015] bttv: 0: timeout: drop=0 
irq=6836/6838, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:30 quad kernel: [13675.076012] bttv: 0: timeout: drop=0 
irq=6862/6864, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:31 quad kernel: [13675.578021] bttv: 0: timeout: drop=0 
irq=6887/6889, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:31 quad kernel: [13676.080026] bttv: 0: timeout: drop=0 
irq=6912/6914, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:32 quad kernel: [13676.581022] bttv: 0: timeout: drop=0 
irq=6937/6939, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:32 quad kernel: [13677.082019] bttv: 0: timeout: drop=0 
irq=6962/6964, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:33 quad kernel: [13677.584015] bttv: 0: timeout: drop=0 
irq=6987/6989, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:33 quad kernel: [13678.086020] bttv: 0: timeout: drop=0 
irq=7012/7014, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:34 quad kernel: [13678.589025] bttv: 0: timeout: drop=0 
irq=7037/7039, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:34 quad kernel: [13679.092018] bttv: 0: timeout: drop=0 
irq=7062/7064, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:35 quad kernel: [13679.594017] bttv: 0: timeout: drop=0 
irq=7087/7089, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:35 quad kernel: [13680.096014] bttv: 0: timeout: drop=0 
irq=7113/7115, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:36 quad kernel: [13680.597021] bttv: 0: timeout: drop=0 
irq=7138/7140, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:36 quad kernel: [13681.099036] bttv: 0: timeout: drop=0 
irq=7163/7165, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:37 quad kernel: [13681.604025] bttv: 0: timeout: drop=0 
irq=7188/7190, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:37 quad kernel: [13682.108041] bttv: 0: timeout: drop=0 
irq=7213/7215, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:38 quad kernel: [13682.618014] bttv: 0: timeout: drop=0 
irq=7239/7241, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:38 quad kernel: [13683.123036] bttv: 0: timeout: drop=0 
irq=7264/7266, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:39 quad kernel: [13683.624022] bttv: 0: timeout: drop=0 
irq=7289/7291, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:39 quad kernel: [13684.127034] bttv: 0: timeout: drop=0 
irq=7314/7316, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:40 quad kernel: [13684.630018] bttv: 0: timeout: drop=0 
irq=7339/7341, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:40 quad kernel: [13685.131026] bttv: 0: timeout: drop=0 
irq=7364/7366, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:41 quad kernel: [13685.632020] bttv: 0: timeout: drop=0 
irq=7389/7391, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:41 quad kernel: [13686.134021] bttv: 0: timeout: drop=0 
irq=7414/7416, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:42 quad kernel: [13686.635017] bttv: 0: timeout: drop=0 
irq=7440/7442, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:42 quad kernel: [13687.138014] bttv: 0: timeout: drop=0 
irq=7465/7467, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:43 quad kernel: [13687.641014] bttv: 0: timeout: drop=0 
irq=7490/7492, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:43 quad sudo:   robert : TTY=pts/4 ; 
PWD=/home/robert/dev/8604PW ; USER=root ; COMMAND=./dumpbt8xx /dev/video0
Jan 26 16:16:43 quad sudo: pam_unix(sudo:session): session opened for 
user root by robert(uid=0)
Jan 26 16:16:43 quad sudo: pam_unix(sudo:session): session closed for 
user root
Jan 26 16:16:43 quad kernel: [13688.144042] bttv: 0: timeout: drop=0 
irq=7515/7517, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:44 quad kernel: [13688.647052] bttv: 0: timeout: drop=0 
irq=7540/7542, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:44 quad kernel: [13689.149016] bttv: 0: timeout: drop=0 
irq=7565/7567, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:45 quad kernel: [13689.651015] bttv: 0: timeout: drop=0 
irq=7590/7592, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:45 quad kernel: [13690.153021] bttv: 0: timeout: drop=0 
irq=7615/7617, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:46 quad kernel: [13690.656015] bttv: 0: timeout: drop=0 
irq=7641/7643, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:46 quad kernel: [13691.160020] bttv: 0: timeout: drop=0 
irq=7666/7668, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:47 quad kernel: [13691.662019] bttv: 0: timeout: drop=0 
irq=7691/7693, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:47 quad kernel: [13692.165036] bttv: 0: timeout: drop=0 
irq=7716/7718, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:48 quad kernel: [13692.666012] bttv: 0: timeout: drop=0 
irq=7741/7743, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:48 quad kernel: [13693.169017] bttv: 0: timeout: drop=0 
irq=7766/7768, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:49 quad kernel: [13693.674027] bttv: 0: timeout: drop=0 
irq=7791/7793, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:49 quad kernel: [13694.178022] bttv: 0: timeout: drop=0 
irq=7817/7819, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:50 quad kernel: [13694.680020] bttv: 0: timeout: drop=0 
irq=7842/7844, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:50 quad kernel: [13695.181021] bttv: 0: timeout: drop=0 
irq=7867/7869, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:51 quad kernel: [13695.684038] bttv: 0: timeout: drop=0 
irq=7892/7894, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:51 quad kernel: [13696.186016] bttv: 0: timeout: drop=0 
irq=7917/7919, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:52 quad kernel: [13696.687018] bttv: 0: timeout: drop=0 
irq=7942/7944, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:52 quad kernel: [13697.188029] bttv: 0: timeout: drop=0 
irq=7967/7969, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:53 quad kernel: [13697.690019] bttv: 0: timeout: drop=0 
irq=7992/7994, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:53 quad kernel: [13698.191017] bttv: 0: timeout: drop=0 
irq=8017/8019, risc=32734000, bits: HSYNC OFLOW
Jan 26 16:16:53 quad kernel: [13698.193133] bttv: 0: reset, reinitialize
Jan 26 16:16:53 quad kernel: [13698.193165] bttv: 0: PLL can sleep, 
using XTAL (35468950)
Jan 26 16:16:54 quad kernel: [13698.694014] bttv: 0: timeout: drop=0 
irq=8019/8021, risc=32734000, bits: VSYNC HSYNC OFLOW
Jan 26 16:16:54 quad lircd-0.9.0[3480]: removed client
Jan 26 16:16:54 quad lircd-0.9.0[3480]: closing '/dev/input/event0'

Thanks,
Rob.
