Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KSlPq-00014n-BI
	for linux-dvb@linuxtv.org; Tue, 12 Aug 2008 06:23:31 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	CD6DA1801617
	for <linux-dvb@linuxtv.org>; Tue, 12 Aug 2008 04:22:50 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: "Steven Toth" <stoth@linuxtv.org>
Date: Tue, 12 Aug 2008 14:22:50 +1000
Message-Id: <20080812042250.B929732675A@ws1-8.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
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


> ----- Original Message -----
> From: "Steven Toth" <stoth@linuxtv.org>
> To: stev391@email.com
> Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB Only support
> Date: Sun, 10 Aug 2008 09:26:15 -0400
> 
> 
> stev391@email.com wrote:
> >> ----- Original Message -----
> >> From: "Steven Toth" <stoth@linuxtv.org>
> >> To: stev391@email.com
> >> Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB Only 
> >> support
> >> Date: Tue, 05 Aug 2008 10:30:57 -0400
> >>
> >>
> >> stev391@email.com wrote:
> >>> Steve,
> >>>
> >>> I have reworked the tuner callback now against your branch at:
> >>> http://linuxtv.org/hg/~stoth/v4l-dvb
> >>>
> >>> The new Patch (to add support for this card) is attached inline below for testing (this is a 
> >>> hint Mark & Jon), I have not provided a signed-off note on purpose as I want to solve the 
> >>> issue mentioned in the next paragraph first.
> >>>
> >>> Regarding the cx25840 module; the card doesn't seem to initialise properly (no DVB output 
> >>> and DMA errors in log) unless I have this requested.  Once the card is up and running I can 
> >>> unload all drivers, recompile without the cx25840 and load and it will work again until I 
> >>> power off the computer and back on again (This has been tedious trying to work out which 
> >>> setting I had missed).  Is there some initialisation work being performed in the cx25840 
> >>> module that I can incorporate into my patch to remove this dependency? Or should I leave it 
> >>> as is?
> >>>
> >>> Anyway nearly bedtime here.
> >> The patch looks good, with the exception of requesting the cx25840.
> >>
> >> I've always been able to run DVB without that driver being present, so something is odd with 
> >> the Leadtek card. I'm not aware of any relationship between the cx25840 driver and the DVB 
> >> core.
> >>
> >> You're going to need to find the magic register write that the cx25840 is performing so we 
> >> can discuss here. I'd rather we figured that out cleanly, than just merged the patch and have 
> >> the problem linger on.
> >>
> >> Other than that, good patch.
> >>
> >> - Steve
> >
> > Steve,
> >
> > I have found the lines (starting at line 1441) within cx25840-core.c that effects the DVB 
> > working or not working. These lines are:
> > 	if (state->is_cx23885) {
> > 		/* Drive GPIO2 direction and values */
> > 		cx25840_write(client, 0x160, 0x1d);
> > 		cx25840_write(client, 0x164, 0x00);
> > 	}
> >
> > If I comment these lines out in the code, the DVB side doesn't work.  I have tried 
> > incorporating these register writes into various places in the cx23885 code 
> > (cx23885_gpio_setup(), cx23885_card_setup() and dvb_register()) as the following lines:
> > cx_write(0x160, 0x1d);
> > cx_write(0x164, 0x00);
> >
> > But this does not allow the card to work.
> >
> > I have also commented out/ removed all of the code in cx25840-core.c except for the read, 
> > write, probe(now only contains the above cx25840_writes) and remove functions and the various 
> > struct configs, to ensure that it is not something else contributing to the dependency.
> >
> > Have a used cx_write correctly?
> >
> > I have also noticed that the following card also uses the cx25840 without any analog support 
> > in the driver:
> > CX23885_BOARD_HAUPPAUGE_HVR1700
> >
> > Perhaps the person who included support for this card has already gone down this track...
> >
> > There are two possible directions that I would like to take from here:
> > 1) Submit the patch as is with the cx25840 dependency
> > 2) Work on why the registers writes aren't working. (However this is out of my depth of 
> > knowledge and will need some guidance or pass it onto someone else).
> 
> OK, so they tied the demod reset to the GPIO on the avcore, rather than a regular GPIO on the 
> pcie bridge itself. I've only ever seen one other card do that (which you found - the HVR1700) 
> because Hauppauge ran out of GPIO's on the bridge itself.
> 
> In this new case, for the Leadtek, I accept that we'll have to request_module for the card.
> 
> You should also add a comment to the _gpio_setup() code (where generally I try to ensure all 
> card GPIO's are document), to say that the GPIO is on the AVCore (like the HVR1700). See the 
> HVR1700 example comments.
> 
> One comment the bitmask in the tuner reset looks unusually long for resetting the xc3028. 70404, 
> and it dosn't match the value used in your _gpio_setup() implementation (0x04).
> 
> So three very minor things to get this patch accepted:
> 1. Change 70404 to 4, this is clean.
> 2. Add the cx25840 request_module() code back.
> 3. Update the comments in _gpio_setup() to indicate the GPIO for the zilink part os on the 
> AVcore.
> 
> Good work Steve, thanks for helping. Please publish the patch to this mailing list (with your 
> sign-off) and I'll put up an official tree for retest and final merge.
> 
> - Steve

Steve,

Attached is my patch and another small additional one. 

In the callback function we check the command several times:
1. To check if it is the CLK RESET command
2. If it is not the tuner reset command
3. If it is the tuner reset command

The third one is within the case statement and appears redundant as the first 2 cover all other possibilities.

Attached below after my patch is a second patch (to be applied after the patch to add support for the Leadtek) that will clean this up and remove the third command test.

Regards,
Stephen

---------Leadtek_Winfast_PxDVR3200_H_Signed_Off.diff---------
cx23885: Add DVB support for Leadtek Winfast PxDVR3200 H

From: Stephen Backway <stev391@email.com>

Add DVB support for the Leadtek Winfast PxDVR3200 H.

Signed-off-by: Stephen Backway <stev391@email.com>

diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885 v4l-dvb3/linux/Documentation/video4linux/CARDLIST.cx23885
--- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-05 16:48:13.000000000 +1000
+++ v4l-dvb3/linux/Documentation/video4linux/CARDLIST.cx23885	2008-08-12 13:32:57.000000000 +1000
@@ -10,3 +10,4 @@
   9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
  10 -> DViCO FusionHDTV7 Dual Express                      [18ac:d618]
  11 -> DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]
