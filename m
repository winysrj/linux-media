Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3801 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab0KPU3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 15:29:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Tue, 16 Nov 2010 21:29:11 +0100
Cc: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <cover.1289740431.git.hverkuil@xs4all.nl> <201011161938.11476.hverkuil@xs4all.nl> <1289937581.2104.29.camel@morgan.silverblock.net>
In-Reply-To: <1289937581.2104.29.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011162129.11096.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, November 16, 2010 20:59:41 Andy Walls wrote:
> On Tue, 2010-11-16 at 19:38 +0100, Hans Verkuil wrote:
> > On Tuesday, November 16, 2010 17:49:05 Hans Verkuil wrote:
> > > On Tuesday, November 16, 2010 17:01:36 Arnd Bergmann wrote:
> > > > On Tuesday 16 November 2010, Hans Verkuil wrote:
> > > > > > I think there is a misunderstanding. One V4L device (e.g. a TV capture
> > > > > > card, a webcam, etc.) has one v4l2_device struct. But it can have multiple
> > > > > > V4L device nodes (/dev/video0, /dev/radio0, etc.), each represented by a
> > > > > > struct video_device (and I really hope I can rename that to v4l2_devnode
> > > > > > soon since that's a very confusing name).
> > > > > >
> > > > > > You typically need to serialize between all the device nodes belonging to
> > > > > > the same video hardware. A mutex in struct video_device doesn't do that,
> > > > > > that just serializes access to that single device node. But a mutex in
> > > > > > v4l2_device is at the right level.
> > > > 
> > > > Ok, got it now.
> > > > 
> > > > > A quick follow-up as I saw I didn't fully answer your question: to my
> > > > > knowledge there are no per-driver data structures that need a BKL for
> > > > > protection. It's definitely not something I am worried about.
> > > > 
> > > > Good. Are you preparing a patch for a per-v4l2_device then? This sounds
> > > > like the right place with your explanation. I would not put in the
> > > > CONFIG_BKL switch, because I tried that for two other subsystems and got
> > > > called back, but I'm not going to stop you.
> > > > 
> > > > As for the fallback to a global mutex, I guess you can set the
> > > > videodev->lock pointer and use unlocked_ioctl for those drivers
> > > > that do not use a v4l2_device yet, if there are only a handful of them.
> > > > 
> > > > 	Arnd
> > > > 
> > > 
> > > I will look into it. I'll try to have something today or tomorrow.
> > 
> > OK, here is my patch adding a mutex to v4l2_device.
> > 
> > I did some tests if we merge this patch then there are three classes of
> > drivers:
> > 
> > 1) Those implementing unlocked_ioctl: these work like a charm.
> > 2) Those implementing v4l2_device: capturing works fine, but calling ioctls
> > at the same time from another process or thread is *exceedingly* slow. But at
> > least there is no interference from other drivers.

BTW, with 'exceedingly slow' I mean that e.g. a v4l2-ctl --list-ctrls takes 10-20
seconds if the device node is streaming at the same time. Something that normally
takes less than 0.01s.

> > 3) Those not implementing v4l2_device: using a core lock makes it simply
> > impossible to capture from e.g. two devices at the same time. I tried with two
> > uvc webcams: the capture rate is simply horrible.
> > 
> > Note that this is tested in blocking mode. These problems do not appear if you
> > capture in non-blocking mode.
> > 
> > I consider class 3 unacceptable for commonly seen devices. I did a quick scan
> > of the v4l drivers and the only common driver that falls in that class is uvc.
> > 
> > There is one other option, although it is very dirty: don't take the lock if
> > the ioctl command is VIDIOC_DQBUF.
> 
> Is this "in addition to" or "instead of" the mutex lock at
> v4l2_device ? 

In addition to.

> >  It works and reliably as well for uvc and
> > videobuf (I did a quick code analysis). But I don't know if it works everywhere.
> > 
> > I would like to get the opinion of others before I implement such a check. But
> > frankly, I think this may be our best bet.
> 
> Opinions? No problem! ;)
> 
> <opinions>
> 
> I think it is probably bad.
> 
> 
> > So the patch below would look like this if I add the check:
> > 
> > -               mutex_lock(&v4l2_ioctl_mutex);
> > +               if (cmd != VIDIOC_DQBUF)
> > +                       mutex_lock(m);
> >                 if (video_is_registered(vdev))
> >                         ret = vdev->fops->ioctl(filp, cmd, arg);
> > -               mutex_unlock(&v4l2_ioctl_mutex);
> > +               if (cmd != VIDIOC_DQBUF)
> > +                       mutex_unlock(m);
> 
> What happens to driver state when VIDIOC_STREAMOFF has the lock held and
> VIDIOC_DQBUF comes through?  I think it is legitimate design for an
> application to have a playback control thread separate from a thread
> that reads in the capture data.

