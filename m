Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbcCLKuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2016 05:50:06 -0500
Subject: Re: [v4l-utils PATCHv2] libv4lconvert: Add support for
 V4L2_PIX_FMT_{NV16,NV61}
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
References: <56E332A8.2080004@xs4all.nl>
 <1457743505-7161-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <56E3F458.4000400@redhat.com>
Date: Sat, 12 Mar 2016 11:50:00 +0100
MIME-Version: 1.0
In-Reply-To: <1457743505-7161-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12-03-16 01:45, Niklas Söderlund wrote:
> NV16 and NV61 are two-plane versions of the YUV 4:2:2 formats YUYV and
> YVYU. Support both formats by merging the two planes into a one and
> falling through to the V4L2_PIX_FMT_{YUYV,YVYU} code path.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>
> I'm sorry this is a bit of a hack. The support for NV16 are scarce and
> this allowed me use it in qv4l2 so I thought it might help someone else.
> I'm not to sure about the entry in supported_src_pixfmts[] is it correct
> to set 'needs conversion' for my use case?

needs_conversion is set on formats which apps are unlikely to support
natively, so yes it is correct to set it.

Patch looks good to me:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Hans Verkuil, if you're happy with this version feel free to push it.

Regards,

Hans



>
> Changes since v1
> - Add NV61 support
> - Fixed s/YUVU/YUYV/g in commit message
>
>
>   lib/libv4lconvert/libv4lconvert-priv.h |  3 +++
>   lib/libv4lconvert/libv4lconvert.c      | 31 +++++++++++++++++++++++++++++++
>   lib/libv4lconvert/rgbyuv.c             | 15 +++++++++++++++
>   3 files changed, 49 insertions(+)
>
> diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
> index b77e3d3..1740efc 100644
> --- a/lib/libv4lconvert/libv4lconvert-priv.h
> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
> @@ -129,6 +129,9 @@ void v4lconvert_yuyv_to_bgr24(const unsigned char *src, unsigned char *dst,
>   void v4lconvert_yuyv_to_yuv420(const unsigned char *src, unsigned char *dst,
>   		int width, int height, int stride, int yvu);
>
> +void v4lconvert_nv16_to_yuyv(const unsigned char *src, unsigned char *dest,
> +		int width, int height);
> +
>   void v4lconvert_yvyu_to_rgb24(const unsigned char *src, unsigned char *dst,
>   		int width, int height, int stride);
>
> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
> index f62aea1..d3d8936 100644
> --- a/lib/libv4lconvert/libv4lconvert.c
> +++ b/lib/libv4lconvert/libv4lconvert.c
> @@ -98,6 +98,8 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>   	{ V4L2_PIX_FMT_YUYV,		16,	 5,	 4,	0 },
>   	{ V4L2_PIX_FMT_YVYU,		16,	 5,	 4,	0 },
>   	{ V4L2_PIX_FMT_UYVY,		16,	 5,	 4,	0 },
> +	{ V4L2_PIX_FMT_NV16,		16,	 5,	 4,	1 },
> +	{ V4L2_PIX_FMT_NV61,		16,	 5,	 4,	1 },
>   	/* yuv 4:2:0 formats */
>   	{ V4L2_PIX_FMT_SPCA501,		12,      6,	 3,	1 },
>   	{ V4L2_PIX_FMT_SPCA505,		12,	 6,	 3,	1 },
> @@ -1229,6 +1231,20 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>   		}
>   		break;
>
> +	case V4L2_PIX_FMT_NV16: {
> +		unsigned char *tmpbuf;
> +
> +		tmpbuf = v4lconvert_alloc_buffer(width * height * 2,
> +				&data->convert_pixfmt_buf, &data->convert_pixfmt_buf_size);
> +		if (!tmpbuf)
> +			return v4lconvert_oom_error(data);
> +
> +		v4lconvert_nv16_to_yuyv(src, tmpbuf, width, height);
> +		src_pix_fmt = V4L2_PIX_FMT_YUYV;
> +		src = tmpbuf;
> +		bytesperline = bytesperline * 2;
> +		/* fall through */
> +	}
>   	case V4L2_PIX_FMT_YUYV:
>   		if (src_size < (width * height * 2)) {
>   			V4LCONVERT_ERR("short yuyv data frame\n");
> @@ -1251,6 +1267,21 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>   		}
>   		break;
>
> +	case V4L2_PIX_FMT_NV61: {
> +		unsigned char *tmpbuf;
> +
> +		tmpbuf = v4lconvert_alloc_buffer(width * height * 2,
> +				&data->convert_pixfmt_buf, &data->convert_pixfmt_buf_size);
> +		if (!tmpbuf)
> +			return v4lconvert_oom_error(data);
> +
> +		/* Note NV61 is NV16 with U and V swapped so this becomes yvyu. */
> +		v4lconvert_nv16_to_yuyv(src, tmpbuf, width, height);
> +		src_pix_fmt = V4L2_PIX_FMT_YVYU;
> +		src = tmpbuf;
> +		bytesperline = bytesperline * 2;
> +		/* fall through */
> +	}
>   	case V4L2_PIX_FMT_YVYU:
>   		if (src_size < (width * height * 2)) {
>   			V4LCONVERT_ERR("short yvyu data frame\n");
> diff --git a/lib/libv4lconvert/rgbyuv.c b/lib/libv4lconvert/rgbyuv.c
> index 695255a..a0f8256 100644
> --- a/lib/libv4lconvert/rgbyuv.c
> +++ b/lib/libv4lconvert/rgbyuv.c
> @@ -295,6 +295,21 @@ void v4lconvert_yuyv_to_yuv420(const unsigned char *src, unsigned char *dest,
>   	}
>   }
>
> +void v4lconvert_nv16_to_yuyv(const unsigned char *src, unsigned char *dest,
> +		int width, int height)
> +{
> +	const unsigned char *y, *cbcr;
> +	int count = 0;
> +
> +	y = src;
> +	cbcr = src + width*height;
> +
> +	while (count++ < width*height) {
> +		*dest++ = *y++;
> +		*dest++ = *cbcr++;
> +	}
> +}
> +
>   void v4lconvert_yvyu_to_bgr24(const unsigned char *src, unsigned char *dest,
>   		int width, int height, int stride)
>   {
> --
> 2.7.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
