Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 216.14.233.220.exetel.com.au ([220.233.14.216]
	helo=mail.carbonaro.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mark@carbonaro.org>) id 1KQNEN-0003IX-QD
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 16:09:47 +0200
Date: Tue, 5 Aug 2008 23:47:46 +1000 (EST)
From: Mark Carbonaro <mark@carbonaro.org>
To: Jonathan Hummel <jhhummel@bigpond.com>
Message-ID: <13353690.261217945344185.JavaMail.mark@trogdor.carbonaro.org>
In-Reply-To: <24526361.241217944963449.JavaMail.mark@trogdor.carbonaro.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----=_Part_11_13311165.1217945344182"
Cc: linux-dvb@linuxtv.org, stev391@email.com
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_11_13311165.1217945344182
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Mark,

Forgive my ignorance/ newbie-ness, but what do I do with that patch code
below? is there a tutorial or howto or something somewhere that will
introduce me to this. I have done some programming, but nothing of this
level.

cheers

Jon

----- Original Message -----
From: "Jonathan Hummel" <jhhummel@bigpond.com>
To: "Mark Carbonaro" <mark@carbonaro.org>
Cc: stev391@email.com, linux-dvb@linuxtv.org
Sent: Tuesday, 5 August, 2008 10:21:11 PM (GMT+1000) Auto-Detected
Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB Only support

Hi Jon,

Not a problem at all, I'm new to this myself, below is what went through and I may not be doing it the right way either.  So if anyone would like to point out what I am doing wrong I would really appreciate it.

The file that I downloaded was called v4l-dvb-2bade2ed7ac8.tar.bz2 which I downloaded from http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2, I also saved the patch to the same location as the download.

The patch didn't apply for me, so I manually patched applied the patches and created a new diff that should hopefully work for you also (attached and inline below).  From what I could see the offsets in Stephens patch were a little off for this code snapshot but otherwise it is all good.

I ran the following using the attached diff...

tar -xjf v4l-dvb-2bade2ed7ac8.tar.bz2
cd v4l-dvb-2bade2ed7ac8
patch -p1 < ../Leadtek.Winfast.PxDVR.3200.H.2.diff

Once the patch was applied I was then able to build and install the modules as per the instructions in the INSTALL file.  I ran the following...

make all
sudo make install

>From there I could load the modules and start testing.

I hope this helps you get started.

Regards,
Mark






diff -Naur v4l-dvb-2bade2ed7ac8/linux/Documentation/video4linux/CARDLIST.cx23885 v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885
--- v4l-dvb-2bade2ed7ac8/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-05 23:27:32.000000000 +1000
@@ -10,3 +10,4 @@
   9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
  10 -> DViCO FusionHDTV7 Dual Express                      [18ac:d618]
  11 -> DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]
+ 12 -> Leadtek Winfast PxDVR3200 H                         [107d:6681]
diff -Naur v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/Kconfig v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig
--- v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/Kconfig	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig	2008-08-05 23:37:51.000000000 +1000
@@ -15,6 +15,7 @@
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
+	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE
diff -Naur v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-cards.c v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-05 23:41:40.000000000 +1000
@@ -155,6 +155,10 @@
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] = {
+		.name        = "Leadtek Winfast PxDVR3200 H",
+		.portc        = CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -230,6 +234,10 @@
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb78,
 		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
+	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6681,
+		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -353,6 +361,10 @@
 		if (command == 0)
 			bitmask = 0x04;
 		break;
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		/* Tuner Reset Command */
+		bitmask = 0x00070404;
+		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		if (command == 0) {
@@ -492,6 +504,15 @@
 		mdelay(20);
 		cx_set(GP0_IO, 0x000f000f);
 		break;
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		/* GPIO-2  xc3028 tuner reset */
+		/* Put the parts into reset and back */
+		cx_set(GP0_IO, 0x00040000);
+		mdelay(20);
+		cx_clear(GP0_IO, 0x00000004);
+		mdelay(20);
+		cx_set(GP0_IO, 0x00040004);
+		break;
 	}
 }
 
@@ -579,6 +600,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1200:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	default:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -592,6 +614,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 		request_module("cx25840");
 		break;
 	}
diff -Naur v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-dvb.c v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-05 23:37:03.000000000 +1000
@@ -37,6 +37,7 @@
 #include "tda8290.h"
 #include "tda18271.h"
 #include "lgdt330x.h"
+#include "zl10353.h"
 #include "xc5000.h"
 #include "tda10048.h"
 #include "tuner-xc2028.h"
