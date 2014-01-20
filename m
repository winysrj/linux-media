Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3971 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaATJ1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 04:27:30 -0500
Message-ID: <52DCEBED.2010603@xs4all.nl>
Date: Mon, 20 Jan 2014 10:27:09 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] s3c-camif: Remove use of deprecated V4L2_CTRL_FLAG_DISABLED.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I came across this while checking the kernel use of V4L2_CTRL_FLAG_DISABLED.

This flag should not be used with the control framework. Instead, just don't
add the control at all.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 40b298a..5372111 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1592,26 +1592,27 @@ int s3c_camif_create_subdev(struct camif_dev *camif)
 			ARRAY_SIZE(s3c_camif_test_pattern_menu) - 1, 0, 0,
 			s3c_camif_test_pattern_menu);
 
-	camif->ctrl_colorfx = v4l2_ctrl_new_std_menu(handler,
+	if (camif->variant->has_img_effect) {
+		camif->ctrl_colorfx = v4l2_ctrl_new_std_menu(handler,
 				&s3c_camif_subdev_ctrl_ops,
 				V4L2_CID_COLORFX, V4L2_COLORFX_SET_CBCR,
 				~0x981f, V4L2_COLORFX_NONE);
 
-	camif->ctrl_colorfx_cbcr = v4l2_ctrl_new_std(handler,
+		camif->ctrl_colorfx_cbcr = v4l2_ctrl_new_std(handler,
 				&s3c_camif_subdev_ctrl_ops,
 				V4L2_CID_COLORFX_CBCR, 0, 0xffff, 1, 0);
+	}
+
 	if (handler->error) {
 		v4l2_ctrl_handler_free(handler);
 		media_entity_cleanup(&sd->entity);
 		return handler->error;
 	}
 
-	v4l2_ctrl_auto_cluster(2, &camif->ctrl_colorfx,
+	if (camif->variant->has_img_effect)
+		v4l2_ctrl_auto_cluster(2, &camif->ctrl_colorfx,
 			       V4L2_COLORFX_SET_CBCR, false);
-	if (!camif->variant->has_img_effect) {
-		camif->ctrl_colorfx->flags |= V4L2_CTRL_FLAG_DISABLED;
-		camif->ctrl_colorfx_cbcr->flags |= V4L2_CTRL_FLAG_DISABLED;
-	}
+
 	sd->ctrl_handler = handler;
 	v4l2_set_subdevdata(sd, camif);
 
-- 
1.8.4.rc3

