Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGNOnl6018840
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 18:24:49 -0500
Received: from smtp-vbr16.xs4all.nl (smtp-vbr16.xs4all.nl [194.109.24.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBGNNjnE002195
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 18:23:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Greg KH <greg@kroah.com>
Date: Wed, 17 Dec 2008 00:23:41 +0100
References: <200812082156.26522.hverkuil@xs4all.nl>
	<200812162200.52260.hverkuil@xs4all.nl>
	<20081216212150.GA20721@kroah.com>
In-Reply-To: <20081216212150.GA20721@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812170023.41936.hverkuil@xs4all.nl>
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

On Tuesday 16 December 2008 22:21:50 Greg KH wrote:
> On Tue, Dec 16, 2008 at 10:00:51PM +0100, Hans Verkuil wrote:
> > On Tuesday 16 December 2008 21:22:48 Greg KH wrote:
> > > On Mon, Dec 08, 2008 at 09:56:26PM +0100, Hans Verkuil wrote:
> > > > Hi Greg,
> > > >
> > > > Laurent found a race condition in the uvc driver that we traced to
> > > > the way chrdev_open and cdev_put/get work.
> > > >
> > > > You need the following ingredients to reproduce it:
> > > >
> > > > 1) a hot-pluggable char device like an USB webcam.
> > > > 2) a manually created device node for such a webcam instead of
> > > > relying on udev.
> > > >
> > > > In order to easily force this situation you would also need to add
> > > > a delay to the char device's release() function. For webcams that
> > > > would be at the top of v4l2_chardev_release() in
> > > > drivers/media/video/v4l2-dev.c. But adding a delay to e.g.
> > > > cdev_purge would have the same effect.
> > > >
> > > > The sequence of events in the case of a webcam is as follows:
> > > >
> > > > 1) The USB device is removed, causing a disconnect.
> > > >
> > > > 2) The webcam driver unregisters the video device which in turn
> > > > calls cdev_del().
> > > >
> > > > 3) When the last application using the device is closed, the cdev
> > > > is released when the kref of the cdev's kobject goes to 0.
> > > >
> > > > 4) If the kref's release() call takes a while due to e.g. extra
> > > > cleanup in the case of a webcam, then another application can try
> > > > to open the video device. Note that this requires a device node
> > > > created with mknod, otherwise the device nodes would already have
> > > > been removed by udev.
> > > >
> > > > 5) chrdev_open checks inode->i_cdev. If this is NULL (i.e. this
> > > > device node was never accessed before), then all is fine since
> > > > kobj_lookup will fail because cdev_del() has been called earlier.
> > > > However, if this device node was used earlier, then the else part
> > > > is called: cdev_get(p). This 'p' is the cdev that is being
> > > > released. Since the kref count is 0 you will get a WARN message
> > > > from kref_get, but the code continues on, the f_op->open will
> > > > (hopefully) return more-or-less gracefully with an error and the
> > > > cdev_put at the end will cause the refcount to go to 0 again, which
> > > > results in a SECOND call to the kref's release function!
> > > >
> > > > See this link for the original discussion on the v4l list
> > > > containing stack traces an a patch that you need if you want to
> > > > (and can) test this with the uvc driver:
> > > >
> > > > http://www.spinics.net/lists/vfl/msg39967.html
> > >
> > > The second sentence in that message shows your problem here:
> > > 	To avoid the need of a reference count in every v4l2 driver,
> > > 	v4l2 moved to cdev which includes its own reference counting
> > > 	infrastructure based on kobject.
> > >
> > > cdev is not ment to handle the reference counting of any object
> > > outside of itself, and should never be embedded within anything. 
> > > I've been thinking of taking the real "kobject" out of that structure
> > > for a long time now, incase someone did something foolish like this.
> > >
> > > Seems I was too late :(
> > >
> > > So, to solve this, just remove the reliance on struct cdev in your
> > > own structures, you don't want to do this for the very reason you
> > > have now found (and for others, like the fact that this isn't a
> > > "real" struct kobject in play here, just a fake one.)
> > >
> > > Ick, what a mess.
> >
> > Sorry, but this makes no sense. First of all the race condition exists
> > regardless of how v4l uses it. Other drivers using cdev with a
> > hot-pluggable device in combination with a manually created device
> > node should show the same problem.
>
> I don't see how this would be, unless this problem has always existed in
> the cdev code, it was created back before dynamic device nodes with udev
> existed :)
>
> > It's just that we found it with v4l because the release callback takes
> > longer than usual, thus increasing the chances of hitting the race.
>
> The release callback for the cdev itself?

Yes, although we override the release kobj_type. I noticed that a patch to 
do this through a cdev function was recently posted (and possibly already 
merged).

> > The core problem is simply that it is possible to call cdev_get while
> > in cdev_put! That should never happen.
>
> True, and cdev_put is only called from __fput() which has the proper
> locking to handle the call to cdev_get() if a char device is opened,
> right?

cdev_put is also called through cdev_del, and that's where the problem 
resides. The cdev_del() call has no locking to prevent a call from 
cdev_get(), and it can be called asynchronously as well in response to a 
USB disconnect.

> > Secondly, why shouldn't struct cdev be embedded in anything? It's used
> > in lots of drivers that way. I really don't see what's unusual or
> > messy about v4l in that respect.
>
> I don't see it embedded in any other structures at the moment, and used
> to reference count the structure, do you have pointers to where it is?

Hmm, I took a closer look and it looks like v4l is indeed the first to use 
cdev for refcounting. Others either don't need it or do their own 
refcounting. It's definitely embedded in several structs, though. (grep for 
cdev_init)

However, I don't see how any amount of refcounting in drivers can prevent 
this race. At some point cdev_del() is called and (if nobody is using the 
chardev) cdev's kref goes to 0 triggering the release, and at that moment 
chrdev_open() can be called and the driver has no chance to prevent that, 
only cdev can do that.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
