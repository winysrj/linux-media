Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39495 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1L1KZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 05:25:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/2] v4l: Add DPCM compressed formats
Date: Wed, 28 Dec 2011 11:25:13 +0100
Cc: linux-media@vger.kernel.org
References: <20111228102028.GR3677@valkosipuli.localdomain> <1325067657-32556-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1325067657-32556-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112281125.15080.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 28 December 2011 11:20:56 Sakari Ailus wrote:
> Add three other colour orders for 10-bit to 8-bit DPCM compressed formats.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  include/linux/videodev2.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 0f8f904..560e468 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -365,7 +365,10 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR..
> BGBG.. */ #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /*
> 12  RGRG.. GBGB.. */ /* 10bit raw bayer DPCM compressed to 8 bits */
> +#define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('B', 'D', 'B', '1')
> +#define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('B', 'D', 'G', '1')
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> +#define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('B', 'D', 'R', '1')
>  	/*
>  	 * 10bit raw bayer, expanded to 16 bits
>  	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...

Could you please have a look at the discussion about a similar patch in 
http://patchwork.linuxtv.org/patch/8844/ ?

-- 
Regards,

Laurent Pinchart
