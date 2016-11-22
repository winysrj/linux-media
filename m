Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46551 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755665AbcKVPuH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 10:50:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] v4l: vsp1: Fix format-info documentation
Date: Tue, 22 Nov 2016 17:50:23 +0200
Message-ID: <38960007.89akIK3ZEG@avalon>
In-Reply-To: <1465495022-8177-1-git-send-email-kieran@bingham.xyz>
References: <1465495022-8177-1-git-send-email-kieran@bingham.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday 09 Jun 2016 18:57:02 Kieran Bingham wrote:
> Minor tweaks to document the swap register and make the documentation
> match the struct ordering
> 
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/platform/vsp1/vsp1_pipe.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
> b/drivers/media/platform/vsp1/vsp1_pipe.h index 7b56113511dd..6ee3db1fab55
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -25,11 +25,12 @@ struct vsp1_rwpf;
> 
>  /*
>   * struct vsp1_format_info - VSP1 video format description
> - * @mbus: media bus format code
>   * @fourcc: V4L2 pixel format FCC identifier
> + * @mbus: media bus format code
> + * @hwfmt: VSP1 hardware format
> + * @swap: swap register control
>   * @planes: number of planes
>   * @bpp: bits per pixel
> - * @hwfmt: VSP1 hardware format
>   * @swap_yc: the Y and C components are swapped (Y comes before C)
>   * @swap_uv: the U and V components are swapped (V comes before U)
>   * @hsub: horizontal subsampling factor

-- 
Regards,

Laurent Pinchart

