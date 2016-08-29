Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47980 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756027AbcH2JNr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 05:13:47 -0400
Date: Mon, 29 Aug 2016 12:13:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 1/4] v4l: Add metadata buffer type and format
Message-ID: <20160829091339.GN12130@valkosipuli.retiisi.org.uk>
References: <1471436430-26245-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1471436430-26245-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471436430-26245-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patchset!

On Wed, Aug 17, 2016 at 03:20:27PM +0300, Laurent Pinchart wrote:
> The metadata buffer type is used to transfer metadata between userspace
> and kernelspace through a V4L2 buffers queue. It comes with a new
> metadata capture capability and format description.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
> Changes since v1:
> 
> - Rebased on top of the DocBook to reST conversion
> 
>  Documentation/media/uapi/v4l/buffer.rst          |  8 +++
>  Documentation/media/uapi/v4l/dev-meta.rst        | 69 ++++++++++++++++++++++++
>  Documentation/media/uapi/v4l/devices.rst         |  1 +
>  Documentation/media/uapi/v4l/vidioc-querycap.rst | 14 +++--
>  Documentation/media/videodev2.h.rst.exceptions   |  2 +
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c    | 19 +++++++
>  drivers/media/v4l2-core/v4l2-dev.c               | 16 +++---
>  drivers/media/v4l2-core/v4l2-ioctl.c             | 41 ++++++++++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c         |  3 ++
>  include/media/v4l2-ioctl.h                       | 17 ++++++
>  include/uapi/linux/videodev2.h                   | 14 +++++
>  11 files changed, 195 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
> 
> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> index 5deb4a46f992..b5177cc63b86 100644
> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst
> @@ -499,6 +499,14 @@ enum v4l2_buf_type
>         -  Buffer for Software Defined Radio (SDR) output stream, see
>  	  :ref:`sdr`.
>  
> +    -  .. row 13
> +
> +       -  ``V4L2_BUF_TYPE_META_CAPTURE``
> +
> +       -  13
> +
> +       -  Buffer for metadata capture, see :ref:`metadata`.
> +
>  
>  
>  .. _buffer-flags:
> diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
> new file mode 100644
> index 000000000000..252ed05b4841
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-meta.rst
> @@ -0,0 +1,69 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _metadata:
> +
> +******************
> +Metadata Interface
> +******************
> +
> +Metadata refers to any non-image data that supplements video frames with
> +additional information. This may include statistics computed over the image
> +or frame capture parameters supplied by the image source. This interface is
> +intended for transfer of metadata to userspace and control of that operation.
> +
> +The metadata interface is implemented on video capture device nodes. The device
> +can be dedicated to metadata or can implement both video and metadata capture
> +as specified in its reported capabilities.
> +
> +.. note::
> +
> +    This is an :ref:`experimental` interface and may
> +    change in the future.
> +
> +Querying Capabilities
> +=====================
> +
> +Device nodes supporting the metadata interface set the ``V4L2_CAP_META_CAPTURE``
> +flag in the ``device_caps`` field of the
> +:ref:`v4l2_capability <v4l2-capability>` structure returned by the
> +:ref:`VIDIOC_QUERYCAP` ioctl. That flag means the device can capture
> +metadata to memory.
> +
> +At least one of the read/write or streaming I/O methods must be supported.
> +
> +
> +Data Format Negotiation
> +=======================
> +
> +The metadata device uses the :ref:`format` ioctls to select the capture format.
> +The metadata buffer content format is bound to that selected format. In addition
> +to the basic :ref:`format` ioctls, the :ref:`VIDIOC_ENUM_FMT` ioctl must be
> +supported as well.
> +
> +To use the :ref:`format` ioctls applications set the ``type`` of the
> +:ref:`v4l2_format <v4l2-format>` structure to ``V4L2_BUF_TYPE_META_CAPTURE``
> +and use the :ref:`v4l2_meta_format <v4l2-meta-format>` ``meta`` member of the
> +``fmt`` union as needed per the desired operation. The :ref:`v4l2-meta-format`
> +structure contains two fields, ``dataformat`` is set by applications to the V4L2

I might not specify the number of number of fields here. It has high chances
of not getting updated when more fields are added. Up to you.

