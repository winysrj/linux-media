Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61N55nJ012690
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 19:05:05 -0400
Received: from mailrelay007.isp.belgacom.be (mailrelay007.isp.belgacom.be
	[195.238.6.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61N4sH4001512
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 19:04:55 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "David Ellingsworth" <david@identd.dyndns.org>
Date: Wed, 2 Jul 2008 01:04:51 +0200
References: <30353c3d0807011346yccc6ad1yab269d0b47068f15@mail.gmail.com>
	<200807012350.53604.laurent.pinchart@skynet.be>
	<30353c3d0807011528v561d4de8ycb7c3f1d8afc82f9@mail.gmail.com>
In-Reply-To: <30353c3d0807011528v561d4de8ycb7c3f1d8afc82f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020104.52122.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix sysfs kobj ref count
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wednesday 02 July 2008, David Ellingsworth wrote:
> On Tue, Jul 1, 2008 at 5:50 PM, Laurent Pinchart
>
> <laurent.pinchart@skynet.be> wrote:
> > Hi David,
> >
> > On Tuesday 01 July 2008, David Ellingsworth wrote:
> >> This patch duplicates the behavior seen by char_dev in videodev.
> >> Please apply.
> >>
> >> char_dev handles the kobject reference count as follows:
> >>      1. Initializes it to 1 in device_register.
> >>      2. Increments it in chrdev_open
> >>      3. Decrements it in __fput(see fs/file_table.c) after the
> >> file_operations.release callback
> >>      4. Decrements it in device_unregister
> >>
> >> videodev currently handles the kobject reference count as follows:
> >>      1. Initializes it to 1 in device_register.
> >>      2. Decrements it in device_unregister.
> >>
> >> With this patch, videodev will handle the kobject reference count as
> >> follows: 1. Initialize it to 1 in device_register.
> >>      2. Increment it in video_open.
> >>      3. Decrement it in video_close.
> >>      4. Decrement it in device_unregister.
> >>
> >> This allows the following sequences of events before the kobject ref
> >> count reaches 0 and the sysfs release callback is called.
> >
> > I've just realised that by sysfs release callback you meant kobject
> > release callback. It might be less confusing, and might help others to
> > follow the discussion, if you talked about kobject, mentioning sysfs only
> > when you really mean to talk about sysfs filesystem.
> >
> >>      1. device_register
> >>      2. video_open
> >>      3. video_close
> >>      4. device_unregister
> >>
> >> - and -
> >>
> >>      1. device_register
> >>      2. video_open
> >>      3. device_unregister
> >>      4. video_close
> >>
> >> Once videodev has been converted to use the char_dev api,
> >
> > Is that planned ?
>
> Honestly, I don't know but I suspect that it is. videodev is a
> character device driver and video_open has been marked as Obsolete for
> some time.
>
> >> video_open
> >> and video_close may be removed. Until then they are needed to mimic
> >> char_dev's behavior and ensure that the sysfs callback occurs at the
> >> appropriate time.
> >>
> >> From 354f72d4ed5861813b1509d437e551c19f8a6aca Mon Sep 17 00:00:00 2001
> >> From: David Ellingsworth <david@identd.dyndns.org>
> >> Date: Tue, 1 Jul 2008 16:04:26 -0400
> >> Subject: [PATCH] videodev: fix sysfs kobj ref count
> >>
> >>
> >> Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
> >> ---
> >>  drivers/media/video/videodev.c |   52
> >> ++++++++++++++++++++++++++-------------- include/media/v4l2-dev.h      
> >> | 1 +
> >>  2 files changed, 35 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/drivers/media/video/videodev.c
> >> b/drivers/media/video/videodev.c index 0d52819..0ef51b8 100644
> >> --- a/drivers/media/video/videodev.c
> >> +++ b/drivers/media/video/videodev.c
> >> @@ -406,17 +406,23 @@ void video_device_release(struct video_device
> >> *vfd) }
> >>  EXPORT_SYMBOL(video_device_release);
> >>
> >> +/*
> >> + *   Active devices
> >> + */
> >> +
> >> +static struct video_device *video_device[VIDEO_NUM_DEVICES];
> >> +static DEFINE_MUTEX(videodev_lock);
> >> +
> >>  static void video_release(struct device *cd)
> >>  {
> >>       struct video_device *vfd = container_of(cd, struct video_device,
> >>                                                              
> >> class_dev);
> >>
> >> -#if 1
> >> -     /* needed until all drivers are fixed */
> >> -     if (!vfd->release)
> >> -             return;
> >> -#endif
> >> -     vfd->release(vfd);
> >> +     mutex_lock(&videodev_lock);
> >> +     if (vfd->release)
> >> +             vfd->release(vfd);
> >> +     video_device[vfd->minor] = NULL;
> >> +     mutex_unlock(&videodev_lock);
> >>  }
> >>
> >>  static struct device_attribute video_device_attrs[] = {
> >> @@ -431,19 +437,30 @@ static struct class video_class = {
> >>       .dev_release = video_release,
> >>  };
> >>
> >> -/*
> >> - *   Active devices
> >> - */
> >> -
> >> -static struct video_device *video_device[VIDEO_NUM_DEVICES];
> >> -static DEFINE_MUTEX(videodev_lock);
> >> -
> >>  struct video_device* video_devdata(struct file *file)
> >>  {
> >>       return video_device[iminor(file->f_path.dentry->d_inode)];
> >>  }
> >>  EXPORT_SYMBOL(video_devdata);
> >>
> >> +static int video_close(struct inode *inode, struct file *file)
> >> +{
> >> +     unsigned int minor = iminor(inode);
> >> +     int err = 0;
> >> +     struct video_device *vfl;
> >> +
> >> +     mutex_lock(&videodev_lock);
> >> +     vfl = video_device[minor];
> >> +
> >> +     if (vfl->fops && vfl->fops->release)
> >> +             err = vfl->fops->release(inode, file);
> >> +
> >> +     mutex_unlock(&videodev_lock);
> >> +     kobject_put(&vfl->class_dev.kobj);
> >> +
> >> +     return err;
> >> +}
> >> +
> >>  /*
> >>   *   Open a video device - FIXME: Obsoleted
> >>   */
> >> @@ -469,8 +486,8 @@ static int video_open(struct inode *inode, struct
> >> file *file) }
> >>       }
> >>       old_fops = file->f_op;
> >> -     file->f_op = fops_get(vfl->fops);
> >> -     if(file->f_op->open)
> >> +     file->f_op = fops_get(&vfl->priv_fops);
> >> +     if(file->f_op->open && kobject_get(&vfl->class_dev.kobj))
> >>               err = file->f_op->open(inode,file);
> >>       if (err) {
> >>               fops_put(file->f_op);
> >> @@ -2175,6 +2192,8 @@ int video_register_device_index(struct
> >> video_device *vfd, int type, int nr, }
> >>
> >>       vfd->index = ret;
> >> +     vfd->priv_fops = *vfd->fops;
> >> +     vfd->priv_fops.release = video_close;
> >>
> >>       mutex_unlock(&videodev_lock);
> >>       mutex_init(&vfd->lock);
> >> @@ -2221,13 +2240,10 @@ EXPORT_SYMBOL(video_register_device_index);
> >>
> >>  void video_unregister_device(struct video_device *vfd)
> >>  {
> >> -     mutex_lock(&videodev_lock);
> >>       if(video_device[vfd->minor]!=vfd)
> >>               panic("videodev: bad unregister");
> >>
> >> -     video_device[vfd->minor]=NULL;
> >>       device_unregister(&vfd->class_dev);
> >> -     mutex_unlock(&videodev_lock);
> >
> > Without locking the videodev_lock mutex you introduce a race condition.
> > video_open() can race device_unregister().
>
> Not true, video_open calls and checks the return of kobject_get which
> will not allow the open to proceed if the return is NULL. The release
> callback must first obtain the videodev_lock mutex before proceeding.

struct kobject *kobject_get(struct kobject *kobj)
{
        if (kobj)
                kref_get(&kobj->kref);
        return kobj;
}

The return value will be non-NULL if called with a non-NULL argument.

> > CPU #1                                          CPU #2
> > -------------------------------------------------------------------------
> >---- disconnect callback
> >  video_unregister_device
> >    device_unregister -> put_device
> >      kobject_put -> kref_put
> >        kobject_release -> kobject_cleanup
> >          video_release
> >                                                video_open
> >                                                -> reference data
> > structures
> >
> >            driver release callback
> >            -> free data structures
> >
> >>  }
> >>  EXPORT_SYMBOL(video_unregister_device);
> >>
> >> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> >> index 3c93414..d4fe617 100644
> >> --- a/include/media/v4l2-dev.h
> >> +++ b/include/media/v4l2-dev.h
> >> @@ -342,6 +342,7 @@ void *priv;
> >>       /* for videodev.c intenal usage -- please don't touch */
> >>       int users;                     /* video_exclusive_{open|close} ...
> >> */ struct mutex lock;             /* ... helper function uses these   */
> >> +     struct file_operations priv_fops; /* video_close */
> >>  };
> >>
> >>  /* Class-dev to video-device */
> >> --
> >> 1.5.5.1
> >
> > Best regards,
> >
> > Laurent Pinchart
>
> Regards,
>
> David Ellingsworth


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
