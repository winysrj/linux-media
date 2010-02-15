Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0BOXXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 18:23:01 -0500
Date: Mon, 15 Feb 2010 18:22:53 -0500
From: Ralph Siemsen <ralphs@netwinder.org>
To: Michael <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: cx23885
Message-ID: <20100215232253.GA17950@harvey.netwinder.org>
References: <1266238446.3075.13.camel@palomino.walls.org>
 <hlbhck$uh9$1@ger.gmane.org>
 <4B795D1A.9040502@kernellabs.com>
 <hlbopr$v7s$1@ger.gmane.org>
 <4B79803B.4070302@kernellabs.com>
 <hlcbhu$4s3$1@ger.gmane.org>
 <4B79B437.5000004@kernellabs.com>
 <hlch5h$ogp$1@ger.gmane.org>
 <hlciur$tb0$1@ger.gmane.org>
 <hlcjfi$unq$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <hlcjfi$unq$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 15, 2010 at 11:56:52PM +0100, Michael wrote:
> 
> If anybody can give me a hint, what to include in a patch and what was old 
> stuff that has jsut changed in 2.6.31, I'd be grateful.

Their source tree contains a .hg_archival.txt file which looks like
it can be used to identify the original v4l-dvb tree they used.

Attached is a diff from that v4l version to the MPX-885 tree.
 cx23885/cx23885-cards.c    |   90 ++++++++++++++++
 cx23885/cx23885-dvb.c      |   30 +++++
 cx23885/cx23885-video.c    |    2 
 cx23885/cx23885.h          |    1 
 cx25840/cx25840-core.c     |  248 +++++++++++++++++++++++++++++++++++++++------
 cx25840/cx25840-firmware.c |    4 
 6 files changed, 338 insertions(+), 37 deletions(-)

Hope it helps...
-R


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="MPX-885.patch"

diff -uNr v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c	2010-02-15 18:19:26.000000000 -0500
+++ MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c	2009-11-11 09:36:16.000000000 -0500
@@ -216,6 +216,29 @@
 		.name		= "Compro VideoMate E800",
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_MPX885] = {
+	    .name       = "MPX-885",
+        .porta      = CX23885_ANALOG_VIDEO,
+        .portb      = CX23885_MPEG_ENCODER,
+        .portc      = CX23885_MPEG_DVB,
+        .input          = {{
+            .type   = CX23885_VMUX_COMPOSITE1,
+            .vmux   = CX25840_VIN1_CH1,
+            .gpio0  = 0,
+        }, {
+            .type   = CX23885_VMUX_COMPOSITE2,
+            .vmux   = CX25840_VIN2_CH1,
+            .gpio0  = 0,
+        }, {
+            .type   = CX23885_VMUX_COMPOSITE3,
+            .vmux   = CX25840_VIN3_CH1,
+            .gpio0  = 0,
+        }, {
+            .type   = CX23885_VMUX_COMPOSITE4,
+            .vmux   = CX25840_VIN4_CH1,
+            .gpio0  = 0,
+        } },
+    },
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -351,7 +374,11 @@
 		.subvendor = 0x1858,
 		.subdevice = 0xe800,
 		.card      = CX23885_BOARD_COMPRO_VIDEOMATE_E800,
-	},
+	}, {
+	    .subvendor = 0x0,
+        .subdevice = 0x0,
+        .card      = CX23885_BOARD_MPX885,
+    },
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
 
@@ -798,6 +825,37 @@
 		/* CX24228 GPIO */
 		/* Connected to IF / Mux */
 		break;
