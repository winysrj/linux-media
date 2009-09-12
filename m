Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:50386 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbZILOtv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:49:51 -0400
Received: by mail-qy0-f172.google.com with SMTP id 2so1629968qyk.21
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:49:54 -0700 (PDT)
Message-ID: <4AABB509.1010004@gmail.com>
Date: Sat, 12 Sep 2009 10:49:45 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 06/10] radio-mr800: simplify locking in ioctl callbacks
Content-Type: multipart/mixed;
 boundary="------------020700040700000607060209"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020700040700000607060209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From c012b1ac39a225e003b190a12ae942e1dd6ea09b Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 01:07:13 -0400
Subject: [PATCH 06/10] mr800: simplify locking in ioctl callbacks

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |  109 
++++++++++---------------------------
 1 files changed, 30 insertions(+), 79 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 7305c96..71d15ba 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -299,18 +299,8 @@ static int vidioc_g_tuner(struct file *file, void 
*priv,
     struct amradio_device *radio = file->private_data;
     int retval;
 
-    mutex_lock(&radio->lock);
-
-    /* safety check */
-    if (radio->removed) {
-        retval = -EIO;
-        goto unlock;
-    }
-
-    if (v->index > 0) {
-        retval = -EINVAL;
-        goto unlock;
-    }
+    if (v->index > 0)
+        return -EINVAL;
 
 /* TODO: Add function which look is signal stereo or not
  *     amradio_getstat(radio);
@@ -338,8 +328,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
     v->signal = 0xffff;     /* Can't get the signal strength, sad.. */
     v->afc = 0; /* Don't know what is this */
 
-unlock:
-    mutex_unlock(&radio->lock);
     return retval;
 }
 
