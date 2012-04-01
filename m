Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma03.mx.aol.com ([64.12.206.41]:35497 "EHLO
	imr-ma03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab2CaWf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 18:35:26 -0400
Message-ID: <4F77B099.7030109@netscape.net>
Date: Sat, 31 Mar 2012 22:34:17 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Toth <stoth@kernellabs.com>
Subject: Broken driver cx23885 mygica x8507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Some of the changes between 3.2 and 3.3 kernel have left without sound, 
the card Mygica X8507.
With kernel 3.0, 3.1 and 3.2 this worked fine.
I tested with OpenSuSE, with two kernel that provides by distribution 
and Kubunto with the kernel download from http://www.kernel.org/. In 
both cases the same problem occurs.
Then leave extra information:


dhcppc0:/home/alfredo # modprobe cx23885
dhcppc0:/home/alfredo # dmesg
...
[ 1127.074871] cx23885 driver version 0.0.3 loaded
[ 1127.076014] cx23885[0]: cx23885_dev_setup() Memory configured for 
PCIe bridge type 885
[ 1127.076416] CORE cx23885[0]: subsystem: 14f1:8502, board: Mygica 
X8507 [card=33,autodetected]
[ 1127.076421] cx23885[0]: cx23885_pci_quirks()
[ 1127.076428] cx23885[0]: cx23885_dev_setup() tuner_type = 0x4c 
tuner_addr = 0x61 tuner_bus = 1
[ 1127.076433] cx23885[0]: cx23885_dev_setup() radio_type = 0x0 
radio_addr = 0x0
[ 1127.076438] cx23885[0]: cx23885_reset()
[ 1127.176467] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [VID A]
[ 1127.176470] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch2]
[ 1127.176473] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [TS1 B]
[ 1127.176475] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch4]
[ 1127.176478] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch5]
[ 1127.176480] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [TS2 C]
[ 1127.176493] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [TV Audio]
[ 1127.176510] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch8]
[ 1127.176512] cx23885[0]: cx23885_sram_channel_setup() Erasing channel 
[ch9]
[ 1127.428328] cx25840 8-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[ 1128.101966] cx25840 8-0044: loaded v4l-cx23885-avcore-01.fw firmware 
(16382 bytes)
[ 1128.135245] cx23885[0]: cx23885_video_register()
[ 1128.138062] tuner 7-0061: Tuner -1 found with type(s) Radio TV.
[ 1128.138095] xc5000 7-0061: creating new instance
[ 1128.138790] xc5000: Successfully identified at address 0x61
[ 1128.138792] xc5000: Firmware has not been loaded previously
[ 1128.138795] cx23885[0]: cx23885_vdev_init()
[ 1128.138891] cx23885[0]: registered device video1 [v4l2]
[ 1128.138893] cx23885[0]: cx23885_vdev_init()
[ 1128.138949] cx23885[0]: registered device vbi1
[ 1128.140495] cx23885[0]: registered ALSA audio device
[ 1128.140500] cx23885[0]: cx23885_set_tvnorm(norm = 0x00001000) name: 
[NTSC-M]
[ 1128.155056] cx23885[0]: open dev=video1 radio=0 type=vid-cap
[ 1128.155061] cx23885[0]: post videobuf_queue_init()
[ 1128.155092] cx23885[0]: open dev=vbi1 radio=0 type=vbi-cap
[ 1128.155097] cx23885[0]: post videobuf_queue_init()
[ 1128.165628] xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
[ 1128.282090] xc5000: firmware read 12401 bytes.
[ 1128.282097] xc5000: firmware uploading...
[ 1129.657015] xc5000: firmware upload complete...
[ 1130.256026] cx23885[0]: cx23885_set_control() calling 
cx25840(VIDIOC_S_CTRL)
[ 1130.256151] cx23885[0]: cx23885_set_control() calling 
cx25840(VIDIOC_S_CTRL)
[ 1130.256267] cx23885[0]: cx23885_set_control() calling 
cx25840(VIDIOC_S_CTRL)
[ 1130.256272] cx23885[0]: cx23885_set_control() calling 
cx25840(VIDIOC_S_CTRL)
[ 1130.256495] cx23885[0]: cx23885_set_control() calling 
cx25840(VIDIOC_S_CTRL)
[ 1130.256609] cx23885[0]: cx23885_set_control() calling 
cx25840(VIDIOC_S_CTRL)
[ 1130.256726] cx23885[0]: cx23885_video_mux() video_mux: 0 [vmux=2, 
gpio=0x0,0x0,0x0,0x0]
[ 1130.288096] cx23885[0]: cx23885_audio_mux(input=0)
[ 1130.288099] cx23885[0]: cx23885_flatiron_mux(input = 1)
[ 1130.288318] cx23885[0]: Flatiron dump
[ 1130.288394] cx23885[0]: FI[00] = d2
[ 1130.288470] cx23885[0]: FI[01] = 03
[ 1130.288545] cx23885[0]: FI[02] = 1b
[ 1130.288620] cx23885[0]: FI[03] = 00
[ 1130.288695] cx23885[0]: FI[04] = 08
[ 1130.288770] cx23885[0]: FI[05] = 08
[ 1130.288846] cx23885[0]: FI[06] = 03
[ 1130.288921] cx23885[0]: FI[07] = 00
[ 1130.288996] cx23885[0]: FI[08] = 13
[ 1130.289078] cx23885[0]: FI[09] = 13
[ 1130.289154] cx23885[0]: FI[0a] = 0a
[ 1130.289233] cx23885[0]: FI[0b] = 00
[ 1130.289308] cx23885[0]: FI[0c] = 05
[ 1130.289383] cx23885[0]: FI[0d] = 00
[ 1130.289458] cx23885[0]: FI[0e] = 20
[ 1130.289534] cx23885[0]: FI[0f] = 00
[ 1130.289609] cx23885[0]: FI[10] = 0c
[ 1130.289684] cx23885[0]: FI[11] = 88
[ 1130.289759] cx23885[0]: FI[12] = 71
[ 1130.289835] cx23885[0]: FI[13] = 08
[ 1130.289910] cx23885[0]: FI[14] = 80
[ 1130.289987] cx23885[0]: FI[15] = 00
[ 1130.290065] cx23885[0]: FI[16] = ff
[ 1130.290140] cx23885[0]: FI[17] = ff
[ 1130.290216] cx23885[0]: FI[18] = ff
[ 1130.290291] cx23885[0]: FI[19] = 00
[ 1130.290366] cx23885[0]: FI[1a] = 02
[ 1130.290441] cx23885[0]: FI[1b] = 00
[ 1130.290517] cx23885[0]: FI[1c] = 00
[ 1130.290592] cx23885[0]: FI[1d] = 00
[ 1130.290667] cx23885[0]: FI[1e] = 00
[ 1130.290743] cx23885[0]: FI[1f] = 00
[ 1130.290819] cx23885[0]: FI[20] = 00
[ 1130.290895] cx23885[0]: FI[21] = 00
[ 1130.290971] cx23885[0]: FI[22] = 00
[ 1130.291048] cx23885[0]: FI[23] = 00
[ 1130.291053] cx23885_dev_checkrevision() Hardware revision = 0xb0
[ 1130.291059] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, 
latency: 0, mmio: 0xfd400000




