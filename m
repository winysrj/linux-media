Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1160 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607AbaGRTh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 15:37:57 -0400
Message-ID: <53C97787.4090008@xs4all.nl>
Date: Fri, 18 Jul 2014 21:37:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl2832_sdr: fill FMT buffer size
References: <1405711769-8463-1-git-send-email-crope@iki.fi> <1405711769-8463-2-git-send-email-crope@iki.fi>
In-Reply-To: <1405711769-8463-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2014 09:29 PM, Antti Palosaari wrote:
> Fill FMT buffer size field in order to inform app which will be
> used streaming buffer size. Currently driver doesn't allow buffer
> size value proposed by application.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/dvb-frontends/rtl2832_sdr.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
> index ae52974..b6f68bd 100644
> --- a/drivers/media/dvb-frontends/rtl2832_sdr.c
> +++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
> @@ -84,15 +84,18 @@ static const struct v4l2_frequency_band bands_fm[] = {
>  struct rtl2832_sdr_format {
>  	char	*name;
>  	u32	pixelformat;
> +	u32	buffersize;
>  };
>  
>  static struct rtl2832_sdr_format formats[] = {
>  	{
>  		.name		= "Complex U8",
> -		.pixelformat	=  V4L2_SDR_FMT_CU8,
> +		.pixelformat	= V4L2_SDR_FMT_CU8,
> +		.buffersize	= BULK_BUFFER_SIZE,
>  	}, {
>  		.name		= "Complex U16LE (emulated)",
>  		.pixelformat	= V4L2_SDR_FMT_CU16LE,
> +		.buffersize	= BULK_BUFFER_SIZE * 2,
>  	},
>  };
>  
> @@ -143,6 +146,7 @@ struct rtl2832_sdr_state {
>  
>  	unsigned int f_adc, f_tuner;
>  	u32 pixelformat;
> +	u32 buffersize;
>  	unsigned int num_formats;
>  
>  	/* Controls */
> @@ -626,8 +630,7 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
>  	if (vq->num_buffers + *nbuffers < 8)
>  		*nbuffers = 8 - vq->num_buffers;
>  	*nplanes = 1;
> -	/* 2 = max 16-bit sample returned */
> -	sizes[0] = PAGE_ALIGN(BULK_BUFFER_SIZE * 2);
> +	sizes[0] = PAGE_ALIGN(s->buffersize);
>  	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
>  			__func__, *nbuffers, sizes[0]);
>  	return 0;
> @@ -1216,6 +1219,8 @@ static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
>  	dev_dbg(&s->udev->dev, "%s:\n", __func__);
>  
>  	f->fmt.sdr.pixelformat = s->pixelformat;
> +	f->fmt.sdr.buffersize = s->buffersize;
> +
>  	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
>  
>  	return 0;
> @@ -1236,13 +1241,17 @@ static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
>  	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
>  	for (i = 0; i < s->num_formats; i++) {
>  		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
> -			s->pixelformat = f->fmt.sdr.pixelformat;
> +			s->pixelformat = formats[i].pixelformat;
> +			s->buffersize = formats[i].buffersize;
> +			f->fmt.sdr.buffersize = formats[i].buffersize;
>  			return 0;
>  		}
>  	}
>  
> -	f->fmt.sdr.pixelformat = formats[0].pixelformat;
>  	s->pixelformat = formats[0].pixelformat;
> +	s->buffersize = formats[0].buffersize;
> +	f->fmt.sdr.pixelformat = formats[0].pixelformat;
> +	f->fmt.sdr.buffersize = formats[0].buffersize;
>  
>  	return 0;
>  }
> @@ -1257,11 +1266,14 @@ static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
>  
>  	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
>  	for (i = 0; i < s->num_formats; i++) {
> -		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
> +		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
> +			f->fmt.sdr.buffersize = formats[i].buffersize;
>  			return 0;
> +		}
>  	}
>  
>  	f->fmt.sdr.pixelformat = formats[0].pixelformat;
> +	f->fmt.sdr.buffersize = formats[0].buffersize;
>  
>  	return 0;
>  }
> @@ -1395,7 +1407,8 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
>  	s->cfg = cfg;
>  	s->f_adc = bands_adc[0].rangelow;
>  	s->f_tuner = bands_fm[0].rangelow;
> -	s->pixelformat =  V4L2_SDR_FMT_CU8;
> +	s->pixelformat = formats[0].pixelformat;
> +	s->buffersize = formats[0].buffersize;
>  	s->num_formats = NUM_FORMATS;
>  	if (rtl2832_sdr_emulated_fmt == false)
>  		s->num_formats -= 1;
> 

