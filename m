Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36239 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbeJNBlF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 21:41:05 -0400
Received: by mail-pl1-f196.google.com with SMTP id y11-v6so7373889plt.3
        for <linux-media@vger.kernel.org>; Sat, 13 Oct 2018 11:02:59 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v3 1/6] media: video-i2c: avoid accessing released memory area when removing driver
Date: Sun, 14 Oct 2018 03:02:34 +0900
Message-Id: <1539453759-29976-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1539453759-29976-1-git-send-email-akinobu.mita@gmail.com>
References: <1539453759-29976-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video device release() callback for video-i2c driver frees the whole
struct video_i2c_data.  If there is no user left for the video device
when video_unregister_device() is called, the release callback is executed.

However, in video_i2c_remove() some fields (v4l2_dev, lock, and queue_lock)
in struct video_i2c_data are still accessed after video_unregister_device()
is called.

This fixes the use after free by moving the code from video_i2c_remove()
to the release() callback.

Fixes: 5cebaac60974 ("media: video-i2c: add video-i2c driver")
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v3
- Move the code causing use-after-free from video_i2c_remove() to the
  video device release() callback.
- Remove Acked-by line as there are enough changes from previous version

 drivers/media/i2c/video-i2c.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 06d29d8..f27d294 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -510,7 +510,12 @@ static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
 
 static void video_i2c_release(struct video_device *vdev)
 {
-	kfree(video_get_drvdata(vdev));
+	struct video_i2c_data *data = video_get_drvdata(vdev);
+
+	v4l2_device_unregister(&data->v4l2_dev);
+	mutex_destroy(&data->lock);
+	mutex_destroy(&data->queue_lock);
+	kfree(data);
 }
 
 static int video_i2c_probe(struct i2c_client *client,
@@ -608,10 +613,6 @@ static int video_i2c_remove(struct i2c_client *client)
 	struct video_i2c_data *data = i2c_get_clientdata(client);
 
 	video_unregister_device(&data->vdev);
-	v4l2_device_unregister(&data->v4l2_dev);
-
-	mutex_destroy(&data->lock);
-	mutex_destroy(&data->queue_lock);
 
 	return 0;
 }
-- 
2.7.4
