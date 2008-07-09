Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m69N4LoO022669
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 19:04:21 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m69N3WUF017858
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 19:04:04 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1726232fga.7
	for <video4linux-list@redhat.com>; Wed, 09 Jul 2008 16:03:32 -0700 (PDT)
Message-ID: <30353c3d0807091603v3c276a15ld15aebd6571d6244@mail.gmail.com>
Date: Wed, 9 Jul 2008 19:03:32 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
In-Reply-To: <200807092342.51633.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0807081923o6ba66d34oac44d5bb98fd0e3a@mail.gmail.com>
	<200807092342.51633.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videodev: fix kobj ref count
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

On Wed, Jul 9, 2008 at 5:42 PM, Laurent Pinchart
<laurent.pinchart@skynet.be> wrote:
> Hi David,
>
> On Wednesday 09 July 2008, David Ellingsworth wrote:
>> Mauro,
>>
>> If Laurent approves, please apply the following patch to the devel
>> branch. I've been using it locally for the past five days or so
>> without issue.
>>
>> This patch increments the kobject reference count during video_open
>> and decrements it during video_close. Doing so allows
>> video_unregister_device to be called during the disconnect callback of
>> usb and pci devices. It also ensures that the video_device struct is
>> not freed while it is still in use and that the kobject release
>> callback occurs at the appropriate time. With this patch, the
>> following sequence is now possible and no longer results in a crash.
>>
>> video_open
>>   disconnect
>>     video_unregister_device
>>       video_ioctl2 (crash was here)
>>         video_close
>>           video_release
>>
>> Regards,
>>
>> David Ellingsworth
>>
>> Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
>> ---
>>  drivers/media/video/videodev.c |   50
>> +++++++++++++++++++++++++++------------ include/media/v4l2-dev.h       |
>> 1 +
>>  2 files changed, 35 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/media/video/videodev.c
>> b/drivers/media/video/videodev.c index 0d52819..9922cd6 100644
>> --- a/drivers/media/video/videodev.c
>> +++ b/drivers/media/video/videodev.c
>> @@ -406,17 +406,22 @@ void video_device_release(struct video_device *vfd)
>>  }
>>  EXPORT_SYMBOL(video_device_release);
>>
>> +/*
>> + *   Active devicesSigned-off-by: David Ellingsworth
>> <david@identd.dyndns.org> ---
>>  drivers/media/video/videodev.c |   50
>> +++++++++++++++++++++++++++------------ include/media/v4l2-dev.h       |
>> 1 +
>>  2 files changed, 35 insertions(+), 16 deletions(-)
>
> Copy & paste issue ?
>
>> diff --git a/drivers/media/video/videodev.c
>> b/drivers/media/video/videodev.c index 0d52819..9922cd6 100644
>> --- a/drivers/media/video/videodev.c
>> +++ b/drivers/media/video/videodev.c
>> @@ -406,17 +406,22 @@ void video_device_release(struct video_device *vfd)
>>  }
>>  EXPORT_SYMBOL(video_device_release);
>>
>> +/*
>> + *   Active devices
>> + */
>> +
>> +static struct video_device *video_device[VIDEO_NUM_DEVICES];
>> +static DEFINE_MUTEX(videodev_lock);
>> +
>> +/* must be called with videodev_lock held */
>>  static void video_release(struct device *cd)
>>  {
>>       struct video_device *vfd = container_of(cd, struct video_device,
>>                                                               class_dev);
>>
>> -#if 1
>> -     /* needed until all drivers are fixed */
>> -     if (!vfd->release)
>> -             return;
>> -#endif
>> -     vfd->release(vfd);
>> +     if (vfd->release)
>> +             vfd->release(vfd);
>> +     video_device[vfd->minor] = NULL;
>>  }
>>
>>  static struct device_attribute video_device_attrs[] = {
>> @@ -431,19 +436,30 @@ static struct class video_class = {
>>       .dev_release = video_release,
>>  };
>>
>> -/*
>> - *   Active devices
>> - */
>> -
>> -static struct video_device *video_device[VIDEO_NUM_DEVICES];
>> -static DEFINE_MUTEX(videodev_lock);
>> -
>>  struct video_device* video_devdata(struct file *file)
>>  {
>>       return video_device[iminor(file->f_path.dentry->d_inode)];
>>  }
>>  EXPORT_SYMBOL(video_devdata);
>>
>> +static int video_close(struct inode *inode, struct file *file)
>> +{
>> +     unsigned int minor = iminor(inode);
>> +     int err = 0;
>> +     struct video_device *vfl;
>> +
>> +     vfl = video_device[minor];
>> +
>> +     if (vfl->fops && vfl->fops->release)
>> +             err = vfl->fops->release(inode, file);
>> +
>> +     mutex_lock(&videodev_lock);
>> +     kobject_put(&vfl->class_dev.kobj);
>> +     mutex_unlock(&videodev_lock);
>> +
>> +     return err;
>> +}
>> +
>>  /*
>>   *   Open a video device - FIXME: Obsoleted
>>   */
>> @@ -469,10 +485,11 @@ static int video_open(struct inode *inode,
>> struct file *file)
>>               }
>>       }
>>       old_fops = file->f_op;
>> -     file->f_op = fops_get(vfl->fops);
>> -     if(file->f_op->open)
>> +     file->f_op = fops_get(&vfl->priv_fops);
>> +     if (file->f_op->open && kobject_get(&vfl->class_dev.kobj))
>
> Shouldn't kobject_get be called even if file->f_op->open is NULL ?
Now that I've looked at it again, it seems you are right, kobject_get
should be called even if file->f_op->open is null since we return err
and it will remain 0. This means a subsequent call to video_close
would occur. Good catch.

