Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:47259 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbcGOS3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 14:29:19 -0400
Subject: Re: [PATCH v2 5/6] [media] vivid: Add support for HSV formats
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468599199-5902-6-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <25a3d29f-b8cb-f7ff-91a7-9b9290d76bfb@xs4all.nl>
Date: Fri, 15 Jul 2016 20:29:13 +0200
MIME-Version: 1.0
In-Reply-To: <1468599199-5902-6-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/15/2016 06:13 PM, Ricardo Ribalda Delgado wrote:
> This patch adds support for V4L2_PIX_FMT_HSV24 and V4L2_PIX_FMT_HSV32.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 94 +++++++++++++++++++++++--
>  drivers/media/platform/vivid/vivid-vid-common.c | 14 ++++
>  include/media/v4l2-tpg.h                        |  1 +
>  3 files changed, 105 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> index acf0e6854832..85b9c1925dd9 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> @@ -318,6 +318,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
>  		tpg->hmask[0] = ~1;
>  		tpg->color_representation = TGP_COLOR_REPRESENTATION_YUV;
>  		break;
> +	case V4L2_PIX_FMT_HSV24:
> +	case V4L2_PIX_FMT_HSV32:
> +		tpg->color_representation = TGP_COLOR_REPRESENTATION_HSV;
> +		break;
>  	default:
>  		return false;
>  	}
> @@ -351,6 +355,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
>  		break;
>  	case V4L2_PIX_FMT_RGB24:
>  	case V4L2_PIX_FMT_BGR24:
> +	case V4L2_PIX_FMT_HSV24:
>  		tpg->twopixelsize[0] = 2 * 3;
>  		break;
>  	case V4L2_PIX_FMT_BGR666:
> @@ -361,6 +366,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
>  	case V4L2_PIX_FMT_ARGB32:
>  	case V4L2_PIX_FMT_ABGR32:
>  	case V4L2_PIX_FMT_YUV32:
> +	case V4L2_PIX_FMT_HSV32:
>  		tpg->twopixelsize[0] = 2 * 4;
>  		break;
>  	case V4L2_PIX_FMT_NV12:
> @@ -408,6 +414,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
>  		tpg->twopixelsize[1] = 4;
>  		break;
>  	}
> +
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(tpg_s_fourcc);
> @@ -490,6 +497,64 @@ static inline int linear_to_rec709(int v)
>  	return tpg_linear_to_rec709[v];
>  }
>  
> +static void color_to_hsv(struct tpg_data *tpg, int r, int g, int b,
> +			   int *h, int *s, int *v)
> +{
> +	int max_rgb, min_rgb, diff_rgb;
> +	int aux;
> +	int third;
> +
> +	r >>= 4;
> +	g >>= 4;
> +	b >>= 4;
> +
> +	/*V*/

Please add a space after /* and before */.
I also think it is better to write Value, Saturation, Hue instead of
V, S, H.

> +	max_rgb = max3(r, g, b);
> +	*v = max_rgb;
> +	if (!max_rgb) {
> +		*h = 0;
> +		*s = 0;
> +		return;
> +	}
> +
> +	/*S*/
> +	min_rgb = min3(r, g, b);
> +	diff_rgb = max_rgb - min_rgb;
> +	aux = 255 * diff_rgb;
> +	aux += max_rgb / 2;
> +	aux /= max_rgb;
> +	*s = aux;
> +	if (!aux) {
> +		*h = 0;
> +		return;
> +	}
> +
> +	/*H*/
> +	if (max_rgb == r) {
> +		aux =  g - b;
> +		third = 0;
> +	} else if (max_rgb == g) {
> +		aux =  b - r;
> +		third = 60;
> +	} else {
> +		aux =  r - g;
> +		third = 120;
> +	}
> +
> +	aux *= 30;
> +	aux += diff_rgb / 2;
> +	aux /= diff_rgb;
> +	aux += third;
> +
> +	/*Clamp H*/
> +	if (aux < 0)
> +		aux += 180;
> +	else if (aux > 180)
> +		aux -= 180;
> +	*h = aux;
> +
> +}
> +
>  static void rgb2ycbcr(const int m[3][3], int r, int g, int b,
>  			int y_offset, int *y, int *cb, int *cr)
>  {
> @@ -829,7 +894,19 @@ static void precalculate_color(struct tpg_data *tpg, int k)
>  		ycbcr_to_color(tpg, y, cb, cr, &r, &g, &b);
>  	}
>  
> -	if (tpg->color_representation == TGP_COLOR_REPRESENTATION_YUV) {
> +	switch (tpg->color_representation) {
> +	case TGP_COLOR_REPRESENTATION_HSV:
> +	{
> +		int h, s, v;
> +
> +		color_to_hsv(tpg, r, g, b, &h, &s, &v);
> +		tpg->colors[k][0] = h;
> +		tpg->colors[k][1] = s;
> +		tpg->colors[k][2] = v;

Would quantization (limited/full range) be relevant here? I don't know if limited
range would make sense (or what those limits would be).

Regards,

	Hans
