Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4452 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab0KPSil (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 13:38:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Tue, 16 Nov 2010 19:38:11 +0100
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1289740431.git.hverkuil@xs4all.nl> <201011161701.36982.arnd@arndb.de> <201011161749.05844.hverkuil@xs4all.nl>
In-Reply-To: <201011161749.05844.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011161938.11476.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, November 16, 2010 17:49:05 Hans Verkuil wrote:
> On Tuesday, November 16, 2010 17:01:36 Arnd Bergmann wrote:
> > On Tuesday 16 November 2010, Hans Verkuil wrote:
> > > > I think there is a misunderstanding. One V4L device (e.g. a TV capture
> > > > card, a webcam, etc.) has one v4l2_device struct. But it can have multiple
> > > > V4L device nodes (/dev/video0, /dev/radio0, etc.), each represented by a
> > > > struct video_device (and I really hope I can rename that to v4l2_devnode
> > > > soon since that's a very confusing name).
> > > >
> > > > You typically need to serialize between all the device nodes belonging to
> > > > the same video hardware. A mutex in struct video_device doesn't do that,
> > > > that just serializes access to that single device node. But a mutex in
> > > > v4l2_device is at the right level.
> > 
> > Ok, got it now.
> > 
> > > A quick follow-up as I saw I didn't fully answer your question: to my
> > > knowledge there are no per-driver data structures that need a BKL for
> > > protection. It's definitely not something I am worried about.
> > 
> > Good. Are you preparing a patch for a per-v4l2_device then? This sounds
> > like the right place with your explanation. I would not put in the
> > CONFIG_BKL switch, because I tried that for two other subsystems and got
> > called back, but I'm not going to stop you.
> > 
> > As for the fallback to a global mutex, I guess you can set the
> > videodev->lock pointer and use unlocked_ioctl for those drivers
> > that do not use a v4l2_device yet, if there are only a handful of them.
> > 
> > 	Arnd
> > 
> 
> I will look into it. I'll try to have something today or tomorrow.

OK, here is my patch adding a mutex to v4l2_device.

I did some tests if we merge this patch then there are three classes of
drivers:

1) Those implementing unlocked_ioctl: these work like a charm.
2) Those implementing v4l2_device: capturing works fine, but calling ioctls
at the same time from another process or thread is *exceedingly* slow. But at
least there is no interference from other drivers.
3) Those not implementing v4l2_device: using a core lock makes it simply
impossible to capture from e.g. two devices at the same time. I tried with two
uvc webcams: the capture rate is simply horrible.

Note that this is tested in blocking mode. These problems do not appear if you
capture in non-blocking mode.

I consider class 3 unacceptable for commonly seen devices. I did a quick scan
of the v4l drivers and the only common driver that falls in that class is uvc.

There is one other option, although it is very dirty: don't take the lock if
the ioctl command is VIDIOC_DQBUF. It works and reliably as well for uvc and
videobuf (I did a quick code analysis). But I don't know if it works everywhere.

I would like to get the opinion of others before I implement such a check. But
frankly, I think this may be our best bet.

So the patch below would look like this if I add the check:

-               mutex_lock(&v4l2_ioctl_mutex);
+               if (cmd != VIDIOC_DQBUF)
+                       mutex_lock(m);
                if (video_is_registered(vdev))
                        ret = vdev->fops->ioctl(filp, cmd, arg);
-               mutex_unlock(&v4l2_ioctl_mutex);
+               if (cmd != VIDIOC_DQBUF)
+                       mutex_unlock(m);

Comments?

Regards,

	Hans

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 03f7f46..026bf38 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -247,11 +247,13 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	} else if (vdev->fops->ioctl) {
 		/* TODO: convert all drivers to unlocked_ioctl */
 		static DEFINE_MUTEX(v4l2_ioctl_mutex);
+		struct mutex *m = vdev->v4l2_dev ?
+			&vdev->v4l2_dev->ioctl_lock : &v4l2_ioctl_mutex;
 
-		mutex_lock(&v4l2_ioctl_mutex);
+		mutex_lock(m);
 		if (video_is_registered(vdev))
 			ret = vdev->fops->ioctl(filp, cmd, arg);
-		mutex_unlock(&v4l2_ioctl_mutex);
+		mutex_unlock(m);
 	} else
 		ret = -ENOTTY;
 
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 0b08f96..7fe6f92 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -35,6 +35,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 
 	INIT_LIST_HEAD(&v4l2_dev->subdevs);
 	spin_lock_init(&v4l2_dev->lock);
+	mutex_init(&v4l2_dev->ioctl_lock);
 	v4l2_dev->dev = dev;
 	if (dev == NULL) {
 		/* If dev == NULL, then name must be filled in by the caller */
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 6648036..b16f307 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -51,6 +51,8 @@ struct v4l2_device {
 			unsigned int notification, void *arg);
 	/* The control handler. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
+	/* BKL replacement mutex. Temporary solution only. */
+	struct mutex ioctl_lock;
 };
 
 /* Initialize v4l2_dev and make dev->driver_data point to v4l2_dev.

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
