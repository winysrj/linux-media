Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756793AbZJMIYZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 04:24:25 -0400
Date: Tue, 13 Oct 2009 10:23:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/5] soc-camera: tw9910: Add revision control on
 tw9910_set_hsync
In-Reply-To: <ubpkbkfm9.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0910131017370.5089@axis700.grange>
References: <ubpkbkfm9.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Oct 2009, Kuninori Morimoto wrote:

> 10 - 3 bit hsync control are same as Rev0/Rev1.
> But only rev1 can control more 3 bit for hsync.
> This patch modify this problem
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/tw9910.c |   26 +++++++++++++++++---------
>  1 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 59158bb..a688c11 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -349,6 +349,7 @@ static int tw9910_set_scale(struct i2c_client *client,
>  static int tw9910_set_hsync(struct i2c_client *client,
>  			    const u16 start, const u16 end)
>  {
> +	struct tw9910_priv *priv = to_tw9910(client);
>  	int ret;
>  
>  	/* bit 10 - 3 */
> @@ -363,15 +364,22 @@ static int tw9910_set_hsync(struct i2c_client *client,
>  	if (ret < 0)
>  		return ret;
>  
> -	/* bit 2 - 0 */
> -	ret = i2c_smbus_read_byte_data(client, HSLOWCTL);
> -	if (ret < 0)
> -		return ret;
> +	/* FIXME

Why FIXME? If this is a real distinction between hardware revisions, 
there's nothing  to fix about that?

> +	 *
> +	 * So far only revisions 0 and 1 have been seen
> +	 */
> +	if (1 == priv->rev) {
>  
> -	ret = i2c_smbus_write_byte_data(client, HSLOWCTL,
> -					(ret   & 0x88)        |
> -					(start & 0x0007) << 4 |
> -					(end   & 0x0007));
> +		/* bit 2 - 0 */
> +		ret = i2c_smbus_read_byte_data(client, HSLOWCTL);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = i2c_smbus_write_byte_data(client, HSLOWCTL,
> +						(ret   & 0x88)        |
> +						(start & 0x0007) << 4 |
> +						(end   & 0x0007));
> +	}

This looks like a perfect case for your mask_set():

		ret = tw9910_mask_set(client, HSLOWCTL, 0x77,
				      (start & 7) << 4 | (end & 7));

While at it, could you also fix that typo copied from the datasheet: 
s/HSGEGIN/HSBEGIN/g?

>  
>  	return ret;
>  }
> -- 
> 1.6.0.4

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