There are two ways to handle this, (1) initialize err to something
like -ENODEV so the open fails if file->f_op->open is not defined or
(2) always call kobject_get and wait for the call to video_close to do
the kobject_put.

Personally I prefer the first approach since it ensures no call to
video_close happens and thus no call to file->f_op->release occurs.
What do you think?
>
>>               err = file->f_op->open(inode,file);
>>       if (err) {
>> +             kobject_put(&vfl->class_dev.kobj);
>>               fops_put(file->f_op);
>>               file->f_op = fops_get(old_fops);
>>       }
>> @@ -2175,6 +2192,8 @@ int video_register_device_index(struct
>> video_device *vfd, int type, int nr,
>>       }
>>
>>       vfd->index = ret;
>> +     vfd->priv_fops = *vfd->fops;
>> +     vfd->priv_fops.release = video_close;
>>
>>       mutex_unlock(&videodev_lock);
>>       mutex_init(&vfd->lock);
>> @@ -2225,7 +2244,6 @@ void video_unregister_device(struct video_device
>> *vfd) if(video_device[vfd->minor]!=vfd)
>>               panic("videodev: bad unregister");
>>
>> -     video_device[vfd->minor]=NULL;
>>       device_unregister(&vfd->class_dev);
>>       mutex_unlock(&videodev_lock);
>>  }
>> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
>> index 3c93414..d4fe617 100644
>> --- a/include/media/v4l2-dev.h
>> +++ b/include/media/v4l2-dev.h
>> @@ -342,6 +342,7 @@ void *priv;
>>       /* for videodev.c intenal usage -- please don't touch */
>>       int users;                     /* video_exclusive_{open|close} ... */
>>       struct mutex lock;             /* ... helper function uses these   */
>> +     struct file_operations priv_fops; /* video_close */
>>  };
>>
>>  /* Class-dev to video-device */
>
> The rest looks ok to me. Just one last question, in a previous e-mail you
> stated
>
> On Wednesday 02 July 2008, David Ellingsworth wrote:
>> I think I found a solution to the above issue. I removed the lock from
>> video_release and the main portion of video_close and wrapped the two
>> calls to kobject_put by the videodev_lock. Since video_close is called
>> when the BKL is held the lock is not required around the main portion
>> of video_close. Acquiring the lock around the calls to kobject_put
>> insures video_release is always called while the lock is being held.
>> This should fix the above race condition between device_unregister and
>> video_open as well. Here is the corrected patch.
>
> Could you elaborate as to why the lock would be required around the main
> portion of video_close if it wasn't called with the BKL held ? I want to be
> sure there is no race condition on SMP systems, where the BKL will only
> prevent open() and close() from running concurrently but will not protect
> from any other race condition.
>
Initially I had hoped to use the videodev lock to prevent open() and
close from racing once the BKL is removed, but it's currently serving
a different purpose. If we maintain this code after the BLK is
removed, another lock will undoubtedly be needed to prevent them from
racing. Two locks are needed is because a call to video_close() may
call video_unregister_device() and therefore and both can not take the
same lock. I didn't want to introduce another lock at this time, and
the BKL is sufficient for the time being.

> As we are dealing with tricky race conditions (the amount of mails exchanged
> to prepare this patch proves the issue is not trivial) I think you should
> include a comment in the code to explain the rationale behind the patch and
> the design decisions/requirements to help other developers not to introduce
> race conditions or dead locks when hacking on videodev.c.
>
Sure, no problem. Should comments be displaced throughout the code? or
should I just place one large comment near the top somewhere?

> You also mentioned that videodev should be converted to char_dev. Would you
> volunteer ? ;-)
>
Sure, I'll volunteer to do the work once we have something stable and
behaves like char_dev.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