+    case CX23885_BOARD_MPX885:
+		/* GPIO-0 656_CLK */
+		/* GPIO-1 656_D0 */
+		/* GPIO-2 8295A Reset */
+		/* GPIO-3-10 cx23417 data0-7 */
+		/* GPIO-11-14 cx23417 addr0-3 */
+		/* GPIO-15-18 cx23417 READY, CS, RD, WR */
+		/* GPIO-19 IR_RX */
+
+		/* CX23417 GPIO's */
+		/* EIO15 Zilog Reset */
+		/* EIO14 S5H1409/CX24227 Reset */
+		mc417_gpio_enable(dev, GPIO_15 | GPIO_14, 1);
+
+		/* Put the demod into reset and protect the eeprom */
+		mc417_gpio_clear(dev, GPIO_15 | GPIO_14);
+		mdelay(100);
+
+		/* Bring the demod and blaster out of reset */
+		mc417_gpio_set(dev, GPIO_15 | GPIO_14);
+		mdelay(100);
+
+		/* Force the TDA8295A into reset and back */
+		cx23885_gpio_enable(dev, GPIO_2, 1);
+		cx23885_gpio_set(dev, GPIO_2);
+		mdelay(20);
+		cx23885_gpio_clear(dev, GPIO_2);
+		mdelay(20);
+		cx23885_gpio_set(dev, GPIO_2);
+		mdelay(20);
+		break;
 	}
 }
 
@@ -827,6 +885,8 @@
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		request_module("ir-kbd-i2c");
 		break;
+    case CX23885_BOARD_MPX885:
+        break;
 	}
 
 	return ret;
@@ -887,6 +947,10 @@
 		if (dev->i2c_bus[0].i2c_rc == 0)
 			hauppauge_eeprom(dev, eeprom+0xc0);
 		break;
+    case CX23885_BOARD_MPX885:
+		if (dev->i2c_bus[0].i2c_rc == 0)
+			hauppauge_eeprom(dev, eeprom+0xc0);
+        break;
 	}
 
 	switch (dev->board) {
@@ -938,6 +1002,22 @@
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+    case CX23885_BOARD_MPX885:
+		/* Defaults for VID B - Analog encoder */
+		/* DREQ_POL, SMODE, PUNC_CLK, MCLK_POL Serial bus + punc clk */
+		ts1->gen_ctrl_val    = 0x10e;
+		ts1->ts_clk_en_val   = 0x1; /* Enable TS_CLK */
+		ts1->src_sel_val     = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+
+		/* APB_TSVALERR_POL (active low)*/
+		ts1->vld_misc_val    = 0x2000;
+		ts1->hw_sop_ctrl_val = (0x47 << 16 | 188 << 4 | 0xc);
+
+		/* Defaults for VID C */
+		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
+		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+        break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
@@ -976,6 +1056,14 @@
 				"cx25840", "cx25840", 0x88 >> 1, NULL);
 		v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
 		break;
+    case CX23885_BOARD_MPX885:
+        
+		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_bus[2].i2c_adap,
+				"cx25840", "cx25840", 0x88 >> 1, NULL);
+		v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
+		
+        break;
 	}
 
 	/* AUX-PLL 27MHz CLK */
diff -uNr v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c	2010-02-15 18:19:26.000000000 -0500
+++ MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c	2009-11-11 09:36:16.000000000 -0500
@@ -617,6 +617,36 @@
 			break;
 		}
 		break;
+    case CX23885_BOARD_MPX885:
+		i2c_bus = &dev->i2c_bus[0];
+		switch (alt_tuner) {
+		case 1:
+			fe0->dvb.frontend =
+				dvb_attach(s5h1409_attach,
+					   &hauppauge_ezqam_config,
+					   &i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL) {
+				dvb_attach(tda829x_attach, fe0->dvb.frontend,
+					   &dev->i2c_bus[1].i2c_adap, 0x42,
+					   &tda829x_no_probe);
+				dvb_attach(tda18271_attach, fe0->dvb.frontend,
+					   0x60, &dev->i2c_bus[1].i2c_adap,
+					   &hauppauge_tda18271_config);
+			}
+			break;
+		case 0:
+		default:
+			fe0->dvb.frontend =
+				dvb_attach(s5h1409_attach,
+					   &hauppauge_generic_config,
+					   &i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL)
+				dvb_attach(mt2131_attach, fe0->dvb.frontend,
+					   &i2c_bus->i2c_adap,
+					   &hauppauge_generic_tunerconfig, 0);
+			break;
+		}
+        break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 		i2c_bus = &dev->i2c_bus[0];
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
diff -uNr v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h	2010-02-15 18:19:26.000000000 -0500
+++ MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h	2009-11-11 09:36:20.000000000 -0500
@@ -80,6 +80,7 @@
 #define CX23885_BOARD_MAGICPRO_PROHDTVE2       23
 #define CX23885_BOARD_HAUPPAUGE_HVR1850        24
 #define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
