Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50632 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2E1VWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 17:22:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv6 01/13] v4l: Add DMABUF as a memory type
Date: Mon, 28 May 2012 23:12:06 +0200
Message-ID: <39362499.rezgOX57D6@avalon>
In-Reply-To: <1337775027-9489-2-git-send-email-t.stanislaws@samsung.com>
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com> <1337775027-9489-2-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Wednesday 23 May 2012 14:10:15 Tomasz Stanislawski wrote:
> From: Sumit Semwal <sumit.semwal@ti.com>
> 
> Adds DMABUF memory type to v4l framework. Also adds the related file
> descriptor in v4l2_plane and v4l2_buffer.

Sorry not to have caught this earlier, but haven't you forgotten to add 
support for V4L2_MEMORY_DMABUF to v4l2-compat-ioctl32.c ?

> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>    [original work in the PoC for buffer sharing]
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |    1 +
>  include/linux/videodev2.h        |    7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c
> b/drivers/media/video/v4l2-ioctl.c index 91be4e8..31fc2ad 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -175,6 +175,7 @@ static const char *v4l2_memory_names[] = {
>  	[V4L2_MEMORY_MMAP]    = "mmap",
>  	[V4L2_MEMORY_USERPTR] = "userptr",
>  	[V4L2_MEMORY_OVERLAY] = "overlay",
> +	[V4L2_MEMORY_DMABUF] = "dmabuf",
>  };
> 
>  #define prt_names(a, arr) ((((a) >= 0) && ((a) < ARRAY_SIZE(arr))) ? \
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 370d111..51b20f4 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -185,6 +185,7 @@ enum v4l2_memory {
>  	V4L2_MEMORY_MMAP             = 1,
>  	V4L2_MEMORY_USERPTR          = 2,
>  	V4L2_MEMORY_OVERLAY          = 3,
> +	V4L2_MEMORY_DMABUF           = 4,
>  };
> 
>  /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
> @@ -591,6 +592,8 @@ struct v4l2_requestbuffers {
>   *			should be passed to mmap() called on the video node)
>   * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
>   *			pointing to this plane
> + * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
> + *			descriptor associated with this plane
>   * @data_offset:	offset in the plane to the start of data; usually 0,
>   *			unless there is a header in front of the data
>   *
> @@ -605,6 +608,7 @@ struct v4l2_plane {
>  	union {
>  		__u32		mem_offset;
>  		unsigned long	userptr;
> +		int		fd;
>  	} m;
>  	__u32			data_offset;
>  	__u32			reserved[11];
> @@ -629,6 +633,8 @@ struct v4l2_plane {
>   *		(or a "cookie" that should be passed to mmap() as offset)
>   * @userptr:	for non-multiplanar buffers with memory ==
> V4L2_MEMORY_USERPTR; *		a userspace pointer pointing to this buffer
> + * @fd:		for non-multiplanar buffers with memory == 
V4L2_MEMORY_DMABUF;
> + *		a userspace file descriptor associated with this buffer
>   * @planes:	for multiplanar buffers; userspace pointer to the array of
> plane *		info structs for this buffer
>   * @length:	size in bytes of the buffer (NOT its payload) for single-
plane
> @@ -655,6 +661,7 @@ struct v4l2_buffer {
>  		__u32           offset;
>  		unsigned long   userptr;
>  		struct v4l2_plane *planes;
> +		int		fd;
>  	} m;
>  	__u32			length;
>  	__u32			input;
-- 
Regards,

Laurent Pinchart

