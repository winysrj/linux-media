Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:61821 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3ADVAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:00 -0500
Received: by mail-vb0-f42.google.com with SMTP id fa15so16981651vbb.15
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 12:59:59 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/15] em28xx: convert to v4l2_fh, fix priority handling.
Date: Fri,  4 Jan 2013 15:59:37 -0500
Message-Id: <1357333186-8466-8-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    5 +++++
 drivers/media/usb/em28xx/em28xx.h       |    2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index ebbf775..c67ff8d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1735,6 +1735,7 @@ static int em28xx_v4l2_open(struct file *filp)
 		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
+	v4l2_fh_init(&fh->fh, vdev);
 	fh->dev = dev;
 	fh->radio = radio;
 	fh->type = fh_type;
@@ -1774,6 +1775,7 @@ static int em28xx_v4l2_open(struct file *filp)
 				    V4L2_FIELD_SEQ_TB,
 				    sizeof(struct em28xx_buffer), fh, &dev->lock);
 	mutex_unlock(&dev->lock);
+	v4l2_fh_add(&fh->fh);
 
 	return errCode;
 }
@@ -1867,6 +1869,8 @@ static int em28xx_v4l2_close(struct file *filp)
 					"0 (error=%i)\n", errCode);
 		}
 	}
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 
 	videobuf_mmap_free(&fh->vb_vidq);
 	videobuf_mmap_free(&fh->vb_vbiq);
@@ -2088,6 +2092,7 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 	vfd->release	= video_device_release;
 	vfd->debug	= video_debug;
 	vfd->lock	= &dev->lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s",
 		 dev->name, type_name);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 707319e..7432be4 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -34,6 +34,7 @@
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/rc-core.h>
 #if defined(CONFIG_VIDEO_EM28XX_DVB) || defined(CONFIG_VIDEO_EM28XX_DVB_MODULE)
@@ -477,6 +478,7 @@ struct em28xx_audio {
 struct em28xx;
 
 struct em28xx_fh {
+	struct v4l2_fh fh;
 	struct em28xx *dev;
 	int           radio;
 	unsigned int  resources;
-- 
1.7.9.5

