Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42886 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2HVXjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 19:39:13 -0400
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
Subject: Re: [PATCHv8 18/26] v4l: add buffer exporting via dmabuf
Date: Thu, 23 Aug 2012 01:39:34 +0200
Message-ID: <1482826.kal9EJjByd@avalon>
In-Reply-To: <201208221341.06056.hverkuil@xs4all.nl>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-19-git-send-email-t.stanislaws@samsung.com> <201208221341.06056.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 22 August 2012 13:41:05 Hans Verkuil wrote:
> On Tue August 14 2012 17:34:48 Tomasz Stanislawski wrote:
> > This patch adds extension to V4L2 api. It allow to export a mmap buffer as
> > file descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer
> > offset used by mmap and return a file descriptor on success.
> > 
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

[snip]

> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 7f918dc..b5d058b 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -688,6 +688,31 @@ struct v4l2_buffer {
> > 
> >  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
> >  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
> > 
> > +/**
> > + * struct v4l2_exportbuffer - export of video buffer as DMABUF file
> > descriptor + *
> > + * @fd:		file descriptor associated with DMABUF (set by driver)
> > + * @mem_offset:	buffer memory offset as returned by VIDIOC_QUERYBUF in
> > struct + *		v4l2_buffer::m.offset (for single-plane formats) or
> > + *		v4l2_plane::m.offset (for multi-planar formats)
> > + * @flags:	flags for newly created file, currently only O_CLOEXEC is
> > + *		supported, refer to manual of open syscall for more details
> > + *
> > + * Contains data used for exporting a video buffer as DMABUF file
> > descriptor. + * The buffer is identified by a 'cookie' returned by
> > VIDIOC_QUERYBUF + * (identical to the cookie used to mmap() the buffer to
> > userspace). All + * reserved fields must be set to zero. The field
> > reserved0 is expected to + * become a structure 'type' allowing an
> > alternative layout of the structure + * content. Therefore this field
> > should not be used for any other extensions. + */
> > +struct v4l2_exportbuffer {
> > +	__u32		fd;
> > +	__u32		reserved0;
> > +	__u32		mem_offset;
> > +	__u32		flags;
> > +	__u32		reserved[12];
> > +};
> 
> OK, I realized that we also need a type field here: you need the type field
> (same as in v4l2_buffer) to know which queue the mem_offset refers to. For
> M2M devices you have two queues, so you need this information.
> 
> Is there any reason not to use __u32 memory instead of __u32 reserved0?
> I really dislike 'reserved0'. It's also very inconsistent with the other
> buffer ioctls which all have type+memory fields.

I'm concerned that we might need to export buffers in the future based on 
something else than the memory type. That's probably an irrational fear 
though.

> Regarding mem_offset: I would prefer a union (possibly anonymous):
> 
>         union {
>                 __u32           mem_offset;
>                 unsigned long   reserved;
>         } m;
> 
> Again, it's more consistent with the existing buffer ioctls, and it prepares
> the API for future pointer values. 'reserved' in the union above could even
> safely be renamed to userptr, even though userptr isn't supported at the
> moment.

Once again I would really want to see compeling use cases before we export a 
userptr buffer as a dmabuf object. As Mauro previously stated, userptr for 
buffer sharing was a hack in the first place (although a pretty successful one 
so far).

-- 
Regards,

Laurent Pinchart

