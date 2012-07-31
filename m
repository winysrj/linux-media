Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:2860 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2GaMLJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 08:11:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Tue, 31 Jul 2012 14:11:06 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <201207310833.56566.hverkuil@xs4all.nl> <36319543.mdnBULUSen@avalon>
In-Reply-To: <36319543.mdnBULUSen@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207311411.06974.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 31 July 2012 13:56:14 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 31 July 2012 08:33:56 Hans Verkuil wrote:
> > On Thu June 14 2012 16:32:23 Tomasz Stanislawski wrote:
> > > +/**
> > > + * struct v4l2_exportbuffer - export of video buffer as DMABUF file
> > > descriptor + *
> > > + * @fd:		file descriptor associated with DMABUF (set by driver)
> > > + * @mem_offset:	buffer memory offset as returned by VIDIOC_QUERYBUF in
> > > struct + *		v4l2_buffer::m.offset (for single-plane formats) or
> > > + *		v4l2_plane::m.offset (for multi-planar formats)
> > > + * @flags:	flags for newly created file, currently only O_CLOEXEC is
> > > + *		supported, refer to manual of open syscall for more details
> > > + *
> > > + * Contains data used for exporting a video buffer as DMABUF file
> > > descriptor. + * The buffer is identified by a 'cookie' returned by
> > > VIDIOC_QUERYBUF + * (identical to the cookie used to mmap() the buffer to
> > > userspace). All + * reserved fields must be set to zero. The field
> > > reserved0 is expected to + * become a structure 'type' allowing an
> > > alternative layout of the structure + * content. Therefore this field
> > > should not be used for any other extensions. + */
> > > +struct v4l2_exportbuffer {
> > > +	__u32		fd;
> > > +	__u32		reserved0;
> > > +	__u32		mem_offset;
> > 
> > This should be a union identical to the m union in v4l2_plane, together with
> > a u32 memory field. That way you can just copy memory and m from
> > v4l2_plane/buffer and call expbuf. If new memory types are added in the
> > future, then you don't need to change this struct.
> 
> OK, reserved0 could be replace by __u32 memory. Could we have other dma-buf 
> export types in the future not corresponding to a memory type ? I don't see 
> any use case right now though.

The memory type should be all you need. And the union is also needed since the
userptr value is unsigned long, thus ensuring that you have 64-bits available
for pointer types in the future. That's really my main point: the union should
have the same size as the union in v4l2_buffer/plane, allowing for the same
size pointers or whatever to be added in the future.

> > For that matter, wouldn't it be useful to support exporting a userptr buffer
> > at some point in the future?
> 
> Shouldn't USERPTR usage be discouraged once we get dma-buf support ?

Why? It's perfectly fine to use it and it's not going away.

I'm not saying that we should support exporting a userptr buffer as a dmabuf fd,
but I'm just wondering if that is possible at all and how difficult it would be.

Regards,

	Hans

> 
> > BTW, this patch series needs to be rebased to the latest for_v3.6. Quite a
> > few core things have changed when it comes to adding new ioctls.
> 
> 