+#define CX23885_BOARD_MPX885                26
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
diff -uNr v4l-dvb/linux/drivers/media/video/cx23885/cx23885-video.c MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx23885/cx23885-video.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-video.c	2010-02-15 18:19:26.000000000 -0500
+++ MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx23885/cx23885-video.c	2009-11-11 09:36:16.000000000 -0500
@@ -970,7 +970,7 @@
 {
 	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)"
 		" (disabled - no action)\n", __func__);
-#if 0
+#if 1
 	call_all(dev, core, s_ctrl, ctl);
 #endif
 	return 0;
diff -uNr v4l-dvb/linux/drivers/media/video/cx25840/cx25840-core.c MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx25840/cx25840-core.c
--- v4l-dvb/linux/drivers/media/video/cx25840/cx25840-core.c	2010-02-15 18:19:26.000000000 -0500
+++ MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx25840/cx25840-core.c	2011-10-13 00:03:10.000000000 -0400
@@ -193,7 +193,7 @@
 {
 	struct cx25840_state *state = arg;
 #endif
-	cx25840_loadfw(state->c);
+//	cx25840_loadfw(state->c);
 	wake_up(&state->fw_wait);
 }
 
@@ -274,23 +274,197 @@
 	DEFINE_WAIT(wait);
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 	struct workqueue_struct *q;
+    int value;
+    int orig_3d_comb;
 
