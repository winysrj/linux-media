Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:37859 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab2HBG4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 02:56:48 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Thu, 2 Aug 2012 09:56:43 +0300
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <201208012350.00207.remi@remlab.net> <201208020835.58332.hverkuil@xs4all.nl>
In-Reply-To: <201208020835.58332.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208020956.45291.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 2 août 2012 09:35:58 Hans Verkuil, vous avez écrit :
> On Wed August 1 2012 22:49:57 Rémi Denis-Courmont wrote:
> > > What about using the CREATE_BUFS ioctl to add new MMAP buffers at
> > > runtime ?
> > 
> > Does CREATE_BUFS always work while already streaming has already started?
> > If it depends on the driver, it's kinda helpless.
> 
> Yes, it does. It's one of the reasons it exists in the first place. But
> there are currently only a handful of drivers that implement it. I hope
> that as more and more drivers are converted to vb2 that the availability
> of create_bufs will increase.

That's contradictory. If most drivers do not support it, then it won't work 
during streaming.

> > What's the guaranteed minimum buffer count? It seems in any case, MMAP
> > has a hard limit of 32 buffers (at least videobuf2 has), though one
> > might argue this should be more than enough.
> 
> Minimum or maximum? The maximum is 32, that's hardcoded in the V4L2 core.
> Although drivers may force a lower maximum if they want. I have no idea
> whether there are drivers that do that. There probably are.

The smallest of the maxima of all drivers.

> The minimum is usually between 1 and 3, depending on hardware limitations.

And that's clearly insufficient without memory copy to userspace buffers.

It does not seem to me that CREATE_BUFS+MMAP is a useful replacement for 
REQBUFS+USERBUF then.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