+ 12 -> Leadtek Winfast PxDVR3200 H                         [107d:6681]
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c v4l-dvb3/linux/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-05 16:48:14.000000000 +1000
+++ v4l-dvb3/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-12 13:43:06.000000000 +1000
@@ -155,6 +155,10 @@
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] = {
+		.name		= "Leadtek Winfast PxDVR3200 H",
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -230,7 +234,11 @@
 		.subvendor = 0x18ac,
 		.subdevice = 0xdb78,
 		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
-	},
+	}, {
+ 		.subvendor = 0x107d,
+ 		.subdevice = 0x6681,
+ 		.card      = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
+  	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
 
@@ -349,6 +357,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 		/* Tuner Reset Command */
 		if (command == 0)
 			bitmask = 0x04;
@@ -492,6 +501,19 @@
 		mdelay(20);
 		cx_set(GP0_IO, 0x000f000f);
 		break;
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+		/* GPIO-2  xc3028 tuner reset */
+
+                /* The following GPIO's are on the internal AVCore (cx25840) */
+                /* GPIO-?  zl10353 demod reset */
+
+		/* Put the parts into reset and back */
+		cx_set(GP0_IO, 0x00040000);
+		mdelay(20);
+		cx_clear(GP0_IO, 0x00000004);
+		mdelay(20);
+		cx_set(GP0_IO, 0x00040004);
+		break;
 	}
 }
 