+    orig_3d_comb = cx25840_read4(client, 0x478);
+    orig_3d_comb &= 0x11000000;
+
+      cx25840_write(client, 0x000, 0);
+    
+      /* Internal Reset */
+      cx25840_and_or(client, 0x102, ~0x01, 0x01);
+      cx25840_and_or(client, 0x102, ~0x01, 0x00);
+      /* Stop microcontroller */
+    cx25840_and_or(client, 0x803, ~0x10, 0x00);
+    
+      /* DIF in reset? */
+      cx25840_write(client, 0x398, 0);
+    
+// autodetect
+    value = cx25840_read4(client, 0x15c);
+    value &= 0xffffc7ff;
+    value |= 0x00001000;
+    cx25840_write4(client, 0x15c, value);
+
+    value = cx25840_read4(client, 0x13c);
+    value |= 0x00000001;
+    cx25840_write4(client, 0x13c, value);
+    value &= 0xfffffffe;
+    cx25840_write4(client, 0x13c, value);
+    //reset thresher
+    cx25840_write4(client, 0x4a4, 0x8000);
+    cx25840_write4(client, 0x4a4, 0x0);
+    //restore video muted
+    cx25840_write(client, 0x414, 0x0);
+    cx25840_write(client, 0x420, 0x0);
+    cx25840_write(client, 0x421, 0x0);
+    cx25840_write(client, 0x415, 0x0);
+    
+    value = cx25840_read4(client, 0x498);
+    value &= 0xfff00000;
+    value |= 0x00000802;
+    cx25840_write4(client, 0x498, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    value |= 0x00000020;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffe7ff;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x494);
+    value &= 0xffff0000;
+    value |= 0x00001000;
+    cx25840_write4(client, 0x494, value);
+
+    value = cx25840_read4(client, 0x420);
+    value &= 0xdfffffff;
+    cx25840_write4(client, 0x420, value);
+
+    value = cx25840_read4(client, 0x404);
+    value &= 0xfffffffc;
+    value |= 0x00000003;
+    cx25840_write4(client, 0x404, value);
+
+    value = cx25840_read4(client, 0x404);
+    value &= 0xfffffff7;
+    value |= 0x00000008;
+    cx25840_write4(client, 0x404, value);
+
+//set input mux 0x0502 channel 0x0201
+    value = cx25840_read4(client, 0x100);
+    value &= 0x00E9FFFF;
+	value |= 0x11100000;
+    cx25840_write4(client, 0x100, value);
+    value = cx25840_read4(client, 0x100);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xfffffff0;
+    value |= 0x00000005;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    value |= 0x00000020;
+    cx25840_write4(client, 0x400, value);
+
+    //3d comb
+    cx25840_write4(client, 0x490, 0xcd3f0288);  
+
+//do mode ctrl[S]
+    value = cx25840_read4(client, 0x474);
+    value &= 0xfffffc00;
+    value |= 0x00000024;
+    cx25840_write4(client, 0x474, value);
+/*    value = cx25840_read4(client, 0x474);
+    value &= 0xffc00fff;
+    value |= 0x001e6000;
+    cx25840_write4(client, 0x474, value);
+    value = cx25840_read4(client, 0x474);
+    value &= 0x00ffffff;
+    value |= 0x1e000000;
+    cx25840_write4(client, 0x474, value);
+*/
+    value = cx25840_read4(client, 0x470);
+    value &= 0xfffffc00;
+    value |= 0x00000089;
+    cx25840_write4(client, 0x470, value);
+//do mode ctrl[E]
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xfffffff0;
+    value |= 0x00000004;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x400);
+    value &= 0xffffffdf;
+    value |= 0x00000020;
+    cx25840_write4(client, 0x400, value);
+
+    value = cx25840_read4(client, 0x478);
+    value &= 0x3fffffff;
+    value |= orig_3d_comb;    
+    cx25840_write4(client, 0x478, value);
+
+    //do mode ctrl   
+    value = cx25840_read4(client, 0x490);
+    value &= 0xfffffffc;
+    cx25840_write4(client, 0x490, value);
+
+    value = cx25840_read4(client, 0x474);
+    value &= 0xfffffc00;
+    value |= 0x00000024;
+    cx25840_write4(client, 0x474, value);
+/*    value = cx25840_read4(client, 0x474);
+    value &= 0xffc00fff;
+    value |= 0x001e6000;
+    cx25840_write4(client, 0x474, value);
+    value = cx25840_read4(client, 0x474);
+    value &= 0x00ffffff;
+    value |= 0x1e000000;
+    cx25840_write4(client, 0x474, value);
+*/
+    value = cx25840_read4(client, 0x470);
+    value &= 0xfffffc00;
+    value |= 0x00000089;
+    cx25840_write4(client, 0x470, value);
+    
+    //brightness
+	cx25840_write(client, 0x414, 0);
+    //contrast
+	cx25840_write(client, 0x415, 0x80);
+    //sharpness
+	cx25840_write(client, 0x416, 0);
+    //saturation
+	cx25840_write(client, 0x420, 0x80);
+	cx25840_write(client, 0x421, 0x80);
+    //hue
+	cx25840_write(client, 0x422, 0);
+	cx25840_write4(client, 0x418, 0);
+	cx25840_write4(client, 0x41c, 0);
+	cx25840_write4(client, 0x100, 0x11100000);
+    cx25840_write4(client, 0x400, 0xe021);
+    cx25840_write4(client, 0x400, 0xe021);
+    cx25840_write4(client, 0x104, 0x704dd80);
+/*     cx25840_write4(client, 0x490, 0xcd3f0288);
+//do mode ctrl 
+   cx25840_write4(client, 0x474, 0x1e1e601a);
+    cx25840_write4(client, 0x474, 0x1e1e601a);
+    cx25840_write4(client, 0x474, 0x1e1e601a);
+    cx25840_write4(client, 0x470, 0x5b2d007f);
+    cx25840_write4(client, 0x49c, 0x20504014);
+    cx25840_write4(client, 0x498, 0x802);
+    cx25840_write4(client, 0x498, 0x802);
+*/
+    cx25840_write4(client, 0x160, 0x1d);
+    cx25840_write4(client, 0x164, 0x2);
+#if 1 //wpwp
 	/*
 	 * Come out of digital power down
 	 * The CX23888, at least, needs this, otherwise registers aside from
 	 * 0x0-0x2 can't be read or written.
 	 */
