Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:48907 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750903AbdFPPst (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 11:48:49 -0400
Subject: Re: [RFC 1/2] v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com
References: <1497626061-2129-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497626061-2129-2-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8e4c6805-324b-da67-8658-c9251d50b67b@xs4all.nl>
Date: Fri, 16 Jun 2017 17:48:44 +0200
MIME-Version: 1.0
In-Reply-To: <1497626061-2129-2-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2017 05:14 PM, Sakari Ailus wrote:
> The V4L2_BUF_TYPE_META_OUTPUT mirrors the V4L2_BUF_TYPE_META_CAPTURE with
> the exception that it is an OUTPUT type. The use case for this is to pass
> buffers to the device that are not image data but metadata. The formats,
> just as the metadata capture formats, are typically device specific and
> highly structured.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>   drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  2 ++
>   drivers/media/v4l2-core/v4l2-ioctl.c          | 25 +++++++++++++++++++++++++
>   drivers/media/v4l2-core/videobuf2-v4l2.c      |  1 +
>   include/media/v4l2-ioctl.h                    | 17 +++++++++++++++++
>   include/uapi/linux/videodev2.h                |  2 ++
>   5 files changed, 47 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 6f52970..a0360fe 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -232,6 +232,7 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
>   	case V4L2_BUF_TYPE_SDR_OUTPUT:
>   		return get_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
>   	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>   		return get_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
>   	default:
>   		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
> @@ -281,6 +282,7 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
>   	case V4L2_BUF_TYPE_SDR_OUTPUT:
>   		return put_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
>   	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>   		return put_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
>   	default:
>   		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 4f27cfa..30dd814 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -156,6 +156,7 @@ const char *v4l2_type_names[] = {
>   	[V4L2_BUF_TYPE_SDR_CAPTURE]        = "sdr-cap",
>   	[V4L2_BUF_TYPE_SDR_OUTPUT]         = "sdr-out",
>   	[V4L2_BUF_TYPE_META_CAPTURE]       = "meta-cap",
> +	[V4L2_BUF_TYPE_META_OUTPUT]	   = "meta-out",
>   };
>   EXPORT_SYMBOL(v4l2_type_names);
>   
> @@ -328,6 +329,7 @@ static void v4l_print_format(const void *arg, bool write_only)
>   			(sdr->pixelformat >> 24) & 0xff);
>   		break;
>   	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>   		meta = &p->fmt.meta;
>   		pr_cont(", dataformat=%c%c%c%c, buffersize=%u\n",
>   			(meta->dataformat >>  0) & 0xff,
> @@ -958,6 +960,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>   		if (is_vid && is_rx && ops->vidioc_g_fmt_meta_cap)
>   			return 0;
>   		break;
> +	case V4L2_BUF_TYPE_META_OUTPUT:
> +		if (is_vid && is_tx && ops->vidioc_g_fmt_meta_out)
> +			return 0;
> +		break;
>   	default:
>   		break;
>   	}
> @@ -1349,6 +1355,11 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
>   			break;
>   		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
>   		break;
> +	case V4L2_BUF_TYPE_META_OUTPUT:
> +		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_meta_out))
> +			break;
> +		ret = ops->vidioc_enum_fmt_meta_out(file, fh, arg);
> +		break;
>   	}
>   	if (ret == 0)
>   		v4l_fill_fmtdesc(p);
> @@ -1452,6 +1463,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>   		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_meta_cap))
>   			break;
>   		return ops->vidioc_g_fmt_meta_cap(file, fh, arg);
> +	case V4L2_BUF_TYPE_META_OUTPUT:
> +		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_meta_out))
> +			break;
> +		return ops->vidioc_g_fmt_meta_out(file, fh, arg);
>   	}
>   	return -EINVAL;
>   }
> @@ -1562,6 +1577,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>   			break;
>   		CLEAR_AFTER_FIELD(p, fmt.meta);
>   		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
> +	case V4L2_BUF_TYPE_META_OUTPUT:
> +		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_meta_out))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.meta);
> +		return ops->vidioc_s_fmt_meta_out(file, fh, arg);
>   	}
>   	return -EINVAL;
>   }
> @@ -1652,6 +1672,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>   			break;
>   		CLEAR_AFTER_FIELD(p, fmt.meta);
>   		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
> +	case V4L2_BUF_TYPE_META_OUTPUT:
> +		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_meta_out))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.meta);
> +		return ops->vidioc_try_fmt_meta_out(file, fh, arg);
>   	}
>   	return -EINVAL;
>   }
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 0c06699..f17f6d7 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -545,6 +545,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
>   		requested_sizes[0] = f->fmt.sdr.buffersize;
>   		break;
>   	case V4L2_BUF_TYPE_META_CAPTURE:
> +	case V4L2_BUF_TYPE_META_OUTPUT:
>   		requested_sizes[0] = f->fmt.meta.buffersize;
>   		break;
>   	default:
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index bd53121..696bd13 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -47,6 +47,9 @@ struct v4l2_fh;
>    * @vidioc_enum_fmt_meta_cap: pointer to the function that implements
>    *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
>    *	for metadata capture
> + * @vidioc_enum_fmt_meta_out: pointer to the function that implements
> + *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
> + *	for metadata output
>    * @vidioc_g_fmt_vid_cap: pointer to the function that implements
>    *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video capture
>    *	in single plane mode
> @@ -79,6 +82,8 @@ struct v4l2_fh;
>    *	Radio output
>    * @vidioc_g_fmt_meta_cap: pointer to the function that implements
>    *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
> + * @vidioc_g_fmt_meta_out: pointer to the function that implements
> + *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for metadata output
>    * @vidioc_s_fmt_vid_cap: pointer to the function that implements
>    *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video capture
>    *	in single plane mode
> @@ -111,6 +116,8 @@ struct v4l2_fh;
>    *	Radio output
>    * @vidioc_s_fmt_meta_cap: pointer to the function that implements
>    *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
> + * @vidioc_s_fmt_meta_out: pointer to the function that implements
> + *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for metadata output
>    * @vidioc_try_fmt_vid_cap: pointer to the function that implements
>    *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video capture
>    *	in single plane mode
> @@ -145,6 +152,8 @@ struct v4l2_fh;
>    *	Radio output
>    * @vidioc_try_fmt_meta_cap: pointer to the function that implements
>    *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
> + * @vidioc_try_fmt_meta_out: pointer to the function that implements
> + *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for metadata output
>    * @vidioc_reqbufs: pointer to the function that implements
>    *	:ref:`VIDIOC_REQBUFS <vidioc_reqbufs>` ioctl
>    * @vidioc_querybuf: pointer to the function that implements
> @@ -317,6 +326,8 @@ struct v4l2_ioctl_ops {
>   				       struct v4l2_fmtdesc *f);
>   	int (*vidioc_enum_fmt_meta_cap)(struct file *file, void *fh,
>   					struct v4l2_fmtdesc *f);
> +	int (*vidioc_enum_fmt_meta_out)(struct file *file, void *fh,
> +					struct v4l2_fmtdesc *f);
>   
>   	/* VIDIOC_G_FMT handlers */
>   	int (*vidioc_g_fmt_vid_cap)(struct file *file, void *fh,
> @@ -345,6 +356,8 @@ struct v4l2_ioctl_ops {
>   				    struct v4l2_format *f);
>   	int (*vidioc_g_fmt_meta_cap)(struct file *file, void *fh,
>   				     struct v4l2_format *f);
> +	int (*vidioc_g_fmt_meta_out)(struct file *file, void *fh,
> +				     struct v4l2_format *f);
>   
>   	/* VIDIOC_S_FMT handlers */
>   	int (*vidioc_s_fmt_vid_cap)(struct file *file, void *fh,
> @@ -373,6 +386,8 @@ struct v4l2_ioctl_ops {
>   				    struct v4l2_format *f);
>   	int (*vidioc_s_fmt_meta_cap)(struct file *file, void *fh,
>   				     struct v4l2_format *f);
> +	int (*vidioc_s_fmt_meta_out)(struct file *file, void *fh,
> +				     struct v4l2_format *f);
>   
>   	/* VIDIOC_TRY_FMT handlers */
>   	int (*vidioc_try_fmt_vid_cap)(struct file *file, void *fh,
> @@ -401,6 +416,8 @@ struct v4l2_ioctl_ops {
>   				      struct v4l2_format *f);
>   	int (*vidioc_try_fmt_meta_cap)(struct file *file, void *fh,
>   				       struct v4l2_format *f);
> +	int (*vidioc_try_fmt_meta_out)(struct file *file, void *fh,
> +				       struct v4l2_format *f);
>   
>   	/* Buffer handlers */
>   	int (*vidioc_reqbufs)(struct file *file, void *fh,
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2b8feb8..b6c850a 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -144,6 +144,7 @@ enum v4l2_buf_type {
>   	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
>   	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
>   	V4L2_BUF_TYPE_META_CAPTURE         = 13,
> +	V4L2_BUF_TYPE_META_OUTPUT	   = 14,
>   	/* Deprecated, do not use */
>   	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>   };
> @@ -457,6 +458,7 @@ struct v4l2_capability {
>   #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
>   #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>   #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
> +#define V4L2_CAP_META_OUTPUT		0x08000000  /* Is a metadata output device */
>   
>   #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
>   
> 
