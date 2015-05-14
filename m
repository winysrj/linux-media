Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422657AbbENW2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 18:28:05 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>
Subject: [PATCH] ov2659: Don't depend on subdev API
Date: Thu, 14 May 2015 19:27:45 -0300
Message-Id: <da8b930d38345df38bac8971f570f6ffdff3b8b6.1431642235.git.mchehab@osg.samsung.com>
In-Reply-To: <554A00F2.5000007@bmw-carit.de>
References: <554A00F2.5000007@bmw-carit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The subdev API is optional. No driver should depend on it.

Avoid compilation breakages if subdev API is not selected:

drivers/media/i2c/ov2659.c: In function ‘ov2659_get_fmt’:
drivers/media/i2c/ov2659.c:1054:3: error: implicit declaration of function ‘v4l2_subdev_get_try_format’ [-Werror=implicit-function-declaration]
   mf = v4l2_subdev_get_try_format(sd, cfg, 0);
   ^
drivers/media/i2c/ov2659.c:1054:6: warning: assignment makes pointer from integer without a cast
   mf = v4l2_subdev_get_try_format(sd, cfg, 0);
      ^
drivers/media/i2c/ov2659.c: In function ‘ov2659_set_fmt’:
drivers/media/i2c/ov2659.c:1129:6: warning: assignment makes pointer from integer without a cast
   mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
      ^
drivers/media/i2c/ov2659.c: In function ‘ov2659_open’:
drivers/media/i2c/ov2659.c:1264:38: error: ‘struct v4l2_subdev_fh’ has no member named ‘pad’
     v4l2_subdev_get_try_format(sd, fh->pad, 0);
                                      ^

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---

Prabhakar,

Please test this patch with the subdev API config option disabled
(CONFIG_VIDEO_V4L2_SUBDEV_API).

If it doesn't work, please fix and re-submit the patch. It should be
possible to use any sensor without the need of having the subdev API
enabled.

Thanks!
Mauro

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index c8615f7f2627..6edffc7b74e3 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1046,16 +1046,21 @@ static int ov2659_get_fmt(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov2659 *ov2659 = to_ov2659(sd);
-	struct v4l2_mbus_framefmt *mf;
 
 	dev_dbg(&client->dev, "ov2659_get_fmt\n");
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
+		struct v4l2_mbus_framefmt *mf;
+
 		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 		mutex_lock(&ov2659->lock);
 		fmt->format = *mf;
 		mutex_unlock(&ov2659->lock);
 		return 0;
+#else
+	return -ENOTTY;
+#endif
 	}
 
 	mutex_lock(&ov2659->lock);
@@ -1126,8 +1131,12 @@ static int ov2659_set_fmt(struct v4l2_subdev *sd,
 	mutex_lock(&ov2659->lock);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		*mf = fmt->format;
+#else
+		return -ENOTTY;
+#endif
 	} else {
 		s64 val;
 
@@ -1257,6 +1266,7 @@ static const char * const ov2659_test_pattern_menu[] = {
  * V4L2 subdev internal operations
  */
 
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 static int ov2659_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -1269,6 +1279,7 @@ static int ov2659_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	return 0;
 }
+#endif
 
 static const struct v4l2_subdev_core_ops ov2659_subdev_core_ops = {
 	.log_status = v4l2_ctrl_subdev_log_status,
@@ -1287,6 +1298,7 @@ static const struct v4l2_subdev_pad_ops ov2659_subdev_pad_ops = {
 	.set_fmt = ov2659_set_fmt,
 };
 
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 static const struct v4l2_subdev_ops ov2659_subdev_ops = {
 	.core  = &ov2659_subdev_core_ops,
 	.video = &ov2659_subdev_video_ops,
@@ -1296,6 +1308,7 @@ static const struct v4l2_subdev_ops ov2659_subdev_ops = {
 static const struct v4l2_subdev_internal_ops ov2659_subdev_internal_ops = {
 	.open = ov2659_open,
 };
+#endif
 
 static int ov2659_detect(struct v4l2_subdev *sd)
 {
@@ -1426,11 +1439,13 @@ static int ov2659_probe(struct i2c_client *client,
 
 	sd = &ov2659->sd;
 	client->flags |= I2C_CLIENT_SCCB;
+#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 	v4l2_i2c_subdev_init(sd, client, &ov2659_subdev_ops);
 
 	sd->internal_ops = &ov2659_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
 		     V4L2_SUBDEV_FL_HAS_EVENTS;
+#endif
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	ov2659->pad.flags = MEDIA_PAD_FL_SOURCE;
-- 
2.1.0