All I can say is that it will work OK for drivers using videobuf since
videobuf will take its own lock.

UVC? I'm not sure. But I think that it is probably best to fix uvc for
2.6.37 regardless given the importance of this driver.

It's dirty, but I actually think that it will work fine.

> If this quirk of "infrastructure locking" is going in, might I suggest
> that you please document in code comments:
> 
> a. The scope of what infrastructure lock is intended to protect.  That
> is obvious right now, but may not be in the future.
>  
> b. Why there is an exception to taking the infrastructure lock or what
> conditions necessitate having the lock ignored/dropped.
> 
> c. What code maintenance must be done to remove the exception to taking
> the lock.  A specific bullet-list of problem drivers might be nice.

Obviously. The right solution is simply that all drivers should move to
unlocked_ioctl. Preferably for 2.6.38. I don't like this hack at all, but
circumstances basically force this on us. Not doing this hack leads to
unacceptable side-effects.

We can also fast-track for 2.6.37 the set of trivial unlocked_ioctl
conversions I did this week. That will reduce the impact as well.

> We won't do future maintainers any favors by letting the operation,
> intended behavior, intended scope, and rationale for this odd locking
> semantic be lost to history.  We just introduce a BKL with smaller
> scope.

We have to aggressively track this and convert all drivers to unlocked_ioctl
as soon as possible. There is no other option.

Regards,

	Hans

> > 
> > diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> > index 03f7f46..026bf38 100644
> > --- a/drivers/media/video/v4l2-dev.c
> > +++ b/drivers/media/video/v4l2-dev.c
> > @@ -247,11 +247,13 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  	} else if (vdev->fops->ioctl) {
> >  		/* TODO: convert all drivers to unlocked_ioctl */
> >  		static DEFINE_MUTEX(v4l2_ioctl_mutex);
> > +		struct mutex *m = vdev->v4l2_dev ?
> > +			&vdev->v4l2_dev->ioctl_lock : &v4l2_ioctl_mutex;
> >  
> > -		mutex_lock(&v4l2_ioctl_mutex);
> > +		mutex_lock(m);
> >  		if (video_is_registered(vdev))
> >  			ret = vdev->fops->ioctl(filp, cmd, arg);
> > -		mutex_unlock(&v4l2_ioctl_mutex);
> > +		mutex_unlock(m);
> >  	} else
> >  		ret = -ENOTTY;
> >  
> > diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
> > index 0b08f96..7fe6f92 100644
> > --- a/drivers/media/video/v4l2-device.c
> > +++ b/drivers/media/video/v4l2-device.c
> > @@ -35,6 +35,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
> >  
> >  	INIT_LIST_HEAD(&v4l2_dev->subdevs);
> >  	spin_lock_init(&v4l2_dev->lock);
> > +	mutex_init(&v4l2_dev->ioctl_lock);
> >  	v4l2_dev->dev = dev;
> >  	if (dev == NULL) {
> >  		/* If dev == NULL, then name must be filled in by the caller */
> > diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
> > index 6648036..b16f307 100644
> > --- a/include/media/v4l2-device.h
> > +++ b/include/media/v4l2-device.h
> > @@ -51,6 +51,8 @@ struct v4l2_device {
> >  			unsigned int notification, void *arg);
> >  	/* The control handler. May be NULL. */
> >  	struct v4l2_ctrl_handler *ctrl_handler;
> > +	/* BKL replacement mutex. Temporary solution only. */
> > +	struct mutex ioctl_lock;
> 
> Perhaps please add a comment on the specific software maintenance tasks
> that are required to remove this temporary solution in the future.
> Knowing is half the battle for future maintainers.
> 
> 
> I know an SCM change log comments can capture the rationale, etc., but
> relying on change logs doesn't work when the SCM tool changes. (e.g. the
> transition to git)
> 
> </opinions>
> 
> :)
> 
> Regards,
> Andy
> 
> >  };
> >  
> >  /* Initialize v4l2_dev and make dev->driver_data point to v4l2_dev.
> > 
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
