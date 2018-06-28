Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58907 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933024AbeF1LDQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 07:03:16 -0400
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1fYUhn-00054m-3v
        for linux-media@vger.kernel.org; Thu, 28 Jun 2018 13:03:15 +0200
Message-ID: <1530183795.6409.17.camel@pengutronix.de>
Subject: Re: [PATCH] media: coda: add h.264 level 4.2
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Date: Thu, 28 Jun 2018 13:03:15 +0200
In-Reply-To: <20180621155123.21939-1-p.zabel@pengutronix.de>
References: <20180621155123.21939-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, 2018-06-21 at 17:51 +0200, Philipp Zabel wrote:
> This enables reordering support for h.264 main profile level 4.2
> streams.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-h264.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
> index 0e27412e01f5..945c6a582e37 100644
> --- a/drivers/media/platform/coda/coda-h264.c
> +++ b/drivers/media/platform/coda/coda-h264.c
> @@ -108,6 +108,7 @@ int coda_h264_level(int level_idc)
>  	case 32: return V4L2_MPEG_VIDEO_H264_LEVEL_3_2;
>  	case 40: return V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
>  	case 41: return V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
> +	case 42: return V4L2_MPEG_VIDEO_H264_LEVEL_4_2;
>  	default: return -EINVAL;
>  	}
>  }

Please disregard this patch, it is superseded by
"media: coda: add missing h.264 levels" [1].

[1] https://patchwork.linuxtv.org/patch/50614/

which also adds the missing 5.0 and 5.1 levels.

regards
Philipp
