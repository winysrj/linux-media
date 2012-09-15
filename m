Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34536 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2IOJa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 05:30:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	=?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS capability.
Date: Sat, 15 Sep 2012 11:31:29 +0200
Message-ID: <3763500.054S7eWLyn@avalon>
In-Reply-To: <201209150941.59198.hverkuil@xs4all.nl>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <50539C29.2070209@iki.fi> <201209150941.59198.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 15 September 2012 09:41:59 Hans Verkuil wrote:
> On Fri September 14 2012 23:05:45 Sakari Ailus wrote:
> > Rémi Denis-Courmont wrote:
> > > Le vendredi 14 septembre 2012 23:25:01, Sakari Ailus a écrit :
> > >> I had a quick discussion with Laurent, and what he suggested was to use
> > >> the kernel version to figure out the type of the timestamp. The drivers
> > >> that use the monotonic time right now wouldn't be affected by the new
> > >> flag on older kernels. If we've decided we're going to switch to
> > >> monotonic time anyway, why not just change all the drivers now and
> > >> forget the capability flag.
> > > 
> > > That does not work In Real Life.
> > > 
> > > People do port old drivers forward to new kernels.
> > > People do port new drivers back to old kernels
> > 
> > Why would you port a driver from an old kernel to a new kernel? Or are
> > you talking about out-of-tree drivers?
> 
> More likely the latter.
> 
> > If you do port drivers across different kernel versions I guess you're
> > supposed to use the appropriate interfaces for those kernels, too. Using
> > a helper function helps here, so compiling a backported driver would
> > fail w/o the helper function that produces the timestamp, forcing the
> > backporter to notice the situation.
> > 
> > Anyway, I don't have a very strict opinion on this, so I'm okay with the
> > flag, too, but I personally simply don't think it's the best choice we
> > can make now. Also, without converting the drivers now the user space
> > must live with different kinds of timestamps much longer.
> 
> There are a number of reasons why I want to go with a flag:
> 
> - Out-of-tree drivers which are unlikely to switch to monotonic in practice
> - Backporting drivers
> - It makes it easy to verify in v4l2-compliance and enforce the use of
>   the monotonic clock.
> - It's easy for apps to check.
> 
> The third reason is probably the most important one for me. There tends to
> be a great deal of inertia before changes like this are applied to new
> drivers, and without being able to (easily) check this in v4l2-compliance
> more drivers will be merged that keep using gettimeofday. It's all too easy
> to miss in a review.

If we switch all existing drivers to monotonic timestamps in kernel release 
3.x, v4l2-compliance can just use the version it gets from VIDIOC_QUERYCAP and 
enforce monotonic timestamps verification if the version is >= 3.x. This isn't 
more difficult for apps to check than a dedicated flag (although it's less 
explicit).

My concern is identical to Sakari's, I'm not very keen on introducing a flag 
that all drivers will set in the very near future and that we will have to 
keep around forever.

> That doesn't mean that it isn't a good idea to convert existing drivers
> asap. But it's not something I'm likely to take up myself.

Sakari, are you volunteering for that ? ;-)

> Creating a small helper function as you suggested elsewhere is a good idea
> as well. I'll write something for that.

-- 
Regards,

Laurent Pinchart

