Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1140 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab3DSJlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 05:41:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 21/24] V4L2: add a subdevice-driver pad-operation wrapper
Date: Fri, 19 Apr 2013 11:40:54 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de> <201304191020.44583.hverkuil@xs4all.nl> <Pine.LNX.4.64.1304191043470.591@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1304191043470.591@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304191140.54968.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri April 19 2013 10:52:23 Guennadi Liakhovetski wrote:
> On Fri, 19 Apr 2013, Hans Verkuil wrote:
> 
> > On Thu April 18 2013 23:35:42 Guennadi Liakhovetski wrote:
> > > Some subdevice drivers implement only the pad-level API, making them
> > > unusable with V4L2 camera host drivers, using the plain subdevice
> > > video API. This patch implements a wrapper to allow those two types
> > > of drivers to be used together. So far only a subset of operations is
> > > supported, the rest shall be added as needed.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > I wish you'd discussed this with me before spending time on this. This is
> > really not the right approach to this problem.
> 
> I don't see this as such a strict requirement. I think, many systems work 
> sufficiently well with subdevice video ops and don't need pad operations. 
> Those systems simply don't have all the complexity, that really led to the 
> pad-level API / MC. Think about simple camera interfaces, that can only 
> capture data from a camera and DMA it to RAM with no or very little 
> processing. No fancy scalers, converters, compressors etc. Do you really 
> want to spend time converting such host drivers to the pad-level API and 
> either use fake file-handles or really export everything to the user-space 
> and make users configure both the camera source and the host sink pads 
> manually independently... Isn't it an overkill?

No it isn't overkill. Having two APIs doing the same thing is always a bad
idea. Just look at what you are doing now. If we had one API you wouldn't
need to do this work, would you? The current situation leads to some subdevs
that implement one API, some that implement another and some that implement
both. And the poor bridge drivers just have to figure out which subdev it is.

It's just inconsistent and it is really not that hard to fix. If I make myself
angry for a day or two I'd have the subdevs converted to support both APIs
through the helper functions and then we (well, probably me) can convert
bridge drivers one by one.

Frankly, I've tried to explain this situation to others, and it is just very
confusing for them: 'so tell me again which API should I use in my new subdev
driver?'. The only correct solution is to work towards dropping the old API,
then there is no confusion anymore and everything is consistent again.

> With my approach you just 
> add "I want to stay with subdev ops and use a wrapper with pad-enabled 
> sensor drivers" to the _host_ driver, because it's really the host driver, 
> that has to be punished for being lazy. And you're done. No need to modify 
> subdevice drivers first to add wrappers and then to remove them again...

And then you're stuck with that wrapper layer for all eternity. It's the
quick hack approach that I don't want to see in the v4l2 core. I'm working
hard to convert all drivers to use the new frameworks so that I can get
rid of legacy code in the core, and I don't want to introduce new hacks that
I need to clean up in the future.

There really aren't all that many drivers that use these ops, so it's not
(as far as I can see) a particularly huge or difficult job.

> > Is there any point to the try variants if you don't have file handles? If
> > there is (and I don't see it), then v4l2_subdev could get a pointer to a
> > struct v4l2_subdev_try_buf and the macro could use that if fh == NULL.

I just noticed that try_mbus_fmt is used in bridge drivers, so we do have to
support the try variants. But I think that it is sufficient if the try macro
just returns NULL if no fh is given. Because in that case there is no reason
to store the updated try value in the filehandle struct.

Regards,

	Hans
