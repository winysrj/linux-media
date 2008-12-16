Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGA6LtV014602
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 05:06:21 -0500
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGA671m024308
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 05:06:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Greg KH <greg@kroah.com>
Date: Tue, 16 Dec 2008 11:06:03 +0100
References: <200812082156.26522.hverkuil@xs4all.nl>
In-Reply-To: <200812082156.26522.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161106.03925.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] cdev_put() race condition
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

On Monday 08 December 2008 21:56:26 Hans Verkuil wrote:
> Hi Greg,
>
> Laurent found a race condition in the uvc driver that we traced to
> the way chrdev_open and cdev_put/get work.
>
> You need the following ingredients to reproduce it:
>
> 1) a hot-pluggable char device like an USB webcam.
> 2) a manually created device node for such a webcam instead of
> relying on udev.
>
> In order to easily force this situation you would also need to add a
> delay to the char device's release() function. For webcams that would
> be at the top of v4l2_chardev_release() in
> drivers/media/video/v4l2-dev.c. But adding a delay to e.g. cdev_purge
> would have the same effect.
>
> The sequence of events in the case of a webcam is as follows:
>
> 1) The USB device is removed, causing a disconnect.
>
> 2) The webcam driver unregisters the video device which in turn calls
> cdev_del().
>
> 3) When the last application using the device is closed, the cdev is
> released when the kref of the cdev's kobject goes to 0.
>
> 4) If the kref's release() call takes a while due to e.g. extra
> cleanup in the case of a webcam, then another application can try to
> open the video device. Note that this requires a device node created
> with mknod, otherwise the device nodes would already have been
> removed by udev.
>
> 5) chrdev_open checks inode->i_cdev. If this is NULL (i.e. this
> device node was never accessed before), then all is fine since
> kobj_lookup will fail because cdev_del() has been called earlier.
> However, if this device node was used earlier, then the else part is
> called:
> cdev_get(p). This 'p' is the cdev that is being released. Since the
> kref count is 0 you will get a WARN message from kref_get, but the
> code continues on, the f_op->open will (hopefully) return
> more-or-less gracefully with an error and the cdev_put at the end
> will cause the refcount to go to 0 again, which results in a SECOND
> call to the kref's release function!
>
> See this link for the original discussion on the v4l list containing
> stack traces an a patch that you need if you want to (and can) test
> this with the uvc driver:
>
> http://www.spinics.net/lists/vfl/msg39967.html
>
> Reading Documentation/kref.txt leads me to the conclusion that a
> mutex should be introduced to prevent cdev_get from being called
> while cdev_put is in progress. It should be a mutex instead of a
> spinlock because the kref's release() can do all sorts of cleanups,
> some of which might involve waits.
>
> I think that replacing cdev_lock with a mutex, adding it to
> cdev_put(), cdev_del() and removing it from cdev_purge() should do
> the trick (I hope).
>
> BTW: shouldn't cdev_del() call cdev_put() instead of kobject_put()?
> If I understand it correctly then cdev_add calls cdev_get (through
> exact_lock()), so cdev_del should do the reverse, right?
>
> Regards,
>
> 	Hans

Hi Greg,

Will you have time to look at this? I can try to make a patch for this, 
but I'd like to get your feedback first.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
