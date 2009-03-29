Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:51446 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZC2XTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 19:19:49 -0400
Received: by bwz17 with SMTP id 17so1704404bwz.37
        for <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 16:19:46 -0700 (PDT)
Subject: [patch 1/2] v4l2-dev.c: return 0 for NULL open and release
 callbacks
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain
Date: Mon, 30 Mar 2009 03:19:38 +0400
Message-Id: <1238368778.21620.35.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all

This is two patches that removes empty open and release functions in
pci/isa radio drivers. To handle that we change v4l2-dev.c file.

I'm not sure, but it's probably that small note about it should be added
in docs. If i did something wrong, please correct.

---
From: Hans Verkuil <hverkuil@xs4all.nl>

Patch allows v4l2_open and v4l2_release functions return 0 if open and
release driver callbacks set to NULL. This will be used in radio
drivers.

Priority: normal

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r df7a51ffa2ba linux/drivers/media/video/v4l2-dev.c
--- a/linux/drivers/media/video/v4l2-dev.c	Sun Mar 29 05:58:58 2009 -0300
+++ b/linux/drivers/media/video/v4l2-dev.c	Mon Mar 30 01:13:59 2009 +0400
@@ -267,7 +267,7 @@
 static int v4l2_open(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev;
-	int ret;
+	int ret = 0;
 
 	/* Check if the video device is available */
 	mutex_lock(&videodev_lock);
@@ -281,7 +281,9 @@
 	/* and increase the device refcount */
 	video_get(vdev);
 	mutex_unlock(&videodev_lock);
-	ret = vdev->fops->open(filp);
+	if(vdev->fops->open)
+		ret = vdev->fops->open(filp);
+
 	/* decrease the refcount in case of an error */
 	if (ret)
 		video_put(vdev);
@@ -292,7 +294,10 @@
 static int v4l2_release(struct inode *inode, struct file *filp)
 {
 	struct video_device *vdev = video_devdata(filp);
-	int ret = vdev->fops->release(filp);
+	int ret = 0;
+	
+	if(vdev->fops->release)
+		vdev->fops->release(filp);
 
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */


-- 
Best regards, Klimov Alexey

