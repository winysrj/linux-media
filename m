Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41808 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab2DMTRC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 15:17:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 3/3] Support additional dpcm compressed bayer formats.
Date: Fri, 13 Apr 2012 21:17:11 +0200
Message-ID: <1753568.64SE3at6Gb@avalon>
In-Reply-To: <1334220095-1698-3-git-send-email-sakari.ailus@iki.fi>
References: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi> <1334220095-1698-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thursday 12 April 2012 11:41:35 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  yavta.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index 532fb1f..a89d475 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -149,7 +149,10 @@ static struct {
>  	{ "SGBRG8", V4L2_PIX_FMT_SGBRG8 },
>  	{ "SGRBG8", V4L2_PIX_FMT_SGRBG8 },
>  	{ "SRGGB8", V4L2_PIX_FMT_SRGGB8 },
> +	{ "SBGGR10_DPCM8", V4L2_PIX_FMT_SBGGR10DPCM8 },
> +	{ "SGBRG10_DPCM8", V4L2_PIX_FMT_SGBRG10DPCM8 },
>  	{ "SGRBG10_DPCM8", V4L2_PIX_FMT_SGRBG10DPCM8 },
> +	{ "SRGGB10_DPCM8", V4L2_PIX_FMT_SRGGB10DPCM8 },
>  	{ "SBGGR10", V4L2_PIX_FMT_SBGGR10 },
>  	{ "SGBRG10", V4L2_PIX_FMT_SGBRG10 },
>  	{ "SGRBG10", V4L2_PIX_FMT_SGRBG10 },

-- 
Regards,

Laurent Pinchart

