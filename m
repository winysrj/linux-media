Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46493 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752045AbaKRFkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:40:42 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl
Subject: [REVIEW PATCH v2 5/5] smiapp: Support V4L2_SEL_TGT_NATIVE_SIZE
Date: Tue, 18 Nov 2014 07:40:20 +0200
Message-Id: <1416289220-32673-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
References: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
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
index 022ad44..65e4e05 100644
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
 			sel->r.left = sel->r.top = 0;
 			sel->r.width =
-- 
1.7.10.4

