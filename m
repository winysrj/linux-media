Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58719 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756569AbZBXXKc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 18:10:32 -0500
Date: Wed, 25 Feb 2009 00:10:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	morimoto.kuninori@renesas.com
Subject: [PATCH 2/2 v3] soc-camera: configure drivers with a default format
 on open
In-Reply-To: <aec7e5c30902232247x4a3e57celc82d4148fd7f045d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0902240851100.4494@axis700.grange>
References: <Pine.LNX.4.64.0902191615000.5156@axis700.grange>
 <Pine.LNX.4.64.0902191616340.5156@axis700.grange>
 <aec7e5c30902232247x4a3e57celc82d4148fd7f045d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently soc-camera doesn't set up any image format without an explicit 
S_FMT. According to the API this should be supported, for example, 
capture-example.c from v4l2-apps by default doesn't issue an S_FMT. This 
patch moves negotiating of available host-camera format translations to 
probe() time, and restores the state from the last close() on the next 
open(). This is needed for some drivers, which power down or reset 
hardware after the last user closes the interface. This patch also has a 
nice side-effect of avoiding multiple allocation anf freeing of format 
translation tables.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
On Tue, 24 Feb 2009, Magnus Damm wrote:

> I like the idea behind this patch, but I wonder if it is compatible
> with standard V4L2 behaviour. Please double check against the  open()
> comment in section "4.1.3. Image Format Negotiation" below:
> 
> http://v4l2spec.bytesex.org/spec/c6488.htm#AEN6520

Hm, until now I was interpreting it in a way "as long as a video device is 
kept open, subsequent open() calls shouldn't change its state," but as 
soon as a device is released by all users, its state is lost. But now I 
see also here http://v4l2spec.bytesex.org/spec/r14090.htm:

<quote>
At the first open() call after loading the driver they will be reset to 
default values, drivers are never in an undefined state.
</quote>

With this patch I still issue a S_FMT on "every first open," i.e., every 
time the use count goes from 0 to 1, but I don't use default parameters 
any more, but those from the previous session, which should make us 
sufficiently compliant with the standard:-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index fcd6b2c..078d4b1 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -286,7 +286,9 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 
 	icd->width		= pix->width;
 	icd->height		= pix->height;
-	icf->vb_vidq.field	= pix->field;
+	icf->vb_vidq.field	=
+		icd->field	= pix->field;
+
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		dev_warn(&icd->dev, "Attention! Wrong buf-type %d\n",
 			 f->type);
@@ -339,26 +341,24 @@ static int soc_camera_open(struct file *file)
 
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
+		/* Restore parameters before the last close() per V4L2 API */
 		struct v4l2_format f = {
 			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			.fmt.pix = {
-				.width		= DEFAULT_WIDTH,
-				.height		= DEFAULT_HEIGHT,
-				.field		= V4L2_FIELD_ANY,
+				.width		= icd->width,
+				.height		= icd->height,
+				.field		= icd->field,
+				.pixelformat	= icd->current_fmt->fourcc,
+				.colorspace	= icd->current_fmt->colorspace,
 			},
 		};
 
-		ret = soc_camera_init_user_formats(icd);
-		if (ret < 0)
-			goto eiufmt;
 		ret = ici->ops->add(icd);
 		if (ret < 0) {
 			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
 			goto eiciadd;
 		}
 
-		f.fmt.pix.pixelformat	= icd->current_fmt->fourcc;
-		f.fmt.pix.colorspace	= icd->current_fmt->colorspace;
 
 		/* Try to configure with default parameters */
 		ret = soc_camera_set_fmt(icf, &f);
@@ -382,8 +382,6 @@ static int soc_camera_open(struct file *file)
 esfmt:
 	ici->ops->remove(icd);
 eiciadd:
-	soc_camera_free_user_formats(icd);
-eiufmt:
 	icd->use_count--;
 	mutex_unlock(&icd->video_lock);
 	module_put(ici->ops->owner);
@@ -403,10 +401,9 @@ static int soc_camera_close(struct file *file)
 
 	mutex_lock(&icd->video_lock);
 	icd->use_count--;
-	if (!icd->use_count) {
+	if (!icd->use_count)
 		ici->ops->remove(icd);
-		soc_camera_free_user_formats(icd);
-	}
+
 	mutex_unlock(&icd->video_lock);
 
 	module_put(icd->ops->owner);
@@ -874,9 +871,18 @@ static int soc_camera_probe(struct device *dev)
 		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
 		icd->exposure = qctrl ? qctrl->default_value :
 			(unsigned short)~0;
+
+		ret = soc_camera_init_user_formats(icd);
+		if (ret < 0)
+			goto eiufmt;
+
+		icd->height	= DEFAULT_HEIGHT;
+		icd->width	= DEFAULT_WIDTH;
+		icd->field	= V4L2_FIELD_ANY;
 	}
-	ici->ops->remove(icd);
 
+eiufmt:
+	ici->ops->remove(icd);
 eiadd:
 	mutex_unlock(&icd->video_lock);
 	module_put(ici->ops->owner);
@@ -895,6 +901,8 @@ static int soc_camera_remove(struct device *dev)
 	if (icd->ops->remove)
 		icd->ops->remove(icd);
 
+	soc_camera_free_user_formats(icd);
+
 	return 0;
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index e9eb607..013c818 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -45,6 +45,7 @@ struct soc_camera_device {
 	int num_formats;
 	struct soc_camera_format_xlate *user_formats;
 	int num_user_formats;
+	enum v4l2_field field;		/* Preserve field over close() */
 	struct module *owner;
 	void *host_priv;		/* Per-device host private data */
 	/* soc_camera.c private count. Only accessed with .video_lock held */
