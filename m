Return-path: <mchehab@pedra>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52629 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752583Ab1AQJ4m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 04:56:42 -0500
From: Qing Xu <qingx@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 17 Jan 2011 01:53:00 -0800
Subject: soc-camera jpeg support?
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D014040BF237@SC-VEXCH2.marvell.com>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040171EE@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101100853490.24479@axis700.grange>
 <201101101133.01636.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101101133.01636.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Many of our sensors support directly outputting JPEG data to camera controller, do you feel it's reasonable to add jpeg support into soc-camera? As it seems that there is no define in v4l2-mediabus.h which is suitable for our case.

Such as:
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -130,6 +130,13 @@ static const struct soc_mbus_pixelfmt mbus_fmt[] = {
                .packing                = SOC_MBUS_PACKING_2X8_PADLO,
                .order                  = SOC_MBUS_ORDER_BE,
        },
+       [MBUS_IDX(JPEG_1X8)] = {
+               .fourcc                 = V4L2_PIX_FMT_JPEG,
+               .name                   = "JPEG",
+               .bits_per_sample        = 8,
+               .packing                = SOC_MBUS_PACKING_NONE,
+               .order                  = SOC_MBUS_ORDER_LE,
+       },
 };

--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -41,6 +41,7 @@ enum v4l2_mbus_pixelcode {
        V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
        V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
        V4L2_MBUS_FMT_SGRBG8_1X8,
+       V4L2_MBUS_FMT_JPEG_1X8,
 };

Any ideas will be appreciated!
Thanks!
Qing Xu

Email: qingx@marvell.com
Application Processor Systems Engineering,
Marvell Technology Group Ltd.
