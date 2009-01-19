Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43967 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752366AbZASH1t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 02:27:49 -0500
Date: Mon, 19 Jan 2009 08:27:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] ov772x: bit mask operation fix on ov772x_mask_set.
In-Reply-To: <u7i4rpxp9.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901190827110.4142@axis700.grange>
References: <u7i4rpxp9.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, 19 Jan 2009, Kuninori Morimoto wrote:

> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/ov772x.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index b75420d..c8e10d3 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -566,8 +566,11 @@ static int ov772x_mask_set(struct i2c_client *client,
>  					  u8  set)
>  {
>  	s32 val = i2c_smbus_read_byte_data(client, command);
> +	if (val < 0)
> +		return val;
> +
>  	val &= ~mask;
> -	val |=  set;
> +	val |= (set & mask);

Please, remove superfluous parenthesis.

>  
>  	return i2c_smbus_write_byte_data(client, command, val);
>  }
> -- 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