Part of the output of dmesg after tuning a channel with tvtime:

[ 1485.223117] cx23885[0]: cx23885_start_audio_dma()
[ 1485.223130] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [TV Audio]
[ 1485.223156] cx23885[0]: Start audio DMA, 1024 B/line, 4 lines/FIFO, 
64 periods, 65536 byte buffer
[ 1485.223169] cx23885[0]: TV Audio - dma channel status dump
[ 1485.223177] cx23885[0]:   cmds: init risc lo   : 0x15287000
[ 1485.223183] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 1485.223188] cx23885[0]:   cmds: cdt base       : 0x00010a00
[ 1485.223194] cx23885[0]:   cmds: cdt size       : 0x00000008
[ 1485.223236] cx23885[0]:   cmds: iq base        : 0x00010480
[ 1485.223243] cx23885[0]:   cmds: iq size        : 0x00000010
[ 1485.223248] cx23885[0]:   cmds: risc pc lo     : 0x1528703c
[ 1485.223256] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 1485.223263] cx23885[0]:   cmds: iq wr ptr      : 0x0000412f
[ 1485.223269] cx23885[0]:   cmds: iq rd ptr      : 0x00004123
[ 1485.223274] cx23885[0]:   cmds: cdt current    : 0x00010a08
[ 1485.223279] cx23885[0]:   cmds: pci target lo  : 0x38666000
[ 1485.223286] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 1485.223293] cx23885[0]:   cmds: line / byte    : 0x00000000
[ 1485.223298] cx23885[0]:   risc0: 0x1c000400 [ write sol eol count=1024 ]
[ 1485.223315] cx23885[0]:   risc1: 0x38666000 [ INVALID sol 22 21 18 
cnt1 14 13 count=0 ]
[ 1485.223329] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 1485.223338] cx23885[0]:   risc3: 0x1d010400 [ write sol eol irq1 cnt0 
count=1024 ]
[ 1485.223351] cx23885[0]:   (0x00010480) iq 0: 0x1c000400 [ write sol 
eol count=1024 ]
[ 1485.223361] cx23885[0]:   iq 1: 0x38666000 [ arg #1 ]
[ 1485.223366] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 1485.223372] cx23885[0]:   (0x0001048c) iq 3: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.223383] cx23885[0]:   iq 4: 0x38666400 [ arg #1 ]
[ 1485.223388] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 1485.223394] cx23885[0]:   (0x00010498) iq 6: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.223404] cx23885[0]:   iq 7: 0x38666800 [ arg #1 ]
[ 1485.223410] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[ 1485.223415] cx23885[0]:   (0x000104a4) iq 9: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.223426] cx23885[0]:   iq a: 0x38666c00 [ arg #1 ]
[ 1485.223432] cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
[ 1485.223437] cx23885[0]:   (0x000104b0) iq c: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.223448] cx23885[0]:   iq d: 0x5a561000 [ arg #1 ]
[ 1485.223453] cx23885[0]:   iq e: 0x00000000 [ arg #2 ]
[ 1485.223459] cx23885[0]:   (0x000104bc) iq f: 0x00000000 [ INVALID 
count=0 ]
[ 1485.223465] cx23885[0]: fifo: 0x00007000 -> 0x8000
[ 1485.223468] cx23885[0]: ctrl: 0x00010480 -> 0x104e0
[ 1485.223473] cx23885[0]:   ptr1_reg: 0x00007068
[ 1485.223478] cx23885[0]:   ptr2_reg: 0x00010a08
[ 1485.223483] cx23885[0]:   cnt1_reg: 0x0000000e
[ 1485.223488] cx23885[0]:   cnt2_reg: 0x00000007
[ 1485.604027] cx23885[0]: Stopping audio DMA
[ 1485.604042] cx23885[0]: TV Audio - dma channel status dump
[ 1485.604049] cx23885[0]:   cmds: init risc lo   : 0x15287000
[ 1485.604055] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 1485.604062] cx23885[0]:   cmds: cdt base       : 0x00010a00
[ 1485.604068] cx23885[0]:   cmds: cdt size       : 0x00000008
[ 1485.604075] cx23885[0]:   cmds: iq base        : 0x00010480
[ 1485.604080] cx23885[0]:   cmds: iq size        : 0x00000010
[ 1485.604087] cx23885[0]:   cmds: risc pc lo     : 0x1528709c
[ 1485.604093] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 1485.604100] cx23885[0]:   cmds: iq wr ptr      : 0x00004129
[ 1485.604105] cx23885[0]:   cmds: iq rd ptr      : 0x0000412d
[ 1485.604111] cx23885[0]:   cmds: cdt current    : 0x00010a08
[ 1485.604119] cx23885[0]:   cmds: pci target lo  : 0x11748000
[ 1485.604127] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 1485.604132] cx23885[0]:   cmds: line / byte    : 0x00880000
[ 1485.604140] cx23885[0]:   risc0: 0x1d010400 [ write sol eol irq1 cnt0 
count=1024 ]
[ 1485.604152] cx23885[0]:   risc1: 0x11748000 [ write irq1 22 21 20 18 
resync count=0 ]
[ 1485.604164] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 1485.604175] cx23885[0]:   risc3: 0x1d010400 [ write sol eol irq1 cnt0 
count=1024 ]
[ 1485.604186] cx23885[0]:   (0x00010480) iq 0: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.604199] cx23885[0]:   iq 1: 0x11748800 [ arg #1 ]
[ 1485.604205] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 1485.604210] cx23885[0]:   (0x0001048c) iq 3: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.604222] cx23885[0]:   iq 4: 0x11748c00 [ arg #1 ]
[ 1485.604230] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 1485.604238] cx23885[0]:   (0x00010498) iq 6: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.604249] cx23885[0]:   iq 7: 0x0e9ef000 [ arg #1 ]
[ 1485.604257] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[ 1485.604262] cx23885[0]:   (0x000104a4) iq 9: 0x00000000 [ INVALID 
count=0 ]
[ 1485.604271] cx23885[0]:   (0x000104a8) iq a: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.604283] cx23885[0]:   iq b: 0x11748000 [ arg #1 ]
[ 1485.604291] cx23885[0]:   iq c: 0x00000000 [ arg #2 ]
[ 1485.604297] cx23885[0]:   (0x000104b4) iq d: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.604312] cx23885[0]:   iq e: 0x11748400 [ arg #1 ]
[ 1485.604320] cx23885[0]:   iq f: 0x00000000 [ arg #2 ]
[ 1485.604326] cx23885[0]: fifo: 0x00007000 -> 0x8000
[ 1485.604330] cx23885[0]: ctrl: 0x00010480 -> 0x104e0
[ 1485.604337] cx23885[0]:   ptr1_reg: 0x00007010
[ 1485.604342] cx23885[0]:   ptr2_reg: 0x00010a08
[ 1485.604347] cx23885[0]:   cnt1_reg: 0x00000002
[ 1485.604351] cx23885[0]:   cnt2_reg: 0x00000007
[ 1485.607081] cx23885[0]: cx23885_start_audio_dma()
[ 1485.607092] cx23885[0]: cx23885_sram_channel_setup() Configuring 
channel [TV Audio]
[ 1485.607117] cx23885[0]: Start audio DMA, 1024 B/line, 4 lines/FIFO, 
64 periods, 65536 byte buffer
[ 1485.607128] cx23885[0]: TV Audio - dma channel status dump
[ 1485.607135] cx23885[0]:   cmds: init risc lo   : 0x15287000
[ 1485.607141] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 1485.607149] cx23885[0]:   cmds: cdt base       : 0x00010a00
[ 1485.607157] cx23885[0]:   cmds: cdt size       : 0x00000008
[ 1485.607165] cx23885[0]:   cmds: iq base        : 0x00010480
[ 1485.607173] cx23885[0]:   cmds: iq size        : 0x00000010
[ 1485.607181] cx23885[0]:   cmds: risc pc lo     : 0x1528703c
[ 1485.607189] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 1485.607197] cx23885[0]:   cmds: iq wr ptr      : 0x0000412f
[ 1485.607203] cx23885[0]:   cmds: iq rd ptr      : 0x00004123
[ 1485.607210] cx23885[0]:   cmds: cdt current    : 0x00010a08
[ 1485.607216] cx23885[0]:   cmds: pci target lo  : 0x38666000
[ 1485.607221] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 1485.607227] cx23885[0]:   cmds: line / byte    : 0x00000000
[ 1485.607232] cx23885[0]:   risc0: 0x1c000400 [ write sol eol count=1024 ]
[ 1485.607243] cx23885[0]:   risc1: 0x38666000 [ INVALID sol 22 21 18 
cnt1 14 13 count=0 ]
[ 1485.607259] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 1485.607267] cx23885[0]:   risc3: 0x1d010400 [ write sol eol irq1 cnt0 
count=1024 ]
[ 1485.607280] cx23885[0]:   (0x00010480) iq 0: 0x1c000400 [ write sol 
eol count=1024 ]
[ 1485.607289] cx23885[0]:   iq 1: 0x38666000 [ arg #1 ]
[ 1485.607295] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 1485.607300] cx23885[0]:   (0x0001048c) iq 3: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.607313] cx23885[0]:   iq 4: 0x38666400 [ arg #1 ]
[ 1485.607319] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 1485.607324] cx23885[0]:   (0x00010498) iq 6: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.607337] cx23885[0]:   iq 7: 0x38666800 [ arg #1 ]
[ 1485.607342] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[ 1485.607348] cx23885[0]:   (0x000104a4) iq 9: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.607358] cx23885[0]:   iq a: 0x38666c00 [ arg #1 ]
[ 1485.607365] cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
[ 1485.607370] cx23885[0]:   (0x000104b0) iq c: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.607381] cx23885[0]:   iq d: 0x5a561000 [ arg #1 ]
[ 1485.607386] cx23885[0]:   iq e: 0x00000000 [ arg #2 ]
[ 1485.607391] cx23885[0]:   (0x000104bc) iq f: 0x00000000 [ INVALID 
count=0 ]
[ 1485.607397] cx23885[0]: fifo: 0x00007000 -> 0x8000
[ 1485.607401] cx23885[0]: ctrl: 0x00010480 -> 0x104e0
[ 1485.607406] cx23885[0]:   ptr1_reg: 0x00007068
[ 1485.607410] cx23885[0]:   ptr2_reg: 0x00010a08
[ 1485.607415] cx23885[0]:   cnt1_reg: 0x0000000e
[ 1485.607420] cx23885[0]:   cnt2_reg: 0x00000007
[ 1485.987968] cx23885[0]: Stopping audio DMA
[ 1485.987982] cx23885[0]: TV Audio - dma channel status dump
[ 1485.987990] cx23885[0]:   cmds: init risc lo   : 0x15287000
[ 1485.987996] cx23885[0]:   cmds: init risc hi   : 0x00000000
[ 1485.988005] cx23885[0]:   cmds: cdt base       : 0x00010a00
[ 1485.988012] cx23885[0]:   cmds: cdt size       : 0x00000008
[ 1485.988020] cx23885[0]:   cmds: iq base        : 0x00010480
[ 1485.988028] cx23885[0]:   cmds: iq size        : 0x00000010
[ 1485.988036] cx23885[0]:   cmds: risc pc lo     : 0x1528709c
[ 1485.988044] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[ 1485.988053] cx23885[0]:   cmds: iq wr ptr      : 0x00004129
[ 1485.988058] cx23885[0]:   cmds: iq rd ptr      : 0x0000412d
[ 1485.988066] cx23885[0]:   cmds: cdt current    : 0x00010a08
[ 1485.988074] cx23885[0]:   cmds: pci target lo  : 0x11748000
[ 1485.988079] cx23885[0]:   cmds: pci target hi  : 0x00000000
[ 1485.988085] cx23885[0]:   cmds: line / byte    : 0x00880000
[ 1485.988090] cx23885[0]:   risc0: 0x1d010400 [ write sol eol irq1 cnt0 
count=1024 ]
[ 1485.988102] cx23885[0]:   risc1: 0x11748000 [ write irq1 22 21 20 18 
resync count=0 ]
[ 1485.988116] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[ 1485.988127] cx23885[0]:   risc3: 0x1d010400 [ write sol eol irq1 cnt0 
count=1024 ]
[ 1485.988142] cx23885[0]:   (0x00010480) iq 0: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.988153] cx23885[0]:   iq 1: 0x11748800 [ arg #1 ]
[ 1485.988158] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[ 1485.988164] cx23885[0]:   (0x0001048c) iq 3: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.988175] cx23885[0]:   iq 4: 0x11748c00 [ arg #1 ]
[ 1485.988183] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[ 1485.988189] cx23885[0]:   (0x00010498) iq 6: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.988201] cx23885[0]:   iq 7: 0x0e9ef000 [ arg #1 ]
[ 1485.988207] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[ 1485.988214] cx23885[0]:   (0x000104a4) iq 9: 0x00000000 [ INVALID 
count=0 ]
[ 1485.988222] cx23885[0]:   (0x000104a8) iq a: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.988232] cx23885[0]:   iq b: 0x11748000 [ arg #1 ]
[ 1485.988238] cx23885[0]:   iq c: 0x00000000 [ arg #2 ]
[ 1485.988245] cx23885[0]:   (0x000104b4) iq d: 0x1d010400 [ write sol 
eol irq1 cnt0 count=1024 ]
[ 1485.988259] cx23885[0]:   iq e: 0x11748400 [ arg #1 ]
[ 1485.988268] cx23885[0]:   iq f: 0x00000000 [ arg #2 ]
[ 1485.988274] cx23885[0]: fifo: 0x00007000 -> 0x8000
[ 1485.988278] cx23885[0]: ctrl: 0x00010480 -> 0x104e0
[ 1485.988283] cx23885[0]:   ptr1_reg: 0x00007010
[ 1485.988288] cx23885[0]:   ptr2_reg: 0x00010a08
[ 1485.988293] cx23885[0]:   cnt1_reg: 0x00000002
[ 1485.988297] cx23885[0]:   cnt2_reg: 0x00000007

alfredo@dhcppc0:~> arecord -D hw:3,0 -r 48000 -c 2 -f S16_LE | aplay -
Recording WAVE 'stdin' : Signed 16 bit Little Endian, Rate 48000 Hz, Stereo
Playing WAVE 'stdin' : Signed 16 bit Little Endian, Rate 48000 Hz, Stereo
overrun!!! (at least 0,031 ms long)
overrun!!! (at least 0,252 ms long)
overrun!!! (at least 0,286 ms long)
overrun!!! (at least 0,275 ms long)
overrun!!! (at least 0,278 ms long)
overrun!!! (at least 0,268 ms long)
overrun!!! (at least 0,281 ms long)
overrun!!! (at least 0,277 ms long)
overrun!!! (at least 0,265 ms long)


Thanks.

Alfredo

-- 
Dona tu voz
http://www.voxforge.org/es

