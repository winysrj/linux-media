Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2GJV3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 17:29:43 -0400
Date: Tue, 10 Jul 2012 23:29:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 09/10] ov772x: Compute window size registers at runtime
In-Reply-To: <1341585301-1003-10-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1207102323380.29825@axis700.grange>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1341585301-1003-10-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Fri, 6 Jul 2012, Laurent Pinchart wrote:

> Instead of hardcoding register arrays, compute the values at runtime.

Great to see this register-array magic go! Just one nitpick:

> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/ov772x.c |  149 ++++++++++++++++-------------------------
>  1 files changed, 58 insertions(+), 91 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 07ff709..98b1bdf 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c

[snip]

> @@ -574,24 +514,26 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
>  
>  #define VGA_WIDTH   640
>  #define VGA_HEIGHT  480
> -#define QVGA_WIDTH  320
> -#define QVGA_HEIGHT 240
> -#define MAX_WIDTH   VGA_WIDTH
> -#define MAX_HEIGHT  VGA_HEIGHT

You removed QVGA_* macros, because they only were used at one location, 
but you kept VGA_*.

>  
>  static const struct ov772x_win_size ov772x_win_sizes[] = {
>  	{
>  		.name     = "VGA",
> -		.width    = VGA_WIDTH,
> -		.height   = VGA_HEIGHT,
>  		.com7_bit = SLCT_VGA,
> -		.regs     = ov772x_vga_regs,
> +		.rect = {
> +			.left = 140,
> +			.top = 14,
> +			.width = 640,
> +			.height = 480,

...but here you hard-code .width and .height. I'd propose to use some 
symbolic names for all these sizes.

> +		},
>  	}, {
>  		.name     = "QVGA",
> -		.width    = QVGA_WIDTH,
> -		.height   = QVGA_HEIGHT,
>  		.com7_bit = SLCT_QVGA,
> -		.regs     = ov772x_qvga_regs,
> +		.rect = {
> +			.left = 252,
> +			.top = 6,
> +			.width = 320,
> +			.height = 240,
> +		},
>  	},
>  };
>  

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
