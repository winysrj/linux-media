Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHKIqSe021169
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 15:18:52 -0500
Received: from smtp-vbr6.xs4all.nl (smtp-vbr6.xs4all.nl [194.109.24.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHKIYgo014567
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 15:18:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Greg KH <greg@kroah.com>
Date: Wed, 17 Dec 2008 21:18:29 +0100
References: <200812082156.26522.hverkuil@xs4all.nl>
	<200812172039.03436.hverkuil@xs4all.nl>
	<20081217195329.GB25211@kroah.com>
In-Reply-To: <20081217195329.GB25211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812172118.29574.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
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

On Wednesday 17 December 2008 20:53:29 Greg KH wrote:
> On Wed, Dec 17, 2008 at 08:39:03PM +0100, Hans Verkuil wrote:
> > On Wednesday 17 December 2008 20:30:32 Hans Verkuil wrote:
> > > This solves this particular problem. But this will certainly break
> > > v4l as it is right now, since the spin_lock means that the kref's
> > > release cannot do any sleeps, which is possible in v4l. If we want to
> > > allow that in cdev, then the spinlock has to be replaced by a mutex.
> > > But I have the strong feeling that that's not going to happen :-)
> >
> > Note that if we ever allow drivers to hook in their own release
> > callback, then we certainly should switch to a mutex in the cdev
> > struct, rather than a global mutex. It obviously makes life more
> > complicated for cdev, but much easier for drivers.
>
> I don't see it being easier for drivers, you should provide this kind of
> infrastructure within your framework already.
>
> Actually, we already do provide this kind of framework, what's wrong
> with using "struct device" for this, like the rest of the kernel does?
> That is the device you need to be doing the reference counting and
> release code for, it is exactly what it is there for.
>
> So why is V4L different than the rest of the kernel in that it wishes to
> do things differently?

Because it has almost no proper framework to speak of and what little there 
is has been pretty much unchanged since the very beginning.

I'm trying to develop a decent framework that should help support upcoming 
devices and generally make life easier for v4l driver developers.

And I've no idea why we don't just use the device's release() callback for 
this. I'm going to implement this right now :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
