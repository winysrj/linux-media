Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:44466 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab0C0Mbp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 08:31:45 -0400
Received: from kabelnet-194-37.juropnet.hu ([91.147.194.37])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NvVAz-0006xo-Kb
	for linux-media@vger.kernel.org; Sat, 27 Mar 2010 13:31:44 +0100
Message-ID: <4BADFC12.4030707@mailbox.hu>
Date: Sat, 27 Mar 2010 13:37:38 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] cx88: implement sharpness control
Content-Type: multipart/mixed;
 boundary="------------090004070906010201070009"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090004070906010201070009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch adds support for V4L2_CID_SHARPNESS by changing the luma peak
filter and notch filter. It can be set in the range 0 to 9, with 0 being
the original and default mode.
One minor problem is that other code that sets the registers being used
(for example when switching TV channels) could reset the control to the
default. This could be avoided by making changes so that the bits used
to implement this control are not overwritten.

Signed-off-by: Istvan Varga <istvanv@users.sourceforge.net>

--------------090004070906010201070009
Content-Type: text/x-patch;
 name="cx88-sharpness.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx88-sharpness.patch"

diff -r -d -N -U4 v4l-dvb-a79dd2ae4d0e.old/linux/drivers/media/video/cx88/cx88-video.c v4l-dvb-a79dd2ae4d0e/linux/drivers/media/video/cx88/cx88-video.c
--- v4l-dvb-a79dd2ae4d0e.old/linux/drivers/media/video/cx88/cx88-video.c	2010-03-23 03:39:52.000000000 +0100
+++ v4l-dvb-a79dd2ae4d0e/linux/drivers/media/video/cx88/cx88-video.c	2010-03-23 19:07:26.000000000 +0100
@@ -220,9 +220,24 @@
 		.off                   = 0,
 		.reg                   = MO_UV_SATURATION,
 		.mask                  = 0x00ff,
 		.shift                 = 0,
-	},{
+	}, {
+		.v = {
+			.id            = V4L2_CID_SHARPNESS,
+			.name          = "Sharpness",
+			.minimum       = 0,
+			.maximum       = 9,
+			.default_value = 0x0,
+			.type          = V4L2_CTRL_TYPE_INTEGER,
+		},
+		.off		       = 0,
+		/* NOTE: the value is converted and written to both even
+		   and odd registers in the code */
+		.reg                   = MO_FILTER_ODD,
+		.mask                  = 7 << 7,
+		.shift                 = 7,
+	}, {
 		.v = {
 			.id            = V4L2_CID_CHROMA_AGC,
 			.name          = "Chroma AGC",
 			.minimum       = 0,
@@ -300,8 +315,9 @@
 	V4L2_CID_HUE,
 	V4L2_CID_AUDIO_VOLUME,
 	V4L2_CID_AUDIO_BALANCE,
 	V4L2_CID_AUDIO_MUTE,
+	V4L2_CID_SHARPNESS,
 	V4L2_CID_CHROMA_AGC,
 	V4L2_CID_COLOR_KILLER,
 	0
 };
@@ -1187,8 +1203,13 @@
 		break;
 	case V4L2_CID_AUDIO_VOLUME:
 		ctl->value = 0x3f - (value & 0x3f);
 		break;
+	case V4L2_CID_SHARPNESS:
+		ctl->value = (value & 0x0380) >> 6;
+		ctl->value = (ctl->value < 8 ? 0 : (ctl->value - 6))
+			     | ((cx_read(MO_HTOTAL) & 0x0800) >> 11);
+		break;
 	default:
 		ctl->value = ((value + (c->off << c->shift)) & c->mask) >> c->shift;
 		break;
 	}
@@ -1246,8 +1267,16 @@
 			value=(value*0x5a)/0x7f<<8|value;
 		}
 		mask=0xffff;
 		break;
+	case V4L2_CID_SHARPNESS:
+		/* use 4xFsc or square pixel notch filter */
+		cx_andor(MO_HTOTAL, 0x1800, (ctl->value & 1) << 11);
+		/* 0b000, 0b100, 0b101, 0b110, or 0b111 */
+		value = (ctl->value < 2 ? 0 : (((ctl->value + 6) & 0x0E) << 6));
+		/* needs to be set for both fields */
+		cx_andor(MO_FILTER_EVEN, mask, value);
+		break;
 	case V4L2_CID_CHROMA_AGC:
 		/* Do not allow chroma AGC to be enabled for SECAM */
 		value = ((ctl->value - c->off) << c->shift) & c->mask;
 		if (core->tvnorm & V4L2_STD_SECAM && value)

--------------090004070906010201070009--
