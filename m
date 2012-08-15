Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59315 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2HOTI3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 15:08:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, dmitriyz@google.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv8 18/26] v4l: add buffer exporting via dmabuf
Date: Wed, 15 Aug 2012 21:08:44 +0200
Message-ID: <2258808.o9mokkE34F@avalon>
In-Reply-To: <1344958496-9373-19-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-19-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 14 August 2012 17:34:48 Tomasz Stanislawski wrote:
> This patch adds extension to V4L2 api. It allow to export a mmap buffer as
> file descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset
> used by mmap and return a file descriptor on success.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-compat-ioctl32.c |    1 +
>  drivers/media/video/v4l2-dev.c            |    1 +
>  drivers/media/video/v4l2-ioctl.c          |   15 +++++++++++++++
>  include/linux/videodev2.h                 |   26 ++++++++++++++++++++++++++
>  include/media/v4l2-ioctl.h                |    2 ++
>  5 files changed, 45 insertions(+)

[snip]

> b/include/linux/videodev2.h index 7f918dc..b5d058b 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -688,6 +688,31 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0800
>  #define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x1000
> 
> +/**
> + * struct v4l2_exportbuffer - export of video buffer as DMABUF file
> descriptor
> + *
> + * @fd:		file descriptor associated with DMABUF (set by driver)
> + * @mem_offset:	buffer memory offset as returned by VIDIOC_QUERYBUF in
> struct
> + *		v4l2_buffer::m.offset (for single-plane formats) or
> + *		v4l2_plane::m.offset (for multi-planar formats)
> + * @flags:	flags for newly created file, currently only O_CLOEXEC is
> + *		supported, refer to manual of open syscall for more details
> + *
> + * Contains data used for exporting a video buffer as DMABUF file
> descriptor.
> + * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
> + * (identical to the cookie used to mmap() the buffer to userspace). All
> + * reserved fields must be set to zero. The field reserved0 is expected to
> + * become a structure 'type' allowing an alternative layout of the
> structure
> + * content. Therefore this field should not be used for any other
> extensions.
> + */
> +struct v4l2_exportbuffer {
> +	__u32		fd;
> +	__u32		reserved0;
> +	__u32		mem_offset;
> +	__u32		flags;
> +	__u32		reserved[12];
> +};

As Hans recently pointed out, this could be layed out as

struct v4l2_exportbuffer {
	__u32		fd;	
	__u32		memory;
	union {
		__u32		mem_offset;
		unsigned long	userptr;
	} m;
	__u32		flags;
	__u32		reserved[12];
};

32-bit compatibility code would need to be added.

-- 
Regards,

Laurent Pinchart

