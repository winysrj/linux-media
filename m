Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4144 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab2IGN3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 17/28] v4l2: make vidioc_s_jpegcomp const.
Date: Fri,  7 Sep 2012 15:29:17 +0200
Message-Id: <c70224d92ad19379afe1580705c80f9d9c1623d1.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_s_jpegcomp.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/zoran/zoran_driver.c     |    4 ++--
 drivers/media/usb/cpia2/cpia2_v4l.c        |    5 ++---
 drivers/media/usb/gspca/gspca.c            |    2 +-
 drivers/media/usb/gspca/gspca.h            |    8 +++++---
 drivers/media/usb/gspca/jeilinj.c          |    2 +-
 drivers/media/usb/gspca/ov519.c            |    2 +-
 drivers/media/usb/gspca/topro.c            |    2 +-
 drivers/media/usb/gspca/zc3xx.c            |    9 ++-------
 drivers/media/usb/s2255/s2255drv.c         |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c       |    2 ++
 drivers/staging/media/go7007/go7007-v4l2.c |    2 +-
 include/media/v4l2-ioctl.h                 |    2 +-
 12 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index f91b551..9ecd7d7 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -2674,7 +2674,7 @@ static int zoran_g_jpegcomp(struct file *file, void *__fh,
 }
 
 static int zoran_s_jpegcomp(struct file *file, void *__fh,
-					struct v4l2_jpegcompression *params)
+					const struct v4l2_jpegcompression *params)
 {
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
@@ -2701,7 +2701,7 @@ static int zoran_s_jpegcomp(struct file *file, void *__fh,
 	if (!fh->buffers.allocated)
 		fh->buffers.buffer_size =
 			zoran_v4l2_calc_bufsize(&fh->jpg_settings);
-	fh->jpg_settings.jpg_comp = *params = settings.jpg_comp;
+	fh->jpg_settings.jpg_comp = settings.jpg_comp;
 sjpegc_unlock_and_return:
 	mutex_unlock(&zr->resource_lock);
 
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 5ca6f44..aeb9d22 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -734,7 +734,8 @@ static int cpia2_g_jpegcomp(struct file *file, void *fh, struct v4l2_jpegcompres
  *
  *****************************************************************************/
 
-static int cpia2_s_jpegcomp(struct file *file, void *fh, struct v4l2_jpegcompression *parms)
+static int cpia2_s_jpegcomp(struct file *file, void *fh,
+		const struct v4l2_jpegcompression *parms)
 {
 	struct camera_data *cam = video_drvdata(file);
 
@@ -743,8 +744,6 @@ static int cpia2_s_jpegcomp(struct file *file, void *fh, struct v4l2_jpegcompres
 
 	cam->params.compression.inhibit_htables =
 		!(parms->jpeg_markers & V4L2_JPEG_MARKER_DHT);
-	parms->jpeg_markers &= V4L2_JPEG_MARKER_DQT | V4L2_JPEG_MARKER_DRI |
-			       V4L2_JPEG_MARKER_DHT;
 
 	if(parms->APP_len != 0) {
 		if(parms->APP_len > 0 &&
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 5d3bcdc..a89de17 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1687,7 +1687,7 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 }
 
 static int vidioc_s_jpegcomp(struct file *file, void *priv,
-			struct v4l2_jpegcompression *jpegcomp)
+			const struct v4l2_jpegcompression *jpegcomp)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index dc688c7..e3eab82 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -83,8 +83,10 @@ struct gspca_frame;
 typedef int (*cam_op) (struct gspca_dev *);
 typedef void (*cam_v_op) (struct gspca_dev *);
 typedef int (*cam_cf_op) (struct gspca_dev *, const struct usb_device_id *);
-typedef int (*cam_jpg_op) (struct gspca_dev *,
+typedef int (*cam_get_jpg_op) (struct gspca_dev *,
 				struct v4l2_jpegcompression *);
+typedef int (*cam_set_jpg_op) (struct gspca_dev *,
+				const struct v4l2_jpegcompression *);
 typedef int (*cam_reg_op) (struct gspca_dev *,
 				struct v4l2_dbg_register *);
 typedef int (*cam_ident_op) (struct gspca_dev *,
@@ -126,8 +128,8 @@ struct sd_desc {
 	cam_v_op stopN;		/* called on stream off - main alt */
 	cam_v_op stop0;		/* called on stream off & disconnect - alt 0 */
 	cam_v_op dq_callback;	/* called when a frame has been dequeued */
-	cam_jpg_op get_jcomp;
-	cam_jpg_op set_jcomp;
+	cam_get_jpg_op get_jcomp;
+	cam_set_jpg_op set_jcomp;
 	cam_qmnu_op querymenu;
 	cam_streamparm_op get_streamparm;
 	cam_streamparm_op set_streamparm;
diff --git a/drivers/media/usb/gspca/jeilinj.c b/drivers/media/usb/gspca/jeilinj.c
index 26b9931..b897aa8 100644
--- a/drivers/media/usb/gspca/jeilinj.c
+++ b/drivers/media/usb/gspca/jeilinj.c
@@ -474,7 +474,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 }
 
 static int sd_set_jcomp(struct gspca_dev *gspca_dev,
-			struct v4l2_jpegcompression *jcomp)
+			const struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index bfc7cef..3d859f4 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -4762,7 +4762,7 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 }
 
 static int sd_set_jcomp(struct gspca_dev *gspca_dev,
-			struct v4l2_jpegcompression *jcomp)
+			const struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
index a605524..4cb511c 100644
--- a/drivers/media/usb/gspca/topro.c
+++ b/drivers/media/usb/gspca/topro.c
@@ -4806,7 +4806,7 @@ static void sd_set_streamparm(struct gspca_dev *gspca_dev,
 }
 
 static int sd_set_jcomp(struct gspca_dev *gspca_dev,
-			struct v4l2_jpegcompression *jcomp)
+			const struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index f0bacee..a3ca809 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -6881,16 +6881,11 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 }
 
 static int sd_set_jcomp(struct gspca_dev *gspca_dev,
-			struct v4l2_jpegcompression *jcomp)
+			const struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
-	int ret;
 
-	ret = v4l2_ctrl_s_ctrl(sd->jpegqual, jcomp->quality);
-	if (ret)
-		return ret;
-	jcomp->quality = v4l2_ctrl_g_ctrl(sd->jpegqual);
-	return 0;
+	return v4l2_ctrl_s_ctrl(sd->jpegqual, jcomp->quality);
 }
 
 static int sd_get_jcomp(struct gspca_dev *gspca_dev,
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index a25513d..2191f6d 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1556,7 +1556,7 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 }
 
 static int vidioc_s_jpegcomp(struct file *file, void *priv,
-			 struct v4l2_jpegcompression *jc)
+			 const struct v4l2_jpegcompression *jc)
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_channel *channel = fh->channel;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 99a8ad7..725c56e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -924,6 +924,8 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 		if (ops->vidioc_g_fmt_sliced_vbi_out)
 			return 0;
 		break;
+	default:
+		break;
 	}
 	return -EINVAL;
 }
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index c184ad3..f1dff3d 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1392,7 +1392,7 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 }
 
 static int vidioc_s_jpegcomp(struct file *file, void *priv,
-			 struct v4l2_jpegcompression *params)
+			 const struct v4l2_jpegcompression *params)
 {
 	if (params->quality != 50 ||
 			params->jpeg_markers != (V4L2_JPEG_MARKER_DHT |
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 73ae24a..21f6245 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -195,7 +195,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_jpegcomp)       (struct file *file, void *fh,
 					struct v4l2_jpegcompression *a);
 	int (*vidioc_s_jpegcomp)       (struct file *file, void *fh,
-					struct v4l2_jpegcompression *a);
+					const struct v4l2_jpegcompression *a);
 	int (*vidioc_g_enc_index)      (struct file *file, void *fh,
 					struct v4l2_enc_idx *a);
 	int (*vidioc_encoder_cmd)      (struct file *file, void *fh,
-- 
1.7.10.4

