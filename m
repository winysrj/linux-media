Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2175 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaCKM00 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:26:26 -0400
Message-ID: <531F00C2.5080300@xs4all.nl>
Date: Tue, 11 Mar 2014 13:25:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 12/14] v4l: ti-vpe: zero out reserved fields in try_fmt
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-13-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-13-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/14 09:33, Archit Taneja wrote:
> Zero out the reserved formats in v4l2_pix_format_mplane and
> v4l2_plane_pix_format members of the returned v4l2_format pointer when passed
> through TRY_FMT ioctl.
> 
> This ensures that the user doesn't interpret the non-zero fields as some data
> passed by the driver, and ensures compliance.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/ti-vpe/vpe.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 85d1122..970408a 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1488,6 +1488,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
>  		}
>  	}
>  
> +	memset(pix->reserved, 0, sizeof(pix->reserved));
>  	for (i = 0; i < pix->num_planes; i++) {
>  		plane_fmt = &pix->plane_fmt[i];
>  		depth = fmt->vpdma_fmt[i]->depth;
> @@ -1499,6 +1500,8 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
>  
>  		plane_fmt->sizeimage =
>  				(pix->height * pix->width * depth) >> 3;
> +
> +		memset(plane_fmt->reserved, 0, sizeof(plane_fmt->reserved));
>  	}
>  
>  	return 0;
> 