> +FourCC code of the desired format, and ``buffersize`` set by drivers to the
> +maximum buffer size (in bytes) required for data transfer.
> +
> +.. _v4l2-meta-format:
> +.. flat-table:: struct v4l2_meta_format
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u32
> +      - ``dataformat``
> +      - The data format, set by the application. This is a little endian
> +        :ref:`four character code <v4l2-fourcc>`. V4L2 defines metadata formats
> +        in :ref:`meta-formats`.
> +    * - __u32
> +      - ``buffersize``
> +      - Maximum buffer size in bytes required for data. The value is set by the
> +        driver.

We'll need to add width and heigth as well but it could be done later on.

> +    * - __u8
> +      - ``reserved[24]``
> +      - This array is reserved for future extensions. Drivers and applications
> +        must set it to zero.

struct v4l2_pix_format has grown without use of reserved fields and it's
been around for ages.

It's not directly used in an IOCTL but within an union in another struct so
this is possible. I would consider doing the same here. Or at least
increasing the number of reserved fields (and possibly making the type u32)
if you feel we shouldn't go that way.

> diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
> index aed0ce11d1f8..961e7fb62063 100644
> --- a/Documentation/media/uapi/v4l/devices.rst
> +++ b/Documentation/media/uapi/v4l/devices.rst
> @@ -24,3 +24,4 @@ Interfaces
>      dev-sdr
>      dev-event
>      dev-subdev
> +    dev-meta
> diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> index b10fed313f99..734fae6fc5e4 100644
> --- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
> @@ -387,6 +387,14 @@ specification the ioctl returns an ``EINVAL`` error code.
>  
>      -  .. row 23
>  
> +       -  ``V4L2_CAP_META_CAPTURE``
> +
> +       -  0x00800000
> +
> +       -  The device supports the :ref:`metadata` capture interface.
> +
> +    -  .. row 24
> +
>         -  ``V4L2_CAP_READWRITE``
>  
>         -  0x01000000
> @@ -394,7 +402,7 @@ specification the ioctl returns an ``EINVAL`` error code.
>         -  The device supports the :ref:`read() <rw>` and/or
>  	  :ref:`write() <rw>` I/O methods.
>  
> -    -  .. row 24
> +    -  .. row 25
>  
>         -  ``V4L2_CAP_ASYNCIO``
>  
> @@ -402,7 +410,7 @@ specification the ioctl returns an ``EINVAL`` error code.
>  
>         -  The device supports the :ref:`asynchronous <async>` I/O methods.
>  
> -    -  .. row 25
> +    -  .. row 26
>  
>         -  ``V4L2_CAP_STREAMING``
>  
> @@ -410,7 +418,7 @@ specification the ioctl returns an ``EINVAL`` error code.
>  
>         -  The device supports the :ref:`streaming <mmap>` I/O method.
>  
> -    -  .. row 26
> +    -  .. row 27
>  
>         -  ``V4L2_CAP_DEVICE_CAPS``
>  
> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
> index 9bb9a6cc39d8..d1275725d367 100644
> --- a/Documentation/media/videodev2.h.rst.exceptions
> +++ b/Documentation/media/videodev2.h.rst.exceptions
> @@ -27,6 +27,7 @@ replace symbol V4L2_FIELD_SEQ_TB v4l2-field
>  replace symbol V4L2_FIELD_TOP v4l2-field
>  
>  # Documented enum v4l2_buf_type
> +replace symbol V4L2_BUF_TYPE_META_CAPTURE v4l2-buf-type
>  replace symbol V4L2_BUF_TYPE_SDR_CAPTURE v4l2-buf-type
>  replace symbol V4L2_BUF_TYPE_SDR_OUTPUT v4l2-buf-type
>  replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE v4l2-buf-type
> @@ -148,6 +149,7 @@ replace define V4L2_CAP_MODULATOR device-capabilities
>  replace define V4L2_CAP_SDR_CAPTURE device-capabilities
>  replace define V4L2_CAP_EXT_PIX_FORMAT device-capabilities
>  replace define V4L2_CAP_SDR_OUTPUT device-capabilities
> +replace define V4L2_CAP_META_CAPTURE device-capabilities
>  replace define V4L2_CAP_READWRITE device-capabilities
>  replace define V4L2_CAP_ASYNCIO device-capabilities
>  replace define V4L2_CAP_STREAMING device-capabilities
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index bacecbd68a6d..da2d836e8887 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -161,6 +161,20 @@ static inline int put_v4l2_sdr_format(struct v4l2_sdr_format *kp, struct v4l2_sd
>  	return 0;
>  }
>  
> +static inline int get_v4l2_meta_format(struct v4l2_meta_format *kp, struct v4l2_meta_format __user *up)
> +{
> +	if (copy_from_user(kp, up, sizeof(struct v4l2_meta_format)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static inline int put_v4l2_meta_format(struct v4l2_meta_format *kp, struct v4l2_meta_format __user *up)
> +{
> +	if (copy_to_user(up, kp, sizeof(struct v4l2_meta_format)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  struct v4l2_format32 {
>  	__u32	type;	/* enum v4l2_buf_type */
>  	union {
> @@ -170,6 +184,7 @@ struct v4l2_format32 {
>  		struct v4l2_vbi_format	vbi;
>  		struct v4l2_sliced_vbi_format	sliced;
>  		struct v4l2_sdr_format	sdr;
> +		struct v4l2_meta_format	meta;
>  		__u8	raw_data[200];        /* user-defined */
>  	} fmt;
>  };
> @@ -216,6 +231,8 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
>  		return get_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		return get_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
>  	default:
>  		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
>  								kp->type);
> @@ -263,6 +280,8 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
>  		return put_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		return put_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
>  	default:
>  		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
>  								kp->type);
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index e6da353b39bc..70af31210cd3 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -574,30 +574,34 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
>  
>  	if (is_vid) {
> -		/* video specific ioctls */
> +		/* video and metadata specific ioctls */
>  		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
>  			       ops->vidioc_enum_fmt_vid_cap_mplane ||
> -			       ops->vidioc_enum_fmt_vid_overlay)) ||
> +			       ops->vidioc_enum_fmt_vid_overlay ||
> +			       ops->vidioc_enum_fmt_meta_cap)) ||
>  		    (is_tx && (ops->vidioc_enum_fmt_vid_out ||
>  			       ops->vidioc_enum_fmt_vid_out_mplane)))
>  			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
>  		if ((is_rx && (ops->vidioc_g_fmt_vid_cap ||
>  			       ops->vidioc_g_fmt_vid_cap_mplane ||
> -			       ops->vidioc_g_fmt_vid_overlay)) ||
> +			       ops->vidioc_g_fmt_vid_overlay ||
> +			       ops->vidioc_g_fmt_meta_cap)) ||
>  		    (is_tx && (ops->vidioc_g_fmt_vid_out ||
>  			       ops->vidioc_g_fmt_vid_out_mplane ||
>  			       ops->vidioc_g_fmt_vid_out_overlay)))
>  			 set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
>  		if ((is_rx && (ops->vidioc_s_fmt_vid_cap ||
>  			       ops->vidioc_s_fmt_vid_cap_mplane ||
> -			       ops->vidioc_s_fmt_vid_overlay)) ||
> +			       ops->vidioc_s_fmt_vid_overlay ||
> +			       ops->vidioc_s_fmt_meta_cap)) ||
>  		    (is_tx && (ops->vidioc_s_fmt_vid_out ||
>  			       ops->vidioc_s_fmt_vid_out_mplane ||
>  			       ops->vidioc_s_fmt_vid_out_overlay)))
>  			 set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
>  		if ((is_rx && (ops->vidioc_try_fmt_vid_cap ||
>  			       ops->vidioc_try_fmt_vid_cap_mplane ||
> -			       ops->vidioc_try_fmt_vid_overlay)) ||
> +			       ops->vidioc_try_fmt_vid_overlay ||
> +			       ops->vidioc_try_fmt_meta_cap)) ||
>  		    (is_tx && (ops->vidioc_try_fmt_vid_out ||
>  			       ops->vidioc_try_fmt_vid_out_mplane ||
>  			       ops->vidioc_try_fmt_vid_out_overlay)))
> @@ -663,7 +667,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  	}
>  
>  	if (is_vid || is_vbi || is_sdr) {
> -		/* ioctls valid for video, vbi or sdr */
> +		/* ioctls valid for video, metadata, vbi or sdr */
>  		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
>  		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
>  		SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 51a0fa144392..0afa07bfea35 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -37,6 +37,13 @@
>  	memset((u8 *)(p) + offsetof(typeof(*(p)), field) + sizeof((p)->field), \
>  	0, sizeof(*(p)) - offsetof(typeof(*(p)), field) - sizeof((p)->field))
>  
> +/* Zero out the end of the struct pointed to by p.  Everything including and
> + * after thee specified field is cleared.
> + */
> +#define CLEAR_FROM_FIELD(p, field) \
> +	memset((u8 *)(p) + offsetof(typeof(*(p)), field), \
> +	0, sizeof(*(p)) - offsetof(typeof(*(p)), field))
> +
>  #define is_valid_ioctl(vfd, cmd) test_bit(_IOC_NR(cmd), (vfd)->valid_ioctls)
>  
>  struct std_descr {
> @@ -155,6 +162,7 @@ const char *v4l2_type_names[] = {
>  	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE] = "vid-out-mplane",
>  	[V4L2_BUF_TYPE_SDR_CAPTURE]        = "sdr-cap",
>  	[V4L2_BUF_TYPE_SDR_OUTPUT]         = "sdr-out",
> +	[V4L2_BUF_TYPE_META_CAPTURE]       = "meta-cap",
>  };
>  EXPORT_SYMBOL(v4l2_type_names);
>  
> @@ -249,6 +257,7 @@ static void v4l_print_format(const void *arg, bool write_only)
>  	const struct v4l2_sliced_vbi_format *sliced;
>  	const struct v4l2_window *win;
>  	const struct v4l2_sdr_format *sdr;
> +	const struct v4l2_meta_format *meta;
>  	unsigned i;
>  
>  	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
> @@ -336,6 +345,15 @@ static void v4l_print_format(const void *arg, bool write_only)
>  			(sdr->pixelformat >> 16) & 0xff,
>  			(sdr->pixelformat >> 24) & 0xff);
>  		break;
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		meta = &p->fmt.meta;
> +		pr_cont(", dataformat=%c%c%c%c, buffersize=%u\n",
> +			(meta->dataformat >>  0) & 0xff,
> +			(meta->dataformat >>  8) & 0xff,
> +			(meta->dataformat >> 16) & 0xff,
> +			(meta->dataformat >> 24) & 0xff,
> +			meta->buffersize);
> +		break;
>  	}
>  }
>  
> @@ -981,6 +999,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
>  		if (is_sdr && is_tx && ops->vidioc_g_fmt_sdr_out)
>  			return 0;
>  		break;
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		if (is_vid && is_rx && ops->vidioc_g_fmt_meta_cap)
> +			return 0;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -1349,6 +1371,11 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
>  		break;
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_meta_cap))
> +			break;
> +		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
> +		break;
>  	}
>  	if (ret == 0)
>  		v4l_fill_fmtdesc(p);
> @@ -1447,6 +1474,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_g_fmt_sdr_out))
>  			break;
>  		return ops->vidioc_g_fmt_sdr_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_meta_cap))
> +			break;
> +		return ops->vidioc_g_fmt_meta_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> @@ -1534,6 +1565,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_meta_cap))
> +			break;
> +		CLEAR_FROM_FIELD(p, fmt.meta.reserved);
> +		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> @@ -1618,6 +1654,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_meta_cap))
> +			break;
> +		CLEAR_FROM_FIELD(p, fmt.meta.reserved);
> +		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 9cfbb6e4bc28..7216668d1056 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -575,6 +575,9 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
>  		requested_sizes[0] = f->fmt.sdr.buffersize;
>  		break;
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		requested_sizes[0] = f->fmt.meta.buffersize;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 8b1d19bc9b0e..a32dcf78d4a3 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -43,6 +43,9 @@ struct v4l2_fh;
>   * @vidioc_enum_fmt_sdr_out: pointer to the function that implements
>   *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
>   *	for Software Defined Radio output
> + * @vidioc_enum_fmt_meta_cap: pointer to the function that implements
> + *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
> + *	for metadata capture
>   * @vidioc_g_fmt_vid_cap: pointer to the function that implements
>   *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video capture
>   *	in single plane mode
> @@ -73,6 +76,8 @@ struct v4l2_fh;
>   * @vidioc_g_fmt_sdr_out: pointer to the function that implements
>   *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
>   *	Radio output
> + * @vidioc_g_fmt_meta_cap: pointer to the function that implements
> + *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
>   * @vidioc_s_fmt_vid_cap: pointer to the function that implements
>   *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video capture
>   *	in single plane mode
> @@ -103,6 +108,8 @@ struct v4l2_fh;
>   * @vidioc_s_fmt_sdr_out: pointer to the function that implements
>   *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
>   *	Radio output
> + * @vidioc_s_fmt_meta_cap: pointer to the function that implements
> + *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
>   * @vidioc_try_fmt_vid_cap: pointer to the function that implements
>   *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video capture
>   *	in single plane mode
> @@ -135,6 +142,8 @@ struct v4l2_fh;
>   * @vidioc_try_fmt_sdr_out: pointer to the function that implements
>   *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
>   *	Radio output
> + * @vidioc_try_fmt_meta_cap: pointer to the function that implements
> + *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
>   * @vidioc_reqbufs: pointer to the function that implements
>   *	:ref:`VIDIOC_REQBUFS <vidioc_reqbufs>` ioctl
>   * @vidioc_querybuf: pointer to the function that implements
> @@ -304,6 +313,8 @@ struct v4l2_ioctl_ops {
>  					    struct v4l2_fmtdesc *f);
>  	int (*vidioc_enum_fmt_sdr_out)     (struct file *file, void *fh,
>  					    struct v4l2_fmtdesc *f);
> +	int (*vidioc_enum_fmt_meta_cap)    (struct file *file, void *fh,
> +					    struct v4l2_fmtdesc *f);
>  
>  	/* VIDIOC_G_FMT handlers */
>  	int (*vidioc_g_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -330,6 +341,8 @@ struct v4l2_ioctl_ops {
>  					struct v4l2_format *f);
>  	int (*vidioc_g_fmt_sdr_out)    (struct file *file, void *fh,
>  					struct v4l2_format *f);
> +	int (*vidioc_g_fmt_meta_cap)   (struct file *file, void *fh,
> +					struct v4l2_format *f);
>  
>  	/* VIDIOC_S_FMT handlers */
>  	int (*vidioc_s_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -356,6 +369,8 @@ struct v4l2_ioctl_ops {
>  					struct v4l2_format *f);
>  	int (*vidioc_s_fmt_sdr_out)    (struct file *file, void *fh,
>  					struct v4l2_format *f);
> +	int (*vidioc_s_fmt_meta_cap)   (struct file *file, void *fh,
> +					struct v4l2_format *f);
>  
>  	/* VIDIOC_TRY_FMT handlers */
>  	int (*vidioc_try_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -382,6 +397,8 @@ struct v4l2_ioctl_ops {
>  					  struct v4l2_format *f);
>  	int (*vidioc_try_fmt_sdr_out)    (struct file *file, void *fh,
>  					  struct v4l2_format *f);
> +	int (*vidioc_try_fmt_meta_cap)   (struct file *file, void *fh,
> +					  struct v4l2_format *f);
>  
>  	/* Buffer handlers */
>  	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 724f43e69d03..d1ac0250a966 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -143,6 +143,7 @@ enum v4l2_buf_type {
>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
>  	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
>  	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
> +	V4L2_BUF_TYPE_META_CAPTURE         = 13,
>  	/* Deprecated, do not use */
>  	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>  };
> @@ -435,6 +436,7 @@ struct v4l2_capability {
>  #define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
>  #define V4L2_CAP_EXT_PIX_FORMAT		0x00200000  /* Supports the extended pixel format */
>  #define V4L2_CAP_SDR_OUTPUT		0x00400000  /* Is a SDR output device */
> +#define V4L2_CAP_META_CAPTURE		0x00800000  /* Is a metadata capture device */
>  
>  #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
>  #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
> @@ -2002,6 +2004,17 @@ struct v4l2_sdr_format {
>  } __attribute__ ((packed));
>  
>  /**
> + * struct v4l2_meta_format - metadata format definition
> + * @dataformat:		little endian four character code (fourcc)
> + * @buffersize:		maximum size in bytes required for data
> + */
> +struct v4l2_meta_format {
> +	__u32				dataformat;
> +	__u32				buffersize;
> +	__u8				reserved[24];
> +} __attribute__ ((packed));
> +
> +/**
>   * struct v4l2_format - stream data format
>   * @type:	enum v4l2_buf_type; type of the data stream
>   * @pix:	definition of an image format
> @@ -2020,6 +2033,7 @@ struct v4l2_format {
>  		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
>  		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
>  		struct v4l2_sdr_format		sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
> +		struct v4l2_meta_format		meta;    /* V4L2_BUF_TYPE_META_CAPTURE */
>  		__u8	raw_data[200];                   /* user-defined */
>  	} fmt;
>  };

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
