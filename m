Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVinA022451
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:44 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVWbr027033
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:32 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:32 +0100
Message-Id: <1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
Cc: Guennadi Liakhovetski <lg@denx.de>
Subject: [PATCH 01/13] soc-camera: merge .try_bus_param() into .try_fmt_cap()
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

.try_bus_param() method from struct soc_camera_host_ops is only called at one
location immediately before .try_fmt_cap(), there is no value in keeping these
two methods separate, merge them.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
 drivers/media/video/pxa_camera.c           |    6 +++++-
 drivers/media/video/sh_mobile_ceu_camera.c |    6 +++++-
 drivers/media/video/soc_camera.c           |    5 -----
 include/media/soc_camera.h                 |    1 -
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index eb6be58..2a811f8 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -913,6 +913,11 @@ static int pxa_camera_set_fmt_cap(struct soc_camera_device *icd,
 static int pxa_camera_try_fmt_cap(struct soc_camera_device *icd,
 				  struct v4l2_format *f)
 {
+	int ret = pxa_camera_try_bus_param(icd, f->fmt.pix.pixelformat);
+
+	if (ret < 0)
+		return ret;
+
 	/* limit to pxa hardware capabilities */
 	if (f->fmt.pix.height < 32)
 		f->fmt.pix.height = 32;
@@ -1039,7 +1044,6 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.reqbufs	= pxa_camera_reqbufs,
 	.poll		= pxa_camera_poll,
 	.querycap	= pxa_camera_querycap,
-	.try_bus_param	= pxa_camera_try_bus_param,
 	.set_bus_param	= pxa_camera_set_bus_param,
 };
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 2407607..a6b29a4 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -453,6 +453,11 @@ static int sh_mobile_ceu_set_fmt_cap(struct soc_camera_device *icd,
 static int sh_mobile_ceu_try_fmt_cap(struct soc_camera_device *icd,
 				     struct v4l2_format *f)
 {
+	int ret = sh_mobile_ceu_try_bus_param(icd, f->fmt.pix.pixelformat);
+
+	if (ret < 0)
+		return ret;
+
 	/* FIXME: calculate using depth and bus width */
 
 	if (f->fmt.pix.height < 4)
@@ -540,7 +545,6 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.reqbufs	= sh_mobile_ceu_reqbufs,
 	.poll		= sh_mobile_ceu_poll,
 	.querycap	= sh_mobile_ceu_querycap,
-	.try_bus_param	= sh_mobile_ceu_try_bus_param,
 	.set_bus_param	= sh_mobile_ceu_set_bus_param,
 	.init_videobuf	= sh_mobile_ceu_init_videobuf,
 };
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 66ebe59..f406042 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -77,11 +77,6 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	/* test physical bus parameters */
-	ret = ici->ops->try_bus_param(icd, f->fmt.pix.pixelformat);
-	if (ret)
-		return ret;
-
 	/* limit format to hardware capabilities */
 	ret = ici->ops->try_fmt_cap(icd, f);
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index c5de7bb..5eb9540 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -73,7 +73,6 @@ struct soc_camera_host_ops {
 			      struct soc_camera_device *);
 	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
-	int (*try_bus_param)(struct soc_camera_device *, __u32);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
 	unsigned int (*poll)(struct file *, poll_table *);
 };
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
