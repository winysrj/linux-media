Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64986 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab0J2UAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 16:00:38 -0400
Received: by eye27 with SMTP id 27so2432733eye.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 13:00:37 -0700 (PDT)
From: Alexey Chernov <4ernov@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] support of GoTView PCI-E X5 3D Hybrid in cx23885
Date: Sat, 30 Oct 2010 00:00:33 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010300000.33617.4ernov@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,
I've added support of GoTView PCI-E X5 3D Hybrid to cx23885 module (thanks to help of Gotview support team). Some details:
1. Everything initialize properly except radio.
2. All analog inputs (TV, composite, S-Video) are tested by myself in several TV norms (SECAM-D, PAL, NTSC), everything work fine. DVB isn't tested properly due to absense of DVB signal.

So the patch adds general support/detection of the card with working analog part and hopefully working (untested) DVB part. I hope it will be useful.

Signed-off-by: Alexey Chernov <4ernov@gmail.com>

diff -uprB v4l-dvb.orig/drivers/media/video/cx23885/cx23885-cards.c v4l-dvb/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb.orig/drivers/media/video/cx23885/cx23885-cards.c	2010-10-28 22:04:10.000000000 +0400
+++ v4l-dvb/drivers/media/video/cx23885/cx23885-cards.c	2010-10-29 23:23:47.000000000 +0400
@@ -309,6 +309,24 @@ struct cx23885_board cx23885_boards[] = 
 				  CX25840_COMPONENT_ON,
 		} },
 	},
+	[CX23885_BOARD_GOTVIEW_X5_3D_HYBRID] = {
+		.name		= "GoTView X5 3D Hybrid",
+		.tuner_type = TUNER_XC5000,
+		.tuner_addr = 0x64,
+		.porta		= CX23885_ANALOG_VIDEO,
+		.portb		= CX23885_MPEG_DVB,
+		.input          = {{
+			.type   = CX23885_VMUX_TELEVISION,
+			.vmux   = CX25840_VIN2_CH1 | CX25840_VIN5_CH2,
+			.gpio0	= 0x02,
+		}, {
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   =	CX23885_VMUX_COMPOSITE1,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   =	CX25840_SVIDEO_LUMA3 | CX25840_SVIDEO_CHROMA4,
+	    } },
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -496,6 +514,10 @@ struct cx23885_subid cx23885_subids[] = 
 		.subvendor = 0x107d,
 		.subdevice = 0x6f22,
 		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXTV1200,
+	}, {
+		.subvendor = 0x5654,
+		.subdevice = 0x2390,
+		.card      = CX23885_BOARD_GOTVIEW_X5_3D_HYBRID,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -712,6 +734,10 @@ int cx23885_tuner_callback(void *priv, i
 		else if (port->nr == 2)
 			bitmask = 0x04;
 		break;
+	case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
+		/* Tuner Reset Command */
+		bitmask = 0x02;
+		break;
 	}
 
 	if (bitmask) {
@@ -1218,6 +1244,7 @@ void cx23885_card_setup(struct cx23885_d
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
+	case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
 	default:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -1245,6 +1272,7 @@ void cx23885_card_setup(struct cx23885_d
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
+	case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", "cx25840", 0x88 >> 1, NULL);
diff -uprB v4l-dvb.orig/drivers/media/video/cx23885/cx23885-dvb.c v4l-dvb/drivers/media/video/cx23885/cx23885-dvb.c
--- v4l-dvb.orig/drivers/media/video/cx23885/cx23885-dvb.c	2010-10-28 22:04:10.000000000 +0400
+++ v4l-dvb/drivers/media/video/cx23885/cx23885-dvb.c	2010-10-29 23:24:53.000000000 +0400
@@ -460,6 +460,10 @@ static struct xc5000_config mygica_x8506
 	.if_khz = 5380,
 };
 
+static struct zl10353_config gotview_x5_3d_hybrid_zl10353_config = {
+	.demod_address         = 0x0F,
+};
+
 static int cx23885_dvb_set_frontend(struct dvb_frontend *fe,
 				    struct dvb_frontend_parameters *param)
 {
@@ -484,6 +488,9 @@ static int cx23885_dvb_set_frontend(stru
 		/* Select Digital TV */
 		cx23885_gpio_set(dev, GPIO_0);
 		break;
+	case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
+		cx23885_gpio_set(dev, GPIO_1);
+		break;
 	}
 	return 0;
 }
@@ -966,6 +973,24 @@ static int dvb_register(struct cx23885_t
 			break;
 		}
 		break;
+	case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:
+		i2c_bus = &dev->i2c_bus[port->nr - 1];
+		
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
+				&gotview_x5_3d_hybrid_zl10353_config,
+				&i2c_bus->i2c_adap);
+		
+		if (fe0->dvb.frontend != NULL) {
+			struct xc5000_config	  cfg;
+			cfg.i2c_address = 0x64;
+
+			i2c_bus = &dev->i2c_bus[port->nr];
+
+			dvb_attach(xc5000_attach, fe0->dvb.frontend,
+					&i2c_bus->i2c_adap,
+					&cfg);
+		}
+		break;
 
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
diff -uprB v4l-dvb.orig/drivers/media/video/cx23885/cx23885.h v4l-dvb/drivers/media/video/cx23885/cx23885.h
--- v4l-dvb.orig/drivers/media/video/cx23885/cx23885.h	2010-10-28 22:04:10.000000000 +0400
+++ v4l-dvb/drivers/media/video/cx23885/cx23885.h	2010-10-29 23:48:23.000000000 +0400
@@ -84,6 +84,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1290        26
 #define CX23885_BOARD_MYGICA_X8558PRO          27
 #define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
+#define CX23885_BOARD_GOTVIEW_X5_3D_HYBRID     29
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
