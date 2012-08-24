Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2HXLXZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 07:23:25 -0400
Date: Fri, 24 Aug 2012 13:23:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Anatolij Gustschin <agust@denx.de>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 3/3] mt9v022: set y_skip_top field to zero
In-Reply-To: <1345799431-29426-4-git-send-email-agust@denx.de>
Message-ID: <Pine.LNX.4.64.1208241323030.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
 <1345799431-29426-4-git-send-email-agust@denx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Aug 2012, Anatolij Gustschin wrote:

> Set "y_skip_top" to zero and remove comment as I do not see this
> line corruption on two different mt9v022 setups. The first read-out
> line is perfectly fine.

On what systems have you checked this?

Thanks
Guennadi

> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  drivers/media/i2c/soc_camera/mt9v022.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
> index d26c071..e41d738 100644
> --- a/drivers/media/i2c/soc_camera/mt9v022.c
> +++ b/drivers/media/i2c/soc_camera/mt9v022.c
> @@ -960,11 +960,7 @@ static int mt9v022_probe(struct i2c_client *client,
>  
>  	mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
>  
> -	/*
> -	 * MT9V022 _really_ corrupts the first read out line.
> -	 * TODO: verify on i.MX31
> -	 */
> -	mt9v022->y_skip_top	= 1;
> +	mt9v022->y_skip_top	= 0;
>  	mt9v022->rect.left	= MT9V022_COLUMN_SKIP;
>  	mt9v022->rect.top	= MT9V022_ROW_SKIP;
>  	mt9v022->rect.width	= MT9V022_MAX_WIDTH;
> -- 
> 1.7.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
