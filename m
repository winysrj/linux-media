Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46907 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2HBVuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 17:50:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Thu, 02 Aug 2012 23:50:31 +0200
Message-ID: <1530169.bCmcyqEdys@avalon>
In-Reply-To: <201208020908.18512.hverkuil@xs4all.nl>
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <201208020956.45291.remi@remlab.net> <201208020908.18512.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 02 August 2012 09:08:18 Hans Verkuil wrote:
> On Thu August 2 2012 08:56:43 R�mi Denis-Courmont wrote:
> > Le jeudi 2 ao�t 2012 09:35:58 Hans Verkuil, vous avez �crit :
> > > On Wed August 1 2012 22:49:57 R�mi Denis-Courmont wrote:
> > > > > What about using the CREATE_BUFS ioctl to add new MMAP buffers at
> > > > > runtime ?
> > > > 
> > > > Does CREATE_BUFS always work while already streaming has already
> > > > started? If it depends on the driver, it's kinda helpless.
> > > 
> > > Yes, it does. It's one of the reasons it exists in the first place. But
> > > there are currently only a handful of drivers that implement it. I hope
> > > that as more and more drivers are converted to vb2 that the availability
> > > of create_bufs will increase.
> > 
> > That's contradictory. If most drivers do not support it, then it won't
> > work during streaming.
> 
> IF create_bufs is implemented in the driver, THEN you can use it during
> streaming. I.e., it will never return EBUSY as an error due to the fact
> that streaming is in progress.
> 
> Obviously it won't work if the driver didn't implement it in the first
> place.
>
> > > > What's the guaranteed minimum buffer count? It seems in any case, MMAP
> > > > has a hard limit of 32 buffers (at least videobuf2 has), though one
> > > > might argue this should be more than enough.
> > > 
> > > Minimum or maximum? The maximum is 32, that's hardcoded in the V4L2
> > > core. Although drivers may force a lower maximum if they want. I have no
> > > idea whether there are drivers that do that. There probably are.
> > 
> > The smallest of the maxima of all drivers.
> 
> I've no idea. Most will probably abide by the 32 maximum, but without
> analyzing all drivers I can't guarantee it.
> 
> > > The minimum is usually between 1 and 3, depending on hardware
> > > limitations.
> > 
> > And that's clearly insufficient without memory copy to userspace buffers.
> > 
> > It does not seem to me that CREATE_BUFS+MMAP is a useful replacement for
> > REQBUFS+USERBUF then.
> 
> Just to put your mind at rest: USERPTR mode will *not* disappear or be
> deprecated in any way. It's been there for a long time, it's in heavy use,
> it's easy to use and it will not be turned into a second class citizen,
> because it isn't. Just because there is a new dmabuf mode available doesn't
> mean that everything should be done as a mmap+dmabuf thing.

I disagree with this. Not everything should obviously be done with MMAP + 
DMABUF, but for buffer sharing between devices, we should encourage 
application developers to use DMABUF instead of USERPTR.

-- 
Regards,

Laurent Pinchart

