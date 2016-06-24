Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45866 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbcFXP5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:57:36 -0400
Subject: Re: [PATCH 01/24] v4l: Add metadata buffer type and format
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1466449842-29502-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fcc32004-82dd-45af-a737-019f81dea8e0@xs4all.nl>
Date: Fri, 24 Jun 2016 17:57:29 +0200
MIME-Version: 1.0
In-Reply-To: <1466449842-29502-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2016 09:10 PM, Laurent Pinchart wrote:
> The metadata buffer type is used to transfer metadata between userspace
> and kernelspace through a V4L2 buffers queue. It comes with a new
> metadata capture capability and format description.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

I am willing to Ack this, provided Sakari and Guennadi Ack this as well. They know
more about metadata handling in various types of hardware than I do, so I feel
their Acks are important here.

Regards,

	Hans

> ---
>  Documentation/DocBook/media/v4l/dev-meta.xml  | 93 +++++++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/v4l2.xml      |  1 +
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 19 ++++++
>  drivers/media/v4l2-core/v4l2-dev.c            | 16 +++--
>  drivers/media/v4l2-core/v4l2-ioctl.c          | 34 ++++++++++
>  drivers/media/v4l2-core/videobuf2-v4l2.c      |  3 +
>  include/media/v4l2-ioctl.h                    |  8 +++
>  include/uapi/linux/videodev2.h                | 14 ++++
>  8 files changed, 182 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/dev-meta.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/dev-meta.xml b/Documentation/DocBook/media/v4l/dev-meta.xml
> new file mode 100644
> index 000000000000..9b5b1fba2007
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/dev-meta.xml
> @@ -0,0 +1,93 @@
> +  <title>Metadata Interface</title>
> +
> +  <note>
> +    <title>Experimental</title>
> +    <para>This is an <link linkend="experimental"> experimental </link>
> +    interface and may change in the future.</para>
> +  </note>
> +
> +  <para>
> +Metadata refers to any non-image data that supplements video frames with
> +additional information. This may include statistics computed over the image
> +or frame capture parameters supplied by the image source. This interface is
> +intended for transfer of metadata to userspace and control of that operation.
> +  </para>
> +
> +  <para>
> +The metadata interface is implemented on video capture devices. The device can
> +be dedicated to metadata or can implement both video and metadata capture as
> +specified in its reported capabilities.
> +  </para>
> +
> +  <section>
> +    <title>Querying Capabilities</title>
> +
> +    <para>
> +Devices supporting the metadata interface set the
> +<constant>V4L2_CAP_META_CAPTURE</constant> flag in the
> +<structfield>capabilities</structfield> field of &v4l2-capability;
> +returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device can capture
> +metadata to memory.
> +    </para>
> +    <para>
> +At least one of the read/write or streaming I/O methods must be supported.
> +    </para>
> +  </section>
> +
> +  <section>
> +    <title>Data Format Negotiation</title>
> +
> +    <para>
> +The metadata device uses the <link linkend="format">format</link> ioctls to
> +select the capture format. The metadata buffer content format is bound to that
> +selectable format. In addition to the basic
> +<link linkend="format">format</link> ioctls, the &VIDIOC-ENUM-FMT; ioctl
> +must be supported as well.
> +    </para>
> +
> +    <para>
> +To use the <link linkend="format">format</link> ioctls applications set the
> +<structfield>type</structfield> field of a &v4l2-format; to
> +<constant>V4L2_BUF_TYPE_META_CAPTURE</constant> and use the &v4l2-meta-format;
> +<structfield>meta</structfield> member of the <structfield>fmt</structfield>
> +union as needed per the desired operation.
> +Currently there are two fields, <structfield>dataformat</structfield> and
> +<structfield>buffersize</structfield>, of struct &v4l2-meta-format; that are
> +used. Content of the <structfield>dataformat</structfield> is the V4L2 FourCC
> +code of the data format. The <structfield>buffersize</structfield> field is the
> +maximum buffer size in bytes required for data transfer, set by the driver in
> +order to inform applications.
> +    </para>
> +
> +    <table pgwide="1" frame="none" id="v4l2-meta-format">
> +      <title>struct <structname>v4l2_meta_format</structname></title>
> +      <tgroup cols="3">
> +        &cs-str;
> +        <tbody valign="top">
> +          <row>
> +            <entry>__u32</entry>
> +            <entry><structfield>dataformat</structfield></entry>
> +            <entry>
> +The data format, set by the application. This is a little endian
> +<link linkend="v4l2-fourcc">four character code</link>.
> +V4L2 defines metadata formats in <xref linkend="meta-formats" />.
> +           </entry>
> +          </row>
> +          <row>
> +            <entry>__u32</entry>
> +            <entry><structfield>buffersize</structfield></entry>
> +            <entry>
> +Maximum size in bytes required for data. Value is set by the driver.
> +           </entry>
> +          </row>
> +          <row>
> +            <entry>__u8</entry>
> +            <entry><structfield>reserved[24]</structfield></entry>
> +            <entry>This array is reserved for future extensions.
> +Drivers and applications must set it to zero.</entry>
> +          </row>
> +        </tbody>
> +      </tgroup>
> +    </table>
> +
> +  </section>
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 42e626d6c936..5c83b5d342dd 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -605,6 +605,7 @@ and discussions on the V4L mailing list.</revremark>
>      <section id="radio"> &sub-dev-radio; </section>
>      <section id="rds"> &sub-dev-rds; </section>
>      <section id="sdr"> &sub-dev-sdr; </section>
> +    <section id="meta"> &sub-dev-meta; </section>
>      <section id="event"> &sub-dev-event; </section>
>      <section id="subdev"> &sub-dev-subdev; </section>
>    </chapter>
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
> index 70b559d7ca80..74b79e60ac38 100644
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
> index 28e5be2c2eef..5d003152ff68 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -155,6 +155,7 @@ const char *v4l2_type_names[] = {
>  	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE] = "vid-out-mplane",
>  	[V4L2_BUF_TYPE_SDR_CAPTURE]        = "sdr-cap",
>  	[V4L2_BUF_TYPE_SDR_OUTPUT]         = "sdr-out",
> +	[V4L2_BUF_TYPE_META_CAPTURE]       = "meta-cap",
>  };
>  EXPORT_SYMBOL(v4l2_type_names);
>  
> @@ -249,6 +250,7 @@ static void v4l_print_format(const void *arg, bool write_only)
>  	const struct v4l2_sliced_vbi_format *sliced;
>  	const struct v4l2_window *win;
>  	const struct v4l2_sdr_format *sdr;
> +	const struct v4l2_meta_format *meta;
>  	unsigned i;
>  
>  	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
> @@ -336,6 +338,15 @@ static void v4l_print_format(const void *arg, bool write_only)
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
> @@ -981,6 +992,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
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
> @@ -1349,6 +1364,11 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
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
> @@ -1447,6 +1467,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
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
> @@ -1534,6 +1558,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_meta_cap))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.meta);
> +		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> @@ -1618,6 +1647,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.sdr);
>  		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
> +	case V4L2_BUF_TYPE_META_CAPTURE:
> +		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_meta_cap))
> +			break;
> +		CLEAR_AFTER_FIELD(p, fmt.meta);
> +		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
>  	}
>  	return -EINVAL;
>  }
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 7f366f1b0377..e4e90d9a3a65 100644
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
> index 017ffb2220c7..2dd00c73e892 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -38,6 +38,8 @@ struct v4l2_ioctl_ops {
>  					    struct v4l2_fmtdesc *f);
>  	int (*vidioc_enum_fmt_sdr_out)     (struct file *file, void *fh,
>  					    struct v4l2_fmtdesc *f);
> +	int (*vidioc_enum_fmt_meta_cap)    (struct file *file, void *fh,
> +					    struct v4l2_fmtdesc *f);
>  
>  	/* VIDIOC_G_FMT handlers */
>  	int (*vidioc_g_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -64,6 +66,8 @@ struct v4l2_ioctl_ops {
>  					struct v4l2_format *f);
>  	int (*vidioc_g_fmt_sdr_out)    (struct file *file, void *fh,
>  					struct v4l2_format *f);
> +	int (*vidioc_g_fmt_meta_cap)   (struct file *file, void *fh,
> +					struct v4l2_format *f);
>  
>  	/* VIDIOC_S_FMT handlers */
>  	int (*vidioc_s_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -90,6 +94,8 @@ struct v4l2_ioctl_ops {
>  					struct v4l2_format *f);
>  	int (*vidioc_s_fmt_sdr_out)    (struct file *file, void *fh,
>  					struct v4l2_format *f);
> +	int (*vidioc_s_fmt_meta_cap)   (struct file *file, void *fh,
> +					struct v4l2_format *f);
>  
>  	/* VIDIOC_TRY_FMT handlers */
>  	int (*vidioc_try_fmt_vid_cap)    (struct file *file, void *fh,
> @@ -116,6 +122,8 @@ struct v4l2_ioctl_ops {
>  					  struct v4l2_format *f);
>  	int (*vidioc_try_fmt_sdr_out)    (struct file *file, void *fh,
>  					  struct v4l2_format *f);
> +	int (*vidioc_try_fmt_meta_cap)   (struct file *file, void *fh,
> +					  struct v4l2_format *f);
>  
>  	/* Buffer handlers */
>  	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 8f951917be74..5fbd30ca9b1e 100644
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
> @@ -2000,6 +2002,17 @@ struct v4l2_sdr_format {
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
> @@ -2018,6 +2031,7 @@ struct v4l2_format {
>  		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
>  		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
>  		struct v4l2_sdr_format		sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
> +		struct v4l2_meta_format		meta;    /* V4L2_BUF_TYPE_META_CAPTURE */
>  		__u8	raw_data[200];                   /* user-defined */
>  	} fmt;
>  };
> 
