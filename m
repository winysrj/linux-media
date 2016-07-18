Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43203 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbcGRNNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 09:13:49 -0400
Message-ID: <1468847611.2994.22.camel@pengutronix.de>
Subject: Re: [PATCH v4 09/12] [media] vivid: Local optimization
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Date: Mon, 18 Jul 2016 15:13:31 +0200
In-Reply-To: <1468845736-19651-10-git-send-email-ricardo.ribalda@gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1468845736-19651-10-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Am Montag, den 18.07.2016, 14:42 +0200 schrieb Ricardo Ribalda Delgado:
> Avoid duplicated data shifts when possible.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> index a26172575e56..7f284c591f25 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> @@ -919,13 +919,14 @@ static void precalculate_color(struct tpg_data *tpg, int k)
>  			color_to_ycbcr(tpg, r, g, b, &y, &cb, &cr);
>  
>  		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
> -			y = clamp(y, 16 << 4, 235 << 4);
> -			cb = clamp(cb, 16 << 4, 240 << 4);
> -			cr = clamp(cr, 16 << 4, 240 << 4);
> +			y = clamp(y >> 4, 16, 235);
> +			cb = clamp(cb >> 4, 16, 240);
> +			cr = clamp(cr >> 4, 16, 240);

Since the constant expressions are evaluated at compile time, you are
not actually removing shifts. The code generated for precalculate_color
by gcc 5.4 even grows by one asr instruction with this patch.

> +		} else {
> +			y = clamp(y >> 4, 1, 254);
> +			cb = clamp(cb >> 4, 1, 254);
> +			cr = clamp(cr >> 4, 1, 254);
>  		}
> -		y = clamp(y >> 4, 1, 254);
> -		cb = clamp(cb >> 4, 1, 254);
> -		cr = clamp(cr >> 4, 1, 254);
>  		switch (tpg->fourcc) {
>  		case V4L2_PIX_FMT_YUV444:
>  			y >>= 4;

regards
Philipp

