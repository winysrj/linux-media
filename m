Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sg1hn0121.outbound.protection.outlook.com ([134.170.132.121]:2625
	"EHLO APAC01-SG1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751520AbaJKDdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 23:33:04 -0400
From: James Harper <james@ejbdigital.com.au>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: panic in cx23885
Date: Sat, 11 Oct 2014 03:32:57 +0000
Message-ID: <603a050e84fa424691c2609aa76d670d@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm still not having any luck getting reliable operation of the second tuner on my cx23885 based card.

Incidental to this, I'm getting a crash in cx23885_video_wakeup at the line:

buf->vb.v4l2_buf.sequence = q->count++;

(full log follows this email)

I'm not sure exactly why, but I do know that the hardware is well and truly messed up at this point. IRQ's are reading 0xffffffff from a lot of the hardware registers etc. Is it worth putting a test in cx23885_video_wakeup to stop it following bad pointers and recovering from a potential crash, or are things so bad by this point that it isn't worth it?

I'm getting things like this too:

Uhhuh. NMI received for unknown reason 21 on CPU 0.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue

Everything works perfectly with only one tuner enabled so I still think the hardware is okay.

Thanks

James

[  346.183389] cx23885 driver version 0.0.4 loaded
[  346.188612] Already setup the GSI :16
[  346.192970] CORE cx23885[0]: subsystem: 18ac:db98, board: DViCO FusionHDTV DVB-T Dual Express2 [card=44,autodetected]
[  346.344149] Registered IR keymap rc-fusionhdtv-mce
[  346.349632] input: i2c IR (FusionHDTV) as /devices/virtual/rc/rc0/input6
[  346.357248] rc0: i2c IR (FusionHDTV) as /devices/virtual/rc/rc0
[  346.363937] ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-6/6-006b/ir0 [cx23885[0]]
[  346.402161] cx23885_dvb_register() allocating 1 frontend(s)
[  346.408458] cx23885[0]: cx23885 based dvb card
[  346.618609] DiB0070: successfully identified
[  346.623478] DVB: registering new adapter (cx23885[0])
[  346.629218] cx23885 0000:10:00.0: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[  346.639696] cx23885_dvb_register() allocating 1 frontend(s)
[  346.646024] cx23885[0]: cx23885 based dvb card
[  346.854595] DiB0070: successfully identified
[  346.859460] DVB: registering new adapter (cx23885[0])
[  346.865196] cx23885 0000:10:00.0: DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
[  346.874967] cx23885_dev_checkrevision() Hardware revision = 0xa5
[  346.881785] cx23885[0]/0: found at 0000:10:00.0, rev: 4, irq: 16, latency: 0, mmio: 0xdfa00000
[  364.229718] cx23885[0]: TS1 B - dma channel status dump
[  364.235665] cx23885[0]:   cmds: init risc lo   : 0x08040000
[  364.241989] cx23885[0]:   cmds: init risc hi   : 0x00000000
[  364.248306] cx23885[0]:   cmds: cdt base       : 0x00010580
[  364.254622] cx23885[0]:   cmds: cdt size       : 0x0000000a
[  364.260946] cx23885[0]:   cmds: iq base        : 0x00010400
[  364.267283] cx23885[0]:   cmds: iq size        : 0x00000010
[  364.273605] cx23885[0]:   cmds: risc pc lo     : 0x00000000
[  364.279923] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  364.286254] cx23885[0]:   cmds: iq wr ptr      : 0x00000000
[  364.292591] cx23885[0]:   cmds: iq rd ptr      : 0x00000000
[  364.298923] cx23885[0]:   cmds: cdt current    : 0x00000000
[  364.305255] cx23885[0]:   cmds: pci target lo  : 0x00000000
[  364.311590] cx23885[0]:   cmds: pci target hi  : 0x00000000
[  364.317926] cx23885[0]:   cmds: line / byte    : 0x00000000
[  364.324257] cx23885[0]:   risc0: 0x00000000 [ INVALID count=0 ]
[  364.331104] cx23885[0]:   risc1: 0x00000000 [ INVALID count=0 ]
[  364.337938] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[  364.344762] cx23885[0]:   risc3: 0x00000000 [ INVALID count=0 ]
[  364.351629] cx23885[0]:   (0x00010400) iq 0: 0xb6335993 [ writerm eol irq2 21 20 cnt1 cnt0 14 12 count=2451 ]
[  364.363430] cx23885[0]:   iq 1: 0x806ea57e [ arg #1 ]
[  364.369166] cx23885[0]:   iq 2: 0xf09414e3 [ arg #2 ]
[  364.374901] cx23885[0]:   (0x0001040c) iq 3:
[  364.379946] 0xb5f47d7e [ writerm eol irq1 23 22 21 20 18 14 13 12
[  364.387525]  count=3454 ]
[  364.390567] cx23885[0]:   iq 4: 0x2167057e [ arg #1 ]
[  364.396300] cx23885[0]:   iq 5: 0xf45bc3a9 [ arg #2 ]
[  364.402035] cx23885[0]:   (0x00010418) iq 6: 0x932db884 [ read irq2 irq1 21 19 18 cnt0 resync 13 12 count=2180 ]
[  364.414183] cx23885[0]:   (0x0001041c) iq 7: 0x79e72545 [ jump sol irq1 23 22 21 18 cnt1 cnt0 13 count=1349 ]
[  364.426019] cx23885[0]:   iq 8: 0xb5cf52c3 [ arg #1 ]
[  364.431756] cx23885[0]:   iq 9: 0x9ad81dad [ arg #2 ]
[  364.437490] cx23885[0]:   (0x00010428) iq a: 0x0b6a2271 [ INVALID sol irq2 irq1 22 21 19 cnt1 13 count=625 ]
[  364.449193] cx23885[0]:   (0x0001042c) iq b: 0x75349ce0 [ jump eol irq1 21 20 18 resync 12 count=3296 ]
[  364.460369] cx23885[0]:   iq c: 0x41bfb24c [ arg #1 ]
[  364.466106] cx23885[0]:   iq d: 0x796c6b1e [ arg #2 ]
[  364.471840] cx23885[0]:   (0x00010438) iq e: 0x5319b595 [ writec irq2 irq1 20 19 cnt0 resync 13 12 count=1429 ]
[  364.483863] cx23885[0]:   (0x0001043c) iq f: 0x1d9345c2 [ write sol eol irq1 23 20 cnt1 cnt0 14 count=1474 ]
[  364.495564] cx23885[0]:   iq 10: 0x0234dd60 [ arg #1 ]
[  364.501413] cx23885[0]:   iq 11: 0x00000000 [ arg #2 ]
[  364.507323] cx23885[0]: fifo: 0x00005000 -> 0x6000
[  364.512816] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[  364.518397] cx23885[0]:   ptr1_reg: 0x00005000
[  364.523478] cx23885[0]:   ptr2_reg: 0x00010588
[  364.528578] cx23885[0]:   cnt1_reg: 0x00000000
[  364.533696] cx23885[0]:   cnt2_reg: 0x00000009
[  364.539036] cx23885[0]: risc disasm: ffff8800b4d9e000 [dma=0x08040000]
[  364.546703] cx23885[0]:   0000: 0x70000000 [ jump count=0 ]
[  364.553340] cx23885[0]:   0001: 0x0804000c [ arg #1 ]
[  364.559129] cx23885[0]:   0002: 0x00000000 [ arg #2 ]
[  364.568864] cx23885[0]: TS1 B - dma channel status dump
[  364.574807] cx23885[0]:   cmds: init risc lo   : 0x08020000
[  364.581135] cx23885[0]:   cmds: init risc hi   : 0x00000000
[  364.587455] cx23885[0]:   cmds: cdt base       : 0x00010580
[  364.593774] cx23885[0]:   cmds: cdt size       : 0x0000000a
[  364.600091] cx23885[0]:   cmds: iq base        : 0x00010400
[  364.606408] cx23885[0]:   cmds: iq size        : 0x00000010
[  364.612728] cx23885[0]:   cmds: risc pc lo     : 0x00000000
[  364.619048] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  364.625365] cx23885[0]:   cmds: iq wr ptr      : 0x00000000
[  364.631689] cx23885[0]:   cmds: iq rd ptr      : 0x00000000
[  364.638008] cx23885[0]:   cmds: cdt current    : 0x00000000
[  364.644324] cx23885[0]:   cmds: pci target lo  : 0x00000000
[  364.650640] cx23885[0]:   cmds: pci target hi  : 0x00000000
[  364.656947] cx23885[0]:   cmds: line / byte    : 0x00000000
[  364.663265] cx23885[0]:   risc0: 0x00000000 [ INVALID count=0 ]
[  364.670087] cx23885[0]:   risc1: 0x00000000 [ INVALID count=0 ]
[  364.676910] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[  364.683736] cx23885[0]:   risc3: 0x00000000 [ INVALID count=0 ]
[  364.690554] cx23885[0]:   (0x00010400) iq 0: 0x70000000 [ jump count=0 ]
[  364.698249] cx23885[0]:   iq 1: 0x1c0002f0 [ arg #1 ]
[  364.703984] cx23885[0]:   iq 2: 0x02180000 [ arg #2 ]
[  364.709718] cx23885[0]:   (0x0001040c) iq 3: 0x00000000 [ INVALID count=0 ]
[  364.717703] cx23885[0]:   (0x00010410) iq 4: 0x1c0002f0 [ write sol eol count=752 ]
[  364.726604] cx23885[0]:   iq 5: 0x021802f0 [ arg #1 ]
[  364.732339] cx23885[0]:   iq 6: 0x00000000 [ arg #2 ]
[  364.738073] cx23885[0]:   (0x0001041c) iq 7: 0x1c0002f0 [ write sol eol count=752 ]
[  364.746986] cx23885[0]:   iq 8: 0x021805e0 [ arg #1 ]
[  364.752718] cx23885[0]:   iq 9: 0x00000000 [ arg #2 ]
[  364.758452] cx23885[0]:   (0x00010428) iq a: 0x1c0002f0 [ write sol eol count=752 ]
[  364.767363] cx23885[0]:   iq b: 0x021808d0 [ arg #1 ]
[  364.773097] cx23885[0]:   iq c: 0x00000000 [ arg #2 ]
[  364.778830] cx23885[0]:   (0x00010434) iq d: 0x1c0002f0 [ write sol eol count=752 ]
[  364.787737] cx23885[0]:   iq e: 0x02180bc0 [ arg #1 ]
[  364.793471] cx23885[0]:   iq f: 0x00000000 [ arg #2 ]
[  364.799203] cx23885[0]: fifo: 0x00005000 -> 0x6000
[  364.804642] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[  364.810179] cx23885[0]:   ptr1_reg: 0x00005000
[  364.815236] cx23885[0]:   ptr2_reg: 0x00010588
[  364.820292] cx23885[0]:   cnt1_reg: 0x00000000
[  364.825339] cx23885[0]:   cnt2_reg: 0x00000009
[  364.830385] cx23885[0]: risc disasm: ffff8800b4d1e000 [dma=0x08020000]
[  364.837773] cx23885[0]:   0000: 0x70000000 [ jump count=0 ]
[  364.844212] cx23885[0]:   0001: 0x0802000c [ arg #1 ]
[  364.849943] cx23885[0]:   0002: 0x00000000 [ arg #2 ]
[  364.906820] cx23885[0]: TS2 C - dma channel status dump
[  364.912762] cx23885[0]:   cmds: init risc lo   : 0x0800b000
[  364.919085] cx23885[0]:   cmds: init risc hi   : 0x00000000
[  364.925407] cx23885[0]:   cmds: cdt base       : 0x000105e0
[  364.931728] cx23885[0]:   cmds: cdt size       : 0x0000000a
[  364.938047] cx23885[0]:   cmds: iq base        : 0x00010440
[  364.944369] cx23885[0]:   cmds: iq size        : 0x00000010
[  364.950691] cx23885[0]:   cmds: risc pc lo     : 0x00000000
[  364.957012] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  364.963330] cx23885[0]:   cmds: iq wr ptr      : 0x00000000
[  364.969652] cx23885[0]:   cmds: iq rd ptr      : 0x00000000
[  364.975974] cx23885[0]:   cmds: cdt current    : 0x00000000
[  364.982296] cx23885[0]:   cmds: pci target lo  : 0x00000000
[  364.988612] cx23885[0]:   cmds: pci target hi  : 0x00000000
[  364.994936] cx23885[0]:   cmds: line / byte    : 0x00000000
[  365.001258] cx23885[0]:   risc0: 0x00000000 [ INVALID
[  365.006841]  count=0 ]
[  365.009825] cx23885[0]:   risc1: 0x00000000 [ INVALID
[  365.015406]  count=0 ]
[  365.018398] cx23885[0]:   risc2: 0x00000000 [ INVALID
[  365.023974]  count=0 ]
[  365.026974] cx23885[0]:   risc3: 0x00000000 [ INVALID
[  365.032550]  count=0 ]
[  365.035544] cx23885[0]:   (0x00010440) iq 0:
[  365.040282] 0x0234dd60 [ INVALID irq2 21 20 18 resync 14 12 count=3424 ]
[  365.048607] cx23885[0]:   (0x00010444) iq 1: 0x00000000 [ INVALID count=0 ]
[  365.056603] cx23885[0]:   (0x00010448) iq 2: 0x1c0002f0 [ write sol eol count=752 ]
[  365.065523] cx23885[0]:   iq 3: 0x0234e050 [ arg #1 ]
[  365.071258] cx23885[0]:   iq 4: 0x00000000 [ arg #2 ]
[  365.076996] cx23885[0]:   (0x00010454) iq 5:
[  365.081733] 0x00000000 [ INVALID count=0 ]
[  365.086737] cx23885[0]:   (0x00010458) iq 6:
[  365.091474] 0x1c0002f0 [ write sol eol count=752 ]
[  365.097360] cx23885[0]:   iq 7: 0x0234d490 [ arg #1 ]
[  365.103098] cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[  365.108836] cx23885[0]:   (0x00010464) iq 9: 0x1c0002f0 [ write
[  365.115386]  sol eol count=752 ]
[  365.119468] cx23885[0]:   iq a: 0x0234d780 [ arg #1 ]
[  365.125206] cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
[  365.130941] cx23885[0]:   (0x00010470) iq c:
[  365.135671] 0x1c0002f0 [ write sol eol
[  365.140123]  count=752 ]
[  365.143313] cx23885[0]:   iq d: 0x0234da70 [ arg #1 ]
[  365.149050] cx23885[0]:   iq e: 0x00000000 [ arg #2 ]
[  365.154783] cx23885[0]:   (0x0001047c) iq f:
[  365.159519] 0x1c0002f0 [ write sol eol count=752 ]
[  365.165408] cx23885[0]:   iq 10: 0x417f1b73 [ arg #1 ]
[  365.171239] cx23885[0]:   iq 11: 0xb98eb8be [ arg #2 ]
[  365.177064] cx23885[0]: fifo: 0x00006000 -> 0x7000
[  365.182510] cx23885[0]: ctrl: 0x00010440 -> 0x104a0
[  365.188050] cx23885[0]:   ptr1_reg: 0x00006000
[  365.193105] cx23885[0]:   ptr2_reg: 0x000105e8
[  365.198148] cx23885[0]:   cnt1_reg: 0x00000000
[  365.203206] cx23885[0]:   cnt2_reg: 0x00000009
[  365.208261] cx23885[0]: risc disasm: ffff8800b7427000 [dma=0x0800b000]
[  365.215650] cx23885[0]:   0000: 0x70000000 [ jump count=0 ]
[  365.222078] cx23885[0]:   0001: 0x0800b00c [ arg #1 ]
[  365.227814] cx23885[0]:   0002: 0x00000000 [ arg #2 ]
[  365.238129] cx23885[0]: TS2 C - dma channel status dump
[  365.244143] cx23885[0]:   cmds: init risc lo   : 0x07eeb000
[  365.251826] cx23885[0]:   cmds: init risc hi   : 0x00000000
[  365.258183] cx23885[0]:   cmds: cdt base       : 0x000105e0
[  365.264505] cx23885[0]:   cmds: cdt size       : 0x0000000a
[  365.270863] cx23885[0]:   cmds: iq base        : 0x00010440
[  365.277219] cx23885[0]:   cmds: iq size        : 0x00000010
[  365.283577] cx23885[0]:   cmds: risc pc lo     : 0x00000000
[  365.289895] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  365.296257] cx23885[0]:   cmds: iq wr ptr      : 0x00000000
[  365.302615] cx23885[0]:   cmds: iq rd ptr      : 0x00000000
[  365.308975] cx23885[0]:   cmds: cdt current    : 0x00000000
[  365.315333] cx23885[0]:   cmds: pci target lo  : 0x00000000
[  365.321651] cx23885[0]:   cmds: pci target hi  : 0x00000000
[  365.328008] cx23885[0]:   cmds: line / byte    : 0x00000000
[  365.334366] cx23885[0]:   risc0:
[  365.337931] 0x00000000 [ INVALID[  365.341719]  count=0 ]
[  365.344441] cx23885[0]:   risc1: 0x00000000 [ INVALID
[  365.350315]  count=0 ]
[  365.353034] cx23885[0]:   risc2: 0x00000000 [ INVALID
[  365.358912]  count=0 ]
[  365.361627] cx23885[0]:   risc3: 0x00000000 [ INVALID
[  365.367517]  count=0 ]
[  365.370229] cx23885[0]:   (0x00010440) iq 0:
[  365.375277] 0x1c0002f0 [ write
[  365.378546]  sol eol count=752 ]
[  365.382673] cx23885[0]:   iq 1: 0x02032eb0 [ arg #1 ]
[  365.388406] cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[  365.394180] cx23885[0]:   (0x0001044c) iq 3:
[  365.399232] 0x1c0002f0 [ write
[  365.402499]  sol eol count=752 ]
[  365.406580] cx23885[0]:   iq 4: 0x020331a0 [ arg #1 ]
[  365.412351] cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[  365.418126] cx23885[0]:   (0x00010458) iq 6:
[  365.422862] 0x00000000 [ INVALID[  365.426641]  count=0 ]
[  365.429360] cx23885[0]:   (0x0001045c) iq 7:
[  365.434406] 0x1c0002f0 [ write
[  365.437682]  sol eol count=752 ]
[  365.441805] cx23885[0]:   iq 8: 0x020325e0 [ arg #1 ]
[  365.447540] cx23885[0]:   iq 9: 0x00000000 [ arg #2 ]
[  365.453306] cx23885[0]:   (0x00010468) iq a:
[  365.458347] 0x1c0002f0 [ write
[  365.461940]  sol eol count=752 ]
[  365.465780] cx23885[0]:   iq b: 0x020328d0 [ arg #1 ]
[  365.471516] cx23885[0]:   iq c: 0x00000000 [ arg #2 ]
[  365.477333] cx23885[0]:   (0x00010474) iq d: 0x1c0002f0 [ write sol
[  365.484523]  eol
[  365.486430]  count=752 ]
[  365.489621] cx23885[0]:   iq e: 0x02032bc0 [ arg #1 ]
[  365.495387] cx23885[0]:   iq f: 0x00000000 [ arg #2 ]
[  365.501160] cx23885[0]: fifo: 0x00006000 -> 0x7000
[  365.506601] cx23885[0]: ctrl: 0x00010440 -> 0x104a0
[  365.512181] cx23885[0]:   ptr1_reg: 0x00006000
[  365.517277] cx23885[0]:   ptr2_reg: 0x000105e8
[  365.522331] cx23885[0]:   cnt1_reg: 0x00000000
[  365.527422] cx23885[0]:   cnt2_reg: 0x00000009
[  365.532513] cx23885[0]: risc disasm: ffff8800b7424000 [dma=0x07eeb000]
[  365.539900] cx23885[0]:   0000: 0x70000000 [ jump count=0 ]
[  365.546328] cx23885[0]:   0001: 0x07eeb00c [ arg #1 ]
[  365.552059] cx23885[0]:   0002: 0x00000000 [ arg #2 ]
[  367.281625] cx23885[0]: TS2 C - dma channel status dump
[  367.287567] cx23885[0]:   cmds: init risc lo   : 0x07ec4000
[  367.293909] cx23885[0]:   cmds: init risc hi   : 0x00000000
[  367.300220] cx23885[0]:   cmds: cdt base       : 0x000105e0
[  367.306539] cx23885[0]:   cmds: cdt size       : 0x0000000a
[  367.312857] cx23885[0]:   cmds: iq base        : 0x00010440
[  367.319174] cx23885[0]:   cmds: iq size        : 0x00000010
[  367.325492] cx23885[0]:   cmds: risc pc lo     : 0x00000000
[  367.331810] cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  367.338126] cx23885[0]:   cmds: iq wr ptr      : 0x00000000
[  367.344443] cx23885[0]:   cmds: iq rd ptr      : 0x00000000
[  367.350760] cx23885[0]:   cmds: cdt current    : 0x00000000
[  367.357067] cx23885[0]:   cmds: pci target lo  : 0x00000000
[  367.363382] cx23885[0]:   cmds: pci target hi  : 0x00000000
[  367.369700] cx23885[0]:   cmds: line / byte    : 0x00000000
[  367.376016] cx23885[0]:   risc0: 0x00000000 [ INVALID count=0 ]
[  367.382843] cx23885[0]:   risc1: 0x00000000 [ INVALID count=0 ]
[  367.389661] cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
[  367.396487] cx23885[0]:   risc3: 0x00000000 [ INVALID count=0 ]
[  367.403317] cx23885[0]:   (0x00010440) iq 0: 0x006431f0 [ INVALID 22 21 18 13 12 count=496 ]
[  367.413260] cx23885[0]:   (0x00010444) iq 1: 0x00000000 [ INVALID count=0 ]
[  367.421253] cx23885[0]:   (0x00010448) iq 2: 0x1c0002f0 [ write sol eol count=752 ]
[  367.430164] cx23885[0]:   iq 3: 0x006434e0 [ arg #1 ]
[  367.435901] cx23885[0]:   iq 4: 0x00000000 [ arg #2 ]
[  367.441637] cx23885[0]:   (0x00010454) iq 5: 0x1c0002f0 [ write sol eol count=752 ]
[  367.450534] cx23885[0]:   iq 6: 0x006437d0 [ arg #1 ]
[  367.456267] cx23885[0]:   iq 7: 0x00000000 [ arg #2 ]
[  367.462000] cx23885[0]:   (0x00010460) iq 8: 0x00000000 [ INVALID count=0 ]
[  367.469992] cx23885[0]:   (0x00010464) iq 9:
[  367.474730] 0x1c0002f0 [ write sol eol count=752 ]
[  367.480629] cx23885[0]:   iq a: 0x00642c10 [ arg #1 ]
[  367.486363] cx23885[0]:   iq b: 0x00000000 [ arg #2 ]
[  367.492101] cx23885[0]:   (0x00010470) iq c: 0x1c0002f0 [ write sol eol count=752 ]
[  367.501014] cx23885[0]:   iq d: 0x00642f00 [ arg #1 ]
[  367.506748] cx23885[0]:   iq e: 0x00000000 [ arg #2 ]
[  367.512485] cx23885[0]:   (0x0001047c) iq f: 0x1c0002f0 [ write sol eol count=752 ]
[  367.521391] cx23885[0]:   iq 10: 0x417f1b73 [ arg #1 ]
[  367.527222] cx23885[0]:   iq 11: 0xb98eb8be [ arg #2 ]
[  367.533052] cx23885[0]: fifo: 0x00006000 -> 0x7000
[  367.538492] cx23885[0]: ctrl: 0x00010440 -> 0x104a0
[  367.544034] cx23885[0]:   ptr1_reg: 0x00006000
[  367.549088] cx23885[0]:   ptr2_reg: 0x000105e8
[  367.554142] cx23885[0]:   cnt1_reg: 0x00000000
[  367.559198] cx23885[0]:   cnt2_reg: 0x00000009
[  367.564278] cx23885[0]: risc disasm: ffff8800b7723000 [dma=0x07ec4000]
[  367.571662] cx23885[0]:   0000: 0x70000000 [ jump count=0 ]
[  367.578090] cx23885[0]:   0001: 0x07ec400c [ arg #1 ]
[  367.583821] cx23885[0]:   0002: 0x00000000 [ arg #2 ]
[  417.306762] cx23885[0]: mpeg risc op code error
[  417.311917] cx23885[0]: TS1 B - dma channel status dump
[  417.317837] cx23885[0]:   cmds: init risc lo   : 0xffffffff
[  417.324138] cx23885[0]:   cmds: init risc hi   : 0xffffffff
[  417.330446] cx23885[0]:   cmds: cdt base       : 0xffffffff
[  417.336753] cx23885[0]:   cmds: cdt size       : 0xffffffff
[  417.343051] cx23885[0]:   cmds: iq base        : 0xffffffff
[  417.349362] cx23885[0]:   cmds: iq size        : 0xffffffff
[  417.355673] cx23885[0]:   cmds: risc pc lo     : 0xffffffff
[  417.361982] cx23885[0]:   cmds: risc pc hi     : 0xffffffff
[  417.368291] cx23885[0]:   cmds: iq wr ptr      : 0xffffffff
[  417.374599] cx23885[0]:   cmds: iq rd ptr      : 0xffffffff
[  417.380908] cx23885[0]:   cmds: cdt current    : 0xffffffff
[  417.387216] cx23885[0]:   cmds: pci target lo  : 0xffffffff
[  417.393525] cx23885[0]:   cmds: pci target hi  : 0xffffffff
[  417.399833] cx23885[0]:   cmds: line / byte    : 0xffffffff
[  417.406133] cx23885[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.420201] cx23885[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.434252] cx23885[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.448317] cx23885[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.462375] cx23885[0]:   (0x00010400) iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.477603] cx23885[0]:   (0x00010404) iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.492833] cx23885[0]:   (0x00010408) iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.508056] cx23885[0]:   (0x0001040c) iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.523284] cx23885[0]:   (0x00010410) iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.538505] cx23885[0]:   (0x00010414) iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.553742] cx23885[0]:   (0x00010418) iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.569005] cx23885[0]:   (0x0001041c) iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.584223] cx23885[0]:   (0x00010420) iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.599454] cx23885[0]:   (0x00010424) iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.614688] cx23885[0]:   (0x00010428) iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.629923] cx23885[0]:   (0x0001042c) iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.645149] cx23885[0]:   (0x00010430) iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.660378] cx23885[0]:   (0x00010434) iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.675611] cx23885[0]:   (0x00010438) iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.690825] cx23885[0]:   (0x0001043c) iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.706054] cx23885[0]: fifo: 0x00005000 -> 0x6000
[  417.711487] cx23885[0]: ctrl: 0x00010400 -> 0x10460
[  417.717016] cx23885[0]:   ptr1_reg: 0xffffffff
[  417.722059] cx23885[0]:   ptr2_reg: 0xffffffff
[  417.727106] cx23885[0]:   cnt1_reg: 0xffffffff
[  417.732151] cx23885[0]:   cnt2_reg: 0xffffffff
[  417.737199] cx23885[0]: mpeg risc op code error
[  417.742342] cx23885[0]: TS2 C - dma channel status dump
[  417.748263] cx23885[0]:   cmds: init risc lo   : 0xffffffff
[  417.754572] cx23885[0]:   cmds: init risc hi   : 0xffffffff
[  417.760880] cx23885[0]:   cmds: cdt base       : 0xffffffff
[  417.767189] cx23885[0]:   cmds: cdt size       : 0xffffffff
[  417.773499] cx23885[0]:   cmds: iq base        : 0xffffffff
[  417.781095] cx23885[0]:   cmds: iq size        : 0xffffffff
[  417.787405] cx23885[0]:   cmds: risc pc lo     : 0xffffffff
[  417.793713] cx23885[0]:   cmds: risc pc hi     : 0xffffffff
[  417.800022] cx23885[0]:   cmds: iq wr ptr      : 0xffffffff
[  417.806332] cx23885[0]:   cmds: iq rd ptr      : 0xffffffff
[  417.812640] cx23885[0]:   cmds: cdt current    : 0xffffffff
[  417.818949] cx23885[0]:   cmds: pci target lo  : 0xffffffff
[  417.825257] cx23885[0]:   cmds: pci target hi  : 0xffffffff
[  417.831566] cx23885[0]:   cmds: line / byte    : 0xffffffff
[  417.837876] cx23885[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.851936] cx23885[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.865990] cx23885[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.880048] cx23885[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.894105] cx23885[0]:   (0x00010440) iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.909333] cx23885[0]:   (0x00010444) iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.924571] cx23885[0]:   (0x00010448) iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.939798] cx23885[0]:   (0x0001044c) iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.955031] cx23885[0]:   (0x00010450) iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.970247] cx23885[0]:   (0x00010454) iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  417.985472] cx23885[0]:   (0x00010458) iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.000698] cx23885[0]:   (0x0001045c) iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.015929] cx23885[0]:   (0x00010460) iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.031162] cx23885[0]:   (0x00010464) iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.046390] cx23885[0]:   (0x00010468) iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.061613] cx23885[0]:   (0x0001046c) iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.076839] cx23885[0]:   (0x00010470) iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.092069] cx23885[0]:   (0x00010474) iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.107303] cx23885[0]:   (0x00010478) iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.122523] cx23885[0]:   (0x0001047c) iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.137758] cx23885[0]: fifo: 0x00006000 -> 0x7000
[  418.143190] cx23885[0]: ctrl: 0x00010440 -> 0x104a0
[  418.148720] cx23885[0]:   ptr1_reg: 0xffffffff
[  418.153763] cx23885[0]:   ptr2_reg: 0xffffffff
[  418.158808] cx23885[0]:   cnt1_reg: 0xffffffff
[  418.163852] cx23885[0]:   cnt2_reg: 0xffffffff
[  418.168897] cx23885[0]: video risc op code error
[  418.174137] cx23885[0]: VID A - dma channel status dump
[  418.180055] cx23885[0]:   cmds: init risc lo   : 0xffffffff
[  418.186364] cx23885[0]:   cmds: init risc hi   : 0xffffffff
[  418.192673] cx23885[0]:   cmds: cdt base       : 0xffffffff
[  418.198983] cx23885[0]:   cmds: cdt size       : 0xffffffff
[  418.205292] cx23885[0]:   cmds: iq base        : 0xffffffff
[  418.211602] cx23885[0]:   cmds: iq size        : 0xffffffff
[  418.217910] cx23885[0]:   cmds: risc pc lo     : 0xffffffff
[  418.224220] cx23885[0]:   cmds: risc pc hi     : 0xffffffff
[  418.230528] cx23885[0]:   cmds: iq wr ptr      : 0xffffffff
[  418.236836] cx23885[0]:   cmds: iq rd ptr      : 0xffffffff
[  418.243137] cx23885[0]:   cmds: cdt current    : 0xffffffff
[  418.249449] cx23885[0]:   cmds: pci target lo  : 0xffffffff
[  418.255757] cx23885[0]:   cmds: pci target hi  : 0xffffffff
[  418.262055] cx23885[0]:   cmds: line / byte    : 0xffffffff
[  418.268355] cx23885[0]:   risc0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.282404] cx23885[0]:   risc1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.296471] cx23885[0]:   risc2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.310535] cx23885[0]:   risc3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.324598] cx23885[0]:   (0x00010380) iq 0: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.339828] cx23885[0]:   (0x00010384) iq 1: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.355057] cx23885[0]:   (0x00010388) iq 2: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.370287] cx23885[0]:   (0x0001038c) iq 3: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.385513] cx23885[0]:   (0x00010390) iq 4: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.400742] cx23885[0]:   (0x00010394) iq 5: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.415958] cx23885[0]:   (0x00010398) iq 6: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.431193] cx23885[0]:   (0x0001039c) iq 7: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.446424] cx23885[0]:   (0x000103a0) iq 8: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.461655] cx23885[0]:   (0x000103a4) iq 9: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.476887] cx23885[0]:   (0x000103a8) iq a: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.492118] cx23885[0]:   (0x000103ac) iq b: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.507334] cx23885[0]:   (0x000103b0) iq c: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.522570] cx23885[0]:   (0x000103b4) iq d: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.537803] cx23885[0]:   (0x000103b8) iq e: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.553034] cx23885[0]:   (0x000103bc) iq f: 0xffffffff [ INVALID sol eol irq2 irq1 23 22 21 20 19 18 cnt1 cnt0 resync 14 13 12 count=4095 ]
[  418.568287] cx23885[0]: fifo: 0x00000040 -> 0x2840
[  418.573720] cx23885[0]: ctrl: 0x00010380 -> 0x103e0
[  418.579250] cx23885[0]:   ptr1_reg: 0xffffffff
[  418.584296] cx23885[0]:   ptr2_reg: 0xffffffff
[  418.589342] cx23885[0]:   cnt1_reg: 0xffffffff
[  418.594387] cx23885[0]:   cnt2_reg: 0xffffffff
[  418.599451] BUG: unable to handle kernel paging request at fffffffffffffc98
[  418.607419] IP: [<ffffffffa073bb33>] cx23885_video_wakeup+0x33/0xc0 [cx23885]
[  418.615539] PGD 1816067 PUD 1818067 PMD 0
[  418.620355] Oops: 0002 [#1] SMP
[  418.624151] Modules linked in: cx23885(O) openvswitch gre vxlan libcrc32c xen_gntdev xen_evtchn xenfs xen_privcmd nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc xt_time iptable_filter      ip_tables x_tables ext4 crc16 mbcache jbd2 mt2060(O) rc_fusionhdtv_mce(O) ir_kbd_i2c(O) iTCO_wdt iTCO_vendor_support altera_ci(O) tda18271(O) altera_stapl(O) videobuf2_dvb(O) snd_pcm snd_timer snd soun     dcore tveeprom(O) cx2341x(O) videobuf2_dma_sg(O) videobuf2_memops(O) videobuf2_core(O) dib7000p(O) dvb_usb_dib0700(O) dib9000(O) dib7000m(O) dib0090(O) dib0070(O) dib3000mc(O) dibx000_common(O) dvb_usb(     O) coretemp dvb_core(O) v4l2_common(O) pcspkr videodev(O) rc_core(O) media(O) i2c_i801 evdev ttm drm_kms_helper drm i2c_algo_bit tpm_tis lpc_ich mfd_core tpm i2c_core ipmi_si ipmi_msghandler shpchp butt     on processor thermal_sys loop fuse autofs4 btrfs xor raid6_pq dm_mod raid1 md_mod bcache hid_generic usbhid sg hid sd_mod crc_t10dif crct10dif_generic crct10dif_common ahci libahci libata tg3 ehci_pci p     tp ehci_hcd pps_core crc32c_intel libphy scsi_mod usbcore usb_common [last unloaded: cx23885]
[  418.738157] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O  3.16-2-amd64 #1 Debian 3.16.3-2
[  418.748187] Hardware name: HP ProLiant ML110 G6/ProLiant ML110 G6, BIOS O27    12/14/2009
[  418.757438] task: ffffffff8181a460 ti: ffffffff81800000 task.ti: ffffffff81800000
[  418.765913] RIP: e030:[<ffffffffa073bb33>]  [<ffffffffa073bb33>] cx23885_video_wakeup+0x33/0xc0 [cx23885]
[  418.776780] RSP: e02b:ffff880428803de0  EFLAGS: 00010082
[  418.782799] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000181d
[  418.790857] RDX: 0000000000000001 RSI: ffff88041210e440 RDI: fffffffffffffc78
[  418.798916] RBP: ffff88041210e440 R08: 000000000000000a R09: 0000000000000000
[  418.806974] R10: 000000000000fa45 R11: ffff880428803b56 R12: fffffffffffffc60
[  418.815034] R13: ffff88041210c000 R14: 00000000ffffffff R15: 0000000000000002
[  418.823094] FS:  00007f5efcdee700(0000) GS:ffff880428800000(0000) knlGS:0000000000000000
[  418.832249] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  418.838752] CR2: fffffffffffffc98 CR3: 00000003e4dad000 CR4: 0000000000002660
[  418.846801] Stack:
[  418.849122]  00000000ffffffff ffff88041210c000 0000000000000000 00000000ffffffff
[  418.857726]  00000000ffffffff ffffffffa073ca28 ffff88041210c000 00000000ffffffff
[  418.866328]  00000000ffffffff ffffffffa073fe0b ffffffff28814240 ffffffff10000000
[  418.874926] Call Trace:
[  418.877733]  <IRQ>
[  418.879931]  [<ffffffffa073ca28>] ? cx23885_video_irq+0xa8/0x140 [cx23885]
[  418.888037]  [<ffffffffa073fe0b>] ? cx23885_irq+0x3fb/0x830 [cx23885]
[  418.895320]  [<ffffffff810b8b35>] ? handle_irq_event_percpu+0x35/0x190
[  418.902701]  [<ffffffff810b8cc8>] ? handle_irq_event+0x38/0x60
[  418.909302]  [<ffffffff810bbec3>] ? handle_fasteoi_irq+0x83/0x150
[  418.916197]  [<ffffffff810b7fd6>] ? generic_handle_irq+0x26/0x40
[  418.922993]  [<ffffffff81355dfa>] ? evtchn_fifo_handle_events+0x16a/0x170
[  418.930664]  [<ffffffff81352faf>] ? __xen_evtchn_do_upcall+0x3f/0x70
[  418.937849]  [<ffffffff81354bdf>] ? xen_evtchn_do_upcall+0x2f/0x50
[  418.944840]  [<ffffffff8150df7e>] ? xen_do_hypervisor_callback+0x1e/0x30
[  418.952412]  <EOI>
[  418.954609]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
[  418.962034]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
[  418.969123]  [<ffffffff81009d7c>] ? xen_safe_halt+0xc/0x20
[  418.975335]  [<ffffffff8101c849>] ? default_idle+0x19/0xb0
[  418.981548]  [<ffffffff810a5d70>] ? cpu_startup_entry+0x340/0x400
[  418.988442]  [<ffffffff8190305a>] ? start_kernel+0x47b/0x486
[  418.994849]  [<ffffffff81902a04>] ? set_init_arg+0x4e/0x4e
[  419.002358]  [<ffffffff81904f4d>] ? xen_start_kernel+0x569/0x573
[  419.009152] Code: 55 41 54 55 48 89 f5 53 48 8b 1e 48 39 de 74 70 8b 46 10 4c 8d a3 60 fc ff ff 41 89 d6 49 89 fd 49 8d 7c 24 18 8d 50 01 89 56 10 <89> 83 98 fc ff ff e8 f2 cd ca ff 83 3d 57 f9 01 00      01 77 4a 48
[  419.034078] RIP  [<ffffffffa073bb33>] cx23885_video_wakeup+0x33/0xc0 [cx23885]
[  419.042319]  RSP <ffff880428803de0>
[  419.046292] CR2: fffffffffffffc98
[  419.050072] ---[ end trace b2852602f91fb2da ]---
[  419.055312] Kernel panic - not syncing: Fatal exception in interrupt
[  419.062509] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

