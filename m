Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVmY7022469
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:48 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVaXQ027070
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:36 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:36 +0100
Message-Id: <1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 05/13] soc-camera: move pixel format handling to host
	drivers (part 2)
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

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Just letting camera host drivers handle the choice of a pixel format in
.vidioc_s_fmt_vid_cap() is not enough, pixel format enumeration should be
handled by host drivers too.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/pxa_camera.c           |   17 +++++++++++++++++
 drivers/media/video/sh_mobile_ceu_camera.c |   17 +++++++++++++++++
 drivers/media/video/soc_camera.c           |   12 +++---------
 include/media/soc_camera.h                 |    1 +
 4 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 665eef2..f7f621c 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -963,6 +963,22 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	return icd->ops->try_fmt(icd, f);
 }
 
+static int pxa_camera_enum_fmt(struct soc_camera_device *icd,
+			       struct v4l2_fmtdesc *f)
+{
+	const struct soc_camera_data_format *format;
+
+	if (f->index >= icd->num_formats)
+		return -EINVAL;
+
+	format = &icd->formats[f->index];
+
+	strlcpy(f->description, format->name, sizeof(f->description));
+	f->pixelformat = format->fourcc;
+
+	return 0;
+}
+
 static int pxa_camera_reqbufs(struct soc_camera_file *icf,
 			      struct v4l2_requestbuffers *p)
 {
@@ -1070,6 +1086,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.resume		= pxa_camera_resume,
 	.set_fmt	= pxa_camera_set_fmt,
 	.try_fmt	= pxa_camera_try_fmt,
+	.enum_fmt	= pxa_camera_enum_fmt,
 	.init_videobuf	= pxa_camera_init_videobuf,
 	.reqbufs	= pxa_camera_reqbufs,
 	.poll		= pxa_camera_poll,
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 367c4eb..fdfe04f 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -505,6 +505,22 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	return icd->ops->try_fmt(icd, f);
 }
 
+static int sh_mobile_ceu_enum_fmt(struct soc_camera_device *icd,
+				  struct v4l2_fmtdesc *f)
+{
+	const struct soc_camera_data_format *format;
+
+	if (f->index >= icd->num_formats)
+		return -EINVAL;
+
+	format = &icd->formats[f->index];
+
+	strlcpy(f->description, format->name, sizeof(f->description));
+	f->pixelformat = format->fourcc;
+
+	return 0;
+}
+
 static int sh_mobile_ceu_reqbufs(struct soc_camera_file *icf,
 				 struct v4l2_requestbuffers *p)
 {
@@ -572,6 +588,7 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.remove		= sh_mobile_ceu_remove_device,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
+	.enum_fmt	= sh_mobile_ceu_enum_fmt,
 	.reqbufs	= sh_mobile_ceu_reqbufs,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 7304e73..f5a1a86 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -355,18 +355,12 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	const struct soc_camera_data_format *format;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
-	if (f->index >= icd->num_formats)
-		return -EINVAL;
-
-	format = &icd->formats[f->index];
-
-	strlcpy(f->description, format->name, sizeof(f->description));
-	f->pixelformat = format->fourcc;
-	return 0;
+	return ici->ops->enum_fmt(icd, f);
 }
 
 static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 64eb4b5..9c3734c 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -68,6 +68,7 @@ struct soc_camera_host_ops {
 	int (*resume)(struct soc_camera_device *);
 	int (*set_fmt)(struct soc_camera_device *, __u32, struct v4l2_rect *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
+	int (*enum_fmt)(struct soc_camera_device *, struct v4l2_fmtdesc *);
 	void (*init_videobuf)(struct videobuf_queue *,
 			      struct soc_camera_device *);
 	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
