Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:35950 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758079AbdJRHW0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 03:22:26 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: i.MX6: 16-bit parallel CSI
Date: Wed, 18 Oct 2017 09:22:24 +0200
Message-ID: <m3y3o8kjin.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another thing. I'm using a 16-bit parallel CSI camera (with the so
called BT.1120, the 16-bit version of BT.656). Both BT.1120 and BT.656
send sync info embedded in the pixel data stream. The current code calls
for "passthrough" in 16-bit YCbCr (YUV) mode, though this isn't actually
required in such situation. "Passthrough" seems to be needed only when
the input is "generic data", e.g. in YCbCr (YUV) modes (no matter how
wide) with dedicated sync inputs (also with Bayer, Y and non-standard
stuff).

According to IMX6SDLIEC (i.MX 6Solo/6DualLite Applications Processors
for Industrial Products, 4.11.10.1 IPU Sensor Interface Signal Mapping),
even 20-bit YCbCr mode is supported with the "on-the-fly processing",
though I haven't tested it.

Currently drivers/staging/media/imx/imx-media-csi.c:
	/*
 	 * Check for conditions that require the IPU to handle the
 	 * data internally as generic data, aka passthrough mode:
 	 * - raw bayer formats
	 * - the sensor bus is 16-bit parallel
 	 */
@@ -353,19 +353,19 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	case V4L2_PIX_FMT_NV12:
 		burst_size = (image.pix.width & 0x3f) ?
 			     ((image.pix.width & 0x1f) ?
 			      ((image.pix.width & 0xf) ? 8 : 16) : 32) : 64;
 		passthrough = (sensor_ep->bus_type != V4L2_MBUS_CSI2 &&
			       sensor_ep->bus.parallel.bus_width >= 16);
 		passthrough_bits = 16;
 		break;
(and so on)

I wonder how to fix it. Should we simply drop the bus_width test, and
use other means of signalling that the incoming data should be treated
as "generic"? Perhaps it could depend on some mbus_cfg->type
(drivers/gpu/ipu-v3/ipu-csi.c), which is either V4L2_MBUS_PARALLEL,
V4L2_MBUS_BT656 or V4L2_MBUS_CSI2 (should we add V4L2_MBUS_BT1120 here?)
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
