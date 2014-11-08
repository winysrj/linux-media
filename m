Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52946 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753263AbaKHXFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:05:17 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 3/3] smiapp: Support V4L2_SEL_TGT_NATIVE_SIZE
Date: Sun,  9 Nov 2014 01:04:32 +0200
Message-Id: <1415487872-27500-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1415487872-27500-1-git-send-email-sakari.ailus@iki.fi>
References: <1415487872-27500-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for selection target V4L2_SEL_TGT_NATIVE_SIZE. It is equivalent
of what V4L2_SEL_TGT_CROP_BOUNDS used to be. Support for
V4L2_SEL_TGT_CROP_BOUNDS is still supported by the driver as a compatibility
interface.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index bcc5866..e2d2b8f 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2092,6 +2092,11 @@ static int __smiapp_sel_supported(struct v4l2_subdev *subdev,
 		    == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP)
 			return 0;
 		return -EINVAL;
+	case V4L2_SEL_TGT_NATIVE_SIZE:
+		if (ssd == sensor->pixel_array
+		    && sel->pad == SMIAPP_PA_PAD_SRC)
+			return 0;
+		return -EINVAL;
 	case V4L2_SEL_TGT_COMPOSE:
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		if (sel->pad == ssd->source_pad)
@@ -2190,6 +2195,7 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_NATIVE_SIZE:
 		if (ssd == sensor->pixel_array) {
 			sel->r.width =
 				sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-- 
1.7.10.4

