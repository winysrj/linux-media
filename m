Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:46811 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbcGOS2s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 14:28:48 -0400
Subject: Re: [PATCH v2 4/6] [media] vivid: code refactor for color
 representation
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
 <1468599199-5902-5-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4370a9db-73aa-9454-fdda-135ebe16ad08@xs4all.nl>
Date: Fri, 15 Jul 2016 20:28:43 +0200
MIME-Version: 1.0
In-Reply-To: <1468599199-5902-5-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/15/2016 06:13 PM, Ricardo Ribalda Delgado wrote:
> Replace is_yuv with color_representation. Which can be used by HSV
> formats.
> 
> This change should ease the review of the following patches.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   | 44 ++++++++++++++-------
>  drivers/media/platform/vivid/vivid-core.h       |  2 +-
>  drivers/media/platform/vivid/vivid-vid-common.c | 52 ++++++++++++-------------
>  include/media/v4l2-tpg.h                        |  7 +++-
>  4 files changed, 63 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> index cf1dadd0be9e..acf0e6854832 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> @@ -1842,7 +1842,9 @@ static void tpg_recalc(struct tpg_data *tpg)
>  
>  		if (tpg->quantization == V4L2_QUANTIZATION_DEFAULT)
>  			tpg->real_quantization =
> -				V4L2_MAP_QUANTIZATION_DEFAULT(!tpg->is_yuv,
> +				V4L2_MAP_QUANTIZATION_DEFAULT(
> +					tpg->color_representation ==
> +						TGP_COLOR_REPRESENTATION_RGB,

This should be != TGP_COLOR_REPRESENTATION_YUV.

Otherwise HSV would map to limited range by default, which is probably wrong.

Regards,

	Hans

>  					tpg->colorspace, tpg->real_ycbcr_enc);
>  
>  		tpg_precalculate_colors(tpg);
