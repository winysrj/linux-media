Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:20584 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbZILOtE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:49:04 -0400
Received: by qw-out-2122.google.com with SMTP id 9so632867qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:49:07 -0700 (PDT)
Message-ID: <4AABB4D7.3070903@gmail.com>
Date: Sat, 12 Sep 2009 10:48:55 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 01/10] radio-mr800: implement proper locking
Content-Type: multipart/mixed;
 boundary="------------080800020803060903010700"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080800020803060903010700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 1773df59dc8e63ca00a27f5235c293341fd07f36 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Fri, 11 Sep 2009 23:21:17 -0400
Subject: [PATCH 01/10] mr800: implement proper locking

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |  181 
++++++++++++++++++++++---------------
 1 files changed, 106 insertions(+), 75 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 575bf9d..8e96c8a 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -168,11 +168,7 @@ static int amradio_set_mute(struct amradio_device 
*radio, char argument)
     int retval;
     int size;
 
-    /* safety check */
-    if (radio->removed)
-        return -EIO;
-
-    mutex_lock(&radio->lock);
+    BUG_ON(!mutex_is_locked(&radio->lock));
 
     radio->buffer[0] = 0x00;
     radio->buffer[1] = 0x55;
@@ -186,15 +182,11 @@ static int amradio_set_mute(struct amradio_device 
*radio, char argument)
     retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
         (void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-    if (retval < 0 || size != BUFFER_LENGTH) {
-        mutex_unlock(&radio->lock);
+    if (retval < 0 || size != BUFFER_LENGTH)
         return retval;
-    }
 
     radio->muted = argument;
 
-    mutex_unlock(&radio->lock);
-
     return retval;
 }
 
@@ -205,11 +197,7 @@ static int amradio_setfreq(struct amradio_device 
*radio, int freq)
     int size;
     unsigned short freq_send = 0x10 + (freq >> 3) / 25;
 
-    /* safety check */
-    if (radio->removed)
-        return -EIO;
-
-    mutex_lock(&radio->lock);
+    BUG_ON(!mutex_is_locked(&radio->lock));
 
     radio->buffer[0] = 0x00;
     radio->buffer[1] = 0x55;
@@ -223,10 +211,8 @@ static int amradio_setfreq(struct amradio_device 
*radio, int freq)
     retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
         (void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-    if (retval < 0 || size != BUFFER_LENGTH) {
-        mutex_unlock(&radio->lock);
+    if (retval < 0 || size != BUFFER_LENGTH)
         return retval;
-    }
 
     /* frequency is calculated from freq_send and placed in first 2 
bytes */
     radio->buffer[0] = (freq_send >> 8) & 0xff;
@@ -240,13 +226,6 @@ static int amradio_setfreq(struct amradio_device 
*radio, int freq)
     retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
         (void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-    if (retval < 0 || size != BUFFER_LENGTH) {
-        mutex_unlock(&radio->lock);
-        return retval;
-    }
-
-    mutex_unlock(&radio->lock);
-
     return retval;
 }
 
@@ -255,11 +234,7 @@ static int amradio_set_stereo(struct amradio_device 
*radio, char argument)
     int retval;
     int size;
 
-    /* safety check */
-    if (radio->removed)
-        return -EIO;
-
-    mutex_lock(&radio->lock);
+    BUG_ON(!mutex_is_locked(&radio->lock));
 
     radio->buffer[0] = 0x00;
     radio->buffer[1] = 0x55;
@@ -275,14 +250,11 @@ static int amradio_set_stereo(struct 
amradio_device *radio, char argument)
 
     if (retval < 0 || size != BUFFER_LENGTH) {
         radio->stereo = -1;
-        mutex_unlock(&radio->lock);
         return retval;
     }
 
     radio->stereo = 1;
 
-    mutex_unlock(&radio->lock);
-
     return retval;
 }
 
