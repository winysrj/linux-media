Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:15620 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbZILOto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:49:44 -0400
Received: by qw-out-2122.google.com with SMTP id 9so632979qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:49:47 -0700 (PDT)
Message-ID: <4AABB503.5030902@gmail.com>
Date: Sat, 12 Sep 2009 10:49:39 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 05/10] radio-mr800: simplify access to amradio_device
Content-Type: multipart/mixed;
 boundary="------------020508010401060503010505"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020508010401060503010505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 762337020b7744f791fc02fff7eb983e3e4a2346 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 00:45:28 -0400
Subject: [PATCH 05/10] mr800: simplify access to amradio_device

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index fb99c6b..7305c96 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -141,6 +141,8 @@ struct amradio_device {
     int muted;
 };
 
+#define vdev_to_amradio(r) container_of(r, struct amradio_device, videodev)
+
 /* USB Device ID List */
 static struct usb_device_id usb_amradio_device_table[] = {
     {USB_DEVICE_AND_INTERFACE_INFO(USB_AMRADIO_VENDOR, USB_AMRADIO_PRODUCT,
@@ -280,7 +282,7 @@ static void usb_amradio_disconnect(struct 
usb_interface *intf)
 static int vidioc_querycap(struct file *file, void *priv,
                     struct v4l2_capability *v)
 {
-    struct amradio_device *radio = video_drvdata(file);
+    struct amradio_device *radio = file->private_data;
 
     strlcpy(v->driver, "radio-mr800", sizeof(v->driver));
     strlcpy(v->card, "AverMedia MR 800 USB FM Radio", sizeof(v->card));
@@ -294,7 +296,7 @@ static int vidioc_querycap(struct file *file, void 
*priv,
 static int vidioc_g_tuner(struct file *file, void *priv,
                 struct v4l2_tuner *v)
 {
-    struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    struct amradio_device *radio = file->private_data;
     int retval;
 
     mutex_lock(&radio->lock);
@@ -345,7 +347,7 @@ unlock:
 static int vidioc_s_tuner(struct file *file, void *priv,
                 struct v4l2_tuner *v)
 {
-    struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    struct amradio_device *radio = file->private_data;
     int retval;
 
     mutex_lock(&radio->lock);
@@ -388,7 +390,7 @@ unlock:
 static int vidioc_s_frequency(struct file *file, void *priv,
                 struct v4l2_frequency *f)
 {
-    struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    struct amradio_device *radio = file->private_data;
     int retval;
 
     mutex_lock(&radio->lock);
@@ -415,7 +417,7 @@ unlock:
 static int vidioc_g_frequency(struct file *file, void *priv,
                 struct v4l2_frequency *f)
 {
-    struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    struct amradio_device *radio = file->private_data;
     int retval = 0;
 
     mutex_lock(&radio->lock);
@@ -450,7 +452,7 @@ static int vidioc_queryctrl(struct file *file, void 
*priv,
 static int vidioc_g_ctrl(struct file *file, void *priv,
                 struct v4l2_control *ctrl)
 {
-    struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    struct amradio_device *radio = file->private_data;
     int retval = -EINVAL;
 
     mutex_lock(&radio->lock);
@@ -477,7 +479,7 @@ unlock:
 static int vidioc_s_ctrl(struct file *file, void *priv,
                 struct v4l2_control *ctrl)
 {
-    struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    struct amradio_device *radio = file->private_data;
     int retval = -EINVAL;
 
     mutex_lock(&radio->lock);
@@ -550,7 +552,7 @@ static int vidioc_s_input(struct file *filp, void 
*priv, unsigned int i)
 /* open device - amradio_start() and amradio_setfreq() */
 static int usb_amradio_open(struct file *file)
 {
-    struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    struct amradio_device *radio = vdev_to_amradio(video_devdata(file));
     int retval = 0;
 
     mutex_lock(&radio->lock);
@@ -560,6 +562,7 @@ static int usb_amradio_open(struct file *file)
         goto unlock;
     }
 
+    file->private_data = radio;
     radio->users = 1;
     radio->muted = 1;
 
@@ -589,7 +592,7 @@ unlock:
 /*close device */
 static int usb_amradio_close(struct file *file)
 {
-    struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    struct amradio_device *radio = file->private_data;
     int retval = 0;
 
     mutex_lock(&radio->lock);
@@ -674,7 +677,7 @@ static const struct v4l2_ioctl_ops 
usb_amradio_ioctl_ops = {
 
 static void usb_amradio_video_device_release(struct video_device *videodev)
 {
-    struct amradio_device *radio = video_get_drvdata(videodev);
+    struct amradio_device *radio = vdev_to_amradio(videodev);
 
     v4l2_device_unregister(&radio->v4l2_dev);
 
-- 
1.6.3.3


--------------020508010401060503010505
Content-Type: text/x-diff;
 name="0005-mr800-simplify-access-to-amradio_device.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0005-mr800-simplify-access-to-amradio_device.patch"

>From 762337020b7744f791fc02fff7eb983e3e4a2346 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 00:45:28 -0400
Subject: [PATCH 05/10] mr800: simplify access to amradio_device

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index fb99c6b..7305c96 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -141,6 +141,8 @@ struct amradio_device {
 	int muted;
 };
 
+#define vdev_to_amradio(r) container_of(r, struct amradio_device, videodev)
+
 /* USB Device ID List */
 static struct usb_device_id usb_amradio_device_table[] = {
 	{USB_DEVICE_AND_INTERFACE_INFO(USB_AMRADIO_VENDOR, USB_AMRADIO_PRODUCT,
@@ -280,7 +282,7 @@ static void usb_amradio_disconnect(struct usb_interface *intf)
 static int vidioc_querycap(struct file *file, void *priv,
 					struct v4l2_capability *v)
 {
-	struct amradio_device *radio = video_drvdata(file);
+	struct amradio_device *radio = file->private_data;
 
 	strlcpy(v->driver, "radio-mr800", sizeof(v->driver));
 	strlcpy(v->card, "AverMedia MR 800 USB FM Radio", sizeof(v->card));
@@ -294,7 +296,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	struct amradio_device *radio = file->private_data;
 	int retval;
 
 	mutex_lock(&radio->lock);
@@ -345,7 +347,7 @@ unlock:
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	struct amradio_device *radio = file->private_data;
 	int retval;
 
 	mutex_lock(&radio->lock);
@@ -388,7 +390,7 @@ unlock:
 static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	struct amradio_device *radio = file->private_data;
 	int retval;
 
 	mutex_lock(&radio->lock);
@@ -415,7 +417,7 @@ unlock:
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	struct amradio_device *radio = file->private_data;
 	int retval = 0;
 
 	mutex_lock(&radio->lock);
@@ -450,7 +452,7 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	struct amradio_device *radio = file->private_data;
 	int retval = -EINVAL;
 
 	mutex_lock(&radio->lock);
@@ -477,7 +479,7 @@ unlock:
 static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	struct amradio_device *radio = file->private_data;
 	int retval = -EINVAL;
 
 	mutex_lock(&radio->lock);
@@ -550,7 +552,7 @@ static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 /* open device - amradio_start() and amradio_setfreq() */
 static int usb_amradio_open(struct file *file)
 {
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	struct amradio_device *radio = vdev_to_amradio(video_devdata(file));
 	int retval = 0;
 
 	mutex_lock(&radio->lock);
@@ -560,6 +562,7 @@ static int usb_amradio_open(struct file *file)
 		goto unlock;
 	}
 
+	file->private_data = radio;
 	radio->users = 1;
 	radio->muted = 1;
 
@@ -589,7 +592,7 @@ unlock:
 /*close device */
 static int usb_amradio_close(struct file *file)
 {
-	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	struct amradio_device *radio = file->private_data;
 	int retval = 0;
 
 	mutex_lock(&radio->lock);
@@ -674,7 +677,7 @@ static const struct v4l2_ioctl_ops usb_amradio_ioctl_ops = {
 
 static void usb_amradio_video_device_release(struct video_device *videodev)
 {
-	struct amradio_device *radio = video_get_drvdata(videodev);
+	struct amradio_device *radio = vdev_to_amradio(videodev);
 
 	v4l2_device_unregister(&radio->v4l2_dev);
 
-- 
1.6.3.3


--------------020508010401060503010505--