-	cx25840_write(client, 0x000, 0);
-
-	/* Internal Reset */
-	cx25840_and_or(client, 0x102, ~0x01, 0x01);
-	cx25840_and_or(client, 0x102, ~0x01, 0x00);
-
-	/* Stop microcontroller */
-	cx25840_and_or(client, 0x803, ~0x10, 0x00);
-
-	/* DIF in reset? */
-	cx25840_write(client, 0x398, 0);
 
 	/*
 	 * Trust the default xtal, no division
@@ -298,7 +472,7 @@
 	 * '887: 25.000000 MHz
 	 * '888: 50.000000 MHz
 	 */
-	cx25840_write(client, 0x2, 0x76);
+	cx25840_write(client, 0x2, 0x77);
 
 	/* Power up all the PLL's and DLL */
 	cx25840_write(client, 0x1, 0x40);
@@ -327,7 +501,7 @@
 		 * 28.636363 MHz * (0x14 + 0x0/0x2000000)/4 = 5 * 28.636363 MHz
 		 * 572.73 MHz before post divide
 		 */
-		cx25840_write4(client, 0x11c, 0x00000000);
+		cx25840_write4(client, 0x11c, 0x00CCCCCC);
 		cx25840_write4(client, 0x118, 0x00000414);
 		break;
 	}
@@ -347,6 +521,8 @@
 	 */
 	cx25840_write4(client, 0x10c, 0x002be2c9);
 	cx25840_write4(client, 0x108, 0x0000040f);
+    cx25840_write4(client, 0x10c, 0x01B6DB7B);
+    cx25840_write4(client, 0x108, 0x00000512);
 
 	/* Luma */
 	cx25840_write4(client, 0x414, 0x00107d12);
@@ -418,8 +594,9 @@
 	 * currently, regardless of the board type.
 	 */
 	cx25840_write(client, 0x160, 0x1d);
-	cx25840_write(client, 0x164, 0x00);
 
+	cx25840_write(client, 0x164, 0x02);
+#endif
 	/* Do the firmware load in a work handler to prevent.
 	   Otherwise the kernel is blocked waiting for the
 	   bit-banging i2c interface to finish uploading the
@@ -437,10 +614,10 @@
 	finish_wait(&state->fw_wait, &wait);
 	destroy_workqueue(q);
 
-	cx25840_std_setup(client);
+//	cx25840_std_setup(client);
 
 	/* (re)set input */
-	set_input(client, state->vid_input, state->aud_input);
+//	set_input(client, state->vid_input, state->aud_input);
 
 	/* start microcontroller */
 	cx25840_and_or(client, 0x803, ~0x10, 0x10);
@@ -516,7 +693,7 @@
 	finish_wait(&state->fw_wait, &wait);
 	destroy_workqueue(q);
 
-	cx25840_std_setup(client);
+//	cx25840_std_setup(client);
 
 	/* (re)set input */
 	set_input(client, state->vid_input, state->aud_input);
@@ -600,9 +777,6 @@
 		pll_int = cx25840_read(client, 0x108);
 		pll_frac = cx25840_read4(client, 0x10c) & 0x1ffffff;
 		pll_post = cx25840_read(client, 0x109);