@@ -325,12 +297,18 @@ static int vidioc_g_tuner(struct file *file, void 
*priv,
     struct amradio_device *radio = video_get_drvdata(video_devdata(file));
     int retval;
 
+    mutex_lock(&radio->lock);
+
     /* safety check */
-    if (radio->removed)
-        return -EIO;
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
 
-    if (v->index > 0)
-        return -EINVAL;
+    if (v->index > 0) {
+        retval = -EINVAL;
+        goto unlock;
+    }
 
 /* TODO: Add function which look is signal stereo or not
  *     amradio_getstat(radio);
@@ -357,7 +335,10 @@ static int vidioc_g_tuner(struct file *file, void 
*priv,
         v->audmode = V4L2_TUNER_MODE_MONO;
     v->signal = 0xffff;     /* Can't get the signal strength, sad.. */
     v->afc = 0; /* Don't know what is this */
-    return 0;
+
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
 }
 
 /* vidioc_s_tuner - set tuner attributes */
@@ -367,12 +348,18 @@ static int vidioc_s_tuner(struct file *file, void 
*priv,
     struct amradio_device *radio = video_get_drvdata(video_devdata(file));
     int retval;
 
+    mutex_lock(&radio->lock);
+
     /* safety check */
-    if (radio->removed)
-        return -EIO;
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
 
-    if (v->index > 0)
-        return -EINVAL;
+    if (v->index > 0) {
+        retval = -EINVAL;
+        goto unlock;
+    }
 
     /* mono/stereo selector */
     switch (v->audmode) {
@@ -389,10 +376,12 @@ static int vidioc_s_tuner(struct file *file, void 
*priv,
                 "set stereo failed\n");
         break;
     default:
-        return -EINVAL;
+        retval = -EINVAL;
     }
 
-    return 0;
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
 }
 
 /* vidioc_s_frequency - set tuner radio frequency */
@@ -402,19 +391,24 @@ static int vidioc_s_frequency(struct file *file, 
void *priv,
     struct amradio_device *radio = video_get_drvdata(video_devdata(file));
     int retval;
 
+    mutex_lock(&radio->lock);
+
     /* safety check */
-    if (radio->removed)
-        return -EIO;
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
 
-    mutex_lock(&radio->lock);
     radio->curfreq = f->frequency;
-    mutex_unlock(&radio->lock);
 
     retval = amradio_setfreq(radio, radio->curfreq);
     if (retval < 0)
         amradio_dev_warn(&radio->videodev->dev,
             "set frequency failed\n");
-    return 0;
+
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
 }
 
 /* vidioc_g_frequency - get tuner radio frequency */
@@ -422,14 +416,22 @@ static int vidioc_g_frequency(struct file *file, 
void *priv,
                 struct v4l2_frequency *f)
 {
     struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    int retval = 0;
+
+    mutex_lock(&radio->lock);
 
     /* safety check */
-    if (radio->removed)
-        return -EIO;
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
 
     f->type = V4L2_TUNER_RADIO;
     f->frequency = radio->curfreq;
-    return 0;
+
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
 }
 
 /* vidioc_queryctrl - enumerate control items */
@@ -449,17 +451,26 @@ static int vidioc_g_ctrl(struct file *file, void 
*priv,
                 struct v4l2_control *ctrl)
 {
     struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+    int retval = -EINVAL;
+
+    mutex_lock(&radio->lock);
 
     /* safety check */
-    if (radio->removed)
-        return -EIO;
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
 
     switch (ctrl->id) {
     case V4L2_CID_AUDIO_MUTE:
         ctrl->value = radio->muted;
-        return 0;
+        retval = 0;
+        break;
     }
-    return -EINVAL;
+
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
 }
 
 /* vidioc_s_ctrl - set the value of a control */
@@ -467,11 +478,15 @@ static int vidioc_s_ctrl(struct file *file, void 
*priv,
                 struct v4l2_control *ctrl)
 {
     struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-    int retval;
+    int retval = -EINVAL;
+
+    mutex_lock(&radio->lock);
 
     /* safety check */
-    if (radio->removed)
-        return -EIO;
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
 
     switch (ctrl->id) {
     case V4L2_CID_AUDIO_MUTE:
@@ -480,19 +495,20 @@ static int vidioc_s_ctrl(struct file *file, void 
*priv,
             if (retval < 0) {
                 amradio_dev_warn(&radio->videodev->dev,
                     "amradio_stop failed\n");
-                return -1;
             }
         } else {
             retval = amradio_set_mute(radio, AMRADIO_START);
             if (retval < 0) {
                 amradio_dev_warn(&radio->videodev->dev,
                     "amradio_start failed\n");
-                return -1;
             }
         }
-        return 0;
+        break;
     }
-    return -EINVAL;
+
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
 }
 
 /* vidioc_g_audio - get audio attributes */
