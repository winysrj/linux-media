Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:59827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab1GQQyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 12:54:18 -0400
Date: Sun, 17 Jul 2011 18:54:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/5] mt9m111: fix missing return value check mt9m111_reg_clear
In-Reply-To: <1310485146-27759-2-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1107171854101.13485@axis700.grange>
References: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
 <1310485146-27759-2-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 12 Jul 2011, Michael Grzeschik wrote:

> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Applied, thanks

> ---
>  drivers/media/video/mt9m111.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index f10dcf0..e08b46c 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -248,7 +248,9 @@ static int mt9m111_reg_clear(struct i2c_client *client, const u16 reg,
>  	int ret = 0;
>  
>  	ret = mt9m111_reg_read(client, reg);
> -	return mt9m111_reg_write(client, reg, ret & ~data);
> +	if (ret >= 0)
> +		ret = mt9m111_reg_write(client, reg, ret & ~data);
> +	return ret;
>  }
>  
>  static int mt9m111_set_context(struct i2c_client *client,
> -- 
> 1.7.5.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
