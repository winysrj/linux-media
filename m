Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3428 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2IOMgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 08:36:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS capability.
Date: Sat, 15 Sep 2012 14:35:41 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	" =?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <201209151205.20981.hverkuil@xs4all.nl> <50545A86.3050904@iki.fi>
In-Reply-To: <50545A86.3050904@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209151435.41800.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat September 15 2012 12:37:58 Sakari Ailus wrote:
> Hi Hans and Laurent,
> 
> Hans Verkuil wrote:
> > On Sat September 15 2012 11:31:29 Laurent Pinchart wrote:
> >> Hi Hans,
> >>
> >> On Saturday 15 September 2012 09:41:59 Hans Verkuil wrote:
> >>> On Fri September 14 2012 23:05:45 Sakari Ailus wrote:
> >>>> Rémi Denis-Courmont wrote:
> >>>>> Le vendredi 14 septembre 2012 23:25:01, Sakari Ailus a écrit :
> >>>>>> I had a quick discussion with Laurent, and what he suggested was to use
> >>>>>> the kernel version to figure out the type of the timestamp. The drivers
> >>>>>> that use the monotonic time right now wouldn't be affected by the new
> >>>>>> flag on older kernels. If we've decided we're going to switch to
> >>>>>> monotonic time anyway, why not just change all the drivers now and
> >>>>>> forget the capability flag.
> >>>>>
> >>>>> That does not work In Real Life.
> >>>>>
> >>>>> People do port old drivers forward to new kernels.
> >>>>> People do port new drivers back to old kernels
> >>>>
> >>>> Why would you port a driver from an old kernel to a new kernel? Or are
> >>>> you talking about out-of-tree drivers?
> >>>
> >>> More likely the latter.
> >>>
> >>>> If you do port drivers across different kernel versions I guess you're
> >>>> supposed to use the appropriate interfaces for those kernels, too. Using
> >>>> a helper function helps here, so compiling a backported driver would
> >>>> fail w/o the helper function that produces the timestamp, forcing the
> >>>> backporter to notice the situation.
> >>>>
> >>>> Anyway, I don't have a very strict opinion on this, so I'm okay with the
> >>>> flag, too, but I personally simply don't think it's the best choice we
> >>>> can make now. Also, without converting the drivers now the user space
> >>>> must live with different kinds of timestamps much longer.
> >>>
> >>> There are a number of reasons why I want to go with a flag:
> >>>
> >>> - Out-of-tree drivers which are unlikely to switch to monotonic in practice
> >>> - Backporting drivers
> >>> - It makes it easy to verify in v4l2-compliance and enforce the use of
> >>>    the monotonic clock.
> >>> - It's easy for apps to check.
> >>>
> >>> The third reason is probably the most important one for me. There tends to
> >>> be a great deal of inertia before changes like this are applied to new
> >>> drivers, and without being able to (easily) check this in v4l2-compliance
> >>> more drivers will be merged that keep using gettimeofday. It's all too easy
> >>> to miss in a review.
> >>
> >> If we switch all existing drivers to monotonic timestamps in kernel release
> >> 3.x, v4l2-compliance can just use the version it gets from VIDIOC_QUERYCAP and
> >> enforce monotonic timestamps verification if the version is >= 3.x. This isn't
> >> more difficult for apps to check than a dedicated flag (although it's less
> >> explicit).
> >
> > I think that checking for the driver (kernel) version is a very poor substitute
> > for testing against a proper flag.
> 
> That flag should be the default in this case. The flag should be set by 
> the framework instead giving every driver the job of setting it.
> 
> > One alternative might be to use a v4l2_buffer flag instead. That does have the
> > advantage that in the future we can add additional flags should we need to
> > support different clocks. Should we ever add support to switch clocks dynamically,
> > then a buffer flag is more suitable than a driver capability. In that scenario
> > it does make real sense to have a flag (or really mask).
> >
> > Say something like this:
> >
> > /* Clock Mask */
> > V4L2_BUF_FLAG_CLOCK_MASK	0xf000
> > /* Possible Clocks */
> > V4L2_BUF_FLAG_CLOCK_SYSTEM	0x0000

I realized that this should be called:

V4L2_BUF_FLAG_CLOCK_UNKNOWN	0x0000

With a comment saying that is clock is either the system clock or a monotonic
clock. That reflects the current situation correctly.

> > V4L2_BUF_FLAG_CLOCK_MONOTONIC	0x1000
> 
> There are three clocks defined in clock_gettime (2) man page. It'd 
> indeed be good that the timestamp was selectable, but this really 
> depends on the user rather than the driver. As you suggested earlier on, 
> I agree that only monotonic timestamps are seen necessary right now.
> 
> It might be that raw monotonic timestamps could have some potential use 
> (albeit I don't know a use case right now) but I still wouldn't think 
> users would change the type of the timestamp that often. So I don't see 
> a need for the buffer flag, but I still think it's better than a device 
> capability flag.
> 
> If we gave the user the ability to pick the type of the timestamp we 
> should move to use timespec at the same time.
> 
> >> My concern is identical to Sakari's, I'm not very keen on introducing a flag
> >> that all drivers will set in the very near future and that we will have to
> >> keep around forever.
> >>
> >>> That doesn't mean that it isn't a good idea to convert existing drivers
> >>> asap. But it's not something I'm likely to take up myself.
> >>
> >> Sakari, are you volunteering for that ? ;-)
> 
> I'd be happy to do that. As the changes are mostly mechanical, it won't 
> really take much time to do that.
> 
> What comes to new drivers --- I think it's wrong to assume every new 
> driver would have been written wrong kind of timestamps in mind. I mean, 
> what do you think would be the reasons why a driver writer would pick 
> do_gettimeofday() instead of ktime_get_ts() if every driver in the tree 
> already uses ktime_get_ts()?

Because I see time and again that driver developers develop on an old
kernel instead of using the latest and greatest. Esp. in the embedded world
where it is often difficult to move to a more recent kernel.

Since you are willing to take on this job, I'll remove the MONOTONIC changes
from my patch series and hand that part over to you, if that's OK with you.

Regards,

	Hans
