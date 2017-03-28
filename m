Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34771 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754066AbdC1Ami (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:42:38 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v6 26/39] media: imx: add support for bayer formats
Date: Mon, 27 Mar 2017 17:40:43 -0700
Message-Id: <1490661656-10318-27-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@armlinux.org.uk>

Add the bayer formats to imx-media's list of supported pixel and bus
formats.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

- added a bayer boolean to struct imx_media_pixfmt.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-utils.c | 68 +++++++++++++++++++++++++++++
 drivers/staging/media/imx/imx-media.h       |  1 +
 2 files changed, 69 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 3e94179..83d227d 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -61,6 +61,74 @@ static const struct imx_media_pixfmt imx_media_formats[] = {
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 32,
 		.ipufmt = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SBGGR8,
+		.codes  = {MEDIA_BUS_FMT_SBGGR8_1X8},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 8,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGBRG8,
+		.codes  = {MEDIA_BUS_FMT_SGBRG8_1X8},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 8,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGRBG8,
+		.codes  = {MEDIA_BUS_FMT_SGRBG8_1X8},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 8,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SRGGB8,
+		.codes  = {MEDIA_BUS_FMT_SRGGB8_1X8},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 8,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SBGGR16,
+		.codes  = {
+			MEDIA_BUS_FMT_SBGGR10_1X10,
+			MEDIA_BUS_FMT_SBGGR12_1X12,
+			MEDIA_BUS_FMT_SBGGR14_1X14,
+			MEDIA_BUS_FMT_SBGGR16_1X16
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGBRG16,
+		.codes  = {
+			MEDIA_BUS_FMT_SGBRG10_1X10,
+			MEDIA_BUS_FMT_SGBRG12_1X12,
+			MEDIA_BUS_FMT_SGBRG14_1X14,
+			MEDIA_BUS_FMT_SGBRG16_1X16,
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGRBG16,
+		.codes  = {
+			MEDIA_BUS_FMT_SGRBG10_1X10,
+			MEDIA_BUS_FMT_SGRBG12_1X12,
+			MEDIA_BUS_FMT_SGRBG14_1X14,
+			MEDIA_BUS_FMT_SGRBG16_1X16,
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SRGGB16,
+		.codes  = {
+			MEDIA_BUS_FMT_SRGGB10_1X10,
+			MEDIA_BUS_FMT_SRGGB12_1X12,
+			MEDIA_BUS_FMT_SRGGB14_1X14,
+			MEDIA_BUS_FMT_SRGGB16_1X16,
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
 	},
 	/*** non-mbus formats start here ***/
 	{
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 96a6931..b991081 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -91,6 +91,7 @@ struct imx_media_pixfmt {
 	int     bpp;     /* total bpp */
 	enum ipu_color_space cs;
 	bool    planar;  /* is a planar format */
+	bool    bayer;   /* is a raw bayer format */
 	bool    ipufmt;  /* is one of the IPU internal formats */
 };
 
-- 
2.7.4
