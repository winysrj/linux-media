Return-path: <mchehab@localhost>
Received: from mail.juropnet.hu ([212.24.188.131]:55790 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab1GKOCc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 10:02:32 -0400
Received: from [94.248.228.50] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QgH40-00070M-71
	for linux-media@vger.kernel.org; Mon, 11 Jul 2011 16:02:31 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] cx88: implemented sharpness control
MIME-Version: 1.0
Date: Mon, 11 Jul 2011 16:02:19 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111602.19656.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This patch implements support for a sharpness control, using the luma
peaking filter feature of cx2388x.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-core.c xc4000/drivers/media/video/cx88/cx88-core.c
--- xc4000_orig/drivers/media/video/cx88/cx88-core.c	2011-07-08 17:01:47.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-core.c	2011-07-11 15:21:56.000000000 +0200
@@ -759,8 +759,8 @@
 	if (nocomb)
 		value |= (3 << 5); // disable comb filter
 
-	cx_write(MO_FILTER_EVEN,  value);
-	cx_write(MO_FILTER_ODD,   value);
+	cx_write(MO_FILTER_EVEN,  0x7ffc7f, value); /* preserve PEAKEN, PSEL */
+	cx_write(MO_FILTER_ODD,   0x7ffc7f, value);
 	dprintk(1,"set_scale: filter  0x%04x\n", value);
 
 	return 0;
diff -uNr xc4000_orig/drivers/media/video/cx88/cx88-video.c xc4000/drivers/media/video/cx88/cx88-video.c
--- xc4000_orig/drivers/media/video/cx88/cx88-video.c	2011-07-08 17:01:47.000000000 +0200
+++ xc4000/drivers/media/video/cx88/cx88-video.c	2011-07-11 15:31:32.000000000 +0200
@@ -221,7 +221,23 @@
 		.reg                   = MO_UV_SATURATION,
 		.mask                  = 0x00ff,
 		.shift                 = 0,
-	},{
+	}, {
+		.v = {
+			.id            = V4L2_CID_SHARPNESS,
+			.name          = "Sharpness",
+			.minimum       = 0,
+			.maximum       = 4,
+			.step          = 1,
+			.default_value = 0x0,
+			.type          = V4L2_CTRL_TYPE_INTEGER,
+		},
+		.off                   = 0,
+		/* NOTE: the value is converted and written to both even
+		   and odd registers in the code */
+		.reg                   = MO_FILTER_ODD,
+		.mask                  = 7 << 7,
+		.shift                 = 7,
+	}, {
 		.v = {
 			.id            = V4L2_CID_CHROMA_AGC,
 			.name          = "Chroma AGC",
@@ -301,6 +317,7 @@
 	V4L2_CID_AUDIO_VOLUME,
 	V4L2_CID_AUDIO_BALANCE,
 	V4L2_CID_AUDIO_MUTE,
+	V4L2_CID_SHARPNESS,
 	V4L2_CID_CHROMA_AGC,
 	V4L2_CID_COLOR_KILLER,
 	0
@@ -963,6 +980,10 @@
 	case V4L2_CID_AUDIO_VOLUME:
 		ctl->value = 0x3f - (value & 0x3f);
 		break;
+	case V4L2_CID_SHARPNESS:
+		ctl->value = ((value & 0x0200) ? (((value & 0x0180) >> 7) + 1)
+						 : 0);
+		break;
 	default:
 		ctl->value = ((value + (c->off << c->shift)) & c->mask) >> c->shift;
 		break;
@@ -1040,6 +1061,12 @@
 		}
 		mask=0xffff;
 		break;
+	case V4L2_CID_SHARPNESS:
+		/* 0b000, 0b100, 0b101, 0b110, or 0b111 */
+		value = (ctl->value < 1 ? 0 : ((ctl->value + 3) << 7));
+		/* needs to be set for both fields */
+		cx_andor(MO_FILTER_EVEN, mask, value);
+		break;
 	case V4L2_CID_CHROMA_AGC:
 		/* Do not allow chroma AGC to be enabled for SECAM */
 		value = ((ctl->value - c->off) << c->shift) & c->mask;
