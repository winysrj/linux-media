Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40514 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbeJEBtL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 21:49:11 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 09/11] media: imx-csi: Move crop/compose reset after filling default mbus fields
Date: Thu,  4 Oct 2018 11:53:59 -0700
Message-Id: <20181004185401.15751-10-slongerbeam@gmail.com>
In-Reply-To: <20181004185401.15751-1-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If caller passes un-initialized field type V4L2_FIELD_ANY to CSI
sink pad, the reset CSI crop window would not be correct, because
the crop window depends on a valid input field type. To fix move
the reset of crop and compose windows to after the call to
imx_media_fill_default_mbus_fields().

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 27 ++++++++++++-----------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6dd53a8e35d2..679295da5dde 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1405,19 +1405,6 @@ static void csi_try_fmt(struct csi_priv *priv,
 				      W_ALIGN, &sdformat->format.height,
 				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
 
-		/* Reset crop and compose rectangles */
-		crop->left = 0;
-		crop->top = 0;
-		crop->width = sdformat->format.width;
-		crop->height = sdformat->format.height;
-		if (sdformat->format.field == V4L2_FIELD_ALTERNATE)
-			crop->height *= 2;
-		csi_try_crop(priv, crop, cfg, &sdformat->format, upstream_ep);
-		compose->left = 0;
-		compose->top = 0;
-		compose->width = crop->width;
-		compose->height = crop->height;
-
 		*cc = imx_media_find_mbus_format(sdformat->format.code,
 						 CS_SEL_ANY, true);
 		if (!*cc) {
@@ -1433,6 +1420,20 @@ static void csi_try_fmt(struct csi_priv *priv,
 		imx_media_fill_default_mbus_fields(
 			&sdformat->format, infmt,
 			priv->active_output_pad == CSI_SRC_PAD_DIRECT);
+
+		/* Reset crop and compose rectangles */
+		crop->left = 0;
+		crop->top = 0;
+		crop->width = sdformat->format.width;
+		crop->height = sdformat->format.height;
+		if (sdformat->format.field == V4L2_FIELD_ALTERNATE)
+			crop->height *= 2;
+		csi_try_crop(priv, crop, cfg, &sdformat->format, upstream_ep);
+		compose->left = 0;
+		compose->top = 0;
+		compose->width = crop->width;
+		compose->height = crop->height;
+
 		break;
 	}
 }
-- 
2.17.1
