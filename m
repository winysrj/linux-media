Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35205 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3B1XsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 18:48:23 -0500
Received: by mail-ia0-f174.google.com with SMTP id u20so2075721iag.5
        for <linux-media@vger.kernel.org>; Thu, 28 Feb 2013 15:48:22 -0800 (PST)
From: "Matt Gomboc" <gomboc0@gmail.com>
To: <linux-media@vger.kernel.org>
Subject: cx231xx : Add support for OTG102 aka EZGrabber2
Date: Thu, 28 Feb 2013 16:48:23 -0700
Message-ID: <9A3F755BB15244F3AC42886FE26E0308@ucdenver.pvt>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001A_01CE15D3.6CD7D550"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_001A_01CE15D3.6CD7D550
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

The text was inadvertently dropped from my first email, reincluding here.
-----------------

This is a patch I have created that enables basic support for a product
marketed as EZGrabber2, which is identified as an OTG102 board by dmesg and
lsusb.

I have documented some detail about the product and this patch at
http://linuxtv.org/wiki/index.php/OTG102. In summary, it has a peculiarly
marked chipset, CX78921-11z, although the packaged windows drivers looked
similar enough to the cx23100 series. With some experimentation, was able to
get the device to operate properly by replicating much of the code for the
CX231XX_BOARD_CNXT_VIDEO_GRABBER, but with the
agc_analog_digital_select_gpio information from the windows driver inf file
and defining .dont_use_port_3.

The vendor documentation states the device supports hardware encoding of
MPEG1/2/4. If I don't include the .has_417=1 option in the device
definition, it creates a single /dev/video0 device which works and provides
uncompressed video. If I do include that option, the working device is moved
to video1, and video0 is created but no data comes out of it. The Geniatech
driver also contains a firmware image called cx416enc.rom which is very
similar (in binary comparison) to the v4l-cx23885-enc.fw/ hcw85enc.rom. 

The patch is against my local gentoo-3.6 kernel. As I am a first time
contributor to this mailing list, and only have a superficial understanding
of the cx231xx and related drivers and the v4l2 framework (and c programming
in general), any stylistic or procedural guidance for improving the patch
for eventual submission, information posted to the linuxtv wiki, etc, would
be welcome.

Also considering the recently submitted patch for the "Elgato Video Capture
V2" which also adds device 16 to cx2311.h and the many recent patches by
Hans Verkuil, this may take some further working to align it with a moving
target.

If you desire any further information, let me know. Thanks.

Matt 



------=_NextPart_000_001A_01CE15D3.6CD7D550
Content-Type: application/octet-stream;
	name="OTG102.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="OTG102.patch"

diff -uprN linux-3.6/drivers/media/video/cx231xx/cx231xx-avcore.c =
linux-3.6.new/drivers/media/video/cx231xx/cx231xx-avcore.c=0A=
--- linux-3.6/drivers/media/video/cx231xx/cx231xx-avcore.c	2012-09-30 =
17:47:46.000000000 -0600=0A=
+++ linux-3.6.new/drivers/media/video/cx231xx/cx231xx-avcore.c	=
2013-02-26 19:58:51.096793077 -0700=0A=
@@ -352,6 +352,7 @@ int cx231xx_afe_update_power_control(str=0A=
 	case CX231XX_BOARD_CNXT_RDE_253S:=0A=
 	case CX231XX_BOARD_CNXT_RDU_253S:=0A=
 	case CX231XX_BOARD_CNXT_VIDEO_GRABBER:=0A=
+	case CX231XX_BOARD_OTG102:=0A=
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:=0A=
 	case CX231XX_BOARD_HAUPPAUGE_USBLIVE2:=0A=
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:=0A=
@@ -1719,6 +1720,7 @@ int cx231xx_dif_set_standard(struct cx23=0A=
 	case CX231XX_BOARD_CNXT_SHELBY:=0A=
 	case CX231XX_BOARD_CNXT_RDU_250:=0A=
 	case CX231XX_BOARD_CNXT_VIDEO_GRABBER:=0A=
+	case CX231XX_BOARD_OTG102:=0A=
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:=0A=
 		func_mode =3D 0x03;=0A=
 		break;=0A=
diff -uprN linux-3.6/drivers/media/video/cx231xx/cx231xx-cards.c =
linux-3.6.new/drivers/media/video/cx231xx/cx231xx-cards.c=0A=
--- linux-3.6/drivers/media/video/cx231xx/cx231xx-cards.c	2012-09-30 =
17:47:46.000000000 -0600=0A=
+++ linux-3.6.new/drivers/media/video/cx231xx/cx231xx-cards.c	2013-02-28 =
12:23:58.925869674 -0700=0A=
@@ -280,6 +280,37 @@ struct cx231xx_board cx231xx_boards[] =3D=0A=
 			}=0A=
 		},=0A=
 	},=0A=
