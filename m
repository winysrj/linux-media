Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40277 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387714AbeHAVAK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 17:00:10 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 12/14] media: imx-csi: Move crop/compose reset after filling default mbus fields
Date: Wed,  1 Aug 2018 12:12:25 -0700
Message-Id: <1533150747-30677-13-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If caller passes un-initialized field type V4L2_FIELD_ANY to CSI
sink pad, the reset CSI crop window would not be correct, because
the crop window depends on a valid input field type. To fix move
the reset of crop and compose windows to after the call to
imx_media_fill_default_mbus_fields().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 139c694..6f24b3b 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1402,19 +1402,6 @@ static void csi_try_fmt(struct csi_priv *priv,
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
@@ -1430,6 +1417,20 @@ static void csi_try_fmt(struct csi_priv *priv,
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
2.7.4
