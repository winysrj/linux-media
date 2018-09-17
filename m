Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41751 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeIQVb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 17:31:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id s15-v6so7878273pgv.8
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 09:03:27 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 1/5] media: video-i2c: avoid accessing released memory area when removing driver
Date: Tue, 18 Sep 2018 01:03:07 +0900
Message-Id: <1537200191-17956-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct video_i2c_data is released when video_unregister_device() is
called, but it will still be accessed after calling
video_unregister_device().

Use devm_kzalloc() and let the memory be automatically released on driver
detach.

Fixes: 5cebaac60974 ("media: video-i2c: add video-i2c driver")
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/video-i2c.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 06d29d8..b7a2af9 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -508,20 +508,15 @@ static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 };
 
-static void video_i2c_release(struct video_device *vdev)
-{
-	kfree(video_get_drvdata(vdev));
-}
-
 static int video_i2c_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
 {
 	struct video_i2c_data *data;
 	struct v4l2_device *v4l2_dev;
 	struct vb2_queue *queue;
-	int ret = -ENODEV;
+	int ret;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -530,7 +525,7 @@ static int video_i2c_probe(struct i2c_client *client,
 	else if (id)
 		data->chip = &video_i2c_chip[id->driver_data];
 	else
-		goto error_free_device;
+		return -ENODEV;
 
 	data->client = client;
 	v4l2_dev = &data->v4l2_dev;
@@ -538,7 +533,7 @@ static int video_i2c_probe(struct i2c_client *client,
 
 	ret = v4l2_device_register(&client->dev, v4l2_dev);
 	if (ret < 0)
-		goto error_free_device;
+		return ret;
 
 	mutex_init(&data->lock);
 	mutex_init(&data->queue_lock);
@@ -568,7 +563,7 @@ static int video_i2c_probe(struct i2c_client *client,
 	data->vdev.fops = &video_i2c_fops;
 	data->vdev.lock = &data->lock;
 	data->vdev.ioctl_ops = &video_i2c_ioctl_ops;
-	data->vdev.release = video_i2c_release;
+	data->vdev.release = video_device_release_empty;
 	data->vdev.device_caps = V4L2_CAP_VIDEO_CAPTURE |
 				 V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 
@@ -597,9 +592,6 @@ static int video_i2c_probe(struct i2c_client *client,
 	mutex_destroy(&data->lock);
 	mutex_destroy(&data->queue_lock);
 
-error_free_device:
-	kfree(data);
-
 	return ret;
 }
 
-- 
2.7.4