+	[CX231XX_BOARD_OTG102] =3D {=0A=
+                .name =3D "Geniatech OTG102",=0A=
+                .tuner_type =3D TUNER_ABSENT,=0A=
+                .decoder =3D CX231XX_AVDECODER,=0A=
+                .output_mode =3D OUT_MODE_VIP11,=0A=
+                .ctl_pin_status_mask =3D 0xFFFFFFC4,=0A=
+                .agc_analog_digital_select_gpio =3D 0x0c, /* According =
with PV CxPlrCAP.inf file */=0A=
+                .gpio_pin_status_mask =3D 0x4001000,=0A=
+                .norm =3D V4L2_STD_NTSC,=0A=
+                .no_alt_vanc =3D 1,=0A=
+                .external_av =3D 1,=0A=
+                .dont_use_port_3 =3D 1,=0A=
+		//.has_417 =3D 1,=0A=
+		/* this board has hardware encoding chip supporting mpeg1/2/4, but as =
the 417 is apparently not working for the=0A=
+		   reference board it is not on this one either. building the driver =
with this option and then loading the module=0A=
+		   creates a second video device node, but nothing comes out of it.  =
*/=0A=
+                .input =3D {{=0A=
+                                .type =3D CX231XX_VMUX_COMPOSITE1,=0A=
+                                .vmux =3D CX231XX_VIN_2_1,=0A=
+                                .amux =3D CX231XX_AMUX_LINE_IN,=0A=
+                                .gpio =3D NULL,=0A=
+                        }, {=0A=
+                                .type =3D CX231XX_VMUX_SVIDEO,=0A=
+                                .vmux =3D CX231XX_VIN_1_1 |=0A=
+                                        (CX231XX_VIN_1_2 << 8) |=0A=
+                                        CX25840_SVIDEO_ON,=0A=
+                                .amux =3D CX231XX_AMUX_LINE_IN,=0A=
+                                .gpio =3D NULL,=0A=
+                        }=0A=
+                },=0A=
+        },=0A=
 	[CX231XX_BOARD_CNXT_RDE_250] =3D {=0A=
 		.name =3D "Conexant Hybrid TV - rde 250",=0A=
 		.tuner_type =3D TUNER_XC5000,=0A=
@@ -620,6 +651,8 @@ struct usb_device_id cx231xx_id_table[]=0A=
 	 .driver_info =3D CX231XX_BOARD_CNXT_RDU_253S},=0A=
 	{USB_DEVICE(0x0572, 0x58A6),=0A=
 	 .driver_info =3D CX231XX_BOARD_CNXT_VIDEO_GRABBER},=0A=
+	{USB_DEVICE(0x1F4D, 0x0102),=0A=
+	 .driver_info =3D CX231XX_BOARD_OTG102},=0A=
 	{USB_DEVICE(0x0572, 0x589E),=0A=
 	 .driver_info =3D CX231XX_BOARD_CNXT_RDE_250},=0A=
 	{USB_DEVICE(0x0572, 0x58A0),=0A=
@@ -904,6 +937,12 @@ static int cx231xx_init_dev(struct cx231=0A=
 		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);=0A=
 		cx231xx_set_alt_setting(dev, INDEX_VANC, 1);=0A=
 	}=0A=
+/*=0A=
+	if (dev->model =3D=3D CX231XX_OTG102) {=0A=
+		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);=0A=
+		cx231xx_set_alt_setting(dev, INDEX_VANC, 1);=0A=
+	}=0A=
+*/=0A=
 	/* Cx231xx pre card setup */=0A=
 	cx231xx_pre_card_setup(dev);=0A=
 =0A=
@@ -1295,6 +1334,12 @@ static int cx231xx_usb_probe(struct usb_=0A=
 		cx231xx_enable_OSC(dev);=0A=
 		cx231xx_reset_out(dev);=0A=
 		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);=0A=
+	}=0A=
+	=0A=
+	if (dev->model =3D=3D CX231XX_BOARD_OTG102) {=0A=
+		cx231xx_enable_OSC(dev);=0A=
+		cx231xx_reset_out(dev);=0A=
+		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);=0A=
 	}=0A=
 =0A=
 	if (dev->model =3D=3D CX231XX_BOARD_CNXT_RDE_253S)=0A=
diff -uprN linux-3.6/drivers/media/video/cx231xx/cx231xx.h =
linux-3.6.new/drivers/media/video/cx231xx/cx231xx.h=0A=
--- linux-3.6/drivers/media/video/cx231xx/cx231xx.h	2012-09-30 =
17:47:46.000000000 -0600=0A=
+++ linux-3.6.new/drivers/media/video/cx231xx/cx231xx.h	2013-02-26 =
16:01:58.924653199 -0700=0A=
@@ -68,6 +68,7 @@=0A=
 #define CX231XX_BOARD_ICONBIT_U100 13=0A=
 #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL 14=0A=
 #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC 15=0A=
+#define CX231XX_BOARD_OTG102 16=0A=
 =0A=
 /* Limits minimum and default number of buffers */=0A=
 #define CX231XX_MIN_BUF                 4=0A=

------=_NextPart_000_001A_01CE15D3.6CD7D550--

