Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaLOR5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 12:57:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH v2 3/3] yavta: Add support for 10-bit packed raw bayer formats
Date: Mon, 15 Dec 2014 19:57:44 +0200
Message-ID: <7095536.9mhnFqSS07@avalon>
In-Reply-To: <1418660809-30548-4-git-send-email-sakari.ailus@linux.intel.com>
References: <1418660809-30548-1-git-send-email-sakari.ailus@linux.intel.com> <1418660809-30548-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 15 December 2014 18:26:49 Sakari Ailus wrote:
> Add support for these pixel formats:
> 
> V4L2_PIX_FMT_SBGGR10P
> V4L2_PIX_FMT_SGBRG10P
> V4L2_PIX_FMT_SGRBG10P
> V4L2_PIX_FMT_SRGGB10P
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  yavta.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/yavta.c b/yavta.c
> index 003d6ba..f40562a 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -202,6 +202,10 @@ static struct v4l2_format_info {
>  	{ "SGBRG10", V4L2_PIX_FMT_SGBRG10, 1 },
>  	{ "SGRBG10", V4L2_PIX_FMT_SGRBG10, 1 },
>  	{ "SRGGB10", V4L2_PIX_FMT_SRGGB10, 1 },
> +	{ "SBGGR10P", V4L2_PIX_FMT_SBGGR10P, 1 },
> +	{ "SGBRG10P", V4L2_PIX_FMT_SGBRG10P, 1 },
> +	{ "SGRBG10P", V4L2_PIX_FMT_SGRBG10P, 1 },
> +	{ "SRGGB10P", V4L2_PIX_FMT_SRGGB10P, 1 },
>  	{ "SBGGR12", V4L2_PIX_FMT_SBGGR12, 1 },
>  	{ "SGBRG12", V4L2_PIX_FMT_SGBRG12, 1 },
>  	{ "SGRBG12", V4L2_PIX_FMT_SGRBG12, 1 },

-- 
Regards,

Laurent Pinchart

