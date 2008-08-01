Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 1 Aug 2008 11:25:54 +1000
From: Anton Blanchard <anton@samba.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080801012554.GD7094@kryten>
References: <20080801012319.GB7094@kryten> <20080801012513.GC7094@kryten>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080801012513.GC7094@kryten>
Cc: linuxdvb@itee.uq.edu.au, stev391@email.com
Subject: [linux-dvb] [PATCH 3/4] Add support for DViCO FusionHDTV DVB-T Dual
	Express
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


Add support for the DViCO FusionHDTV DVB-T Dual Express card, based on
work by Chris Pascoe and Stephen Backway.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
===================================================================
--- v4l-dvb.orig/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-01 11:00:36.000000000 +1000
+++ v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-01 11:04:07.000000000 +1000
@@ -9,3 +9,4 @@
   8 -> Hauppauge WinTV-HVR1700                             [0070:8101]
   9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
  10 -> DViCO FusionHDTV7 Dual Express                      [18ac:d618]
+ 11 -> DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]
Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-01 11:03:28.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-01 11:04:39.000000000 +1000
@@ -150,6 +150,11 @@
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] = {
+		.name		= "DViCO FusionHDTV DVB-T Dual Express",
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -221,6 +226,10 @@
 		.subvendor = 0x18ac,
 		.subdevice = 0xd618,
 		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,
+	},{
+		.subvendor = 0x18ac,
+		.subdevice = 0xdb78,
+		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -341,6 +350,7 @@
 			bitmask = 0x04;
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		if (command == 0) {
 
 			/* Two identical tuners on two different i2c buses,
@@ -484,6 +494,19 @@
 		mdelay(20);
 		cx_set(GP0_IO, 0x000f000f);
 		break;
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+		/* GPIO-0 portb xc3028 reset */
+		/* GPIO-1 portb zl10353 reset */
+		/* GPIO-2 portc xc3028 reset */
+		/* GPIO-3 portc zl10353 reset */
+
+		/* Put the parts into reset and back */
+		cx_set(GP0_IO, 0x000f0000);
+		mdelay(20);
+		cx_clear(GP0_IO, 0x0000000f);
+		mdelay(20);
+		cx_set(GP0_IO, 0x000f000f);
+		break;
 	}
 }
 
@@ -535,6 +558,7 @@
 
 	switch (dev->board) {
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-01 11:00:54.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-01 11:04:07.000000000 +1000
@@ -43,6 +43,7 @@
 #include "tuner-simple.h"
 #include "dib7000p.h"
 #include "dibx000_common.h"
+#include "zl10353.h"
 
 static unsigned int debug;
 
@@ -304,6 +305,12 @@
 	.output_mode = OUTMODE_MPEG2_SERIAL,
 };
 
+static struct zl10353_config dvico_fusionhdtv_xc3028 = {
+	.demod_address = 0x0f,
+	.if2           = 45600,
+	.no_tuner      = 1,
+};
+
 static int dvb_register(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
@@ -466,6 +473,33 @@
 				&i2c_bus->i2c_adap,
 				&dvico_xc5000_tunerconfig, i2c_bus);
 		break;
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {
+		i2c_bus = &dev->i2c_bus[port->nr - 1];
+
+		port->dvb.frontend = dvb_attach(zl10353_attach,
+					       &dvico_fusionhdtv_xc3028,
+					       &i2c_bus->i2c_adap);
+		if (port->dvb.frontend != NULL) {
+			struct dvb_frontend      *fe;
+			struct xc2028_config	  cfg = {
+				.i2c_adap  = &i2c_bus->i2c_adap,
+				.i2c_addr  = 0x61,
+				.video_dev = port,
+				.callback  = cx23885_xc3028_tuner_callback,
+			};
+			static struct xc2028_ctrl ctl = {
+				.fname       = "xc3028-v27.fw",
+				.max_len     = 64,
+				.demod       = XC3028_FE_ZARLINK456,
+			};
+
+			fe = dvb_attach(xc2028_attach, port->dvb.frontend,
+					&cfg);
+			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
+				fe->ops.tuner_ops.set_config(fe, &ctl);
+		}
+		break;
+	}
 	default:
 		printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       dev->name);
Index: v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885.h	2008-08-01 11:00:54.000000000 +1000
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h	2008-08-01 11:04:07.000000000 +1000
@@ -65,6 +65,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1700        8
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
+#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
 
 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */
 #define CX23885_NORMS (\

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
