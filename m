Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50598 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752125AbaJBIrK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:47:10 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 16/18] smiapp: Clean up smiapp_set_format()
Date: Thu,  2 Oct 2014 11:46:06 +0300
Message-Id: <1412239568-8524-17-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smiapp_set_format() has accumulated a fair amount of changes without a
needed refactoring, do the cleanup now. There's also an unlocked version of
v4l2_ctrl_range_changed(), using that fixes a small serialisation issue with
the user space interface.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   65 +++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 926f60c..cf8eba8 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1728,6 +1728,42 @@ static const struct smiapp_csi_data_format
 	return csi_format;
 }
 
+static int smiapp_set_format_source(struct v4l2_subdev *subdev,
+				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_format *fmt)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	const struct smiapp_csi_data_format *csi_format,
+		*old_csi_format = sensor->csi_format;
+	u32 code = fmt->format.code;
+	unsigned int i;
+	int rval;
+
+	rval = __smiapp_get_format(subdev, fh, fmt);
+	if (rval)
+		return rval;
+
+	if (subdev != &sensor->src->sd)
+		return 0;
+
+	csi_format = smiapp_validate_csi_data_format(sensor, code);
+
+	fmt->format.code = csi_format->code;
+
+	if (fmt->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+		return 0;
+
+	sensor->csi_format = csi_format;
+
+	if (csi_format->width != old_csi_format->width)
+		for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++)
+			__v4l2_ctrl_modify_range(
+				sensor->test_data[i], 0,
+				(1 << csi_format->width) - 1, 1, 0);
+
+	return 0;
+}
+
 static int smiapp_set_format(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_fh *fh,
 			     struct v4l2_subdev_format *fmt)
@@ -1743,36 +1779,13 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 	 * other source pads we just get format here.
 	 */
 	if (fmt->pad == ssd->source_pad) {
-		u32 code = fmt->format.code;
-		int rval = __smiapp_get_format(subdev, fh, fmt);
-		bool range_changed = false;
-		unsigned int i;
-
-		if (!rval && subdev == &sensor->src->sd) {
-			const struct smiapp_csi_data_format *csi_format =
-				smiapp_validate_csi_data_format(sensor, code);
+		int rval;
 
-			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-				if (csi_format->width !=
-				    sensor->csi_format->width)
-					range_changed = true;
-
-				sensor->csi_format = csi_format;
-			}
-
-			fmt->format.code = csi_format->code;
-		}
+		rval = smiapp_set_format_source(subdev, fh, fmt);
 
 		mutex_unlock(&sensor->mutex);
-		if (rval || !range_changed)
-			return rval;
-
-		for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++)
-			v4l2_ctrl_modify_range(
-				sensor->test_data[i],
-				0, (1 << sensor->csi_format->width) - 1, 1, 0);
 
-		return 0;
+		return rval;
 	}
 
 	/* Sink pad. Width and height are changeable here. */
-- 
1.7.10.4

