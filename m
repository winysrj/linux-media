Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIBWK5k011464
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 06:32:20 -0500
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBIBW3ts005124
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 06:32:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Thu, 18 Dec 2008 12:31:41 +0100
References: <200812180109.51813.hverkuil@xs4all.nl> <494A2492.2050106@hhs.nl>
In-Reply-To: <494A2492.2050106@hhs.nl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200812181231.41885.hverkuil@xs4all.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Please test: using the device release() callback instead of the
	cdev release
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

On Thursday 18 December 2008 11:23:14 Hans de Goede wrote:
> <resend with reply to all>
>
> Hans Verkuil wrote:
> > Hi all,
> >
> > My tree http://linuxtv.org/hg/~hverkuil/v4l-dvb drops the cdev release
> > code in favor of using the refcounting and release callback from the
> > device struct. Based on the discussion on the kernel list regarding the
> > use of cdev refcounting it became clear that that was not the right
> > solution, hence this change.
>
> I haven't tested it, but I have reviewed it. In general it looks ok, but:
>
> I do not like the VFL_FL_REGISTERED trickery. Why not just hold the
> videodev_lock in video_register_device_index until completely done? It is
> not like these are functions which will get called many times a second.
> This will also lead to cleaner code.

This flag is meant to handle the case where a USB device is disconnected 
while an application is still using the video device. In that case the 
disconnect routine unregisters the video device, but it is still possible 
to open the device if the device node was made with mknod instead of 
handled by udev. So it is still possible to call open. Currently drivers 
need to check for this, but it is much easier to catch this in the v4l core 
directly.

Note that eventually all the file_operations that v4l drivers use will go 
through similar code as is now done for open and release. So all those 
operations will do the same test and hopefully drivers don't need to be 
bothered about it. There are some other neat things you can do if all ops 
go through some standard function first (e.g. proper priority handling), 
but that's for the future.

> The correct return code in v4l2_open when cfd == NULL, so the device has
> been removed underneath the open call is -ENODEV, not -EBUSY.

Oops, you are correct. Stupid of me.

> last, device_* seem to have the same problem as cdev_*, when
> video_unregister_device and v4l2_release race, we can still end up with a
> kref_put race. I see you've fixed this by taking videodev_lock around
> device_unregister() and device_put(), but IMHO this really should happen
> in drivers/base/core.c, other drivers might vary well hit the same issue.
> Seems you need to hit gkh a bit more with that clue stick of yours :)
> (note this last one is not a blocker, but would be nice to get fixed
> eventually).

It seems that the rule is that drivers need to take care of their own 
locking. Personally I suspect that there are no doubt a lot of drivers that 
don't do that properly. I don't think it is a terribly good idea to start 
messing with this, though. I prefer to concentrate on doing the right thing 
in the v4l framework, that's already difficult enough.

One change I made is that the video_device release() callback is now called 
without holding the global mutex. Since the release() can take some time 
depending on what it is doing it's much better not to hold that lock. It 
takes a bit of extra code, but it's well worth it.

Both changes are now pushed to my tree for review.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
