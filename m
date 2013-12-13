Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3856 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3LMOgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 09:36:43 -0500
Message-ID: <52AB1B5F.7090804@xs4all.nl>
Date: Fri, 13 Dec 2013 15:36:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 1/2] v4l2: add stream format for SDR receiver
References: <1386867447-1018-1-git-send-email-crope@iki.fi> <1386867447-1018-2-git-send-email-crope@iki.fi>
In-Reply-To: <1386867447-1018-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2013 05:57 PM, Antti Palosaari wrote:
> Add new V4L2 stream format definition, named V4L2_BUF_TYPE_SDR_RX,
> for SDR receiver.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c |  1 +
>  include/trace/events/v4l2.h          |  1 +
>  include/uapi/linux/videodev2.h       | 11 +++++++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index ee91a9f..5b6e0e8 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -149,6 +149,7 @@ const char *v4l2_type_names[] = {
>  	[V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY] = "vid-out-overlay",
>  	[V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE] = "vid-cap-mplane",
>  	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE] = "vid-out-mplane",
> +	[V4L2_BUF_TYPE_SDR_RX]             = "sdr-rx",

Make this SDR_CAPTURE and sdr-cap to be consistent with existing naming
conventions.

>  };
>  EXPORT_SYMBOL(v4l2_type_names);
>  
> diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
> index ef94eca..d2ddd82 100644
> --- a/include/trace/events/v4l2.h
> +++ b/include/trace/events/v4l2.h
> @@ -18,6 +18,7 @@
>  		{ V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY, "VIDEO_OUTPUT_OVERLAY" },\
>  		{ V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, "VIDEO_CAPTURE_MPLANE" },\
>  		{ V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,  "VIDEO_OUTPUT_MPLANE" }, \
> +		{ V4L2_BUF_TYPE_SDR_RX,               "SDR_RX" }, \

"SDR_CAPTURE"

Regards,

	Hans

>  		{ V4L2_BUF_TYPE_PRIVATE,	      "PRIVATE" })
>  
>  #define show_field(field)						\
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 1bac6c4..694694a 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -139,6 +139,7 @@ enum v4l2_buf_type {
>  #endif
>  	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
> +	V4L2_BUF_TYPE_SDR_RX               = 11,
>  	/* Deprecated, do not use */
>  	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>  };
> @@ -1703,6 +1704,15 @@ struct v4l2_pix_format_mplane {
>  } __attribute__ ((packed));
>  
>  /**
> + * struct v4l2_format_sdr - SDR format definition
> + * @pixelformat:	little endian four character code (fourcc)
> + */
> +struct v4l2_format_sdr {
> +	__u32				pixelformat;
> +	__u8				reserved[28];
> +} __attribute__ ((packed));
> +
> +/**
>   * struct v4l2_format - stream data format
>   * @type:	enum v4l2_buf_type; type of the data stream
>   * @pix:	definition of an image format
> @@ -1720,6 +1730,7 @@ struct v4l2_format {
>  		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
>  		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
>  		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
> +		struct v4l2_format_sdr		sdr;     /* V4L2_BUF_TYPE_SDR_RX */
>  		__u8	raw_data[200];                   /* user-defined */
>  	} fmt;
>  };
> 

