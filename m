Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1685 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2HBHIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 03:08:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Thu, 2 Aug 2012 09:08:18 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <201208020835.58332.hverkuil@xs4all.nl> <201208020956.45291.remi@remlab.net>
In-Reply-To: <201208020956.45291.remi@remlab.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208020908.18512.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu August 2 2012 08:56:43 Rémi Denis-Courmont wrote:
> Le jeudi 2 août 2012 09:35:58 Hans Verkuil, vous avez écrit :
> > On Wed August 1 2012 22:49:57 Rémi Denis-Courmont wrote:
> > > > What about using the CREATE_BUFS ioctl to add new MMAP buffers at
> > > > runtime ?
> > > 
> > > Does CREATE_BUFS always work while already streaming has already started?
> > > If it depends on the driver, it's kinda helpless.
> > 
> > Yes, it does. It's one of the reasons it exists in the first place. But
> > there are currently only a handful of drivers that implement it. I hope
> > that as more and more drivers are converted to vb2 that the availability
> > of create_bufs will increase.
> 
> That's contradictory. If most drivers do not support it, then it won't work 
> during streaming.

IF create_bufs is implemented in the driver, THEN you can use it during streaming.
I.e., it will never return EBUSY as an error due to the fact that streaming is in
progress.

Obviously it won't work if the driver didn't implement it in the first place.

> 
> > > What's the guaranteed minimum buffer count? It seems in any case, MMAP
> > > has a hard limit of 32 buffers (at least videobuf2 has), though one
> > > might argue this should be more than enough.
> > 
> > Minimum or maximum? The maximum is 32, that's hardcoded in the V4L2 core.
> > Although drivers may force a lower maximum if they want. I have no idea
> > whether there are drivers that do that. There probably are.
> 
> The smallest of the maxima of all drivers.

I've no idea. Most will probably abide by the 32 maximum, but without analyzing
all drivers I can't guarantee it.

> > The minimum is usually between 1 and 3, depending on hardware limitations.
> 
> And that's clearly insufficient without memory copy to userspace buffers.
> 
> It does not seem to me that CREATE_BUFS+MMAP is a useful replacement for 
> REQBUFS+USERBUF then.

Just to put your mind at rest: USERPTR mode will *not* disappear or be deprecated
in any way. It's been there for a long time, it's in heavy use, it's easy to use
and it will not be turned into a second class citizen, because it isn't. Just
because there is a new dmabuf mode available doesn't mean that everything should
be done as a mmap+dmabuf thing.

Regards,

	Hans
