Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:39356 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbbFHJKT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 05:10:19 -0400
Message-ID: <55755BF4.2060100@xs4all.nl>
Date: Mon, 08 Jun 2015 11:10:12 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/9] v4l2: add support for SDR transmitter
References: <1433592188-31748-1-git-send-email-crope@iki.fi> <1433592188-31748-4-git-send-email-crope@iki.fi>
In-Reply-To: <1433592188-31748-4-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 02:03 PM, Antti Palosaari wrote:
> New IOCTL ops:
> vidioc_enum_fmt_sdr_out
> vidioc_g_fmt_sdr_out
> vidioc_s_fmt_sdr_out
> vidioc_try_fmt_sdr_out
> 
> New vb2 buffertype:
> V4L2_BUF_TYPE_SDR_OUTPUT
> 
> New v4l2 capability:
> V4L2_CAP_SDR_OUTPUT
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>


> ---
>  drivers/media/v4l2-core/v4l2-dev.c      | 14 ++++++++++++--
>  drivers/media/v4l2-core/v4l2-ioctl.c    | 25 +++++++++++++++++++++++++
>  drivers/media/v4l2-core/videobuf-core.c |  4 +++-
>  include/media/v4l2-ioctl.h              |  8 ++++++++
>  include/trace/events/v4l2.h             |  1 +
>  include/uapi/linux/videodev2.h          |  5 ++++-
>  6 files changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 71a1b93..6b1eaed 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -637,8 +637,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  			       ops->vidioc_try_fmt_sliced_vbi_out)))
>  			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
>  		SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
> -	} else if (is_sdr) {
> -		/* SDR specific ioctls */
> +	} else if (is_sdr && is_rx) {
> +		/* SDR receiver specific ioctls */
>  		if (ops->vidioc_enum_fmt_sdr_cap)
>  			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
>  		if (ops->vidioc_g_fmt_sdr_cap)
> @@ -647,6 +647,16 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
>  		if (ops->vidioc_try_fmt_sdr_cap)
>  			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
> +	} else if (is_sdr && is_tx) {
> +		/* SDR transmitter specific ioctls */
> +		if (ops->vidioc_enum_fmt_sdr_out)
> +			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
> +		if (ops->vidioc_g_fmt_sdr_out)
> +			set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
> +		if (ops->vidioc_s_fmt_sdr_out)
> +			set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
> +		if (ops->vidioc_try_fmt_sdr_out)
> +			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
>  	}
>  
>  	if (is_vid || is_vbi || is_sdr) {
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index ef42474..21e9598 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -154,6 +154,7 @@ const char *v4l2_type_names[] = {
>  	[V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE] = "vid-cap-mplane",
>  	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE] = "vid-out-mplane",
>  	[V4L2_BUF_TYPE_SDR_CAPTURE]        = "sdr-cap",
> +	[V4L2_BUF_TYPE_SDR_OUTPUT]         = "sdr-out",
>  };
>  EXPORT_SYMBOL(v4l2_type_names);
>  
> @@ -327,6 +328,7 @@ static void v4l_print_format(const void *arg, bool write_only)
>  				sliced->service_lines[1][i]);
>  		break;
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
> +	case V4L2_BUF_TYPE_SDR_OUTPUT:
>  		sdr = &p->fmt.sdr;
>  		pr_cont(", pixelformat=%c%c%c%c\n",
>  			(sdr->pixelformat >>  0) & 0xff,
> @@ -975,6 +977,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>  		if (is_sdr && is_rx && ops->vidioc_g_fmt_sdr_cap)
>  			return 0;
>  		break;
> +	case V4L2_BUF_TYPE_SDR_OUTPUT:
> +		if (is_sdr && is_tx && ops->vidioc_g_fmt_sdr_out)
> +			return 0;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -1324,6 +1330,11 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		ret = ops->vidioc_enum_fmt_sdr_cap(file, fh, arg);
>  		break;
> +	case V4L2_BUF_TYPE_SDR_OUTPUT:
> +		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_enum_fmt_sdr_out))
> +			break;
> +		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
> +		break;
>  	}
>  	if (ret == 0)
>  		v4l_fill_fmtdesc(p);
> @@ -1418,6 +1429,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!is_rx || !is_sdr || !ops->vidioc_g_fmt_sdr_cap))
>  			break;
>  		return ops->vidioc_g_fmt_sdr_cap(file, fh, arg);
> +	case V4L2_BUF_TYPE_SDR_OUTPUT:
> +		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_g_fmt_sdr_out))
> +			break;
> +		return ops->vidioc_g_fmt_sdr_out(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> @@ -1497,6 +1512,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_s_fmt_sdr_cap(file, fh, arg);
> +	case V4L2_BUF_TYPE_SDR_OUTPUT:
> +		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_s_fmt_sdr_out))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.sdr);
> +		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> @@ -1576,6 +1596,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_try_fmt_sdr_cap(file, fh, arg);
> +	case V4L2_BUF_TYPE_SDR_OUTPUT:
> +		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_try_fmt_sdr_out))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.sdr);
> +		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
> index 926836d..6c02989 100644
> --- a/drivers/media/v4l2-core/videobuf-core.c
> +++ b/drivers/media/v4l2-core/videobuf-core.c
> @@ -576,7 +576,8 @@ int videobuf_qbuf(struct videobuf_queue *q, struct v4l2_buffer *b)
>  		}
>  		if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT
>  		    || q->type == V4L2_BUF_TYPE_VBI_OUTPUT
> -		    || q->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
> +		    || q->type == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT
> +		    || q->type == V4L2_BUF_TYPE_SDR_OUTPUT) {
>  			buf->size = b->bytesused;
>  			buf->field = b->field;
>  			buf->ts = b->timestamp;
> @@ -1154,6 +1155,7 @@ unsigned int videobuf_poll_stream(struct file *file,
>  			case V4L2_BUF_TYPE_VIDEO_OUTPUT:
>  			case V4L2_BUF_TYPE_VBI_OUTPUT:
>  			case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> +			case V4L2_BUF_TYPE_SDR_OUTPUT:
>  				rc = POLLOUT | POLLWRNORM;
>  				break;
>  			default:
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 8fbbd76..017ffb2 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -36,6 +36,8 @@ struct v4l2_ioctl_ops {
>  					      struct v4l2_fmtdesc *f);
>  	int (*vidioc_enum_fmt_sdr_cap)     (struct file *file, void *fh,
>  					    struct v4l2_fmtdesc *f);
> +	int (*vidioc_enum_fmt_sdr_out)     (struct file *file, void *fh,
> +					    struct v4l2_fmtdesc *f);
>  
>  	/* VIDIOC_G_FMT handlers */
>  	int (*vidioc_g_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -60,6 +62,8 @@ struct v4l2_ioctl_ops {
>  					   struct v4l2_format *f);
>  	int (*vidioc_g_fmt_sdr_cap)    (struct file *file, void *fh,
>  					struct v4l2_format *f);
> +	int (*vidioc_g_fmt_sdr_out)    (struct file *file, void *fh,
> +					struct v4l2_format *f);
>  
>  	/* VIDIOC_S_FMT handlers */
>  	int (*vidioc_s_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -84,6 +88,8 @@ struct v4l2_ioctl_ops {
>  					   struct v4l2_format *f);
>  	int (*vidioc_s_fmt_sdr_cap)    (struct file *file, void *fh,
>  					struct v4l2_format *f);
> +	int (*vidioc_s_fmt_sdr_out)    (struct file *file, void *fh,
> +					struct v4l2_format *f);
>  
>  	/* VIDIOC_TRY_FMT handlers */
>  	int (*vidioc_try_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -108,6 +114,8 @@ struct v4l2_ioctl_ops {
>  					     struct v4l2_format *f);
>  	int (*vidioc_try_fmt_sdr_cap)    (struct file *file, void *fh,
>  					  struct v4l2_format *f);
> +	int (*vidioc_try_fmt_sdr_out)    (struct file *file, void *fh,
> +					  struct v4l2_format *f);
>  
>  	/* Buffer handlers */
>  	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
> index 89d0497..29d64e4 100644
> --- a/include/trace/events/v4l2.h
> +++ b/include/trace/events/v4l2.h
> @@ -27,6 +27,7 @@
>  	EM( V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, "VIDEO_CAPTURE_MPLANE" ) \
>  	EM( V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,  "VIDEO_OUTPUT_MPLANE" )	\
>  	EM( V4L2_BUF_TYPE_SDR_CAPTURE,          "SDR_CAPTURE" )		\
> +	EM( V4L2_BUF_TYPE_SDR_OUTPUT,           "SDR_OUTPUT" )		\
>  	EMe(V4L2_BUF_TYPE_PRIVATE,		"PRIVATE" )
>  
>  SHOW_TYPE
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 3310ce4..db52dc3 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -145,6 +145,7 @@ enum v4l2_buf_type {
>  	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
>  	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
> +	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
>  	/* Deprecated, do not use */
>  	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>  };
> @@ -159,7 +160,8 @@ enum v4l2_buf_type {
>  	 || (type) == V4L2_BUF_TYPE_VIDEO_OVERLAY		\
>  	 || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY	\
>  	 || (type) == V4L2_BUF_TYPE_VBI_OUTPUT			\
> -	 || (type) == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT)
> +	 || (type) == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT		\
> +	 || (type) == V4L2_BUF_TYPE_SDR_OUTPUT)
>  
>  enum v4l2_tuner_type {
>  	V4L2_TUNER_RADIO	     = 1,
> @@ -426,6 +428,7 @@ struct v4l2_capability {
>  
>  #define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
>  #define V4L2_CAP_EXT_PIX_FORMAT		0x00200000  /* Supports the extended pixel format */
> +#define V4L2_CAP_SDR_OUTPUT		0x00400000  /* Is a SDR output device */
>  
>  #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
>  #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
> 

