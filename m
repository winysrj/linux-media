Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3HWKyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 06:54:50 -0400
Date: Fri, 23 Aug 2013 12:54:41 +0200 (CEST)
From: remi <remi@remis.cc>
Reply-To: remi <remi@remis.cc>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Steven Toth <stoth@kernellabs.com>
Message-ID: <1703728015.160246.1377255281074.open-xchange@email.1and1.fr>
In-Reply-To: <936351930.115960.1377088165697.open-xchange@email.1and1.fr>
References: <641271032.80124.1376921926586.open-xchange@email.1and1.fr> <52123758.4090007@iki.fi> <408826654.91086.1376994751713.open-xchange@email.1and1.fr> <1970131979.98476.1377009869066.open-xchange@email.1and1.fr> <945611328.103225.1377027103612.open-xchange@email.1and1.fr> <936351930.115960.1377088165697.open-xchange@email.1and1.fr>
Subject: Re: avermedia A306 / PCIe-minicard (laptop) / CX23885
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I resubmit with the proper keyword , sorry for the pollution .

Signed-off-by: Rémi PUTHOMME-ESSAISSI <remi@remis.cc>

Hello

I suggest this patch,

For v4l/cx23885.h
    v4l/cx23885-video.c
and v4l/cx23885-cards.c

Status,

AVerMedia A306 MiniCard Hybrid DVB-T  / 14f1:8852 (rev 02) Subsystem: 1461:c139

Is beeing regognized and loaded by the driver, by it's PCI ID ,

The correct firmwares are loaded fully notably by the Xceive 3028 .

I'm testing the mpeg side, not fully yet (firmware) .

The full dmesg output, with all relevant drivers set debug=1 , is atteched to
the email .

I do not have all the cables to test (it's a laptop ..:) )
so testing is more than welcome.

Best regards

Rémi PUTHOMME-ESSAISSI .



root@medeb:~/v4l# diff -u  media_build/v4l/cx23885-cards.c
media_build.remi/v4l/cx23885-cards.c
--- media_build/v4l/cx23885-cards.c     2012-12-28 00:04:05.000000000 +0100
+++ media_build.remi/v4l/cx23885-cards.c        2013-08-21 14:15:54.173195979
+0200
@@ -604,8 +604,39 @@
                                  CX25840_NONE0_CH3 |
                                  CX25840_NONE1_CH3,
                        .amux   = CX25840_AUDIO6,
-               } },
-       }
+               }}
+        },
+       [CX23885_BOARD_AVERMEDIA_A306] = {
+                .name           = "AVerTV Hybrid Minicard PCIe A306",
+                .tuner_type     = TUNER_XC2028,
+                .tuner_addr     = 0x61, /* 0xc2 >> 1 */
+                .tuner_bus      = 1,
+                .porta          = CX23885_ANALOG_VIDEO,
+               .portb          = CX23885_MPEG_ENCODER,
+                .input          = {{
+                        .type   = CX23885_VMUX_TELEVISION,
+                        .vmux   = CX25840_VIN2_CH1 |
+                                  CX25840_VIN5_CH2 |
+                                  CX25840_NONE0_CH3 |
+                                  CX25840_NONE1_CH3,
+                        .amux   = CX25840_AUDIO8,
+                }, {
+                        .type   = CX23885_VMUX_SVIDEO,
+                        .vmux   = CX25840_VIN8_CH1 |
+                                  CX25840_NONE_CH2 |
+                                  CX25840_VIN7_CH3 |
+                                  CX25840_SVIDEO_ON,
+                        .amux   = CX25840_AUDIO6,
+                }, {
+                        .type   = CX23885_VMUX_COMPONENT,
+                        .vmux   = CX25840_VIN1_CH1 |
+                                  CX25840_NONE_CH2 |
+                                  CX25840_NONE0_CH3 |
+                                  CX25840_NONE1_CH3,
+                        .amux   = CX25840_AUDIO6,
+                }},
+
+       }       
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -841,7 +872,12 @@
                .subvendor = 0x1461,
                .subdevice = 0xd939,
                .card      = CX23885_BOARD_AVERMEDIA_HC81R,
