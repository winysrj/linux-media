Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2HVLDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 07:03:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	dmitriyz@google.com, s.nawrocki@samsung.com, k.debski@samsung.com
Subject: Re: [PATCHv8 13/26] v4l: vivi: support for dmabuf importing
Date: Wed, 22 Aug 2012 13:03:34 +0200
Message-ID: <1420558.oAlJzEsVFr@avalon>
In-Reply-To: <201208221256.30179.hverkuil@xs4all.nl>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-14-git-send-email-t.stanislaws@samsung.com> <201208221256.30179.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 22 August 2012 12:56:30 Hans Verkuil wrote:
> On Tue August 14 2012 17:34:43 Tomasz Stanislawski wrote:
> > This patch enhances VIVI driver with a support for importing a buffer
> > from DMABUF file descriptors.
> 
> Thanks for adding DMABUF support to vivi.
> 
> What would be great is if DMABUF support is also added to mem2mem_testdev.
> It would make an excellent test case to take the vivi output, pass it
> through mem2mem_testdev, and finally output the image using the gpu, all
> using dmabuf.
> 
> It's also very useful for application developers to test dmabuf support
> without requiring special hardware (other than a dmabuf-enabled gpu
> driver).

One important missing feature is support for exporting GPU buffers as dmabuf 
file descriptors in the userspace APIs. I'm not sure where that would plug in 
the graphics stack, but we probably need at least a Linux-specific OpenGL 
extension for that. I've heard from Rob Clark that work was ongoing in that 
direction. I believe that  
https://wiki.linaro.org/OfficeofCTO/MemoryManagement?action=AttachFile&do=get&target=linux-
video.pdf is also related.

-- 
Regards,

Laurent Pinchart