@@ -502,6 +503,32 @@
 		}
 		break;
 	}
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		i2c_bus = &dev->i2c_bus[0];
+
+		port->dvb.frontend = dvb_attach(zl10353_attach,
+						&dvico_fusionhdtv_xc3028,
+						&i2c_bus->i2c_adap);
+		if (port->dvb.frontend != NULL) {
+			struct dvb_frontend      *fe;
+			struct xc2028_config      cfg = {
+				.i2c_adap  = &dev->i2c_bus[1].i2c_adap,
+				.i2c_addr  = 0x61,
+				.video_dev = port,
+				.callback  = cx23885_tuner_callback,
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
 	default:
 		printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       dev->name);
diff -Naur v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885.h v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h
--- v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885.h	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h	2008-08-05 23:37:33.000000000 +1000
@@ -66,6 +66,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
 #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
+#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12
 
 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */
 #define CX23885_NORMS (\
------=_Part_11_13311165.1217945344182
Content-Type: application/octet-stream;
	name=Leadtek.Winfast.PxDVR.3200.H.2.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=Leadtek.Winfast.PxDVR.3200.H.2.diff

diff -Naur v4l-dvb-2bade2ed7ac8/linux/Documentation/video4linux/CARDLIST.cx23885 v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885
--- v4l-dvb-2bade2ed7ac8/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-05 23:27:32.000000000 +1000
@@ -10,3 +10,4 @@
   9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
  10 -> DViCO FusionHDTV7 Dual Express                      [18ac:d618]
  11 -> DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]
+ 12 -> Leadtek Winfast PxDVR3200 H                         [107d:6681]
diff -Naur v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/Kconfig v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig
--- v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/Kconfig	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/Kconfig	2008-08-05 23:37:51.000000000 +1000
@@ -15,6 +15,7 @@
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
+	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE
diff -Naur v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-cards.c v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-05 23:41:40.000000000 +1000
@@ -155,6 +155,10 @@
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] = {
+		.name        = "Leadtek Winfast PxDVR3200 H",
+		.portc        = CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -230,6 +234,10 @@
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb78,
 		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
+	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6681,
+		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -353,6 +361,10 @@
 		if (command == 0)
 			bitmask = 0x04;
 		break;
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		/* Tuner Reset Command */
+		bitmask = 0x00070404;
+		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		if (command == 0) {
@@ -492,6 +504,15 @@
 		mdelay(20);
 		cx_set(GP0_IO, 0x000f000f);
 		break;
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		/* GPIO-2  xc3028 tuner reset */
+		/* Put the parts into reset and back */
+		cx_set(GP0_IO, 0x00040000);
+		mdelay(20);
+		cx_clear(GP0_IO, 0x00000004);
+		mdelay(20);
+		cx_set(GP0_IO, 0x00040004);
+		break;
 	}
 }
 
@@ -579,6 +600,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1200:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	default:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -592,6 +614,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 		request_module("cx25840");
 		break;
 	}
diff -Naur v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-dvb.c v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-05 23:37:03.000000000 +1000
@@ -37,6 +37,7 @@
 #include "tda8290.h"
 #include "tda18271.h"
 #include "lgdt330x.h"
+#include "zl10353.h"
 #include "xc5000.h"
 #include "tda10048.h"
 #include "tuner-xc2028.h"
@@ -502,6 +503,32 @@
 		}
 		break;
 	}
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		i2c_bus = &dev->i2c_bus[0];
+
+		port->dvb.frontend = dvb_attach(zl10353_attach,
+						&dvico_fusionhdtv_xc3028,
+						&i2c_bus->i2c_adap);
+		if (port->dvb.frontend != NULL) {
+			struct dvb_frontend      *fe;
+			struct xc2028_config      cfg = {
+				.i2c_adap  = &dev->i2c_bus[1].i2c_adap,
+				.i2c_addr  = 0x61,
+				.video_dev = port,
+				.callback  = cx23885_tuner_callback,
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
 	default:
 		printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       dev->name);
diff -Naur v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885.h v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h
--- v4l-dvb-2bade2ed7ac8/linux/drivers/media/video/cx23885/cx23885.h	2008-08-05 11:18:19.000000000 +1000
+++ v4l-dvb2/linux/drivers/media/video/cx23885/cx23885.h	2008-08-05 23:37:33.000000000 +1000
@@ -66,6 +66,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
 #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
+#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12
 
 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */
 #define CX23885_NORMS (\

------=_Part_11_13311165.1217945344182
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_11_13311165.1217945344182--
