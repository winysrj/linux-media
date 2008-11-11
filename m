Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABMCufs025979
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 17:12:56 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mABMCBOM009738
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 17:12:11 -0500
Date: Tue, 11 Nov 2008 23:12:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uskpynb3h.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0811112308280.8435@axis700.grange>
References: <uskpynb3h.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: khali@linux-fr.org, V4L <video4linux-list@redhat.com>,
	mchehab@infradead.org
Subject: Re: [PATCH 1/2] Add dumy power function for ov772x
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

> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Why? Is the only reason to remove if's? If so, then look here:

> ---
>  drivers/media/video/ov772x.c |   24 ++++++++++++++++++------
>  1 files changed, 18 insertions(+), 6 deletions(-)

                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I don't think this makes the driver any more optimal / readable, in short, 
sorry, I don't understand why this is needed. So, unless you (or someone 
else) provide a good reason for this, I would reject it. Besides,

> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 0af2ca6..14a4545 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -554,6 +554,16 @@ static const struct ov772x_win_size ov772x_win_qvga = {
>   * general function
>   */
>  
> +static int ov772x_dumy_power(struct device *dev, int mode)

you have typos in the spelling of "dummy."

Thanks
Guennadi

> +{
> +	return 0;
> +}
> +
> +static int ov772x_dumy_reset(struct device *dev)
> +{
> +	return 0;
> +}
> +
>  static int ov772x_write_array(struct i2c_client        *client,
>  			      const struct regval_list *vals)
>  {
> @@ -814,8 +824,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
>  	icd->formats     = ov772x_fmt_lists;
>  	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
>  
> -	if (priv->info->link.power)
> -		priv->info->link.power(&priv->client->dev, 1);
> +	priv->info->link.power(&priv->client->dev, 1);
>  
>  	/*
>  	 * check and show product ID and manufacturer ID
> @@ -824,8 +833,7 @@ static int ov772x_video_probe(struct soc_camera_device *icd)
>  	ver = i2c_smbus_read_byte_data(priv->client, VER);
>  	if (pid != 0x77 ||
>  	    ver != 0x21) {
> -		if (priv->info->link.power)
> -			priv->info->link.power(&priv->client->dev, 0);
> +		priv->info->link.power(&priv->client->dev, 0);
>  		return -ENODEV;
>  	}
>  
> @@ -846,8 +854,7 @@ static void ov772x_video_remove(struct soc_camera_device *icd)
>  
>  	soc_camera_video_stop(icd);
>  
> -	if (priv->info->link.power)
> -		priv->info->link.power(&priv->client->dev, 0);
> +	priv->info->link.power(&priv->client->dev, 0);
>  
>  }
>  
> @@ -909,6 +916,11 @@ static int ov772x_probe(struct i2c_client *client,
>  	icd->height_max = MAX_HEIGHT;
>  	icd->iface      = priv->info->link.bus_id;
>  
> +	if (!info->link.power)
> +		info->link.power = ov772x_dumy_power;
> +	if (!info->link.reset)
> +		info->link.reset = ov772x_dumy_reset;
> +
>  	ret = soc_camera_device_register(icd);
>  
>  	if (ret)
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
