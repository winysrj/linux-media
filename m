Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1534 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab0C1QDE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 12:03:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: What would be a good time to move subdev drivers to a subdev directory?
Date: Sun, 28 Mar 2010 18:03:22 +0200
Cc: linux-media@vger.kernel.org
References: <201003281224.17678.hverkuil@xs4all.nl> <4BAF77F7.3070205@redhat.com>
In-Reply-To: <4BAF77F7.3070205@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003281803.22405.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 28 March 2010 17:38:31 Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
> > Hi Mauro,
> > 
> > Currently drivers/media/video is a mix of subdev drivers and bridge/platform
> > drivers. I think it would be good to create a drivers/media/subdev directory
> > where subdev drivers can go.
> > 
> > We discussed in the past whether we should have categories for audio subdevs,
> > video subdevs, etc. but I think that will cause problems, especially with
> > future multifunction devices.
> 
> Due to the discussions we had on the last time, I'm not so sure that such move
> would be good: There are some cases where the division of a subdev is more a
> matter of a logical organization than a physical device division. for example,
> cx231xx is just one chip, but, as it has internally the same functionalities as
> a cx2584x, the cx2584x is a subdev used by the driver. There are other similar
> examples on other IC's and SoC.

I should have mentioned why I think it is a good idea to split it: right now it
is not clear in media/video what the bridge drivers are and what the subdev
drivers are.

Note that integrated subdev drivers that are tightly coupled to a bridge or
platform driver should stay with that driver (in practice these will always
be in a driver-specific subdirectory), but subdevs that can be used stand-alone
should (I think) be moved to their own 'subdev' subdirectory.

It also makes no sense to me to mix bridge drivers and subdev drivers in one
directory. They are simply different types of driver.

I don't care whether they are moved to media/subdev or media/video/subdev. The
latter is probably easier.
 
> I remember that Oliver argued on that time that the better would be to reduce the
> number of subdirs, instead of increasing. On that discussions, I got convinced 
> that he was right, but maybe we have some new reasons to create a subdev dir.
> 
> So, let's get some feedback from developers about this again. Whatever decided,
> we should clearly document the used criteria, to avoid having drivers misplaced.

1) Reusable subdev drivers go into the subdev directory.
2) Subdev drivers that are tightly coupled to a bridge or platform driver go
into the subdirectory containing that bridge or platform driver.

Rule 1 applies to roughly 50 subdev drivers.

I wonder if for rule 2 we should require that subdev drivers would go into a
<bridge driver>/subdev directory. It would help in keeping track of what is what,
but this may be overkill.
 
> Ah, as we're talking about drivers directory, I'm intending to move the Remote
> Controller common code to another place, likely drivers/input/rc or drivers/rc.
> The idea is to use this subsystem for pure input devices as well. By keeping it
> at drivers/media, it will be missplaced.

Makes sense.

> 
> > What is your opinion on this, and what would be a good time to start moving
> > drivers?
> 
> If we're doing this change, I prefer to generate the patch by the end of a
> merge window, after merging from everybody else and being sure that trivial patches
> also got merged.

OK, makes sense.
 
> Comments?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
