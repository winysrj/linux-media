Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1490 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab0BVVvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 16:51:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Chroma gain configuration
Date: Mon, 22 Feb 2010 22:54:05 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com> <201002222241.22456.hverkuil@xs4all.nl> <829197381002221343u7001cff2t59bfe3ef735db5fc@mail.gmail.com>
In-Reply-To: <829197381002221343u7001cff2t59bfe3ef735db5fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002222254.05573.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 February 2010 22:43:58 Devin Heitmueller wrote:
> On Mon, Feb 22, 2010 at 4:41 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > I am still planning to continue my work for a general control handling
> > framework. I know how to do it and it's just time that I lack.
> >
> > Converting all drivers to support the extended control API is quite complicated
> > since the API is fairly complex (esp. with regard to atomicity). In this case
> > my advice would be to support extended controls only where needed and wait for
> > this framework before converting all the other drivers.
> 
> Hans,
> 
> I have no objection to holding off if that's what you recommend.  The
> only reason we got onto this thread was because the v4l2-dbg
> application seems to implicitly assume that *all* private controls
> using V4L2_CID_PRIVATE_BASE can only be accessed via the extended
> control interface, meaning you cannot use the utility in conjunction
> with a driver that has a private control defined in the the
> VIDIOC_G_CTRL function.

Ah, that's another matter. The original approach for handling private
controls is seriously flawed. Drivers that want to use private controls
are strongly encouraged to use the extended control mechanism for them,
and to document those controls in the spec.

Actually, it is not so much the extended control API that is relevant
here, but the use of V4L2_CTRL_FLAG_NEXT_CTRL in VIDIOC_QUERYCTRL to
enumerate the controls.

Unfortunately, the current support functions in v4l2-common.c to help
with this are pretty crappy, for which I apologize.

Regards,

	Hans

> 
> Devin
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