-       },
+       }, {
+                .subvendor = 0x1461,
+                .subdevice = 0xc139,
+                .card      = CX23885_BOARD_AVERMEDIA_A306,
+        },
+       
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
 
@@ -1069,6 +1105,10 @@
                /* XC3028L Reset Command */
                bitmask = 1 << 2;
                break;
+       case CX23885_BOARD_AVERMEDIA_A306:
+                /* XC3028L Reset Command */
+                bitmask = 1 << 2;
+                break;
        }
 
        if (bitmask) {
@@ -1394,6 +1434,34 @@
                cx_set(GP0_IO, 0x00040004);
                mdelay(60);
                break;
+        case CX23885_BOARD_AVERMEDIA_A306:
+                cx_clear(MC417_CTL, 1);
+                /* GPIO-0,1,2 setup direction as output */
+                cx_set(GP0_IO, 0x00070000);
+                mdelay(10);
+                /* AF9013 demod reset */
+                cx_set(GP0_IO, 0x00010001);
+                mdelay(10);
+                cx_clear(GP0_IO, 0x00010001);
+                mdelay(10);
+                cx_set(GP0_IO, 0x00010001);
+                mdelay(10);
+                /* demod tune? */
+                cx_clear(GP0_IO, 0x00030003);
+                mdelay(10);
+                cx_set(GP0_IO, 0x00020002);
+                mdelay(10);
+                cx_set(GP0_IO, 0x00010001);
+                mdelay(10);
+                cx_clear(GP0_IO, 0x00020002);
+                /* XC3028L tuner reset */
+                cx_set(GP0_IO, 0x00040004);
+                cx_clear(GP0_IO, 0x00040004);
+                cx_set(GP0_IO, 0x00040004);
+                mdelay(60);
+                break;
+
+
        }
 }
 
@@ -1623,6 +1691,21 @@
                ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
                ts2->src_sel_val     = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
                break;
+
+        case CX23885_BOARD_AVERMEDIA_A306:
+                /* Defaults for VID B */
+                ts1->gen_ctrl_val  = 0x4; /* Parallel */
+                ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+                ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+                /* Defaults for VID C */
+                /* DREQ_POL, SMODE, PUNC_CLK, MCLK_POL Serial bus + punc clk */
+                ts2->gen_ctrl_val  = 0x10e;
+                ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+                ts2->src_sel_val     = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+                break;
+
+
+
        case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
        case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
                ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
@@ -1758,6 +1841,18 @@
                        v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
                }
                break;
+
+        case CX23885_BOARD_AVERMEDIA_A306:
+                dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
+                                &dev->i2c_bus[2].i2c_adap,
+                                "cx25840", 0x88 >> 1, NULL);
+                if (dev->sd_cx25840) {
+                        dev->sd_cx25840->grp_id = CX23885_HW_AV_CORE;
+                        v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
+                }
+                break;
+
+
        }
 
        /* AUX-PLL 27MHz CLK */
root@medeb:~/v4l# diff -u  media_build/v4l/cx23885-video.c
media_build.remi/v4l/cx23885-video.c
--- media_build/v4l/cx23885-video.c     2013-08-02 05:45:59.000000000 +0200
+++ media_build.remi/v4l/cx23885-video.c        2013-08-21 13:55:20.017625046
+0200
@@ -511,7 +511,8 @@
                (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
                (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
                (dev->board == CX23885_BOARD_MYGICA_X8507) ||
-               (dev->board == CX23885_BOARD_AVERMEDIA_HC81R)) {
+               (dev->board == CX23885_BOARD_AVERMEDIA_HC81R)||
+               (dev->board == CX23885_BOARD_AVERMEDIA_A306)) {
                /* Configure audio routing */
                v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
                        INPUT(input)->amux, 0, 0);
@@ -1888,6 +1889,20 @@
                                };
                                v4l2_subdev_call(sd, tuner, s_config, &cfg);
                        }
