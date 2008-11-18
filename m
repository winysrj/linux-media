Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAIJPmPB022803
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 14:25:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAIJParS023865
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 14:25:37 -0500
Date: Tue, 18 Nov 2008 20:25:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811182006230.8628@axis700.grange>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 1/2 v3] soc-camera: pixel format negotiation - core support
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Allocate and fill a list of formats, supported by this specific 
camera-host combination. Use it for format enumeration. Take care to stay 
backwards-compatible.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 9db66a4..f5a1e5a 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -161,6 +161,56 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 	return videobuf_dqbuf(&icf->vb_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
+static int soc_camera_init_user_formats(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	int i, fmts = 0;
+
+	if (!ici->ops->get_formats)
+		/*
+		 * Fallback mode - the host will have to serve all
+		 * sensor-provided formats one-to-one to the user
+		 */
+		fmts = icd->num_formats;
+	else
+		/*
+		 * First pass - only count formats this host-sensor
+		 * configuration can provide
+		 */
+		for (i = 0; i < icd->num_formats; i++)
+			fmts += ici->ops->get_formats(icd, i, NULL);
+
+	if (!fmts)
+		return -ENXIO;
+
+	icd->user_formats = vmalloc(sizeof(struct soc_camera_data_format *) *
+				    fmts);
+	if (!icd->user_formats)
+		return -ENOMEM;
+
+	icd->num_user_formats = fmts;
+	fmts = 0;
+
+	dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
+
+	/* Second pass - actually fill data formats */
+	for (i = 0; i < icd->num_formats; i++)
+		if (!ici->ops->get_formats)
+			icd->user_formats[i] = icd->formats + i;
+		else
+			fmts += ici->ops->get_formats(icd, i,
+						      &icd->user_formats[fmts]);
+
+	icd->current_fmt = icd->user_formats[0];
+
+	return 0;
+}
+
+static void soc_camera_free_user_formats(struct soc_camera_device *icd)
+{
+	vfree(icd->user_formats);
+}
+
 static int soc_camera_open(struct inode *inode, struct file *file)
 {
 	struct video_device *vdev;
@@ -197,10 +247,12 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
+		ret = soc_camera_init_user_formats(icd);
+		if (ret < 0)
+			goto eiufmt;
 		ret = ici->ops->add(icd);
 		if (ret < 0) {
 			dev_err(&icd->dev, "Couldn't activate the camera: %d\n", ret);
-			icd->use_count--;
 			goto eiciadd;
 		}
 	}
@@ -216,6 +268,9 @@ static int soc_camera_open(struct inode *inode, struct file *file)
 
 	/* All errors are entered with the video_lock held */
 eiciadd:
+	soc_camera_free_user_formats(icd);
+eiufmt:
+	icd->use_count--;
 	module_put(ici->ops->owner);
 emgi:
 	module_put(icd->ops->owner);
@@ -234,8 +289,10 @@ static int soc_camera_close(struct inode *inode, struct file *file)
 
 	mutex_lock(&video_lock);
 	icd->use_count--;
-	if (!icd->use_count)
+	if (!icd->use_count) {
 		ici->ops->remove(icd);
+		soc_camera_free_user_formats(icd);
+	}
 	module_put(icd->ops->owner);
 	module_put(ici->ops->owner);
 	mutex_unlock(&video_lock);
@@ -329,13 +386,11 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 		return ret;
 	} else if (!icd->current_fmt ||
 		   icd->current_fmt->fourcc != f->fmt.pix.pixelformat) {
-		dev_err(&ici->dev, "Host driver hasn't set up current "
-			"format correctly!\n");
+		dev_err(&ici->dev,
+			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
 	}
 
-	/* buswidth may be further adjusted by the ici */
-	icd->buswidth		= icd->current_fmt->depth;
 	icd->width		= rect.width;
 	icd->height		= rect.height;
 	icf->vb_vidq.field	= f->fmt.pix.field;
@@ -359,10 +414,10 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	if (f->index >= icd->num_formats)
+	if (f->index >= icd->num_user_formats)
 		return -EINVAL;
 
-	format = &icd->formats[f->index];
+	format = icd->user_formats[f->index];
 
 	strlcpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
@@ -919,8 +974,6 @@ int soc_camera_video_start(struct soc_camera_device *icd)
 	vdev->minor		= -1;
 	vdev->tvnorms		= V4L2_STD_UNKNOWN,
 
-	icd->current_fmt = &icd->formats[0];
-
 	err = video_register_device(vdev, VFL_TYPE_GRABBER, vdev->minor);
 	if (err < 0) {
 		dev_err(vdev->parent, "video_register_device failed\n");
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index dddaf45..d6333a0 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -41,6 +41,8 @@ struct soc_camera_device {
 	const struct soc_camera_data_format *current_fmt;
 	const struct soc_camera_data_format *formats;
 	int num_formats;
+	const struct soc_camera_data_format **user_formats;
+	int num_user_formats;
 	struct module *owner;
 	void *host_priv;		/* per-device host private data */
 	/* soc_camera.c private count. Only accessed with video_lock held */
@@ -65,8 +67,10 @@ struct soc_camera_host_ops {
 	struct module *owner;
 	int (*add)(struct soc_camera_device *);
 	void (*remove)(struct soc_camera_device *);
-	int (*suspend)(struct soc_camera_device *, pm_message_t state);
+	int (*suspend)(struct soc_camera_device *, pm_message_t);
 	int (*resume)(struct soc_camera_device *);
+	int (*get_formats)(struct soc_camera_device *, int,
+			   const struct soc_camera_data_format **);
 	int (*set_fmt)(struct soc_camera_device *, __u32, struct v4l2_rect *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
