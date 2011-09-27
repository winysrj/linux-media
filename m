Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2268 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1I0L1w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 07:27:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/4] v4l: add documentation for selection API
Date: Tue, 27 Sep 2011 13:27:06 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@iki.fi
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com> <201109271120.29606.hverkuil@xs4all.nl> <201109271311.36174.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109271311.36174.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271327.07095.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 13:11:35 Laurent Pinchart wrote:
> On Tuesday 27 September 2011 11:20:29 Hans Verkuil wrote:
> > On Wednesday, August 31, 2011 14:28:21 Tomasz Stanislawski wrote:
> > > This patch adds a documentation for VIDIOC_{G/S}_SELECTION ioctl.
> > > Moreover, the patch adds the description of modeling of composing,
> > > cropping and scaling features in V4L2. Finally, some examples are
> > > presented.
> > > 
> > > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> [snip]
> 
> > >    <section id="crop">
> > > 
> > > -    <title>Image Cropping, Insertion and Scaling</title>
> > > +    <title>Deprecated API for image cropping, insertion and
> > > scaling</title>
> > 
> > I wouldn't call this deprecated. It's part of the API and we will just keep
> > on supporting this.
> 
> I think we should still encourage driver and application developers to 
> implement the selection API and use it when available instead of the crop API.

New drivers should use the selection API and old drivers are encouraged
to convert to the selection API. But the existing crop API can't go away.
And applications can't use it any time soon (it takes years before all customers
are on kernels that have the selection API).

And anyway, an ioctl like G/S_CROP can't be deprecated. It's been part of V4L2
for ages and it just works fine for those use-cases.

For driver development it is a different story, but that's outside the scope
of the V4L2 spec.

> > I would instead refer to the new section on the selection API.
> 
> [snip]
> 
> > > +<para>The range of coordinates of the top left corner, width and height
> > > of a +area which can be sampled is given by the <constant>
> > > V4L2_SEL_CROP_BOUNDS +</constant> target. To support a wide range of
> > > hardware this specification does +not define an origin or units.</para>
> > 
> > I know this phrase is present in the crop API, but I've never liked it. It
> > makes life very hard for applications if the units aren't in pixels. The
> > main reason the crop API was written in that way was for analog video
> > receivers: while analog TV has discrete lines, in the horizontal direction
> > there really isn't a clear 'pixel' concept. However, I've always thought
> > that was a bogus argument since after sampling you end up with pixels
> > anyway.
> > 
> > In my opinion the selection API should deal with pixels only.
> 
> What about hardware that supports sub-pixel cropping and/or composing ?

That should be an addition to the API: sub-pixel targets etc. We would need
to discuss that in more detail (how is it done? how are the sub-pixels defined?
how would you represent it?). We may even only support such things on the
subdev API. I just can't see any 'normal' application wanting to use sub-pixel
cropping/composing.

> > The main driver where this might cause problems is bttv. I'm not sure how
> > the selection vs crop API translation would work there. It might be best to
> > just keep the current crop implementation in bttv and make a separate
> > selection implementation. I'm pretty sure the bttv driver actually
> > does/can do sub-pixel cropping.
> > 
> > With respect to the origin: I think I would put the top-left corner of the
> > default crop rectangle at (0, 0). Strictly speaking it shouldn't matter
> > where the origin is, but it seems to me that that's a logical choice.
> 
> For sensor drivers I found it easier to have the pixel array origin at (0, 0). 
> It might just be me though.

This was just a suggestion from me. We may also leave it to the driver.
I don't have a very strong opinion on this.

Regards,

	Hans