@@ -535,9 +551,14 @@ static int vidioc_s_input(struct file *filp, void 
*priv, unsigned int i)
 static int usb_amradio_open(struct file *file)
 {
     struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-    int retval;
+    int retval = 0;
 
-    lock_kernel();
+    mutex_lock(&radio->lock);
+
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
 
     radio->users = 1;
     radio->muted = 1;
@@ -547,8 +568,7 @@ static int usb_amradio_open(struct file *file)
         amradio_dev_warn(&radio->videodev->dev,
             "radio did not start up properly\n");
         radio->users = 0;
-        unlock_kernel();
-        return -EIO;
+        goto unlock;
     }
 
     retval = amradio_set_stereo(radio, WANT_STEREO);
@@ -561,22 +581,25 @@ static int usb_amradio_open(struct file *file)
         amradio_dev_warn(&radio->videodev->dev,
             "set frequency failed\n");
 
-    unlock_kernel();
-    return 0;
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
 }
 
 /*close device */
 static int usb_amradio_close(struct file *file)
 {
     struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-    int retval;
-
-    if (!radio)
-        return -ENODEV;
+    int retval = 0;
 
     mutex_lock(&radio->lock);
+
+    if (radio->removed) {
+        retval = -EIO;
+        goto unlock;
+    }
+
     radio->users = 0;
-    mutex_unlock(&radio->lock);
 
     if (!radio->removed) {
         retval = amradio_set_mute(radio, AMRADIO_STOP);
@@ -585,7 +608,9 @@ static int usb_amradio_close(struct file *file)
                 "amradio_stop failed\n");
     }
 
-    return 0;
+unlock:
+    mutex_unlock(&radio->lock);
+    return retval;
 }
 
 /* Suspend device - stop device. Need to be checked and fixed */
@@ -594,12 +619,15 @@ static int usb_amradio_suspend(struct 
usb_interface *intf, pm_message_t message)
     struct amradio_device *radio = usb_get_intfdata(intf);
     int retval;
 
+    mutex_lock(&radio->lock);
+
     retval = amradio_set_mute(radio, AMRADIO_STOP);
     if (retval < 0)
         dev_warn(&intf->dev, "amradio_stop failed\n");
 
     dev_info(&intf->dev, "going into suspend..\n");
 
+    mutex_unlock(&radio->lock);
     return 0;
 }
 
@@ -609,12 +637,15 @@ static int usb_amradio_resume(struct usb_interface 
*intf)
     struct amradio_device *radio = usb_get_intfdata(intf);
     int retval;
 
+    mutex_lock(&radio->lock);
+
     retval = amradio_set_mute(radio, AMRADIO_START);
     if (retval < 0)
         dev_warn(&intf->dev, "amradio_start failed\n");
 
     dev_info(&intf->dev, "coming out of suspend..\n");
 
+    mutex_unlock(&radio->lock);
     return 0;
 }
 
-- 
1.6.3.3


--------------080800020803060903010700
Content-Type: text/x-diff;
 name="0001-mr800-implement-proper-locking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-mr800-implement-proper-locking.patch"

>From 1773df59dc8e63ca00a27f5235c293341fd07f36 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Fri, 11 Sep 2009 23:21:17 -0400
Subject: [PATCH 01/10] mr800: implement proper locking

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |  181 ++++++++++++++++++++++---------------
 1 files changed, 106 insertions(+), 75 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 575bf9d..8e96c8a 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -168,11 +168,7 @@ static int amradio_set_mute(struct amradio_device *radio, char argument)
 	int retval;
 	int size;
 
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
-	mutex_lock(&radio->lock);
+	BUG_ON(!mutex_is_locked(&radio->lock));
 
 	radio->buffer[0] = 0x00;
 	radio->buffer[1] = 0x55;
@@ -186,15 +182,11 @@ static int amradio_set_mute(struct amradio_device *radio, char argument)
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval < 0 || size != BUFFER_LENGTH) {
-		mutex_unlock(&radio->lock);
+	if (retval < 0 || size != BUFFER_LENGTH)
 		return retval;
-	}
 
 	radio->muted = argument;
 