@@ -348,20 +336,10 @@ static int vidioc_s_tuner(struct file *file, void 
*priv,
                 struct v4l2_tuner *v)
 {
     struct amradio_device *radio = file->private_data;
-    int retval;
-
-    mutex_lock(&radio->lock);
-
-    /* safety check */
-    if (radio->removed) {
-        retval = -EIO;
-        goto unlock;
-    }
+    int retval = -EINVAL;
 
-    if (v->index > 0) {
-        retval = -EINVAL;
-        goto unlock;
-    }
+    if (v->index > 0)
+        return -EINVAL;
 
     /* mono/stereo selector */
     switch (v->audmode) {
@@ -377,12 +355,8 @@ static int vidioc_s_tuner(struct file *file, void 
*priv,
             amradio_dev_warn(&radio->videodev.dev,
                 "set stereo failed\n");
         break;
-    default:
-        retval = -EINVAL;
     }
 
-unlock:
-    mutex_unlock(&radio->lock);
     return retval;
 }
 
@@ -391,15 +365,7 @@ static int vidioc_s_frequency(struct file *file, 
void *priv,
                 struct v4l2_frequency *f)
 {
     struct amradio_device *radio = file->private_data;
-    int retval;
-
-    mutex_lock(&radio->lock);
-
-    /* safety check */
-    if (radio->removed) {
-        retval = -EIO;
-        goto unlock;
-    }
+    int retval = 0;
 
     radio->curfreq = f->frequency;
 
@@ -408,8 +374,6 @@ static int vidioc_s_frequency(struct file *file, 
void *priv,
         amradio_dev_warn(&radio->videodev.dev,
             "set frequency failed\n");
 
-unlock:
-    mutex_unlock(&radio->lock);
     return retval;
 }
 
@@ -418,22 +382,11 @@ static int vidioc_g_frequency(struct file *file, 
void *priv,
                 struct v4l2_frequency *f)
 {
     struct amradio_device *radio = file->private_data;
-    int retval = 0;
-
-    mutex_lock(&radio->lock);
-
-    /* safety check */
-    if (radio->removed) {
-        retval = -EIO;
-        goto unlock;
-    }
 
     f->type = V4L2_TUNER_RADIO;
     f->frequency = radio->curfreq;
 
-unlock:
-    mutex_unlock(&radio->lock);
-    return retval;
+    return 0;
 }
 
 /* vidioc_queryctrl - enumerate control items */
@@ -453,26 +406,14 @@ static int vidioc_g_ctrl(struct file *file, void 
*priv,
                 struct v4l2_control *ctrl)
 {
     struct amradio_device *radio = file->private_data;
-    int retval = -EINVAL;
-
-    mutex_lock(&radio->lock);
-
-    /* safety check */
-    if (radio->removed) {
-        retval = -EIO;
-        goto unlock;
-    }
 
     switch (ctrl->id) {
     case V4L2_CID_AUDIO_MUTE:
         ctrl->value = radio->muted;
-        retval = 0;
-        break;
+        return 0;
     }
 
-unlock:
-    mutex_unlock(&radio->lock);
-    return retval;
+    return -EINVAL;
 }
 
 /* vidioc_s_ctrl - set the value of a control */
@@ -482,14 +423,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
     struct amradio_device *radio = file->private_data;
     int retval = -EINVAL;
 
-    mutex_lock(&radio->lock);
-
-    /* safety check */
-    if (radio->removed) {
-        retval = -EIO;
-        goto unlock;
-    }
-
     switch (ctrl->id) {
     case V4L2_CID_AUDIO_MUTE:
         if (ctrl->value) {
@@ -508,8 +441,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
         break;
     }
 
-unlock:
-    mutex_unlock(&radio->lock);
     return retval;
 }
 
@@ -616,6 +547,26 @@ unlock:
     return retval;
 }
 
+static long usb_amradio_ioctl(struct file *file, unsigned int cmd,
+                unsigned long arg)
+{
+    struct amradio_device *radio = file->private_data;
+    long retval = 0;
+
+    mutex_lock(&radio->lock);
+
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
+
+    retval = video_ioctl2(file, cmd, arg);
+
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
+}
+
 /* Suspend device - stop device. Need to be checked and fixed */
 static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t 
message)
 {
@@ -657,7 +608,7 @@ static const struct v4l2_file_operations 
usb_amradio_fops = {
     .owner        = THIS_MODULE,
     .open        = usb_amradio_open,
     .release    = usb_amradio_close,
-    .ioctl        = video_ioctl2,
+    .ioctl        = usb_amradio_ioctl,
 };
 
 static const struct v4l2_ioctl_ops usb_amradio_ioctl_ops = {
-- 
1.6.3.3


--------------020700040700000607060209
Content-Type: text/x-diff;
 name="0006-mr800-simplify-locking-in-ioctl-callbacks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0006-mr800-simplify-locking-in-ioctl-callbacks.patch"

>From c012b1ac39a225e003b190a12ae942e1dd6ea09b Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 01:07:13 -0400
Subject: [PATCH 06/10] mr800: simplify locking in ioctl callbacks

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |  109 ++++++++++---------------------------
 1 files changed, 30 insertions(+), 79 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 7305c96..71d15ba 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -299,18 +299,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	struct amradio_device *radio = file->private_data;
 	int retval;
 
-	mutex_lock(&radio->lock);
-
-	/* safety check */
-	if (radio->removed) {
-		retval = -EIO;
-		goto unlock;
-	}
-
-	if (v->index > 0) {
-		retval = -EINVAL;
-		goto unlock;
-	}
+	if (v->index > 0)
+		return -EINVAL;
 
 /* TODO: Add function which look is signal stereo or not
  * 	amradio_getstat(radio);
@@ -338,8 +328,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	v->signal = 0xffff;     /* Can't get the signal strength, sad.. */
 	v->afc = 0; /* Don't know what is this */
 
-unlock:
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -348,20 +336,10 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
 	struct amradio_device *radio = file->private_data;
-	int retval;
-
-	mutex_lock(&radio->lock);
-
-	/* safety check */
-	if (radio->removed) {
-		retval = -EIO;
-		goto unlock;
-	}
+	int retval = -EINVAL;
 
-	if (v->index > 0) {
-		retval = -EINVAL;
-		goto unlock;
-	}
+	if (v->index > 0)
+		return -EINVAL;
 
 	/* mono/stereo selector */
 	switch (v->audmode) {
@@ -377,12 +355,8 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 			amradio_dev_warn(&radio->videodev.dev,
 				"set stereo failed\n");
 		break;
-	default:
-		retval = -EINVAL;
 	}
 
-unlock:
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -391,15 +365,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
 	struct amradio_device *radio = file->private_data;
-	int retval;
-
-	mutex_lock(&radio->lock);
-
-	/* safety check */
-	if (radio->removed) {
-		retval = -EIO;
-		goto unlock;
-	}
+	int retval = 0;
 
 	radio->curfreq = f->frequency;
 
@@ -408,8 +374,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		amradio_dev_warn(&radio->videodev.dev,
 			"set frequency failed\n");
 
-unlock:
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -418,22 +382,11 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
 	struct amradio_device *radio = file->private_data;
-	int retval = 0;
-
-	mutex_lock(&radio->lock);
-
-	/* safety check */
-	if (radio->removed) {
-		retval = -EIO;
-		goto unlock;
-	}
 
 	f->type = V4L2_TUNER_RADIO;
 	f->frequency = radio->curfreq;
 
-unlock:
-	mutex_unlock(&radio->lock);
-	return retval;
+	return 0;
 }
 
 /* vidioc_queryctrl - enumerate control items */
@@ -453,26 +406,14 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
 	struct amradio_device *radio = file->private_data;
-	int retval = -EINVAL;
-
-	mutex_lock(&radio->lock);
-
-	/* safety check */
-	if (radio->removed) {
-		retval = -EIO;
-		goto unlock;
-	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		ctrl->value = radio->muted;
-		retval = 0;
-		break;
+		return 0;
 	}
 
-unlock:
-	mutex_unlock(&radio->lock);
-	return retval;
+	return -EINVAL;
 }
 
 /* vidioc_s_ctrl - set the value of a control */
@@ -482,14 +423,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	struct amradio_device *radio = file->private_data;
 	int retval = -EINVAL;
 
-	mutex_lock(&radio->lock);
-
-	/* safety check */
-	if (radio->removed) {
-		retval = -EIO;
-		goto unlock;
-	}
-
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
@@ -508,8 +441,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 		break;
 	}
 
-unlock:
-	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -616,6 +547,26 @@ unlock:
 	return retval;
 }
 
+static long usb_amradio_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	struct amradio_device *radio = file->private_data;
+	long retval = 0;
+
+	mutex_lock(&radio->lock);
+
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
+
+	retval = video_ioctl2(file, cmd, arg);
+
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
+}
+
 /* Suspend device - stop device. Need to be checked and fixed */
 static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 {
@@ -657,7 +608,7 @@ static const struct v4l2_file_operations usb_amradio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= usb_amradio_open,
 	.release	= usb_amradio_close,
-	.ioctl		= video_ioctl2,
+	.ioctl		= usb_amradio_ioctl,
 };
 
 static const struct v4l2_ioctl_ops usb_amradio_ioctl_ops = {
-- 
1.6.3.3


--------------020700040700000607060209--
