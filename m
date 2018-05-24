Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44430 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030464AbeEXKYh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 06:24:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v4 01/11] media: vsp1: drm: Fix minor grammar error
Date: Thu, 24 May 2018 13:24:33 +0300
Message-ID: <18402905.oJTJa3tjgA@avalon>
In-Reply-To: <7ad68ea5ac48bbf51e30205c05b3fd4167f7afc5.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com> <7ad68ea5ac48bbf51e30205c05b3fd4167f7afc5.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday, 3 May 2018 16:36:12 EEST Kieran Bingham wrote:
> The pixel format is 'unsupported'. Fix the small debug message which
> incorrectly declares this.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> b/drivers/media/platform/vsp1/vsp1_drm.c index ef0148082bf7..2c3db8b8adce
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -806,7 +806,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned
> int pipe_index, */
>  	fmtinfo = vsp1_get_format_info(vsp1, cfg->pixelformat);
>  	if (!fmtinfo) {
> -		dev_dbg(vsp1->dev, "Unsupport pixel format %08x for RPF\n",
> +		dev_dbg(vsp1->dev, "Unsupported pixel format %08x for RPF\n",
>  			cfg->pixelformat);
>  		return -EINVAL;
>  	}


-- 
Regards,

Laurent Pinchart
