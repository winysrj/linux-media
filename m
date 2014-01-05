Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1273 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaAEMPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 07:15:12 -0500
Message-ID: <52C94CC2.30005@xs4all.nl>
Date: Sun, 05 Jan 2014 13:14:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] msi3101: add u8 sample format
References: <1388292700-18369-1-git-send-email-crope@iki.fi> <1388292700-18369-4-git-send-email-crope@iki.fi>
In-Reply-To: <1388292700-18369-4-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/29/2013 05:51 AM, Antti Palosaari wrote:
> Add unsigned 8-bit sample format. Format is got directly from
> hardware, but it is converted from signed to unsigned. It is worst
> known sampling resolution hardware offer.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/staging/media/msi3101/sdr-msi3101.c | 67 ++++++++++++++++++++++++++++-
>  1 file changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
> index 9c54c63..2110488 100644
> --- a/drivers/staging/media/msi3101/sdr-msi3101.c
> +++ b/drivers/staging/media/msi3101/sdr-msi3101.c
> @@ -385,6 +385,7 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
>  #define MSI3101_CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
>  #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
>  
> +#define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
>  #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
>  #define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
>  #define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */

These defines should be moved to videodev2.h and documented in DocBook.

Regards,

	Hans

> @@ -428,6 +429,9 @@ struct msi3101_format {
>  /* format descriptions for capture and preview */
>  static struct msi3101_format formats[] = {
>  	{
> +		.name		= "I/Q 8-bit unsigned",
> +		.pixelformat	= V4L2_PIX_FMT_SDR_U8,
> +	}, {
>  		.name		= "I/Q 8-bit signed",
>  		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
>  	}, {
> @@ -487,6 +491,7 @@ struct msi3101_state {
>  	u32 next_sample; /* for track lost packets */
>  	u32 sample; /* for sample rate calc */
>  	unsigned long jiffies;
> +	unsigned long jiffies_next;
>  	unsigned int sample_ctrl_bit[4];
>  };
>  
> @@ -572,6 +577,63 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
>  	return dst_len;
>  }
>  
> +static int msi3101_convert_stream_504_u8(struct msi3101_state *s, u8 *dst,
> +		u8 *src, unsigned int src_len)
> +{
> +	int i, j, i_max, dst_len = 0;
> +	u32 sample_num[3];
> +	s8 *s8src;
> +	u8 *u8dst;
> +
> +	/* There could be 1-3 1024 bytes URB frames */
> +	i_max = src_len / 1024;
> +	u8dst = (u8 *) dst;
> +
> +	for (i = 0; i < i_max; i++) {
> +		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;
> +		if (i == 0 && s->next_sample != sample_num[0]) {
> +			dev_dbg_ratelimited(&s->udev->dev,
> +					"%d samples lost, %d %08x:%08x\n",
> +					sample_num[0] - s->next_sample,
> +					src_len, s->next_sample, sample_num[0]);
> +		}
> +
> +		/*
> +		 * Dump all unknown 'garbage' data - maybe we will discover
> +		 * someday if there is something rational...
> +		 */
> +		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
> +
> +		/* 504 x I+Q samples */
> +		src += 16;
> +
> +		s8src = (s8 *) src;
> +		for (j = 0; j < 1008; j++)
> +			*u8dst++ = *s8src++ + 128;
> +
> +		src += 1008;
> +		dst += 1008;
> +		dst_len += 1008;
> +	}
> +
> +	/* calculate samping rate and output it in 10 seconds intervals */
> +	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
> +#define MSECS 10000UL
> +		unsigned int samples = sample_num[i_max - 1] - s->sample;
> +		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
> +		s->sample = sample_num[i_max - 1];
> +		dev_dbg(&s->udev->dev,
> +				"slen=%d samples=%u msecs=%lu sampling rate=%lu\n",
> +				src_len, samples, MSECS,
> +				samples * 1000UL / MSECS);
> +	}
> +
> +	/* next sample (sample = sample + i * 504) */
> +	s->next_sample = sample_num[i_max - 1] + 504;
> +
> +	return dst_len;
> +}
> +
>  /*
>   * +===========================================================================
>   * |   00-1023 | USB packet type '384'
> @@ -1159,7 +1221,10 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
>  		reg7 = 0x000c9407;
>  	}
>  
> -	if (s->pixelformat == V4L2_PIX_FMT_SDR_S8) {
> +	if (s->pixelformat == V4L2_PIX_FMT_SDR_U8) {
> +		s->convert_stream = msi3101_convert_stream_504_u8;
> +		reg7 = 0x000c9407;
> +	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_S8) {
>  		s->convert_stream = msi3101_convert_stream_504;
>  		reg7 = 0x000c9407;
>  	} else if (s->pixelformat == V4L2_PIX_FMT_SDR_MSI2500_384) {
> 