-	mutex_unlock(&radio->lock);
-
 	return retval;
 }
 
@@ -205,11 +197,7 @@ static int amradio_setfreq(struct amradio_device *radio, int freq)
 	int size;
 	unsigned short freq_send = 0x10 + (freq >> 3) / 25;
 
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
-	mutex_lock(&radio->lock);
+	BUG_ON(!mutex_is_locked(&radio->lock));
 
 	radio->buffer[0] = 0x00;
 	radio->buffer[1] = 0x55;
@@ -223,10 +211,8 @@ static int amradio_setfreq(struct amradio_device *radio, int freq)
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval < 0 || size != BUFFER_LENGTH) {
-		mutex_unlock(&radio->lock);
+	if (retval < 0 || size != BUFFER_LENGTH)
 		return retval;
-	}
 
 	/* frequency is calculated from freq_send and placed in first 2 bytes */
 	radio->buffer[0] = (freq_send >> 8) & 0xff;
@@ -240,13 +226,6 @@ static int amradio_setfreq(struct amradio_device *radio, int freq)
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval < 0 || size != BUFFER_LENGTH) {
-		mutex_unlock(&radio->lock);
-		return retval;
-	}
-
-	mutex_unlock(&radio->lock);
-
 	return retval;
 }
 
@@ -255,11 +234,7 @@ static int amradio_set_stereo(struct amradio_device *radio, char argument)
 	int retval;
 	int size;
 
-	/* safety check */
-	if (radio->removed)
-		return -EIO;
-
-	mutex_lock(&radio->lock);
+	BUG_ON(!mutex_is_locked(&radio->lock));
 
 	radio->buffer[0] = 0x00;
 	radio->buffer[1] = 0x55;
@@ -275,14 +250,11 @@ static int amradio_set_stereo(struct amradio_device *radio, char argument)
 
 	if (retval < 0 || size != BUFFER_LENGTH) {
 		radio->stereo = -1;
-		mutex_unlock(&radio->lock);
 		return retval;
 	}
 
 	radio->stereo = 1;
 
-	mutex_unlock(&radio->lock);
-
 	return retval;
 }
 
@@ -325,12 +297,18 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
+	mutex_lock(&radio->lock);
+
 	/* safety check */
-	if (radio->removed)
-		return -EIO;
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
 
-	if (v->index > 0)
-		return -EINVAL;
+	if (v->index > 0) {
+		retval = -EINVAL;
+		goto unlock;
+	}
 
 /* TODO: Add function which look is signal stereo or not
  * 	amradio_getstat(radio);
@@ -357,7 +335,10 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 		v->audmode = V4L2_TUNER_MODE_MONO;
 	v->signal = 0xffff;     /* Can't get the signal strength, sad.. */
 	v->afc = 0; /* Don't know what is this */
-	return 0;
+
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
 }
 
 /* vidioc_s_tuner - set tuner attributes */
@@ -367,12 +348,18 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
+	mutex_lock(&radio->lock);
+
 	/* safety check */
-	if (radio->removed)
-		return -EIO;
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
 
-	if (v->index > 0)
-		return -EINVAL;
+	if (v->index > 0) {
+		retval = -EINVAL;
+		goto unlock;
+	}
 
 	/* mono/stereo selector */
 	switch (v->audmode) {
@@ -389,10 +376,12 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 				"set stereo failed\n");
 		break;
 	default:
-		return -EINVAL;
+		retval = -EINVAL;
 	}
 
-	return 0;
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
 }
 
 /* vidioc_s_frequency - set tuner radio frequency */
@@ -402,19 +391,24 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
+	mutex_lock(&radio->lock);
+
 	/* safety check */
-	if (radio->removed)
-		return -EIO;
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
 
-	mutex_lock(&radio->lock);
 	radio->curfreq = f->frequency;
-	mutex_unlock(&radio->lock);
 
 	retval = amradio_setfreq(radio, radio->curfreq);
 	if (retval < 0)
 		amradio_dev_warn(&radio->videodev->dev,
 			"set frequency failed\n");
-	return 0;
+
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
 }
 
 /* vidioc_g_frequency - get tuner radio frequency */
