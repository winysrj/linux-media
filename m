Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBRHSiJD032444
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 12:28:44 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBRHSe2e005160
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 12:28:41 -0500
Date: Sat, 27 Dec 2008 18:28:51 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ulju3iige.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812271828360.4409@axis700.grange>
References: <ulju3iige.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] The failure of set_fmt is solved in tw9910
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

On Fri, 26 Dec 2008, Kuninori Morimoto wrote:

> 
> priv->scale is checked in start_capture.
> Therefore, it should be NULL if failing in set_fmt.
> This patch resolve this problem.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Queued.

Thanks
Guennadi

> ---
>  drivers/media/video/tw9910.c |   22 ++++++++++++++++------
>  1 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 75cfde0..d5cdc4b 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -651,7 +651,7 @@ static int tw9910_set_fmt(struct soc_camera_device *icd, __u32 pixfmt,
>  	 */
>  	priv->scale = tw9910_select_norm(icd, rect->width, rect->height);
>  	if (!priv->scale)
> -		return ret;
> +		goto tw9910_set_fmt_error;
>  
>  	/*
>  	 * reset hardware
> @@ -659,7 +659,8 @@ static int tw9910_set_fmt(struct soc_camera_device *icd, __u32 pixfmt,
>  	tw9910_reset(priv->client);
>  	ret = tw9910_write_array(priv->client, tw9910_default_regs);
>  	if (ret < 0)
> -		return ret;
> +		goto tw9910_set_fmt_error;
> +
>  	/*
>  	 * set bus width
>  	 */
> @@ -669,7 +670,7 @@ static int tw9910_set_fmt(struct soc_camera_device *icd, __u32 pixfmt,
>  
>  	ret = tw9910_mask_set(priv->client, OPFORM, LEN, val);
>  	if (ret < 0)
> -		return ret;
> +		goto tw9910_set_fmt_error;
>  
>  	/*
>  	 * select MPOUT behavior
> @@ -697,26 +698,35 @@ static int tw9910_set_fmt(struct soc_camera_device *icd, __u32 pixfmt,
>  
>  	ret = tw9910_mask_set(priv->client, VBICNTL, RTSEL_MASK, val);
>  	if (ret < 0)
> -		return ret;
> +		goto tw9910_set_fmt_error;
>  
>  	/*
>  	 * set scale
>  	 */
>  	ret = tw9910_set_scale(priv->client, priv->scale);
>  	if (ret < 0)
> -		return ret;
> +		goto tw9910_set_fmt_error;
>  
>  	/*
>  	 * set cropping
>  	 */
>  	ret = tw9910_set_cropping(priv->client, &tw9910_cropping_ctrl);
>  	if (ret < 0)
> -		return ret;
> +		goto tw9910_set_fmt_error;
>  
>  	/*
>  	 * set hsync
>  	 */
>  	ret = tw9910_set_hsync(priv->client, &tw9910_hsync_ctrl);
> +	if (ret < 0)
> +		goto tw9910_set_fmt_error;
> +
> +	return ret;
> +
> +tw9910_set_fmt_error:
> +
> +	tw9910_reset(priv->client);
> +	priv->scale = NULL;
>  
>  	return ret;
>  }
> -- 
> 1.5.6.3
> 

---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
