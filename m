Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m69JkrFS007401
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 15:46:53 -0400
Received: from mailrelay006.isp.belgacom.be (mailrelay006.isp.belgacom.be
	[195.238.6.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m69JkAxI018963
	for <video4linux-list@redhat.com>; Wed, 9 Jul 2008 15:46:10 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Wed, 9 Jul 2008 21:46:09 +0200
References: <30353c3d0807081923o6ba66d34oac44d5bb98fd0e3a@mail.gmail.com>
	<48744036.506@hhs.nl>
In-Reply-To: <48744036.506@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092146.09826.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
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

Hi Hans,

On Wednesday 09 July 2008, Hans de Goede wrote:
> David Ellingsworth wrote:
> > Mauro,
> >
> > If Laurent approves, please apply the following patch to the devel
> > branch. I've been using it locally for the past five days or so
> > without issue.
> >
> > This patch increments the kobject reference count during video_open
> > and decrements it during video_close. Doing so allows
> > video_unregister_device to be called during the disconnect callback of
> > usb and pci devices. It also ensures that the video_device struct is
> > not freed while it is still in use and that the kobject release
> > callback occurs at the appropriate time. With this patch, the
> > following sequence is now possible and no longer results in a crash.
> >
> > video_open
> >   disconnect
> >     video_unregister_device
> >       video_ioctl2 (crash was here)
> >         video_close
> >           video_release
>
> I like this patch, I really do, as currently this refcounting needs to
> be done in all v4l devices seperately, and an video_ioctl2 wrapper needs
> to be used to stop the crash (check if device was disconnected and thus
> video_unregister_device was called and ifso don't call video_ioctl2).

I like it as well, as there is currently no way for video drivers to avoid 
both race conditions and deadlocks. As you stated, refcounting currently 
needs to be done in the device drivers. To avoid race conditions between 
open() and disconnect(), device drivers need a global lock that will prevent 
open() to reference driver-specific structures that just got freed through 
disconnect(). That lock must be taken in the driver open() handler, already 
protected by the videodev_lock, and in the driver disconnect() handler, that 
calls video_unregister_device() that will in turn take the videodev_lock. 
This results in a AB-BA deadlock.

In short, reference counting in the videodev layer is required.

> So I've taken a good look and this, and I cannot find any issues.

I'm currently reviewing David's patch (sorry for the delay). I'll post a go/no 
go (hopefully the former :-)) very soon.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
