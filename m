Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2165 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaBJJIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:08:45 -0500
Message-ID: <52F896F5.40808@xs4all.nl>
Date: Mon, 10 Feb 2014 10:08:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 2/5] synch videodev2.h headers with kernel SDR API
References: <1391925954-25975-1-git-send-email-crope@iki.fi> <1391925954-25975-3-git-send-email-crope@iki.fi>
In-Reply-To: <1391925954-25975-3-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

I'm not sure if you know this, but to sync with a new kernel you use
'make sync-with-kernel'. Not a problem here, I'll do that anyway once the
SDR API is merged.

Regards,

	Hans

On 02/09/2014 07:05 AM, Antti Palosaari wrote:
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  contrib/freebsd/include/linux/videodev2.h | 16 ++++++++++++++++
>  include/linux/videodev2.h                 | 16 ++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
> index 5c75762..6d49f97 100644
> --- a/contrib/freebsd/include/linux/videodev2.h
> +++ b/contrib/freebsd/include/linux/videodev2.h
> @@ -173,6 +173,7 @@ enum v4l2_buf_type {
>  #endif
>  	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
> +	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
>  	/* Deprecated, do not use */
>  	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>  };
> @@ -193,6 +194,8 @@ enum v4l2_tuner_type {
>  	V4L2_TUNER_RADIO	     = 1,
>  	V4L2_TUNER_ANALOG_TV	     = 2,
>  	V4L2_TUNER_DIGITAL_TV	     = 3,
> +	V4L2_TUNER_ADC               = 4,
> +	V4L2_TUNER_RF                = 5,
>  };
>  
>  enum v4l2_memory {
> @@ -298,6 +301,8 @@ struct v4l2_capability {
>  #define V4L2_CAP_RADIO			0x00040000  /* is a radio device */
>  #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
>  
> +#define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
> +
>  #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
>  #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>  #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
> @@ -1373,6 +1378,7 @@ struct v4l2_modulator {
>  #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
>  #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
>  #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
> +#define V4L2_TUNER_CAP_1HZ		0x1000
>  
>  /*  Flags for the 'rxsubchans' field */
>  #define V4L2_TUNER_SUB_MONO		0x0001
> @@ -1726,6 +1732,15 @@ struct v4l2_pix_format_mplane {
>  } __attribute__ ((packed));
>  
>  /**
> + * struct v4l2_format_sdr - SDR format definition
> + * @pixelformat:	little endian four character code (fourcc)
> + */
> +struct v4l2_format_sdr {
> +	uint32_t				pixelformat;
> +	uint8_t				reserved[28];
> +} __attribute__ ((packed));
> +
> +/**
>   * struct v4l2_format - stream data format
>   * @type:	enum v4l2_buf_type; type of the data stream
>   * @pix:	definition of an image format
> @@ -1743,6 +1758,7 @@ struct v4l2_format {
>  		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
>  		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
>  		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
> +		struct v4l2_format_sdr		sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
>  		uint8_t	raw_data[200];                   /* user-defined */
>  	} fmt;
>  };
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 6ae7bbe..27fedfe 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -139,6 +139,7 @@ enum v4l2_buf_type {
>  #endif
>  	V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
>  	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
> +	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
>  	/* Deprecated, do not use */
>  	V4L2_BUF_TYPE_PRIVATE              = 0x80,
>  };
> @@ -159,6 +160,8 @@ enum v4l2_tuner_type {
>  	V4L2_TUNER_RADIO	     = 1,
>  	V4L2_TUNER_ANALOG_TV	     = 2,
>  	V4L2_TUNER_DIGITAL_TV	     = 3,
> +	V4L2_TUNER_ADC               = 4,
> +	V4L2_TUNER_RF                = 5,
>  };
>  
>  enum v4l2_memory {
> @@ -264,6 +267,8 @@ struct v4l2_capability {
>  #define V4L2_CAP_RADIO			0x00040000  /* is a radio device */
>  #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
>  
> +#define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
> +
>  #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
>  #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>  #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
> @@ -1339,6 +1344,7 @@ struct v4l2_modulator {
>  #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
>  #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
>  #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
> +#define V4L2_TUNER_CAP_1HZ		0x1000
>  
>  /*  Flags for the 'rxsubchans' field */
>  #define V4L2_TUNER_SUB_MONO		0x0001
> @@ -1692,6 +1698,15 @@ struct v4l2_pix_format_mplane {
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
> @@ -1709,6 +1724,7 @@ struct v4l2_format {
>  		struct v4l2_window		win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
>  		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
>  		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
> +		struct v4l2_format_sdr		sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
>  		__u8	raw_data[200];                   /* user-defined */
>  	} fmt;
>  };
> 

