Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3ACSe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 13:34:29 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 2/3] sh_vou: Use video_drvdata()
Date: Thu,  3 Jan 2013 19:35:56 +0100
Message-Id: <1357238157-18115-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1357238157-18115-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1357238157-18115-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace video_devdata() followed by video_get_drvdata() calls with
video_drvdata().

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/sh_vou.c |   57 ++++++++++++++------------------------
 1 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 43278de..02c1b5c 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -419,8 +419,7 @@ static int sh_vou_enum_fmt_vid_out(struct file *file, void  *priv,
 static int sh_vou_g_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
@@ -671,8 +670,7 @@ static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct v4l2_pix_format *pix = &fmt->fmt.pix;
 	unsigned int img_height_max;
 	int pix_idx;
@@ -829,8 +827,7 @@ static int sh_vou_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 static int sh_vou_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type buftype)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = priv;
 	int ret;
 
@@ -848,8 +845,7 @@ static int sh_vou_streamon(struct file *file, void *priv,
 static int sh_vou_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type buftype)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = priv;
 
 	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
@@ -881,13 +877,12 @@ static u32 sh_vou_ntsc_mode(enum sh_vou_bus_fmt bus_fmt)
 
 static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	int ret;
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s(): 0x%llx\n", __func__, *std_id);
 
-	if (*std_id & ~vdev->tvnorms)
+	if (*std_id & ~vou_dev->vdev->tvnorms)
 		return -EINVAL;
 
 	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, video,
@@ -909,8 +904,7 @@ static int sh_vou_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 
 static int sh_vou_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
@@ -921,8 +915,7 @@ static int sh_vou_g_std(struct file *file, void *priv, v4l2_std_id *std)
 
 static int sh_vou_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
@@ -935,8 +928,7 @@ static int sh_vou_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
 /* Assume a dull encoder, do all the work ourselves. */
 static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	const struct v4l2_rect *rect = &a->c;
 	struct v4l2_crop sd_crop = {.type = V4L2_BUF_TYPE_VIDEO_OUTPUT};
 	struct v4l2_pix_format *pix = &vou_dev->pix;
@@ -1159,8 +1151,7 @@ static int sh_vou_hw_init(struct sh_vou_device *vou_dev)
 /* File operations */
 static int sh_vou_open(struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = kzalloc(sizeof(struct sh_vou_file),
 					       GFP_KERNEL);
 
@@ -1177,11 +1168,11 @@ static int sh_vou_open(struct file *file)
 		int ret;
 		/* First open */
 		vou_dev->status = SH_VOU_INITIALISING;
-		pm_runtime_get_sync(vdev->v4l2_dev->dev);
+		pm_runtime_get_sync(vou_dev->v4l2_dev.dev);
 		ret = sh_vou_hw_init(vou_dev);
 		if (ret < 0) {
 			atomic_dec(&vou_dev->use_count);
-			pm_runtime_put(vdev->v4l2_dev->dev);
+			pm_runtime_put(vou_dev->v4l2_dev.dev);
 			vou_dev->status = SH_VOU_IDLE;
 			mutex_unlock(&vou_dev->fop_lock);
 			return ret;
@@ -1192,8 +1183,8 @@ static int sh_vou_open(struct file *file)
 				       vou_dev->v4l2_dev.dev, &vou_dev->lock,
 				       V4L2_BUF_TYPE_VIDEO_OUTPUT,
 				       V4L2_FIELD_NONE,
-				       sizeof(struct videobuf_buffer), vdev,
-				       &vou_dev->fop_lock);
+				       sizeof(struct videobuf_buffer),
+				       vou_dev->vdev, &vou_dev->fop_lock);
 	mutex_unlock(&vou_dev->fop_lock);
 
 	return 0;
@@ -1201,8 +1192,7 @@ static int sh_vou_open(struct file *file)
 
 static int sh_vou_release(struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = file->private_data;
 
 	dev_dbg(vou_file->vbq.dev, "%s()\n", __func__);
@@ -1212,7 +1202,7 @@ static int sh_vou_release(struct file *file)
 		/* Last close */
 		vou_dev->status = SH_VOU_IDLE;
 		sh_vou_reg_a_set(vou_dev, VOUER, 0, 0x101);
-		pm_runtime_put(vdev->v4l2_dev->dev);
+		pm_runtime_put(vou_dev->v4l2_dev.dev);
 		mutex_unlock(&vou_dev->fop_lock);
 	}
 
@@ -1224,8 +1214,7 @@ static int sh_vou_release(struct file *file)
 
 static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = file->private_data;
 	int ret;
 
@@ -1240,8 +1229,7 @@ static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
 
 static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 	struct sh_vou_file *vou_file = file->private_data;
 	unsigned int res;
 
@@ -1256,8 +1244,7 @@ static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
 static int sh_vou_g_chip_ident(struct file *file, void *fh,
 				   struct v4l2_dbg_chip_ident *id)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
 	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, g_chip_ident, id);
 }
@@ -1266,8 +1253,7 @@ static int sh_vou_g_chip_ident(struct file *file, void *fh,
 static int sh_vou_g_register(struct file *file, void *fh,
 				 struct v4l2_dbg_register *reg)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
 	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, g_register, reg);
 }
@@ -1275,8 +1261,7 @@ static int sh_vou_g_register(struct file *file, void *fh,
 static int sh_vou_s_register(struct file *file, void *fh,
 				 struct v4l2_dbg_register *reg)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
+	struct sh_vou_device *vou_dev = video_drvdata(file);
 
 	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, s_register, reg);
 }
-- 
1.7.8.6

