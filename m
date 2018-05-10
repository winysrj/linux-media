Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:37364 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756736AbeEJI16 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 04:27:58 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: i.MX6 IPU CSI analog video input on Ventana
Date: Thu, 10 May 2018 10:19:11 +0200
Message-ID: <m37eobudmo.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using analog PAL video in on GW53xx/54xx boards (through ADV7180
chip and 8-bit parallel CSI input, with (presumably) BT.656).
I'm trying to upgrade from e.g. Linux 4.2 + Steve's older MX6 camera
driver (which works fine) to v.4.16 with the recently merged driver.

media-ctl -r -l '"adv7180 2-0020":0->"ipu2_csi1_mux":1[1],
                 "ipu2_csi1_mux":2->"ipu2_csi1":0[1],
                 "ipu2_csi1":2->"ipu2_csi1 capture":0[1]'

media-ctl -V '"adv7180 2-0020":0[fmt:UYVY2X8 720x576 field:interlaced]'
media-ctl -V '"ipu2_csi1_mux":1[fmt:UYVY2X8 720x576 field:interlaced]'
media-ctl -V '"ipu2_csi1_mux":2[fmt:UYVY2X8 720x576 field:interlaced]'

It seems there are issues, though:

First, I can't find a way to change to PAL standard. *s_std() doesn't
propagate from "ipu2_csi1 capture" through "ipu2_csi1_mux" to adv7180.

For now I have just changed the default:
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1320,7 +1321,7 @@ static int adv7180_probe(struct i2c_client *client,
 
     state->irq = client->irq;
     mutex_init(&state->mutex);
-    state->curr_norm = V4L2_STD_NTSC;
+    state->curr_norm = V4L2_STD_PAL;
     if (state->chip_info->flags & ADV7180_FLAG_RESET_POWERED)
         state->powered = true;
     else


Second, the image format information I'm getting out of "ipu2_csi1
capture" device is:

open("/dev/video6")
ioctl(VIDIOC_S_FMT, {V4L2_BUF_TYPE_VIDEO_CAPTURE,
	fmt.pix={704x576, pixelformat=NV12, V4L2_FIELD_INTERLACED} =>
	fmt.pix={720x576, pixelformat=NV12, V4L2_FIELD_INTERLACED,
        bytesperline=720, sizeimage=622080,
	colorspace=V4L2_COLORSPACE_SMPTE170M}})

Now, the resulting image obtained via QBUF/DQBUF doesn't seem to be
a single interlaced frame (like it was with older drivers). Actually,
I'm getting the two fields, encoded with NV12 and concatenated
together (I think it's V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT).

What's wrong?
Is it possible to get a real V4L2_FIELD_INTERLACED frame, so it can be
passed straight to the CODA H.264 encoder?
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
