Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56173 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2GJNso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 09:48:44 -0400
Date: Tue, 10 Jul 2012 15:48:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 03/10] ov772x: Select the default format at probe time
In-Reply-To: <1341585301-1003-4-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1207101545580.29825@axis700.grange>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1341585301-1003-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Jul 2012, Laurent Pinchart wrote:

> The format and window size are only initialized during the first g_fmt
> call. This leaves the device in an inconsistent state after
> initialization, which will cause problems when implementing pad
> operations. Move the format and window size initialization to probe
> time.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/ov772x.c |   63 ++++++++++++++++++++---------------------
>  1 files changed, 31 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 066bac6..576780a 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -547,37 +547,36 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
>  #define MAX_WIDTH   VGA_WIDTH
>  #define MAX_HEIGHT  VGA_HEIGHT
>  
> -static const struct ov772x_win_size ov772x_win_vga = {
> -	.name     = "VGA",
> -	.width    = VGA_WIDTH,
> -	.height   = VGA_HEIGHT,
> -	.com7_bit = SLCT_VGA,
> -	.regs     = ov772x_vga_regs,
> -};
> -
> -static const struct ov772x_win_size ov772x_win_qvga = {
> -	.name     = "QVGA",
> -	.width    = QVGA_WIDTH,
> -	.height   = QVGA_HEIGHT,
> -	.com7_bit = SLCT_QVGA,
> -	.regs     = ov772x_qvga_regs,
> +static const struct ov772x_win_size ov772x_win_sizes[] = {
> +	{
> +		.name     = "VGA",
> +		.width    = VGA_WIDTH,
> +		.height   = VGA_HEIGHT,
> +		.com7_bit = SLCT_VGA,
> +		.regs     = ov772x_vga_regs,
> +	}, {
> +		.name     = "QVGA",
> +		.width    = QVGA_WIDTH,
> +		.height   = QVGA_HEIGHT,
> +		.com7_bit = SLCT_QVGA,
> +		.regs     = ov772x_qvga_regs,
> +	},
>  };
>  
>  static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
>  {
> -	__u32 diff;
> -	const struct ov772x_win_size *win;
> -
> -	/* default is QVGA */
> -	diff = abs(width - ov772x_win_qvga.width) +
> -		abs(height - ov772x_win_qvga.height);
> -	win = &ov772x_win_qvga;
> -
> -	/* VGA */
> -	if (diff >
> -	    abs(width  - ov772x_win_vga.width) +
> -	    abs(height - ov772x_win_vga.height))
> -		win = &ov772x_win_vga;
> +	const struct ov772x_win_size *win = &ov772x_win_sizes[0];
> +	unsigned int i;
> +	u32 best_diff = (u32)-1;

Not a reason enough for a new version, if you don't mind and ig I don't 
forget, I might

#include <linux/kernel.h>
+	u32 best_diff = UINT_MAX;

> +
> +	for (i = 0; i < ARRAY_SIZE(ov772x_win_sizes); ++i) {
> +		u32 diff = abs(width - ov772x_win_sizes[i].width)
> +			 + abs(height - ov772x_win_sizes[i].height);
> +		if (diff < best_diff) {
> +			best_diff = diff;
> +			win = &ov772x_win_sizes[i];
> +		}
> +	}
>  
>  	return win;
>  }

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