@@ -422,14 +416,22 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
+
+	mutex_lock(&radio->lock);
 
 	/* safety check */
-	if (radio->removed)
-		return -EIO;
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
 
 	f->type = V4L2_TUNER_RADIO;
 	f->frequency = radio->curfreq;
-	return 0;
+
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
 }
 
 /* vidioc_queryctrl - enumerate control items */
@@ -449,17 +451,26 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = -EINVAL;
+
+	mutex_lock(&radio->lock);
 
 	/* safety check */
-	if (radio->removed)
-		return -EIO;
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
 		ctrl->value = radio->muted;
-		return 0;
+		retval = 0;
+		break;
 	}
-	return -EINVAL;
+
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
 }
 
 /* vidioc_s_ctrl - set the value of a control */
@@ -467,11 +478,15 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 				struct v4l2_control *ctrl)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = -EINVAL;
+
+	mutex_lock(&radio->lock);
 
 	/* safety check */
-	if (radio->removed)
-		return -EIO;
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
@@ -480,19 +495,20 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 			if (retval < 0) {
 				amradio_dev_warn(&radio->videodev->dev,
 					"amradio_stop failed\n");
-				return -1;
 			}
 		} else {
 			retval = amradio_set_mute(radio, AMRADIO_START);
 			if (retval < 0) {
 				amradio_dev_warn(&radio->videodev->dev,
 					"amradio_start failed\n");
-				return -1;
 			}
 		}
-		return 0;
+		break;
 	}
-	return -EINVAL;
+
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
 }
 
 /* vidioc_g_audio - get audio attributes */
@@ -535,9 +551,14 @@ static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 static int usb_amradio_open(struct file *file)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	lock_kernel();
+	mutex_lock(&radio->lock);
+
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
 
 	radio->users = 1;
 	radio->muted = 1;
@@ -547,8 +568,7 @@ static int usb_amradio_open(struct file *file)
 		amradio_dev_warn(&radio->videodev->dev,
 			"radio did not start up properly\n");
 		radio->users = 0;
-		unlock_kernel();
-		return -EIO;
+		goto unlock;
 	}
 
 	retval = amradio_set_stereo(radio, WANT_STEREO);
@@ -561,22 +581,25 @@ static int usb_amradio_open(struct file *file)
 		amradio_dev_warn(&radio->videodev->dev,
 			"set frequency failed\n");
 
-	unlock_kernel();
-	return 0;
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
 }
 
 /*close device */
 static int usb_amradio_close(struct file *file)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
-
-	if (!radio)
-		return -ENODEV;
+	int retval = 0;
 
 	mutex_lock(&radio->lock);
+
+	if (radio->removed) {
+		retval = -EIO;
+		goto unlock;
+	}
+
 	radio->users = 0;
-	mutex_unlock(&radio->lock);
 
 	if (!radio->removed) {
 		retval = amradio_set_mute(radio, AMRADIO_STOP);
@@ -585,7 +608,9 @@ static int usb_amradio_close(struct file *file)
 				"amradio_stop failed\n");
 	}
 
-	return 0;
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
 }
 
 /* Suspend device - stop device. Need to be checked and fixed */
@@ -594,12 +619,15 @@ static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 	struct amradio_device *radio = usb_get_intfdata(intf);
 	int retval;
 
+	mutex_lock(&radio->lock);
+
 	retval = amradio_set_mute(radio, AMRADIO_STOP);
 	if (retval < 0)
 		dev_warn(&intf->dev, "amradio_stop failed\n");
 
 	dev_info(&intf->dev, "going into suspend..\n");
 
+	mutex_unlock(&radio->lock);
 	return 0;
 }
 
@@ -609,12 +637,15 @@ static int usb_amradio_resume(struct usb_interface *intf)
 	struct amradio_device *radio = usb_get_intfdata(intf);
 	int retval;
 
+	mutex_lock(&radio->lock);
+
 	retval = amradio_set_mute(radio, AMRADIO_START);
 	if (retval < 0)
 		dev_warn(&intf->dev, "amradio_start failed\n");
 
 	dev_info(&intf->dev, "coming out of suspend..\n");
 
+	mutex_unlock(&radio->lock);
 	return 0;
 }
 
-- 
1.6.3.3


--------------080800020803060903010700--
