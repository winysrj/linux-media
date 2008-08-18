Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7IEo8KL030450
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 10:50:09 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7IEnvF2006377
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 10:49:58 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1159219nfc.21
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 07:49:57 -0700 (PDT)
Message-ID: <1bdf54290808180749x183371cfl490374cc969e289b@mail.gmail.com>
Date: Mon, 18 Aug 2008 11:49:57 -0300
From: "Piero B. Contezini" <piero@contezini.net>
To: video4linux-list@redhat.com
In-Reply-To: <1bdf54290808152156x35b46460lbc7889d2b1a6c20f@mail.gmail.com>
MIME-Version: 1.0
References: <1bdf54290808152156x35b46460lbc7889d2b1a6c20f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Geovision GV-800v2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

I'm trying to make this board work on Linux.
I've just bought this one used so i don't actually know too much about it.

The kernel has been patched and i've created a new entry on the bbtv_cards
array to match this board as it follows:

        { 0xc84e32da, BTTV_BOARD_GEOVISION_GV800V2,     "GeoVision GV-800v2"
},
        { 0xc84e32db, BTTV_BOARD_GEOVISION_GV800V2,     "GeoVision GV-800v2"
},
        { 0xc84e32dc, BTTV_BOARD_GEOVISION_GV800V2,     "GeoVision GV-800v2"
},
        { 0xc84e32dd, BTTV_BOARD_GEOVISION_GV800V2,     "GeoVision GV-800v2"
},

These are the 4 PCI id's that this board is registering thru my system, i've
created this entries to match it and redirect to this array field:

        [BTTV_BOARD_GEOVISION_GV800V2] = {
                /* Piero B. Contezini <piero@contezini.net> */
                .name             = "Geovision GV-800v2",
                .video_inputs     = 4,
                .audio_inputs     = 0,
                .tuner            = UNSET,
                .svhs             = UNSET,
                .gpiomask         = 0x0,
                .muxsel           = { 2, 2, 2, 2, 2, 2, 2, 2,
                                      2, 2, 2, 2, 2, 2, 2, 2 },
                .muxsel_hook      = geovision_muxsel,
                .gpiomux          = { 0 },
                .no_msp34xx       = 1,
                .pll              = PLL_28,
                .tuner_type       = UNSET,
                .tuner_addr       = ADDR_UNSET,
                .radio_addr       = ADDR_UNSET,
        },

However i don't know exactly the purpose of each of these fields, i'm sure
it is 4 outputs for each device because my board has 16 outputs, and i'm
sure it has some audio input too but no idea how map it thru.

It has been sucessifully loaded and when I call xawtv the kernel returns
some weird things like:

bttv0: PLL: 28636363 => 35468950 .. ok
bttv0: PLL can sleep, using XTAL (28636363).
bttv0: PLL: 28636363 => 35468950 .. ok
bttv0: PLL can sleep, using XTAL (28636363).
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: SCERR @ 1f200000,bits: HSYNC SCERR*
bttv0: timeout: drop=0 irq=14486/14587, risc=1f1fc01c, bits: HSYNC

When I load the module dmesg shows:

ttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:03:00.0, irq: 21, latency: 32, mmio:
0xf45fe000
bttv0: detected: GeoVision GV-800v2 [card=152], PCI subsystem ID is
32da:c84e
bttv0: using: Geovision GV-800v2 [card=152,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ff08ff [init]
bttv0: tuner absent
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
bttv: Bt8xx card found (1).
bttv1: Bt878 (rev 17) at 0000:03:04.0, irq: 21, latency: 32, mmio:
0xf45fc000
bttv1: detected: GeoVision GV-800v2 [card=152], PCI subsystem ID is
32db:c84e
bttv1: using: Geovision GV-800v2 [card=152,autodetected]
bttv1: gpio: en=00000000, out=00000000 in=00ff7cff [init]
bttv1: tuner absent
bttv1: registered device video1
bttv1: registered device vbi1
bttv1: PLL: 28636363 => 35468950 .. ok
bttv: Bt8xx card found (2).
bttv2: Bt878 (rev 17) at 0000:03:08.0, irq: 21, latency: 32, mmio:
0xf45fa000
bttv2: detected: GeoVision GV-800v2 [card=152], PCI subsystem ID is
32dc:c84e
bttv2: using: Geovision GV-800v2 [card=152,autodetected]
bttv2: gpio: en=00000000, out=00000000 in=00ffbcff [init]
bttv2: tuner absent
bttv2: registered device video2
bttv2: registered device vbi2
bttv2: PLL: 28636363 => 35468950 .. ok
bttv: Bt8xx card found (3).
bttv3: Bt878 (rev 17) at 0000:03:0c.0, irq: 21, latency: 32, mmio:
0xf45f8000
bttv3: detected: GeoVision GV-800v2 [card=152], PCI subsystem ID is
32dd:c84e
bttv3: using: Geovision GV-800v2 [card=152,autodetected]
bttv3: gpio: en=00000000, out=00000000 in=00fffcff [init]
bttv3: tuner absent
bttv3: registered device video3
bttv3: registered device vbi3
bttv3: PLL: 28636363 => 35468950 .. ok

My next step is install a windows with all the geovision drivers and try to
get this GPIO mask but i'm not sure if it will help me anyway.

Someone could possibly guide me thru this problem to make this work ?

Thanks

Piero
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
