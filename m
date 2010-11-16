Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:58424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501Ab0KPOVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 09:21:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Tue, 16 Nov 2010 15:22:19 +0100
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <cover.1289740431.git.hverkuil@xs4all.nl> <4CE281E8.3040705@redhat.com> <7d7108eaf1260587bbe2cacf8f5d2db9.squirrel@webmail.xs4all.nl>
In-Reply-To: <7d7108eaf1260587bbe2cacf8f5d2db9.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011161522.19758.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 16 November 2010, Hans Verkuil wrote:
> No, it will also affect e.g. two bttv cards that you capture from in
> parallel. Or two webcams, or...

Would it be safe to turn the global mutex into a per-driver or per-device
mutex? That would largely mitigate the impact as far as I can tell.

> We can't just ditch the BKL yet for 2.6.37 IMHO. Perhaps for 2.6.38 if we
> all work really hard to convert everything.

Linus was pretty clear in that he wanted to make the default for the BKL
disabled for 2.6.37. That may of course change if there are significant
problems with this, but as long as there is an easier way, we could do
that instead.

I have not tested the patch below, but maybe that would solve the
immediate problem without reverting v4l2-dev back to use the BKL.

It would not work if we have drivers that need to serialize access
to multiple v4l2 devices in their ioctl functions because they access
global data, which is unlikely but possible.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 03f7f46..5873d12 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -246,12 +246,11 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			mutex_unlock(vdev->lock);
 	} else if (vdev->fops->ioctl) {
 		/* TODO: convert all drivers to unlocked_ioctl */
-		static DEFINE_MUTEX(v4l2_ioctl_mutex);
-
-		mutex_lock(&v4l2_ioctl_mutex);
-		if (video_is_registered(vdev))
+		if (video_is_registered(vdev)) {
+			mutex_lock(&vdev->ioctl_lock);
 			ret = vdev->fops->ioctl(filp, cmd, arg);
-		mutex_unlock(&v4l2_ioctl_mutex);
+			mutex_unlock(&vdev->ioctl_lock);
+		}
 	} else
 		ret = -ENOTTY;
 
@@ -507,6 +506,7 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 #endif
 	vdev->minor = i + minor_offset;
 	vdev->num = nr;
+	mutex_init(&vdev->ioctl_lock);
 	devnode_set(vdev);
 
 	/* Should not happen since we thought this minor was free */
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 15802a0..e8a8485 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -97,6 +97,9 @@ struct video_device
 
 	/* serialization lock */
 	struct mutex *lock;
+
+	/* used for the legacy locked ioctl */
+	struct mutex ioctl_lock;
 };
 
 /* dev to video-device */
