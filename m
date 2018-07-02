Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:36748 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753057AbeGBIxR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 04:53:17 -0400
Subject: Re: [PATCH] media: coda: add SPS fixup code for frame sizes that are
 not multiples of 16
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
References: <20180628164701.26936-1-p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <00c884f5-3a7e-9515-ec4b-e9aa3bf64532@xs4all.nl>
Date: Mon, 2 Jul 2018 10:53:14 +0200
MIME-Version: 1.0
In-Reply-To: <20180628164701.26936-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/06/18 18:47, Philipp Zabel wrote:
> The CODA firmware does not set the VUI frame cropping fields to properly
> describe coded h.264 streams with frame sizes that are not a multiple of
> the macroblock size.
> This adds RBSP parsing code and a SPS fixup routine to manually replace
> the cropping information in the headers produced by the firmware with
> the correct values.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-bit.c  |  11 +
>  drivers/media/platform/coda/coda-h264.c | 302 ++++++++++++++++++++++++
>  drivers/media/platform/coda/coda.h      |   2 +
>  3 files changed, 315 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index 94ba3cc3bf14..d6380a10fa2c 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -1197,6 +1197,17 @@ static int coda_start_encoding(struct coda_ctx *ctx)
>  		if (ret < 0)
>  			goto out;
>  
> +		if ((q_data_src->rect.width % 16) ||
> +		    (q_data_src->rect.height % 16)) {
> +			ret = coda_sps_fixup(ctx, q_data_src->rect.width,
> +					     q_data_src->rect.height,
> +					     &ctx->vpu_header[0][0],
> +					     &ctx->vpu_header_size[0],
> +					     sizeof(ctx->vpu_header[0]));

You need to add a comment here why this is needed.

> +			if (ret < 0)
> +				goto out;
> +		}
> +
>  		/*
>  		 * Get PPS in the first frame and copy it to an
>  		 * intermediate buffer.
> diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
> index 0e27412e01f5..8ec5a5d076c0 100644
> --- a/drivers/media/platform/coda/coda-h264.c
> +++ b/drivers/media/platform/coda/coda-h264.c
> @@ -111,3 +111,305 @@ int coda_h264_level(int level_idc)
>  	default: return -EINVAL;
>  	}
>  }
> +
> +struct rbsp {
> +	char *buf;
> +	int size;
> +	int pos;
> +};
> +
> +static inline int rbsp_read_bit(struct rbsp *rbsp)
> +{
> +	int shift = 7 - (rbsp->pos % 8);
> +	int ofs = rbsp->pos++ / 8;
> +
> +	if (ofs >= rbsp->size)
> +		return -EINVAL;
> +
> +	return (rbsp->buf[ofs] >> shift) & 1;
> +}
> +
> +static inline int rbsp_write_bit(struct rbsp *rbsp, int bit)
> +{
> +	int shift = 7 - (rbsp->pos % 8);
> +	int ofs = rbsp->pos++ / 8;
> +
> +	if (ofs >= rbsp->size)
> +		return -EINVAL;
> +
> +	rbsp->buf[ofs] &= ~(1 << shift);
> +	rbsp->buf[ofs] |= bit << shift;
> +
> +	return 0;
> +}
> +
> +static inline int rbsp_read_bits(struct rbsp *rbsp, int num, int *val)
> +{
> +	int i, ret;
> +	int tmp = 0;
> +
> +	if (num > 32)
> +		return -EINVAL;
> +
> +	for (i = 0; i < num; i++) {
> +		ret = rbsp_read_bit(rbsp);
> +		if (ret < 0)
> +			return ret;
> +		tmp |= ret << (num - i - 1);
> +	}
> +
> +	if (val)
> +		*val = tmp;
> +
> +	return 0;
> +}
> +
> +static int rbsp_write_bits(struct rbsp *rbsp, int num, int value)
> +{
> +	int ret;
> +
> +	while (num--) {
> +		ret = rbsp_write_bit(rbsp, (value >> num) & 1);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rbsp_read_uev(struct rbsp *rbsp, unsigned int *val)
> +{
> +	int leading_zero_bits = 0;
> +	unsigned int tmp = 0;
> +	int ret;
> +
> +	while ((ret = rbsp_read_bit(rbsp)) == 0)
> +		leading_zero_bits++;
> +	if (ret < 0)
> +		return ret;
> +
> +	if (leading_zero_bits > 0) {
> +		ret = rbsp_read_bits(rbsp, leading_zero_bits, &tmp);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (val)
> +		*val = (1 << leading_zero_bits) - 1 + tmp;
> +
> +	return 0;
> +}
> +
> +static int rbsp_write_uev(struct rbsp *rbsp, unsigned int value)
> +{
> +	int i;
> +	int ret;
> +	int tmp = value + 1;
> +	int leading_zero_bits = fls(tmp) - 1;
> +
> +	for (i = 0; i < leading_zero_bits; i++) {
> +		ret = rbsp_write_bit(rbsp, 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return rbsp_write_bits(rbsp, leading_zero_bits + 1, tmp);
> +}
> +
> +static int rbsp_read_sev(struct rbsp *rbsp, int *val)
> +{
> +	unsigned int tmp;
> +	int ret;
> +
> +	ret = rbsp_read_uev(rbsp, &tmp);
> +	if (ret)
> +		return ret;
> +
> +	if (val) {
> +		if (tmp & 1)
> +			*val = (tmp + 1) / 2;
> +		else
> +			*val = -(tmp / 2);
> +	}
> +
> +	return 0;
> +}
> +
> +int coda_sps_fixup(struct coda_ctx *ctx, int width, int height, char *buf,
> +		   int *size, int max_size)

Same here: why it is needed and what does it do.

Regards,

	Hans
