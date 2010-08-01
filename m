Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2169 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0HAMao (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 08:30:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH v5 2/3] v4l: Add multi-planar ioctl handling code
Date: Sun, 1 Aug 2010 14:30:30 +0200
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
References: <1280479783-23945-1-git-send-email-p.osciak@samsung.com> <1280479783-23945-3-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1280479783-23945-3-git-send-email-p.osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011430.30145.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 July 2010 10:49:42 Pawel Osciak wrote:
> Add multi-planar API core ioctl handling and conversion functions.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |  418 ++++++++++++++++++++++++++++++++++----
>  include/media/v4l2-ioctl.h       |   16 ++
>  2 files changed, 390 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index a830bbd..3b2880a 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -476,20 +476,33 @@ static void dbgbuf(unsigned int cmd, struct video_device *vfd,
>  					struct v4l2_buffer *p)
>  {
>  	struct v4l2_timecode *tc = &p->timecode;
> +	struct v4l2_plane *plane;
> +	int i;
>  
>  	dbgarg(cmd, "%02ld:%02d:%02d.%08ld index=%d, type=%s, "
> -		"bytesused=%d, flags=0x%08d, "
> -		"field=%0d, sequence=%d, memory=%s, offset/userptr=0x%08lx, length=%d\n",
> +		"flags=0x%08d, field=%0d, sequence=%d, memory=%s\n",
>  			p->timestamp.tv_sec / 3600,
>  			(int)(p->timestamp.tv_sec / 60) % 60,
>  			(int)(p->timestamp.tv_sec % 60),
>  			(long)p->timestamp.tv_usec,
>  			p->index,
>  			prt_names(p->type, v4l2_type_names),
> -			p->bytesused, p->flags,
> -			p->field, p->sequence,
> -			prt_names(p->memory, v4l2_memory_names),
> -			p->m.userptr, p->length);
> +			p->flags, p->field, p->sequence,
> +			prt_names(p->memory, v4l2_memory_names));
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(p->type) && p->m.planes) {
> +		for (i = 0; i < p->length; ++i) {
> +			plane = &p->m.planes[i];
> +			dbgarg2("plane %d: bytesused=%d, data_offset=0x%08x "
> +				"offset/userptr=0x%08lx, length=%d\n",
> +				i, plane->bytesused, plane->data_offset,
> +				plane->m.userptr, plane->length);
> +		}
> +	} else {
> +		dbgarg2("bytesused=%d, offset/userptr=0x%08lx, length=%d\n",
> +			p->bytesused, p->m.userptr, p->length);
> +	}
> +
>  	dbgarg2("timecode=%02d:%02d:%02d type=%d, "
>  		"flags=0x%08d, frames=%d, userbits=0x%08x\n",
>  			tc->hours, tc->minutes, tc->seconds,
> @@ -517,6 +530,27 @@ static inline void v4l_print_pix_fmt(struct video_device *vfd,
>  		fmt->bytesperline, fmt->sizeimage, fmt->colorspace);
>  };
>  
> +static inline void v4l_print_pix_fmt_mplane(struct video_device *vfd,
> +					    struct v4l2_pix_format_mplane *fmt)
> +{
> +	int i;
> +
> +	dbgarg2("width=%d, height=%d, format=%c%c%c%c, field=%s, "
> +		"colorspace=%d, num_planes=%d\n",
> +		fmt->width, fmt->height,
> +		(fmt->pixelformat & 0xff),
> +		(fmt->pixelformat >>  8) & 0xff,
> +		(fmt->pixelformat >> 16) & 0xff,
> +		(fmt->pixelformat >> 24) & 0xff,
> +		prt_names(fmt->field, v4l2_field_names),
> +		fmt->colorspace, fmt->num_planes);
> +
> +	for (i = 0; i < fmt->num_planes; ++i)
> +		dbgarg2("plane %d: bytesperline=%d sizeimage=%d\n", i,
> +			fmt->plane_fmt[i].bytesperline,
> +			fmt->plane_fmt[i].sizeimage);
> +}
> +
>  static inline void v4l_print_ext_ctrls(unsigned int cmd,
>  	struct video_device *vfd, struct v4l2_ext_controls *c, int show_vals)
>  {
> @@ -570,7 +604,12 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
>  
>  	switch (type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		if (ops->vidioc_g_fmt_vid_cap)
> +		if (ops->vidioc_g_fmt_vid_cap ||
> +				ops->vidioc_g_fmt_vid_cap_mplane)
> +			return 0;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		if (ops->vidioc_g_fmt_vid_cap_mplane)
>  			return 0;
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> @@ -578,7 +617,12 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
>  			return 0;
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		if (ops->vidioc_g_fmt_vid_out)
> +		if (ops->vidioc_g_fmt_vid_out ||
> +				ops->vidioc_g_fmt_vid_out_mplane)
> +			return 0;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		if (ops->vidioc_g_fmt_vid_out_mplane)
>  			return 0;
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
> @@ -609,12 +653,70 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
>  	return -EINVAL;
>  }
>  
> +/**
> + * fmt_sp_to_mp() - Convert a single-plane format to its multi-planar 1-plane
> + * equivalent
> + */
> +static int fmt_sp_to_mp(const struct v4l2_format *f_sp,
> +			struct v4l2_format *f_mp)
> +{
> +	struct v4l2_pix_format_mplane *pix_mp = &f_mp->fmt.pix_mp;
> +	const struct v4l2_pix_format *pix = &f_sp->fmt.pix;
> +
> +	if (f_sp->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		f_mp->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	else if (f_sp->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		f_mp->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	else
> +		return -EINVAL;
> +
> +	pix_mp->width = pix->width;
> +	pix_mp->height = pix->height;
> +	pix_mp->pixelformat = pix->pixelformat;
> +	pix_mp->field = pix->field;
> +	pix_mp->colorspace = pix->colorspace;
> +	pix_mp->num_planes = 1;
> +	pix_mp->plane_fmt[0].sizeimage = pix->sizeimage;
> +	pix_mp->plane_fmt[0].bytesperline = pix->bytesperline;
> +
> +	return 0;
> +}
> +
> +/**
> + * fmt_mp_to_sp() - Convert a multi-planar 1-plane format to its single-planar
> + * equivalent
> + */
> +static int fmt_mp_to_sp(const struct v4l2_format *f_mp,
> +			struct v4l2_format *f_sp)
> +{
> +	const struct v4l2_pix_format_mplane *pix_mp = &f_mp->fmt.pix_mp;
> +	struct v4l2_pix_format *pix = &f_sp->fmt.pix;
> +
> +	if (f_mp->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		f_sp->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	else if (f_mp->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		f_sp->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	else
> +		return -EINVAL;
> +
> +	pix->width = pix_mp->width;
> +	pix->height = pix_mp->height;
> +	pix->pixelformat = pix_mp->pixelformat;
> +	pix->field = pix_mp->field;
> +	pix->colorspace = pix_mp->colorspace;
> +	pix->sizeimage = pix_mp->plane_fmt[0].sizeimage;
> +	pix->bytesperline = pix_mp->plane_fmt[0].bytesperline;
> +
> +	return 0;
> +}
> +
>  static long __video_do_ioctl(struct file *file,
>  		unsigned int cmd, void *arg)
>  {
>  	struct video_device *vfd = video_devdata(file);
>  	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
>  	void *fh = file->private_data;
> +	struct v4l2_format f_copy;
>  	long ret = -EINVAL;
>  
>  	if (ops == NULL) {
> @@ -720,6 +822,11 @@ static long __video_do_ioctl(struct file *file,
>  			if (ops->vidioc_enum_fmt_vid_cap)
>  				ret = ops->vidioc_enum_fmt_vid_cap(file, fh, f);
>  			break;
> +		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +			if (ops->vidioc_enum_fmt_vid_cap_mplane)
> +				ret = ops->vidioc_enum_fmt_vid_cap_mplane(file,
> +									fh, f);
> +			break;
>  		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  			if (ops->vidioc_enum_fmt_vid_overlay)
>  				ret = ops->vidioc_enum_fmt_vid_overlay(file,
> @@ -729,6 +836,11 @@ static long __video_do_ioctl(struct file *file,
>  			if (ops->vidioc_enum_fmt_vid_out)
>  				ret = ops->vidioc_enum_fmt_vid_out(file, fh, f);
>  			break;
> +		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +			if (ops->vidioc_enum_fmt_vid_out_mplane)
> +				ret = ops->vidioc_enum_fmt_vid_out_mplane(file,
> +									fh, f);
> +			break;
>  		case V4L2_BUF_TYPE_PRIVATE:
>  			if (ops->vidioc_enum_fmt_type_private)
>  				ret = ops->vidioc_enum_fmt_type_private(file,
> @@ -757,22 +869,79 @@ static long __video_do_ioctl(struct file *file,
>  
>  		switch (f->type) {
>  		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -			if (ops->vidioc_g_fmt_vid_cap)
> +			if (ops->vidioc_g_fmt_vid_cap) {
>  				ret = ops->vidioc_g_fmt_vid_cap(file, fh, f);
> +			} else if (ops->vidioc_g_fmt_vid_cap_mplane) {
> +				if (fmt_sp_to_mp(f, &f_copy))
> +					break;
> +				ret = ops->vidioc_g_fmt_vid_cap_mplane(file, fh,
> +									&f_copy);
> +				/* Driver is currently in multi-planar format,
> +				 * we can't return it in single-planar API*/
> +				if (f_copy.fmt.pix_mp.num_planes > 1) {

Only do this if ret == 0.

> +					ret = -EBUSY;
> +					break;
> +				}
> +
> +				ret = fmt_mp_to_sp(&f_copy, f);

Ditto: 'ret' is overwritten here.

Same happens elsewhere as well.

<snip>

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