@@ -579,6 +601,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1200:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	default:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -592,6 +615,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
+	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 		request_module("cx25840");
 		break;
 	}
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c v4l-dvb3/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-05 16:48:14.000000000 +1000
+++ v4l-dvb3/linux/drivers/media/video/cx23885/cx23885-dvb.c	2008-08-12 13:54:39.000000000 +1000
@@ -502,6 +502,32 @@
 		}
 		break;
 	}
+ 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
+ 		i2c_bus = &dev->i2c_bus[0];
+ 
+ 		port->dvb.frontend = dvb_attach(zl10353_attach,
+ 					       &dvico_fusionhdtv_xc3028,
+ 					       &i2c_bus->i2c_adap);
+ 		if (port->dvb.frontend != NULL) {
+ 			struct dvb_frontend      *fe;
+ 			struct xc2028_config	  cfg = {
+ 				.i2c_adap  = &dev->i2c_bus[1].i2c_adap,
+ 				.i2c_addr  = 0x61,
+ 				.video_dev = port,
+ 				.callback  = cx23885_tuner_callback,
+ 			};
+ 			static struct xc2028_ctrl ctl = {
+ 				.fname       = "xc3028-v27.fw",
+ 				.max_len     = 64,
+ 				.demod       = XC3028_FE_ZARLINK456,
+ 			};
+ 
+ 			fe = dvb_attach(xc2028_attach, port->dvb.frontend,
+ 					&cfg);
+ 			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
+ 				fe->ops.tuner_ops.set_config(fe, &ctl);
+ 		}
+ 		break;
 	default:
 		printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       dev->name);
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h v4l-dvb3/linux/drivers/media/video/cx23885/cx23885.h
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h	2008-08-05 16:48:14.000000000 +1000
+++ v4l-dvb3/linux/drivers/media/video/cx23885/cx23885.h	2008-08-12 13:32:57.000000000 +1000
@@ -66,6 +66,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
 #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
+#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 12
 
 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */
 #define CX23885_NORMS (\
diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig v4l-dvb3/linux/drivers/media/video/cx23885/Kconfig
--- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig	2008-08-05 16:48:14.000000000 +1000
+++ v4l-dvb3/linux/drivers/media/video/cx23885/Kconfig	2008-08-12 13:32:57.000000000 +1000
@@ -15,6 +15,7 @@
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE
+ 	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE


---------cx23885_callback_tidyup.diff---------
cx23885: Remove Redundant if statements in tuner callback

From: Stephen Backway <stev391@email.com>

The tuner callback previously checked the command 3 times:
1) To see if it was the XC2028_RESET_CLK
2) To see if it was not the XC2028_RESET_TUNER
3) To see if it was the XC2028_RESET_TUNER
This patch removes the third check.

Signed-off-by: Stephen Backway <stev391@email.com>

diff -Naur v4l-dvb3/linux/drivers/media/video/cx23885/cx23885-cards.c v4l-dvb4/linux/drivers/media/video/cx23885/cx23885-cards.c
--- v4l-dvb3/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-12 13:43:06.000000000 +1000
+++ v4l-dvb4/linux/drivers/media/video/cx23885/cx23885-cards.c	2008-08-12 14:17:13.000000000 +1000
@@ -359,20 +359,16 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 		/* Tuner Reset Command */
-		if (command == 0)
-			bitmask = 0x04;
+		bitmask = 0x04;
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
-		if (command == 0) {
-
-			/* Two identical tuners on two different i2c buses,
-			 * we need to reset the correct gpio. */
-			if (port->nr == 0)
-				bitmask = 0x01;
-			else if (port->nr == 1)
-				bitmask = 0x04;
-		}
+		/* Two identical tuners on two different i2c buses,
+		 * we need to reset the correct gpio. */
+		if (port->nr == 0)
+			bitmask = 0x01;
+		else if (port->nr == 1)
+			bitmask = 0x04;
 		break;
 	}
 




-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
