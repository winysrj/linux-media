Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1073 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3AaKZu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/18] tlg2300: embed video_device.
Date: Thu, 31 Jan 2013 11:25:28 +0100
Message-Id: <b7465542a57ac28f1c9d54bfb11766e8c8f35e64.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-common.h |    6 ++--
 drivers/media/usb/tlg2300/pd-video.c  |   55 +++++++--------------------------
 2 files changed, 13 insertions(+), 48 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
index 67ad065..052cb0c 100644
--- a/drivers/media/usb/tlg2300/pd-common.h
+++ b/drivers/media/usb/tlg2300/pd-common.h
@@ -40,7 +40,7 @@
 #define TUNER_FREQ_MAX		(862000000)
 
 struct vbi_data {
-	struct video_device	*v_dev;
+	struct video_device	v_dev;
 	struct video_data	*video;
 	struct front_face	*front;
 
@@ -63,7 +63,7 @@ struct running_context {
 
 struct video_data {
 	/* v4l2 video device */
-	struct video_device	*v_dev;
+	struct video_device	v_dev;
 
 	/* the working context */
 	struct running_context	context;
@@ -234,7 +234,6 @@ void dvb_stop_streaming(struct pd_dvb_adapter *);
 /* FM */
 int poseidon_fm_init(struct poseidon *);
 int poseidon_fm_exit(struct poseidon *);
-struct video_device *vdev_init(struct poseidon *, struct video_device *);
 
 /* vendor command ops */
 int send_set_req(struct poseidon*, u8, s32, s32*);
@@ -250,7 +249,6 @@ void free_all_urb_generic(struct urb **urb_array, int num);
 
 /* misc */
 void poseidon_delete(struct kref *kref);
-void destroy_video_device(struct video_device **v_dev);
 extern int debug_mode;
 void set_debug_mode(struct video_device *vfd, int debug_mode);
 
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 2172337..312809a 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -1590,48 +1590,18 @@ static struct video_device pd_video_template = {
 	.name = "Telegent-Video",
 	.fops = &pd_video_fops,
 	.minor = -1,
-	.release = video_device_release,
+	.release = video_device_release_empty,
 	.tvnorms = V4L2_STD_ALL,
 	.ioctl_ops = &pd_video_ioctl_ops,
 };
 
-struct video_device *vdev_init(struct poseidon *pd, struct video_device *tmp)
-{
-	struct video_device *vfd;
-
-	vfd = video_device_alloc();
-	if (vfd == NULL)
-		return NULL;
-	*vfd		= *tmp;
-	vfd->minor	= -1;
-	vfd->v4l2_dev	= &pd->v4l2_dev;
-	/*vfd->parent	= &(pd->udev->dev); */
-	vfd->release	= video_device_release;
-	video_set_drvdata(vfd, pd);
-	return vfd;
-}
-
-void destroy_video_device(struct video_device **v_dev)
-{
-	struct video_device *dev = *v_dev;
-
-	if (dev == NULL)
-		return;
-
-	if (video_is_registered(dev))
-		video_unregister_device(dev);
-	else
-		video_device_release(dev);
-	*v_dev = NULL;
-}
-
 void pd_video_exit(struct poseidon *pd)
 {
 	struct video_data *video = &pd->video_data;
 	struct vbi_data *vbi = &pd->vbi_data;
 
-	destroy_video_device(&video->v_dev);
-	destroy_video_device(&vbi->v_dev);
+	video_unregister_device(&video->v_dev);
+	video_unregister_device(&vbi->v_dev);
 	log();
 }
 
@@ -1641,21 +1611,19 @@ int pd_video_init(struct poseidon *pd)
 	struct vbi_data *vbi	= &pd->vbi_data;
 	int ret = -ENOMEM;
 
-	video->v_dev = vdev_init(pd, &pd_video_template);
-	if (video->v_dev == NULL)
-		goto out;
+	video->v_dev = pd_video_template;
+	video->v_dev.v4l2_dev = &pd->v4l2_dev;
+	video_set_drvdata(&video->v_dev, pd);
 
-	ret = video_register_device(video->v_dev, VFL_TYPE_GRABBER, -1);
+	ret = video_register_device(&video->v_dev, VFL_TYPE_GRABBER, -1);
 	if (ret != 0)
 		goto out;
 
 	/* VBI uses the same template as video */
-	vbi->v_dev = vdev_init(pd, &pd_video_template);
-	if (vbi->v_dev == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	ret = video_register_device(vbi->v_dev, VFL_TYPE_VBI, -1);
+	vbi->v_dev = pd_video_template;
+	vbi->v_dev.v4l2_dev = &pd->v4l2_dev;
+	video_set_drvdata(&vbi->v_dev, pd);
+	ret = video_register_device(&vbi->v_dev, VFL_TYPE_VBI, -1);
 	if (ret != 0)
 		goto out;
 	log("register VIDEO/VBI devices");
@@ -1665,4 +1633,3 @@ out:
 	pd_video_exit(pd);
 	return ret;
 }
-
-- 
1.7.10.4

