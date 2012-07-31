Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:56566 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab2GaOSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 10:18:08 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Rob Clark <rob.clark@linaro.org>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Tue, 31 Jul 2012 17:18:02 +0300
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <201207311639.02693.remi@remlab.net> <CAF6AEGvZnz=1XEX9tuk_ZcfS14LXmnjeZGvOunWvi8aZ3sER5Q@mail.gmail.com>
In-Reply-To: <CAF6AEGvZnz=1XEX9tuk_ZcfS14LXmnjeZGvOunWvi8aZ3sER5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207311718.05738.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 31 juillet 2012 17:03:52 Rob Clark, vous avez écrit :
> On Tue, Jul 31, 2012 at 8:39 AM, Rémi Denis-Courmont <remi@remlab.net> 
wrote:
> > Le mardi 31 juillet 2012 14:56:14 Laurent Pinchart, vous avez écrit :
> >> > For that matter, wouldn't it be useful to support exporting a userptr
> >> > buffer at some point in the future?
> >> 
> >> Shouldn't USERPTR usage be discouraged once we get dma-buf support ?
> > 
> > USERPTR, where available, is currently the only way to perform zero-copy
> > from kernel to userspace. READWRITE does not support zero-copy at all.
> > MMAP only supports zero-copy if userspace knows a boundary on the number
> > of concurrent buffers *and* the device can deal with that number of
> > buffers; in general, MMAP requires memory copying.
> 
> hmm, this sounds like the problem is device pre-allocating buffers?

Basically, yes.

> Anyways, last time I looked, the vb2 core supported changing dmabuf fd
> each time you QBUF, in a similar way to what you can do w/ userptr.
> So that seems to get you the advantages you miss w/ mmap without the
> pitfalls of userptr.

It might work albeit with a higher system calls count overhead.

But what about libv4l2 transparent format conversion? Emulated USERBUF, with  
MMAP in the back-end would provide by far the least overhead. I don't see how 
DMABUF would work there.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
