Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABMKVhC030012
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 17:20:31 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mABMKINO014206
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 17:20:18 -0500
Date: Tue, 11 Nov 2008 23:20:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ur65inb1i.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0811112317370.8435@axis700.grange>
References: <ur65inb1i.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: khali@linux-fr.org, V4L <video4linux-list@redhat.com>,
	mchehab@infradead.org
Subject: Re: [PATCH 2/2] Change power on/off sequence on ov772x
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, 11 Nov 2008, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> This patch is based on linux-next git

Ok, this makes sense to me, but if we agree on keeping if's which you 
removed with your previous patch, then please, recode this one with if's. 
Besides, having if's in place also makes it clear, that these methods are 
optional, IMHO.

Thanks
Guennadi

> 
>  drivers/media/video/ov772x.c |   22 ++++++++++++----------
>  1 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 14a4545..8f0bc56 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -603,12 +603,20 @@ static int ov772x_reset(struct i2c_client *client)
>  
>  static int ov772x_init(struct soc_camera_device *icd)
>  {
> -	return 0;
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	int ret;
> +
> +	ret = priv->info->link.power(&priv->client->dev, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	return priv->info->link.reset(&priv->client->dev);
>  }
>  
>  static int ov772x_release(struct soc_camera_device *icd)
>  {
> -	return 0;
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +	return priv->info->link.power(&priv->client->dev, 0);
>  }
>  
>  static int ov772x_start_capture(struct soc_camera_device *icd)
> @@ -824,8 +832,6 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
>  	icd->formats     = ov772x_fmt_lists;
>  	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
>  
> -	priv->info->link.power(&priv->client->dev, 1);
> -
>  	/*
>  	 * check and show product ID and manufacturer ID
>  	 */
> @@ -833,7 +839,8 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
>  	ver = i2c_smbus_read_byte_data(priv->client, VER);
>  	if (pid != 0x77 ||
>  	    ver != 0x21) {
> -		priv->info->link.power(&priv->client->dev, 0);
> +		dev_err(&icd->dev,
> +			"Product ID error %x:%x\n", pid, ver);
>  		return -ENODEV;
>  	}
>  
> @@ -850,12 +857,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
>  
>  static void ov772x_video_remove(struct soc_camera_device *icd)
>  {
> -	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> -
>  	soc_camera_video_stop(icd);
> -
> -	priv->info->link.power(&priv->client->dev, 0);
> -
>  }
>  
>  static struct soc_camera_ops ov772x_ops = {
> -- 
> 1.5.4.3
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