-		v4l_dbg(1, cx25840_debug, client,
-			"PLL regs = int: %u, frac: %u, post: %u\n",
-			pll_int, pll_frac, pll_post);
 
 		if (pll_post) {
 			int fin, fsc;
@@ -740,7 +914,7 @@
 	v4l_dbg(1, cx25840_debug, client,
 		"decoder set video input %d, audio input %d\n",
 		vid_input, aud_input);
-
+#if 1 //wpwp
 	if (vid_input >= CX25840_VIN1_CH1) {
 		v4l_dbg(1, cx25840_debug, client, "vid_input 0x%x\n",
 			vid_input);
@@ -805,21 +979,28 @@
 
 	if (!is_cx2388x(state) && !is_cx231xx(state)) {
 		/* Set CH_SEL_ADC2 to 1 if input comes from CH3 */
-		cx25840_and_or(client, 0x102, ~0x2, (reg & 0x80) == 0 ? 2 : 0);
+		cx25840_and_or(client, 0x102, ~0x2, (reg & 0x80) == 0 ? 0x12 : 0x10);
 		/* Set DUAL_MODE_ADC2 to 1 if input comes from both CH2&CH3 */
 		if ((reg & 0xc0) != 0xc0 && (reg & 0x30) != 0x30)
-			cx25840_and_or(client, 0x102, ~0x4, 4);
+			cx25840_and_or(client, 0x102, ~0x4, 0x14);
 		else
-			cx25840_and_or(client, 0x102, ~0x4, 0);
+			cx25840_and_or(client, 0x102, ~0x4, 0x10);
 	} else {
 		if (is_composite)
 			/* ADC2 input select channel 2 */
-			cx25840_and_or(client, 0x102, ~0x2, 0);
+			cx25840_and_or(client, 0x102, ~0x2, 0x10);
 		else
 			/* ADC2 input select channel 3 */
-			cx25840_and_or(client, 0x102, ~0x2, 2);
+			cx25840_and_or(client, 0x102, ~0x2, 0x12);
 	}
 
+//	cx25840_and_or(client, 0x400, 0xffffffdf, 0x20);
+//	cx25840_and_or(client, 0x400, 0xfffff9ff, 0);
+
+    
+//	cx25840_and_or(client, 0x490, 0xfffffffc, 0);
+//	cx25840_and_or(client, 0x474, 0xfffffc00, 0x24);
+//	cx25840_and_or(client, 0x470, 0xfffffc00, 0x89);
 	state->vid_input = vid_input;
 	state->aud_input = aud_input;
 	if (!is_cx2583x(state)) {
@@ -857,7 +1038,7 @@
 		cx25840_write(client, 0x918, 0xa0);
 		cx25840_write(client, 0x919, 0x01);
 	}
-
+#endif
 	return 0;
 }
 
@@ -868,7 +1049,7 @@
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 	u8 fmt = 0; 	/* zero is autodetect */
 	u8 pal_m = 0;
-
+#if 1
 	/* First tests should be against specific std */
 	if (state->std == V4L2_STD_NTSC_M_JP) {
 		fmt = 0x2;
@@ -909,6 +1090,7 @@
 	cx25840_std_setup(client);
 	if (!is_cx2583x(state))
 		input_change(client);
+#endif    
 	return 0;
 }
 
@@ -957,12 +1139,12 @@
 		break;
 
 	case V4L2_CID_HUE:
-		if (ctrl->value < -128 || ctrl->value > 127) {
+		if (ctrl->value < 0 || ctrl->value > 255) {
 			v4l_err(client, "invalid hue setting %d\n", ctrl->value);
 			return -ERANGE;
 		}
 
-		cx25840_write(client, 0x422, ctrl->value);
+		cx25840_write(client, 0x422, ctrl->value - 128 );
 		break;
 
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1000,7 +1182,7 @@
 		ctrl->value = cx25840_read(client, 0x420) >> 1;
 		break;
 	case V4L2_CID_HUE:
-		ctrl->value = (s8)cx25840_read(client, 0x422);
+		ctrl->value = (s8)cx25840_read(client, 0x422) + 128;
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
 	case V4L2_CID_AUDIO_BASS:
@@ -1748,7 +1930,7 @@
 	}
 
 	state->c = client;
-	state->vid_input = CX25840_COMPOSITE7;
+	state->vid_input = CX25840_COMPOSITE1;
 	state->aud_input = CX25840_AUDIO8;
 	state->audclk_freq = 48000;
 	state->pvr150_workaround = 0;
diff -uNr v4l-dvb/linux/drivers/media/video/cx25840/cx25840-firmware.c MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx25840/cx25840-firmware.c
--- v4l-dvb/linux/drivers/media/video/cx25840/cx25840-firmware.c	2010-01-05 18:25:14.000000000 -0500
+++ MPX-885/linux/v4l-dvb/linux/drivers/media/video/cx25840/cx25840-firmware.c	2009-11-11 09:36:38.000000000 -0500
@@ -130,7 +130,7 @@
 	}
 
 	start_fw_load(client);
-
+#if 0
 	buffer[0] = 0x08;
 	buffer[1] = 0x02;
 
@@ -151,7 +151,7 @@
 		size -= len;
 		ptr += len;
 	}
-
+#endif
 	end_fw_load(client);
 
 	size = fw->size;

--tThc/1wpZn/ma/RB--