+                       if (dev->board == CX23885_BOARD_AVERMEDIA_A306) {
+                                struct xc2028_ctrl ctrl = {
+                                     /* .fname = "xc3028L-v36.fw", */
+                                       .fname = "xc3028-v27.fw",
+                                        .max_len = 64
+                                };
+                                struct v4l2_priv_tun_config cfg = {
+                                        .tuner = dev->tuner_type,
+                                        .priv = &ctrl
+                                };
+                                v4l2_subdev_call(sd, tuner, s_config, &cfg);
+                        }
+
+
                }
        }
 
root@medeb:~/v4l# diff -u  media_build/v4l/cx23885.h
media_build.remi/v4l/cx23885.h
--- media_build/v4l/cx23885.h   2013-03-25 05:45:50.000000000 +0100
+++ media_build.remi/v4l/cx23885.h      2013-08-21 13:55:20.010625134 +0200
@@ -93,6 +93,7 @@
 #define CX23885_BOARD_PROF_8000                37
 #define CX23885_BOARD_HAUPPAUGE_HVR4400        38
 #define CX23885_BOARD_AVERMEDIA_HC81R          39
+#define CX23885_BOARD_AVERMEDIA_A306           40
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
root@medeb:~/v4l#




> Le 20 août 2013 à 21:31, remi <remi@remis.cc> a écrit :
>
>
> Hello
>
> Seeing that card=39 worked, and, that the A306 doesnt use the LowPower version
> of the XC3028 , HC81 is an expressCard == lowpower
>
> A306 is the PCIe minicard version == not LowPower ,
>
>
> I decided to clone the HC81 entries in cx23885-video.c, cx23885.h ,
> cx23885-cards.c
>
> And intruct it to load then the xc3028-v27.fw instead,
>
> Seems to me alot better , see below ,
>
> And I added so, the card=40 in the definitions ...
>
> I dont think submiting a patch for this woth it yet ...
>
> as none of the tuners get "created" ,
>
> For the analog video composite/s-video, i'll be able to test it when i find
> the
> right cable .
>
>
>
> root@medeb:~/v4l/media_build/v4l# grep A306 *
> cx23885-cards.c:        [CX23885_BOARD_AVERMEDIA_A306] = {
> cx23885-cards.c:                .name           = "AVerTV Hybrid Minicard PCIe
> A306",
> cx23885-cards.c:                .card      = CX23885_BOARD_AVERMEDIA_A306,
> cx23885-cards.c:        case CX23885_BOARD_AVERMEDIA_A306:
> cx23885-cards.c:        case CX23885_BOARD_AVERMEDIA_A306:
> cx23885-cards.c:        case CX23885_BOARD_AVERMEDIA_A306:
> cx23885-cards.c:        case CX23885_BOARD_AVERMEDIA_A306:
> cx23885.h:#define CX23885_BOARD_AVERMEDIA_A306          40
> cx23885-video.c:                (dev->board == CX23885_BOARD_AVERMEDIA_A306))
> {
> cx23885-video.c:                        if (dev->board ==
> CX23885_BOARD_AVERMEDIA_A306) {
>
>
>
>
>                         if (dev->board == CX23885_BOARD_AVERMEDIA_HC81R) {
>                                 struct xc2028_ctrl ctrl = {
>                                         .fname = "xc3028L-v36.fw",
>                                         .max_len = 64
>                                 };
>                                 struct v4l2_priv_tun_config cfg = {
>                                         .tuner = dev->tuner_type,
>                                         .priv = &ctrl
>                                 };
>                                 v4l2_subdev_call(sd, tuner, s_config, &cfg);
>                         }
>                         if (dev->board == CX23885_BOARD_AVERMEDIA_A306) {
>                                 struct xc2028_ctrl ctrl = {
>                                      /* .fname = "xc3028L-v36.fw", */
>                                         .fname = "xc3028-v27.fw",
>                                         .max_len = 64
>                                 };
>                                 struct v4l2_priv_tun_config cfg = {
>                                         .tuner = dev->tuner_type,
>                                         .priv = &ctrl
>                                 };
>                                 v4l2_subdev_call(sd, tuner, s_config, &cfg);
>                         }
>
>
>
> [32653.087693] cx23885 driver version 0.0.3 loaded
> [32653.088091] CORE cx23885[0]: subsystem: 1461:c139, board: AVerTV Hybrid
> Minicard PCIe A306 [card=40,autodetected]
> [32653.318339] cx23885[0]: scan bus 0:
> [32653.329792] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
> [32653.336716] cx23885[0]: scan bus 1:
> [32653.350543] cx23885[0]: i2c scan: found device @ 0xc2
> [tuner/mt2131/tda8275/xc5000/xc3028]
> [32653.355042] cx23885[0]: scan bus 2:
> [32653.357050] cx23885[0]: i2c scan: found device @ 0x66  [???]
> [32653.357699] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
> [32653.358011] cx23885[0]: i2c scan: found device @ 0x98  [flatiron]
> [32653.391211] cx25840 3-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
> [32654.031992] cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382
> bytes)
> [32654.049675] tuner 2-0061: Tuner -1 found with type(s) Radio TV.
> [32654.051827] xc2028: Xcv2028/3028 init called!
> [32654.051830] xc2028 2-0061: creating new instance
> [32654.051832] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> [32654.051834] xc2028 2-0061: xc2028_set_config called
> [32654.051963] cx23885[0]: registered device video0 [v4l2]
> [32654.052165] cx23885[0]: registered device vbi0
> [32654.052329] cx23885[0]: registered ALSA audio device
> [32654.052593] xc2028 2-0061: request_firmware_nowait(): OK
> [32654.052596] xc2028 2-0061: load_all_firmwares called
> [32654.052598] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw,
> type: xc2028 firmware, ver 2.7
> [32654.052606] xc2028 2-0061: Reading firmware type BASE F8MHZ (3), id 0,
> size=8718.
> [32654.052614] xc2028 2-0061: Reading firmware type BASE F8MHZ MTS (7), id 0,
> size=8712.
> [32654.052623] xc2028 2-0061: Reading firmware type BASE FM (401), id 0,
> size=8562.
> [32654.052631] xc2028 2-0061: Reading firmware type BASE FM INPUT1 (c01), id
> 0,
> size=8576.
> [32654.052640] xc2028 2-0061: Reading firmware type BASE (1), id 0, size=8706.
> [32654.052647] xc2028 2-0061: Reading firmware type BASE MTS (5), id 0,
> size=8682.
> [32654.052652] xc2028 2-0061: Reading firmware type (0), id 100000007,
> size=161.
> [32654.052654] xc2028 2-0061: Reading firmware type MTS (4), id 100000007,
> size=169.
> [32654.052657] xc2028 2-0061: Reading firmware type (0), id 200000007,
> size=161.
> [32654.052659] xc2028 2-0061: Reading firmware type MTS (4), id 200000007,
> size=169.
> [32654.052661] xc2028 2-0061: Reading firmware type (0), id 400000007,
> size=161.
> [32654.052663] xc2028 2-0061: Reading firmware type MTS (4), id 400000007,
> size=169.
> [32654.052666] xc2028 2-0061: Reading firmware type (0), id 800000007,
> size=161.
> [32654.052668] xc2028 2-0061: Reading firmware type MTS (4), id 800000007,
> size=169.
> [32654.052670] xc2028 2-0061: Reading firmware type (0), id 3000000e0,
> size=161.
> [32654.052672] xc2028 2-0061: Reading firmware type MTS (4), id 3000000e0,
> size=169.
> [32654.052675] xc2028 2-0061: Reading firmware type (0), id c000000e0,
> size=161.
> [32654.052677] xc2028 2-0061: Reading firmware type MTS (4), id c000000e0,
> size=169.
> [32654.052679] xc2028 2-0061: Reading firmware type (0), id 200000, size=161.
> [32654.052681] xc2028 2-0061: Reading firmware type MTS (4), id 200000,
> size=169.
> [32654.052684] xc2028 2-0061: Reading firmware type (0), id 4000000, size=161.
> [32654.052686] xc2028 2-0061: Reading firmware type MTS (4), id 4000000,
> size=169.
> [32654.052688] xc2028 2-0061: Reading firmware type D2633 DTV6 ATSC (10030),
> id
> 0, size=149.
> [32654.052691] xc2028 2-0061: Reading firmware type D2620 DTV6 QAM (68), id 0,
> size=149.
> [32654.052694] xc2028 2-0061: Reading firmware type D2633 DTV6 QAM (70), id 0,
> size=149.
> [32654.052698] xc2028 2-0061: Reading firmware type D2620 DTV7 (88), id 0,
> size=149.
> [32654.052700] xc2028 2-0061: Reading firmware type D2633 DTV7 (90), id 0,
> size=149.
> [32654.052703] xc2028 2-0061: Reading firmware type D2620 DTV78 (108), id 0,
> size=149.
> [32654.052706] xc2028 2-0061: Reading firmware type D2633 DTV78 (110), id 0,
> size=149.
> [32654.052708] xc2028 2-0061: Reading firmware type D2620 DTV8 (208), id 0,
> size=149.
> [32654.052711] xc2028 2-0061: Reading firmware type D2633 DTV8 (210), id 0,
> size=149.
> [32654.052714] xc2028 2-0061: Reading firmware type FM (400), id 0, size=135.
> [32654.052716] xc2028 2-0061: Reading firmware type (0), id 10, size=161.
> [32654.052718] xc2028 2-0061: Reading firmware type MTS (4), id 10, size=169.
> [32654.052721] xc2028 2-0061: Reading firmware type (0), id 1000400000,
> size=169.
> [32654.052723] xc2028 2-0061: Reading firmware type (0), id c00400000,
> size=161.
> [32654.052725] xc2028 2-0061: Reading firmware type (0), id 800000, size=161.
> [32654.052727] xc2028 2-0061: Reading firmware type (0), id 8000, size=161.
> [32654.052729] xc2028 2-0061: Reading firmware type LCD (1000), id 8000,
> size=161.
> [32654.052732] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id 8000,
> size=161.
> [32654.052734] xc2028 2-0061: Reading firmware type MTS (4), id 8000,
> size=169.
> [32654.052737] xc2028 2-0061: Reading firmware type (0), id b700, size=161.
> [32654.052739] xc2028 2-0061: Reading firmware type LCD (1000), id b700,
> size=161.
> [32654.052741] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id b700,
> size=161.
> [32654.052744] xc2028 2-0061: Reading firmware type (0), id 2000, size=161.
> [32654.052745] xc2028 2-0061: Reading firmware type MTS (4), id b700,
> size=169.
> [32654.052748] xc2028 2-0061: Reading firmware type MTS LCD (1004), id b700,
> size=169.
> [32654.052750] xc2028 2-0061: Reading firmware type MTS LCD NOGD (3004), id
> b700, size=169.
> [32654.052753] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3280
> (60000000), id 0, size=192.
> [32654.052756] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3300
> (60000000), id 0, size=192.
> [32654.052759] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3440
> (60000000), id 0, size=192.
> [32654.052762] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3460
> (60000000), id 0, size=192.
> [32654.052765] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN36 SCODE
> HAS_IF_3800 (60210020), id 0, size=192.
> [32654.052768] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4000
> (60000000), id 0, size=192.
> [32654.052771] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE
> HAS_IF_4080 (60410020), id 0, size=192.
> [32654.052775] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4200
> (60000000), id 0, size=192.
> [32654.052778] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_4320
> (60008000), id 8000, size=192.
> [32654.052781] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4450
> (60000000), id 0, size=192.
> [32654.052783] xc2028 2-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE
> HAS_IF_4500 (6002b004), id b700, size=192.
> [32654.052788] xc2028 2-0061: Reading firmware type LCD NOGD IF SCODE
> HAS_IF_4600 (60023000), id 8000, size=192.
> [32654.052792] xc2028 2-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8
> ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
> [32654.052796] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4940
> (60000000), id 0, size=192.
> [32654.052799] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5260
> (60000000), id 0, size=192.
> [32654.052802] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_5320
> (60008000), id f00000007, size=192.
> [32654.052805] xc2028 2-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52
> CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
> [32654.052809] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN538 SCODE
> HAS_IF_5580 (60110020), id 0, size=192.
> [32654.052813] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5640
> (60000000), id 300000007, size=192.
> [32654.052816] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5740
> (60000000), id c00000007, size=192.
> [32654.052819] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5900
> (60000000), id 0, size=192.
> [32654.052822] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6000
> (60008000), id c04c000f0, size=192.
> [32654.052825] xc2028 2-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ
> SCODE HAS_IF_6200 (68050060), id 0, size=192.
> [32654.052829] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6240
> (60000000), id 10, size=192.
> [32654.052834] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6320
> (60008000), id 200000, size=192.
> [32654.052837] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6340
> (60000000), id 200000, size=192.
> [32654.052840] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6500
> (60008000), id c044000e0, size=192.
> [32654.052843] xc2028 2-0061: Reading firmware type DTV6 ATSC ATI638 SCODE
> HAS_IF_6580 (60090020), id 0, size=192.
> [32654.052847] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6600
> (60000000), id 3000000e0, size=192.
> [32654.052850] xc2028 2-0061: Reading firmware type MONO SCODE HAS_IF_6680
> (60008000), id 3000000e0, size=192.
> [32654.052853] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE
> HAS_IF_8140 (60810020), id 0, size=192.
> [32654.052857] xc2028 2-0061: Reading firmware type SCODE HAS_IF_8200
> (60000000), id 0, size=192.
> [32654.052860] xc2028 2-0061: Firmware files loaded.
> [32654.057869] xc2028 2-0061: xc2028_set_analog_freq called
> [32654.057872] xc2028 2-0061: generic_set_freq called
> [32654.057874] xc2028 2-0061: should set frequency 400000 kHz
> [32654.057876] xc2028 2-0061: check_firmware called
> [32654.057877] xc2028 2-0061: checking firmware, user requested type=(0), id
> 0000000c00001000, scode_tbl (0), scode_nr 0
> [32654.257895] xc2028 2-0061: load_firmware called
> [32654.257898] xc2028 2-0061: seek_firmware called, want type=BASE (1), id
> 0000000000000000.
> [32654.257900] xc2028 2-0061: Found firmware for type=BASE (1), id
> 0000000000000000.
> [32654.257902] xc2028 2-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [32655.425394] xc2028 2-0061: Load init1 firmware, if exists
> [32655.425399] xc2028 2-0061: load_firmware called
> [32655.425402] xc2028 2-0061: seek_firmware called, want type=BASE INIT1
> (4001),
> id 0000000000000000.
> [32655.425407] xc2028 2-0061: Can't find firmware for type=BASE INIT1 (4001),
> id
> 0000000000000000.
> [32655.425412] xc2028 2-0061: load_firmware called
> [32655.425414] xc2028 2-0061: seek_firmware called, want type=BASE INIT1
> (4001),
> id 0000000000000000.
> [32655.425418] xc2028 2-0061: Can't find firmware for type=BASE INIT1 (4001),
> id
> 0000000000000000.
> [32655.425423] xc2028 2-0061: load_firmware called
> [32655.425425] xc2028 2-0061: seek_firmware called, want type=(0), id
> 0000000c00001000.
> [32655.425429] xc2028 2-0061: Selecting best matching firmware (2 bits) for
> type=(0), id 0000000c00001000:
> [32655.425432] xc2028 2-0061: Found firmware for type=(0), id
> 0000000c000000e0.
> [32655.425435] xc2028 2-0061: Loading firmware for type=(0), id
> 0000000c000000e0.
> [32655.440874] xc2028 2-0061: Trying to load scode 0
> [32655.440875] xc2028 2-0061: load_scode called
> [32655.440877] xc2028 2-0061: seek_firmware called, want type=SCODE
> (20000000),
> id 0000000c000000e0.
> [32655.440879] xc2028 2-0061: Found firmware for type=SCODE (20000000), id
> 0000000c04c000f0.
> [32655.440881] xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_6000
> (60008000), id 0000000c04c000f0.
> [32655.443192] xc2028 2-0061: xc2028_get_reg 0004 called
> [32655.443855] xc2028 2-0061: xc2028_get_reg 0008 called
> [32655.444521] xc2028 2-0061: Device is Xceive 3028 version 1.0, firmware
> version 2.7
> [32655.557141] xc2028 2-0061: divisor= 00 00 64 00 (freq=400.000)
> [32655.580856] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [32655.580862] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 18, latency:
> 0,
> mmio: 0xd3000000
> root@medeb:~/v4l/media_build#
>
>
>
> Best regards
>
> Rémi .
>
>
>> Le 20 août 2013 à 16:44, remi <remi@remis.cc> a écrit :
>>
>>
>> Hello
>>
>> FYI
>>
>> I digged into the firmware problem a little,
>>
>>
>> xc3028L-v36.fw  gets loaded by default , and the errors are as you saw
>> earlier
>>
>>
>> forcing the /lib/firmware/xc3028-v27.fw :
>>
>> [ 3569.941404] xc2028 2-0061: Could not load firmware
>> /lib/firmware/xc3028-v27.fw
>>
>>
>> So i searched the original dell/windows driver :
>>
>>
>> I have these files in there :
>>
>> root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070# ls -lR
>> .:
>> total 5468
>> drwxr-xr-x 2 gpunk gpunk    4096 août  20 13:24 Driver_X86
>> -rwxr-xr-x 1 gpunk gpunk 5589827 sept. 12  2007 Setup.exe
>> -rw-r--r-- 1 gpunk gpunk     197 oct.   9  2007 setup.iss
>>
>> ./Driver_X86:
>> total 1448
>> -rw-r--r-- 1 gpunk gpunk 114338 sept.  7  2007 A885VCap_ASUS_DELL_2.inf
>> -rw-r--r-- 1 gpunk gpunk  15850 sept. 11  2007 a885vcap.cat
>> -rw-r--r-- 1 gpunk gpunk 733824 sept.  7  2007 A885VCap.sys
>> -rw-r--r-- 1 gpunk gpunk 147870 avril 20  2007 cpnotify.ax
>> -rw-r--r-- 1 gpunk gpunk 376836 avril 20  2007 cx416enc.rom
>> -rw-r--r-- 1 gpunk gpunk  65536 avril 20  2007 cxtvrate.dll
>> -rw-r--r-- 1 gpunk gpunk  16382 avril 20  2007 merlinC.rom
>> root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070#
>>
>> root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86# grep
>> firmware *
>> Fichier binaire A885VCap.sys concordant
>> root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86#
>>
>>
>>
>> I'll try to find a way to extract "maybe" the right firmware for what this
>> card
>> ,
>>
>> I'd love some help
>>
>> Good news there are ALOT of infos on how to initialize the card in the .INF
>> ,
>> so
>>
>> many problems, i think, are partially solved (I need to implement them )
>>
>> I'll send a copy of theses to anyone who wishes,
>>
>> Or see
>> http://www.dell.com/support/drivers/us/en/04/DriverDetails?driverId=R169070
>> 
>> 
>>  :)
>>
>> Regards
>>
>> Rémi
>>
>>
>>
>>
>>
>>> Le 20 août 2013 à 12:32, remi <remi@remis.cc> a écrit :
>>>
>>>
>>> Hello
>>>
>>> I have just putdown my screwdrivers
>>>
>>>
>>> Yes it was three ICs
>>>
>>>
>>> on the bottom-side , no heatsinks (digital reception, that's why i guess)
>>> ,
>>> is
>>> an AF9013-N1
>>>
>>> on the top-side, with a heatsink : CX23885-13Z , PCIe A/V controler
>>>
>>> on the top-side, with heat-sink + "radio-isolation" (aluminum box)
>>> XC3028ACQ
>>> ,
>>> so the analog reception .
>>>
>>> 
>>> Its all on a PCIe bus, the reason why i baught it ...
>>>
>>>
>>>
>>> To resume :
>>>
>>>
>>> AF9013-N1
>>>
>>> CX23885-13Z
>>>
>>> XC3028ACQ
>>>
>>>
>>> the drivers while scanning
>>>
>>>
>>> gpunk@medeb:~/Bureau$ dmesg |grep i2c
>>> [    2.363784] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
>>> [    2.384721] cx23885[0]: i2c scan: found device @ 0xc2
>>> [tuner/mt2131/tda8275/xc5000/xc3028]
>>> [    2.391502] cx23885[0]: i2c scan: found device @ 0x66  [???]
>>> [    2.392339] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
>>> [    2.392831] cx23885[0]: i2c scan: found device @ 0x98  [flatiron]
>>> [    5.306751] i2c /dev entries driver
>>> gpunk@medeb:~/Bureau$
>>>
>>>
>>>  4.560428] xc2028 2-0061: xc2028_get_reg 0008 called
>>> [    4.560989] xc2028 2-0061: Device is Xceive 0 version 0.0, firmware
>>> version
>>> 0.0
>>> [    4.560990] xc2028 2-0061: Incorrect readback of firmware version.
>>> [ *    4.561184] xc2028 2-0061: Read invalid device hardware information -
>>> tuner
>>> hung?
>>> [ *    4.561386] xc2028 2-0061: 0.0      0.0
>>> [ *    4.674072] xc2028 2-0061: divisor= 00 00 64 00 (freq=400.000)
>>> [    4.697830] cx23885_dev_checkrevision() Hardware revision = 0xb0
>>> [    4.698029] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 18,
>>> latency:
>>> 0,
>>> mmio: 0xd3000000
>>>
>>> * --> I bypassed the "goto fail" to start debugging a little bit the
>>> tuner-xc2028.c/ko ... lines 869
>>> ...
>>>
>>>
>>>
>>> The firmware doesnt get all loaded .
>>> gpunk@medeb:~/Bureau$  uname -a
>>> Linux medeb 3.11.0-rc6remi #1 SMP PREEMPT Mon Aug 19 13:30:04 CEST 2013
>>> i686
>>> GNU/Linux
>>> gpunk@medeb:~/Bureau$
>>>
>>>
>>> With yesterday's tarball from linuxtv.org / media-build git .
>>>
>>>
>>>
>>> Best regards
>>>
>>> Rémi
>>>
>>>
>>>
>>>
>>>> Le 19 août 2013 à 17:18, Antti Palosaari <crope@iki.fi> a écrit :
>>>>
>>>>
>>>> On 08/19/2013 05:18 PM, remi wrote:
>>>>> Hello
>>>>>
>>>>> I have this card since months,
>>>>>
>>>>> http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=376&SI=true
>>>>>
>>>>> I have finally retested it with the cx23885 driver : card=39
>>>>>
>>>>>
>>>>>
>>>>> If I could do anything to identify : [    2.414734] cx23885[0]: i2c
>>>>> scan:
>>>>> found
>>>>> device @ 0x66  [???]
>>>>>
>>>>> Or "hookup" the xc5000 etc
>>>>>
>>>>> I'll be more than glad .
>>>>>
>>>>
>>>>
>>>>>
>>>>> ps: i opened it up a while ago,i saw an af9013 chip ? dvb-tuner looks
>>>>> like
>>>>> maybe the "device @ 0x66 i2c"
>>>>>
>>>>> I will double check , and re-write-down all the chips , i think 3 .
>>>>
>>>> You have to identify all the chips, for DVB-T there is tuner missing.
>>>>
>>>> USB-interface: cx23885
>>>> DVB-T demodulator: AF9013
>>>> RF-tuner: ?
>>>>
>>>> If there is existing driver for used RF-tuner it comes nice hacking
>>>> project for some newcomer.
>>>>
>>>> It is just tweaking and hacking to find out all settings. AF9013 driver
>>>> also needs likely some changes, currently it is used only for devices
>>>> having AF9015 with integrated AF9013, or AF9015 dual devices having
>>>> AF9015 + external AF9013 providing second tuner.
>>>>
>>>> I have bought quite similar AverMedia A301 ages back as I was looking
>>>> for that AF9013 model, but maybe I have bought just wrong one...
>>>>
>>>>
>>>> regards
>>>> Antti
>>>>
>>>>
>>>> --
>>>> http://palosaari.fi/
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
