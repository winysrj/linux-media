Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35458 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbcGRIv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 04:51:58 -0400
Subject: Re: [PATCH v3 8/9] [media] vivid: Fix YUV555 and YUV565 handling
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468665716-10178-9-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6224fd35-50f3-e1cd-a9b5-f377087fade6@xs4all.nl>
Date: Mon, 18 Jul 2016 10:51:53 +0200
MIME-Version: 1.0
In-Reply-To: <1468665716-10178-9-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2016 12:41 PM, Ricardo Ribalda Delgado wrote:
> precalculate_color() had a optimization that avoided duplicated
> conversion for YUV formats. This optimization did not take into
> consideration YUV444, YUV555, YUV565 or limited range quantization.
> 
> This patch keeps the optimization, but fixes the wrong handling.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> index e91bf3cbaab9..1c862465e335 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> @@ -797,6 +797,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
>  	int r = tpg_colors[col].r;
>  	int g = tpg_colors[col].g;
>  	int b = tpg_colors[col].b;
> +	int y, cb, cr;
> +	bool ycbbr_valid = false;

I guess you mean ycbcr_valid?

Regards,

	Hans

>  
>  	if (k == TPG_COLOR_TEXTBG) {
>  		col = tpg_get_textbg_color(tpg);
> @@ -873,7 +875,6 @@ static void precalculate_color(struct tpg_data *tpg, int k)
>  	     tpg->saturation != 128 || tpg->hue) &&
>  	    tpg->color_enc != TGP_COLOR_ENC_LUMA) {
>  		/* Implement these operations */
> -		int y, cb, cr;
>  		int tmp_cb, tmp_cr;
>  
>  		/* First convert to YCbCr */
> @@ -890,13 +891,10 @@ static void precalculate_color(struct tpg_data *tpg, int k)
>  
>  		cb = (128 << 4) + (tmp_cb * tpg->contrast * tpg->saturation) / (128 * 128);
>  		cr = (128 << 4) + (tmp_cr * tpg->contrast * tpg->saturation) / (128 * 128);
> -		if (tpg->color_enc == TGP_COLOR_ENC_YUV) {
> -			tpg->colors[k][0] = clamp(y >> 4, 1, 254);
> -			tpg->colors[k][1] = clamp(cb >> 4, 1, 254);
> -			tpg->colors[k][2] = clamp(cr >> 4, 1, 254);
> -			return;
> -		}
> -		ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
> +		if (tpg->color_enc == TGP_COLOR_ENC_YUV)
> +			ycbbr_valid = true;
> +		else
> +			ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
>  	} else if ((tpg->brightness != 128 || tpg->contrast != 128) &&
>  		   tpg->color_enc == TGP_COLOR_ENC_LUMA) {
>  		r = (16 << 4) + ((r - (16 << 4)) * tpg->contrast) / 128;
> @@ -917,9 +915,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
>  	case TGP_COLOR_ENC_YUV:
>  	{
>  		/* Convert to YCbCr */
> -		int y, cb, cr;
> -
> -		color_to_ycbcr(tpg, r, g, b, &y, &cb, &cr);
> +		if (!ycbbr_valid)
> +			color_to_ycbcr(tpg, r, g, b, &y, &cb, &cr);
>  
>  		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
>  			y = clamp(y, 16 << 4, 235 << 4);
> 
