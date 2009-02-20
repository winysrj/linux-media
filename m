Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49659 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752915AbZBTQkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 11:40:08 -0500
Date: Fri, 20 Feb 2009 17:40:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH 2/2 v2] soc-camera: configure drivers with a default format
 on open
In-Reply-To: <u3ae9zzd9.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902201737000.5004@axis700.grange>
References: <Pine.LNX.4.64.0902191615000.5156@axis700.grange>
 <Pine.LNX.4.64.0902191616340.5156@axis700.grange> <u3ae9zzd9.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently soc-camera doesn't set up any image format without an explicit S_FMT.
It seems this should be supported, since, for example, capture-example.c from
v4l2-apps by default doesn't issue an S_FMT. This patch configures a default
image format on open().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
On Fri, 20 Feb 2009, morimoto.kuninori@renesas.com wrote:

> > Morimoto-san, please, have a look how far these two patches take you, I 
> > lost the track of the problems a bit:-) Does capture-example work for you 
> > now without the "-f"?
> 
> Oooops. sorry ov772x and tw9910 doesn't works...
> The reason is videobuf-core.c :: videobuf_next_field.
> 
> BUG_ON(V4L2_FIELD_ANY == filed);
> 
> sh_mobile_ceu use V4L2_FIELD_ANY now.
> and ov772x and tw9910 change field in try_fmt.
> But try_fmt isn't called...

Ok, you're right. I do call it now. How about this version?

 drivers/media/video/soc_camera.c |  100 ++++++++++++++++++++++++++------------
 1 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 9939b04..fcd6b2c 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -30,6 +30,10 @@
 #include <media/videobuf-core.h>
 #include <media/soc_camera.h>
 
+/* Default to VGA resolution */
+#define DEFAULT_WIDTH	640
+#define DEFAULT_HEIGHT	480
+
 static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);
@@ -256,6 +260,44 @@ static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 	vfree(icd->user_formats);
 }
 
+/* Called with .vb_lock held */
+static int soc_camera_set_fmt(struct soc_camera_file *icf,
+			      struct v4l2_format *f)
+{
+	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	int ret;
+
+	/* We always call try_fmt() before set_fmt() or set_crop() */
+	ret = ici->ops->try_fmt(icd, f);
+	if (ret < 0)
+		return ret;
+
+	ret = ici->ops->set_fmt(icd, f);
+	if (ret < 0) {
+		return ret;
+	} else if (!icd->current_fmt ||
+		   icd->current_fmt->fourcc != pix->pixelformat) {
+		dev_err(&ici->dev,
+			"Host driver hasn't set up current format correctly!\n");
+		return -EINVAL;
+	}
+
+	icd->width		= pix->width;
+	icd->height		= pix->height;
+	icf->vb_vidq.field	= pix->field;
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
+			 f->type);
+
+	dev_dbg(&icd->dev, "set width: %d height: %d\n",
+		icd->width, icd->height);
+
+	/* set physical bus parameters */
+	return ici->ops->set_bus_param(icd, pix->pixelformat);
+}
+
 static int soc_camera_open(struct file *file)
 {
 	struct video_device *vdev;
@@ -297,6 +339,15 @@ static int soc_camera_open(struct file *file)
 
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
+		struct v4l2_format f = {
+			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			.fmt.pix = {
+				.width		= DEFAULT_WIDTH,
+				.height		= DEFAULT_HEIGHT,
+				.field		= V4L2_FIELD_ANY,
+			},
+		};
+
 		ret = soc_camera_init_user_formats(icd);
 		if (ret < 0)
 			goto eiufmt;
@@ -305,6 +356,14 @@ static int soc_camera_open(struct file *file)
 			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
 			goto eiciadd;
 		}
+
+		f.fmt.pix.pixelformat	= icd->current_fmt->fourcc;
+		f.fmt.pix.colorspace	= icd->current_fmt->colorspace;
+
+		/* Try to configure with default parameters */
+		ret = soc_camera_set_fmt(icf, &f);
+		if (ret < 0)
+			goto esfmt;
 	}
 
 	mutex_unlock(&icd->video_lock);
@@ -316,7 +375,12 @@ static int soc_camera_open(struct file *file)
 
 	return 0;
 
-	/* First two errors are entered with the .video_lock held */
+	/*
+	 * First three errors are entered with the .video_lock held
+	 * and use_count == 1
+	 */
+esfmt:
+	ici->ops->remove(icd);
 eiciadd:
 	soc_camera_free_user_formats(icd);
 eiufmt:
@@ -415,16 +479,10 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
 	WARN_ON(priv != file->private_data);
 
-	ret = soc_camera_try_fmt_vid_cap(file, priv, f);
-	if (ret < 0)
-		return ret;
-
 	mutex_lock(&icf->vb_vidq.vb_lock);
 
 	if (videobuf_queue_is_busy(&icf->vb_vidq)) {
@@ -433,29 +491,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		goto unlock;
 	}
 
-	ret = ici->ops->set_fmt(icd, f);
-	if (ret < 0) {
-		goto unlock;
-	} else if (!icd->current_fmt ||
-		   icd->current_fmt->fourcc != pix->pixelformat) {
-		dev_err(&ici->dev,
-			"Host driver hasn't set up current format correctly!\n");
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	icd->width		= f->fmt.pix.width;
-	icd->height		= f->fmt.pix.height;
-	icf->vb_vidq.field	= pix->field;
-	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
-			 f->type);
-
-	dev_dbg(&icd->dev, "set width: %d height: %d\n",
-		icd->width, icd->height);
-
-	/* set physical bus parameters */
-	ret = ici->ops->set_bus_param(icd, pix->pixelformat);
+	ret = soc_camera_set_fmt(icf, f);
 
 unlock:
 	mutex_unlock(&icf->vb_vidq.vb_lock);
@@ -642,8 +678,8 @@ static int soc_camera_cropcap(struct file *file, void *fh,
 	a->bounds.height		= icd->height_max;
 	a->defrect.left			= icd->x_min;
 	a->defrect.top			= icd->y_min;
-	a->defrect.width		= 640;
-	a->defrect.height		= 480;
+	a->defrect.width		= DEFAULT_WIDTH;
+	a->defrect.height		= DEFAULT_HEIGHT;
 	a->pixelaspect.numerator	= 1;
 	a->pixelaspect.denominator	= 1;
 
-- 
1.5.4

