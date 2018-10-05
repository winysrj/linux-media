Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34366 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728279AbeJEOqs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/11] v4l2-ioctl: add QUIRK_INVERTED_CROP
Date: Fri,  5 Oct 2018 09:49:03 +0200
Message-Id: <20181005074911.47574-4-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some old Samsung drivers use the legacy crop API incorrectly:
the crop and compose targets are swapped. Normally VIDIOC_G_CROP
will return the CROP rectangle of a CAPTURE stream and the COMPOSE
rectangle of an OUTPUT stream.

The Samsung drivers do the opposite. Note that these drivers predate
the selection API.

If this 'QUIRK' flag is set, then the v4l2-ioctl core will swap
the CROP and COMPOSE targets as well.

That way backwards compatibility is ensured and we can convert the
Samsung drivers to the selection API.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 17 ++++++++++++++++-
 include/media/v4l2-dev.h             | 13 +++++++++++--
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 9c2370e4d05c..63a92285de39 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2200,6 +2200,7 @@ static int v4l_s_selection(const struct v4l2_ioctl_ops *ops,
 static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_crop *p = arg;
 	struct v4l2_selection s = {
 		.type = p->type,
@@ -2216,6 +2217,10 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
 	else
 		s.target = V4L2_SEL_TGT_CROP;
 
+	if (test_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags))
+		s.target = s.target == V4L2_SEL_TGT_COMPOSE ?
+			V4L2_SEL_TGT_CROP : V4L2_SEL_TGT_COMPOSE;
+
 	ret = v4l_g_selection(ops, file, fh, &s);
 
 	/* copying results to old structure on success */
@@ -2227,6 +2232,7 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
 static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_crop *p = arg;
 	struct v4l2_selection s = {
 		.type = p->type,
@@ -2243,12 +2249,17 @@ static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
 	else
 		s.target = V4L2_SEL_TGT_CROP;
 
+	if (test_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags))
+		s.target = s.target == V4L2_SEL_TGT_COMPOSE ?
+			V4L2_SEL_TGT_CROP : V4L2_SEL_TGT_COMPOSE;
+
 	return v4l_s_selection(ops, file, fh, &s);
 }
 
 static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_cropcap *p = arg;
 	struct v4l2_selection s = { .type = p->type };
 	int ret = 0;
@@ -2285,13 +2296,17 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 	else
 		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
 
+	if (test_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags))
+		s.target = s.target == V4L2_SEL_TGT_COMPOSE_BOUNDS ?
+			V4L2_SEL_TGT_CROP_BOUNDS : V4L2_SEL_TGT_COMPOSE_BOUNDS;
+
 	ret = v4l_g_selection(ops, file, fh, &s);
 	if (ret)
 		return ret;
 	p->bounds = s.r;
 
 	/* obtaining defrect */
-	if (V4L2_TYPE_IS_OUTPUT(p->type))
+	if (s.target == V4L2_SEL_TGT_COMPOSE_BOUNDS)
 		s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
 	else
 		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 456ac13eca1d..48531e57cc5a 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -74,10 +74,19 @@ struct v4l2_ctrl_handler;
  *	indicates that file->private_data points to &struct v4l2_fh.
  *	This flag is set by the core when v4l2_fh_init() is called.
  *	All new drivers should use it.
+ * @V4L2_FL_QUIRK_INVERTED_CROP:
+ *	some old M2M drivers use g/s_crop/cropcap incorrectly: crop and
+ *	compose are swapped. If this flag is set, then the selection
+ *	targets are swapped in the g/s_crop/cropcap functions in v4l2-ioctl.c.
+ *	This allows those drivers to correctly implement the selection API,
+ *	but the old crop API will still work as expected in order to preserve
+ *	backwards compatibility.
+ *	Never set this flag for new drivers.
  */
 enum v4l2_video_device_flags {
-	V4L2_FL_REGISTERED	= 0,
-	V4L2_FL_USES_V4L2_FH	= 1,
+	V4L2_FL_REGISTERED		= 0,
+	V4L2_FL_USES_V4L2_FH		= 1,
+	V4L2_FL_QUIRK_INVERTED_CROP	= 2,
 };
 
 /* Priority helper functions */
-- 
2.18.0
