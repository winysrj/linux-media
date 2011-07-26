Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2259 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1GZL6S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 07:58:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Tue, 26 Jul 2011 13:57:31 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange> <201107261305.29863.hverkuil@xs4all.nl> <20110726114427.GC32507@valkosipuli.localdomain>
In-Reply-To: <20110726114427.GC32507@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107261357.31673.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, July 26, 2011 13:44:28 Sakari Ailus wrote:
> Hi Hans and Guennadi,

<snip>

> > I realized that it is not clear from the documentation whether it is possible to call
> > VIDIOC_REQBUFS and make additional calls to VIDIOC_CREATE_BUFS afterwards.
> 
> That's actually a must if one wants to release buffers. Currently no other
> method than requesting 0 buffers using REQBUFS is provided (apart from
> closing the file handle).

I was referring to the non-0 use-case :-)

> > I can't remember whether the code allows it or not, but it should be clearly documented.
> 
> I would guess no user application would have to call REQBUFS with other than
> zero buffers when using CREATE_BUFS. This must be an exception if mixing
> REQBUFS and CREATE_BUFS is not allowed in general. That said, I don't see a
> reason to prohibit either, but perhaps Guennadi has more informed opinion
> on this.
 
<snip>

> > > > > Future functionality which would be nice:
> > > > > 
> > > > > - Format counters. Every format set by S_FMT (or gotten by G_FMT) should
> > > > >   come with a counter value so that the user would know the format of
> > > > >   dequeued buffers when setting the format on-the-fly. Currently there are
> > > > >   only bytesperline and length, but the format can't be explicitly
> > > > >   determined from those.
> > 
> > Actually, the index field will give you that information. When you create the
> > buffers you know that range [index, index + count - 1] is associated with that
> > specific format.
> 
> Some hardware is able to change the format while streaming is ongoing (for
> example: OMAP 3). The problem is that the user should be able to know which
> frame has the new format.

Ah, of course.

> Of course one could stop streaming but this would mean lost frames.
> 
> A flag has been proposed to this previously. That's one option but forces
> the user to keep track of the changes since only one change is allowed until
> it has taken effect.

Something to discuss next week, I think.

Regards,

	Hans
