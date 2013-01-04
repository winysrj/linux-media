Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:64660 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3ADU75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 15:59:57 -0500
Received: by mail-vb0-f42.google.com with SMTP id fa15so17261950vbb.29
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:59:56 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/15] em28xx: fix tuner/frequency handling
Date: Fri,  4 Jan 2013 15:59:34 -0500
Message-Id: <1357333186-8466-5-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance found problems with frequency clamping that wasn't
reported correctly and missing tuner index checks.

Also removed unnecessary tuner type checks (these are now done by the
v4l2 core).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index b71df42..89cbfaf 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1322,7 +1322,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	strcpy(t->name, "Tuner");
-	t->type = V4L2_TUNER_ANALOG_TV;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
 	return 0;
@@ -1352,7 +1351,9 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
 
-	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	if (0 != f->tuner)
+		return -EINVAL;
+
 	f->frequency = dev->ctl_freq;
 	return 0;
 }
@@ -1371,13 +1372,9 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (0 != f->tuner)
 		return -EINVAL;
 
-	if (unlikely(0 == fh->radio && f->type != V4L2_TUNER_ANALOG_TV))
-		return -EINVAL;
-	if (unlikely(1 == fh->radio && f->type != V4L2_TUNER_RADIO))
-		return -EINVAL;
-
-	dev->ctl_freq = f->frequency;
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, f);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, f);
+	dev->ctl_freq = f->frequency;
 
 	return 0;
 }
-- 
1.7.9.5

