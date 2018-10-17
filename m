Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43291 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeJQHxh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 03:53:37 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 06/12] media: imx-csi: Double crop height for alternate fields at sink
Date: Tue, 16 Oct 2018 17:00:21 -0700
Message-Id: <20181017000027.23696-7-slongerbeam@gmail.com>
In-Reply-To: <20181017000027.23696-1-slongerbeam@gmail.com>
References: <20181017000027.23696-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the incoming sink field type is alternate, the reset crop height
and crop height bounds must be set to twice the incoming height,
because in alternate field mode, upstream will report only the
lines for a single field, and the CSI captures the whole frame.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 8f52428d2c75..d5b0f8a66750 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1140,6 +1140,8 @@ static void csi_try_crop(struct csi_priv *priv,
 			 struct v4l2_mbus_framefmt *infmt,
 			 struct v4l2_fwnode_endpoint *upstream_ep)
 {
+	u32 in_height;
+
 	crop->width = min_t(__u32, infmt->width, crop->width);
 	if (crop->left + crop->width > infmt->width)
 		crop->left = infmt->width - crop->width;
@@ -1147,6 +1149,10 @@ static void csi_try_crop(struct csi_priv *priv,
 	crop->left &= ~0x3;
 	crop->width &= ~0x7;
 
+	in_height = infmt->height;
+	if (infmt->field == V4L2_FIELD_ALTERNATE)
+		in_height *= 2;
+
 	/*
 	 * FIXME: not sure why yet, but on interlaced bt.656,
 	 * changing the vertical cropping causes loss of vertical
@@ -1156,12 +1162,12 @@ static void csi_try_crop(struct csi_priv *priv,
 	if (upstream_ep->bus_type == V4L2_MBUS_BT656 &&
 	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
 	     infmt->field == V4L2_FIELD_ALTERNATE)) {
-		crop->height = infmt->height;
-		crop->top = (infmt->height == 480) ? 2 : 0;
+		crop->height = in_height;
+		crop->top = (in_height == 480) ? 2 : 0;
 	} else {
-		crop->height = min_t(__u32, infmt->height, crop->height);
-		if (crop->top + crop->height > infmt->height)
-			crop->top = infmt->height - crop->height;
+		crop->height = min_t(__u32, in_height, crop->height);
+		if (crop->top + crop->height > in_height)
+			crop->top = in_height - crop->height;
 	}
 }
 
@@ -1401,6 +1407,8 @@ static void csi_try_fmt(struct csi_priv *priv,
 		crop->top = 0;
 		crop->width = sdformat->format.width;
 		crop->height = sdformat->format.height;
+		if (sdformat->format.field == V4L2_FIELD_ALTERNATE)
+			crop->height *= 2;
 		csi_try_crop(priv, crop, cfg, &sdformat->format, upstream_ep);
 		compose->left = 0;
 		compose->top = 0;
@@ -1528,6 +1536,8 @@ static int csi_get_selection(struct v4l2_subdev *sd,
 		sel->r.top = 0;
 		sel->r.width = infmt->width;
 		sel->r.height = infmt->height;
+		if (infmt->field == V4L2_FIELD_ALTERNATE)
+			sel->r.height *= 2;
 		break;
 	case V4L2_SEL_TGT_CROP:
 		sel->r = *crop;
-- 
2.17.1
