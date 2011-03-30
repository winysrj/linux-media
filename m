Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:65008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1C3Hky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 03:40:54 -0400
Date: Wed, 30 Mar 2011 09:40:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paolo Santinelli <paolo.santinelli@unimore.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L: soc-camera: add a livecrop host operation
In-Reply-To: <Pine.LNX.4.64.1103300932050.4695@axis700.grange>
Message-ID: <Pine.LNX.4.64.1103300936510.4695@axis700.grange>
References: <AANLkTinVP6CePBY6g9Dn2aKXM0ovwmpqMd5G4ucz44EH@mail.gmail.com>
 <Pine.LNX.4.64.1103292357270.13285@axis700.grange>
 <AANLkTimhP_YoqKRKyPzRbM6gw5jXVNV2D3pveRqqH0W_@mail.gmail.com>
 <AANLkTimuV6Mjvp5K+mUOOBgvRsw+vWtYqPb_Vqr8-tDo@mail.gmail.com>
 <Pine.LNX.4.64.1103300932050.4695@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add an soc-camera host livecrop operation to implement live zoom. If
a host driver implements it, it should take care to preserve output
frame format, then live crop doesn't break streaming.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   20 ++++++++++++++------
 include/media/soc_camera.h       |    5 +++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 2f0fd2f..11f0f1e 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -41,6 +41,11 @@
 #define DEFAULT_WIDTH	640
 #define DEFAULT_HEIGHT	480
 
+#define is_streaming(ici, icd)				\
+	(((ici)->ops->init_videobuf) ?			\
+	 (icd)->vb_vidq.streaming :			\
+	 vb2_is_streaming(&(icd)->vb2_vidq))
+
 static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
@@ -626,7 +631,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 	if (icd->streamer && icd->streamer != file)
 		return -EBUSY;
 
-	if (icd->vb_vidq.bufs[0]) {
+	if (is_streaming(to_soc_camera_host(icd->dev.parent), icd)) {
 		dev_err(&icd->dev, "S_FMT denied: queue initialised\n");
 		return -EBUSY;
 	}
@@ -867,14 +872,17 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	if (ret < 0) {
 		dev_err(&icd->dev,
 			"S_CROP denied: getting current crop failed\n");
-	} else if (icd->vb_vidq.bufs[0] &&
-		   (a->c.width != current_crop.c.width ||
-		    a->c.height != current_crop.c.height)) {
+	} else if ((a->c.width == current_crop.c.width &&
+		    a->c.height == current_crop.c.height) ||
+		   !is_streaming(ici, icd)) {
+		/* same size or not streaming - use .set_crop() */
+		ret = ici->ops->set_crop(icd, a);
+	} else if (ici->ops->set_livecrop) {
+		ret = ici->ops->set_livecrop(icd, a);
+	} else {
 		dev_err(&icd->dev,
 			"S_CROP denied: queue initialised and sizes differ\n");
 		ret = -EBUSY;
-	} else {
-		ret = ici->ops->set_crop(icd, a);
 	}
 
 	return ret;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index f80b537..844cd09 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -80,6 +80,11 @@ struct soc_camera_host_ops {
 	int (*cropcap)(struct soc_camera_device *, struct v4l2_cropcap *);
 	int (*get_crop)(struct soc_camera_device *, struct v4l2_crop *);
 	int (*set_crop)(struct soc_camera_device *, struct v4l2_crop *);
+	/*
+	 * The difference to .set_crop() is, that .set_livecrop is not allowed
+	 * to change the output sizes
+	 */
+	int (*set_livecrop)(struct soc_camera_device *, struct v4l2_crop *);
 	int (*set_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
-- 
1.7.2.5

