Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3681 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0HAMPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 08:15:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH v5 1/3] v4l: Add multi-planar API definitions to the V4L2 API
Date: Sun, 1 Aug 2010 14:14:49 +0200
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
References: <1280479783-23945-1-git-send-email-p.osciak@samsung.com> <1280479783-23945-2-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1280479783-23945-2-git-send-email-p.osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011414.49302.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 July 2010 10:49:41 Pawel Osciak wrote:
> Multi-planar API is as a backwards-compatible extension of the V4L2 API,
> which allows video buffers to consist of one or more planes. Planes are
> separate memory buffers; each has its own mapping, backed by usually
> separate physical memory buffers.
> 
> Many different uses for the multi-planar API are possible, examples
> include:
> - embedded devices requiring video components to be placed in physically
> separate buffers, e.g. for Samsung S3C/S5P SoC series' video codec,
> Y and interleaved Cb/Cr components reside in buffers in different
> memory banks;
> - applications may receive (or choose to store) video data of one video
> buffer in separate memory buffers; such data would have to be temporarily
> copied together into one buffer before passing it to a V4L2 device;
> - applications or drivers may want to pass metadata related to a buffer and
> it may not be possible to place it in the same buffer, together with video
> data.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |    2 +
>  include/linux/videodev2.h        |  126 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 126 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 0eeceae..a830bbd 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -168,6 +168,8 @@ const char *v4l2_type_names[] = {
>  	[V4L2_BUF_TYPE_SLICED_VBI_CAPTURE] = "sliced-vbi-cap",
>  	[V4L2_BUF_TYPE_SLICED_VBI_OUTPUT]  = "sliced-vbi-out",
>  	[V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY] = "vid-out-overlay",
> +	[V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE] = "vid-cap-mplane",
> +	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE] = "vid-out-mplane",
>  };
>  EXPORT_SYMBOL(v4l2_type_names);
>  
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 047f7e6..0379f07 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -70,6 +70,7 @@
>   * Moved from videodev.h
>   */
>  #define VIDEO_MAX_FRAME               32
> +#define VIDEO_MAX_PLANES               8
>  
>  #ifndef __KERNEL__
>  
> @@ -157,9 +158,23 @@ enum v4l2_buf_type {
>  	/* Experimental */
>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
>  #endif
> +	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 17,
> +	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 18,

Why 17 and 18 instead of 9 and 10?

>  	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>  };
>  
> +#define V4L2_TYPE_IS_MULTIPLANAR(type)			\
> +	((type) == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE	\
> +	 || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +
> +#define V4L2_TYPE_IS_OUTPUT(type)				\
> +	((type) == V4L2_BUF_TYPE_VIDEO_OUTPUT			\
> +	 || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE		\
> +	 || (type) == V4L2_BUF_TYPE_VIDEO_OVERLAY		\
> +	 || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY	\
> +	 || (type) == V4L2_BUF_TYPE_VBI_OUTPUT			\
> +	 || (type) == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT)
> +
>  enum v4l2_tuner_type {
>  	V4L2_TUNER_RADIO	     = 1,
>  	V4L2_TUNER_ANALOG_TV	     = 2,
> @@ -245,6 +260,11 @@ struct v4l2_capability {
>  #define V4L2_CAP_HW_FREQ_SEEK		0x00000400  /* Can do hardware frequency seek  */
>  #define V4L2_CAP_RDS_OUTPUT		0x00000800  /* Is an RDS encoder */
>  
> +/* Is a video capture device that supports multiplanar formats */
> +#define V4L2_CAP_VIDEO_CAPTURE_MPLANE	0x00001000
> +/* Is a video output device that supports multiplanar formats */
> +#define V4L2_CAP_VIDEO_OUTPUT_MPLANE	0x00002000
> +
>  #define V4L2_CAP_TUNER			0x00010000  /* has a tuner */
>  #define V4L2_CAP_AUDIO			0x00020000  /* has audio support */
>  #define V4L2_CAP_RADIO			0x00040000  /* is a radio device */
> @@ -514,6 +534,63 @@ struct v4l2_requestbuffers {
>  	__u32			reserved[2];
>  };
>  
> +/**
> + * struct v4l2_plane - plane info for multi-planar buffers
> + * @bytesused:		number of bytes occupied by data in the plane (payload)
> + * @mem_offset:		when memory in the associated struct v4l2_buffer is
> + * 			V4L2_MEMORY_MMAP, equals the offset from the start of
> + * 			the device memory for this plane (or is a "cookie" that
> + * 			should be passed to mmap() called on the video node)
> + * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
> + * 			pointing
> + * 			to this plane

Can be put on one line instead of two.

> + * @length:		size of this plane (NOT the payload) in bytes

Note: mismatch between the order of the fields here and in the actual struct.
@length should be after @bytesused.

> + * @data_offset:	offset in plane to the start of data/end of header,
> + * 			if relevant

I would rephrase this:

offset in the plane to the start of data. Usually this is 0, unless there is
a header in front of the data.


> + *
> + * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
> + * with two planes can have one plane for Y, and another for interleaved CbCr
> + * components. Each plane can reside in a separate memory buffer, or even in
> + * a completely separate memory node (e.g. in embedded devices).
> + */
> +struct v4l2_plane {
> +	__u32			bytesused;
> +	__u32			length;
> +	union {
> +		__u32		mem_offset;
> +		unsigned long	userptr;
> +	} m;
> +	__u32			data_offset;
> +	__u32			reserved[11];
> +};
> +
> +/**
> + * struct v4l2_buffer - video buffer info
> + * @index:	id number of the buffer
> + * @type:	buffer type (type == *_MPLANE for multiplanar buffers)
> + * @bytesused:	number of bytes occupied by data in the buffer (payload);
> + * 		unused (set to 0) for multiplanar buffers
> + * @flags:	buffer informational flags
> + * @field:	field order of the image in the buffer
> + * @timestamp:	frame timestamp
> + * @timecode:	frame timecode
> + * @sequence:	sequence count of this frame
> + * @memory:	the method, in which the actual video data is passed
> + * @offset:	for non-multiplanar buffers with memory == V4L2_MEMORY_MMAP;
> + * 		offset from the start of the device memory for this plane,
> + * 		(or a "cookie" that should be passed to mmap() as offset)
> + * @userptr:	for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
> + * 		a userspace pointer pointing to this buffer
> + * @planes:	for multiplanar buffers; userspace pointer to the array of plane
> + * 		info structs for this buffer
> + * @length:	size in bytes of the buffer (NOT its payload) for single-plane
> + * 		buffers (when type != *_MPLANE); number of planes (and number
> + * 		of elements in the planes array) for multi-plane buffers

This is confusing. Just write "number of elements in the planes array".

> + * @input:	input number from which the video data has has been captured
> + *
> + * Contains data exchanged by application and driver using one of the Streaming
> + * I/O methods.
> + */
>  struct v4l2_buffer {
>  	__u32			index;
>  	enum v4l2_buf_type      type;
> @@ -529,6 +606,7 @@ struct v4l2_buffer {
>  	union {
>  		__u32           offset;
>  		unsigned long   userptr;
> +		struct v4l2_plane *planes;

Should use the __user attribute.

>  	} m;
>  	__u32			length;
>  	__u32			input;
> @@ -1613,12 +1691,57 @@ struct v4l2_mpeg_vbi_fmt_ivtv {
>   *	A G G R E G A T E   S T R U C T U R E S
>   */
>  
> -/*	Stream data format
> +/**
> + * struct v4l2_plane_pix_format - additional, per-plane format definition
> + * @sizeimage:		maximum size in bytes required for data, for which
> + * 			this plane will be used
> + * @bytesperline:	distance in bytes between the leftmost pixels in two
> + * 			adjacent lines
> + */
> +struct v4l2_plane_pix_format {
> +	__u32		sizeimage;
> +	__u16		bytesperline;
> +	__u16		reserved[7];
> +} __attribute__ ((packed));
> +
> +/**
> + * struct v4l2_pix_format_mplane - multiplanar format definition
> + * @width:		image width in pixels
> + * @height:		image height in pixels
> + * @pixelformat:	little endian four character code (fourcc)
> + * @field:		field order (for interlaced video)
> + * @colorspace:		supplemental to pixelformat
> + * @plane_fmt:		per-plane information
> + * @num_planes:		number of planes for this format and number of valid
> + * 			elements in plane_fmt array

Same problem here: just write "number of planes for this format".

> + */
> +struct v4l2_pix_format_mplane {
> +	__u32				width;
> +	__u32				height;
> +	__u32				pixelformat;
> +	enum v4l2_field			field;
> +	enum v4l2_colorspace		colorspace;
> +
> +	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
> +	__u8				num_planes;
> +	__u8				reserved[11];
> +} __attribute__ ((packed));
> +
> +/**
> + * struct v4l2_format - stream data format
> + * @type:	type of the data stream
> + * @pix:	definition of an image format
> + * @pix_mp:	definition of a multiplanar image format
> + * @win:	definition of an overlaid image
> + * @vbi:	raw VBI capture or output parameters
> + * @sliced:	sliced VBI capture or output parameters
> + * @raw_data:	placeholder for future extensions and custom formats
>   */
>  struct v4l2_format {
>  	enum v4l2_buf_type type;
>  	union {
>  		struct v4l2_pix_format		pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
> +		struct v4l2_pix_format_mplane	pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
>  		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
>  		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
>  		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
> @@ -1626,7 +1749,6 @@ struct v4l2_format {
>  	} fmt;
>  };
>  
> -
>  /*	Stream type-dependent parameters
>   */
>  struct v4l2_streamparm {
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
