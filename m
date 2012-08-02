Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3670 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2HBGgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 02:36:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Thu, 2 Aug 2012 08:35:58 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <1390726.ZQ58TDe5fq@avalon> <201208012350.00207.remi@remlab.net>
In-Reply-To: <201208012350.00207.remi@remlab.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208020835.58332.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed August 1 2012 22:49:57 Rémi Denis-Courmont wrote:
> Le mercredi 1 août 2012 14:35:03 Laurent Pinchart, vous avez écrit :
> > > But in general, the V4L element in the pipeline does not know how fast
> > > the downstream element(s) will consume the buffers. Thus it has to copy
> > > from the MMAP buffers into anonymous user memory pending processing.
> > > Then any dequeued buffer can be requeued as soon as possible. In theory,
> > > it might also be that, even though the latency is known, the number of
> > > required buffers exceeds the maximum MMAP buffers count of the V4L
> > > device. Either way, user space ends up doing memory copy from MMAP to
> > > custom buffers.
> > > 
> > > This problem does not exist with USERBUF - the V4L2 element can simply
> > > allocate a new buffer for each dequeued buffer.
> > 
> > What about using the CREATE_BUFS ioctl to add new MMAP buffers at runtime ?
> 
> Does CREATE_BUFS always work while already streaming has already started? If 
> it depends on the driver, it's kinda helpless.

Yes, it does. It's one of the reasons it exists in the first place. But there
are currently only a handful of drivers that implement it. I hope that as
more and more drivers are converted to vb2 that the availability of create_bufs
will increase.

> What's the guaranteed minimum buffer count? It seems in any case, MMAP has a 
> hard limit of 32 buffers (at least videobuf2 has), though one might argue this 
> should be more than enough.

Minimum or maximum? The maximum is 32, that's hardcoded in the V4L2 core.
Although drivers may force a lower maximum if they want. I have no idea
whether there are drivers that do that. There probably are.

The minimum is usually between 1 and 3, depending on hardware limitations.

Regards,

	Hans
