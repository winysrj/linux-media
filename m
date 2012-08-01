Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:58330 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab2HAUuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 16:50:03 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Wed, 1 Aug 2012 23:49:57 +0300
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <60c9f6aa1a35c476f6d3493aa24438ad@chewa.net> <1390726.ZQ58TDe5fq@avalon>
In-Reply-To: <1390726.ZQ58TDe5fq@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208012350.00207.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 1 août 2012 14:35:03 Laurent Pinchart, vous avez écrit :
> > But in general, the V4L element in the pipeline does not know how fast
> > the downstream element(s) will consume the buffers. Thus it has to copy
> > from the MMAP buffers into anonymous user memory pending processing.
> > Then any dequeued buffer can be requeued as soon as possible. In theory,
> > it might also be that, even though the latency is known, the number of
> > required buffers exceeds the maximum MMAP buffers count of the V4L
> > device. Either way, user space ends up doing memory copy from MMAP to
> > custom buffers.
> > 
> > This problem does not exist with USERBUF - the V4L2 element can simply
> > allocate a new buffer for each dequeued buffer.
> 
> What about using the CREATE_BUFS ioctl to add new MMAP buffers at runtime ?

Does CREATE_BUFS always work while already streaming has already started? If 
it depends on the driver, it's kinda helpless.

What's the guaranteed minimum buffer count? It seems in any case, MMAP has a 
hard limit of 32 buffers (at least videobuf2 has), though one might argue this 
should be more than enough.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
