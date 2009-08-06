Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n768DT4a030571
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 04:13:29 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n768D7lb006647
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 04:13:08 -0400
Date: Thu, 6 Aug 2009 10:13:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uy6pxephb.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0908061012310.4631@axis700.grange>
References: <uy6pxephb.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/2 v2] sh_mobile_ceu: add soft reset function
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

On Thu, 6 Aug 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Ok, I'm away for a week starting today, I'll have a look at your patches 
after I come back then.

Thanks
Guennadi

> ---
> v1 -> v2
> 
> o it use msleep
> o it judge in_atomic or not
> 
> it judge in_atomic because sh_mobile_ceu_soft_reset
> will also be called from atomic.
> 
>  drivers/media/video/sh_mobile_ceu_camera.c |   36 ++++++++++++++++++++++++---
>  1 files changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 0db88a5..3741ad6 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -135,6 +135,36 @@ static u32 ceu_read(struct sh_mobile_ceu_dev *priv, unsigned long reg_offs)
>  	return ioread32(priv->base + reg_offs);
>  }
>  
> +static void sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
> +{
> +	int t;
> +	int atomic = in_atomic();
> +
> +	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
> +
> +	t = 10000;
> +	while (t--) {
> +		if (!(ceu_read(pcdev, CAPSR) & (1 << 16)))
> +			break;
> +
> +		if (atomic)
> +			cpu_relax();
> +		else
> +			msleep(1);
> +	}
> +
> +	t = 10000;
> +	while (t--) {
> +		if (!(ceu_read(pcdev, CSTSR) & 1))
> +			break;
> +
> +		if (atomic)
> +			cpu_relax();
> +		else
> +			msleep(1);
> +	}
> +}
> +
>  /*
>   *  Videobuf operations
>   */
> @@ -366,9 +396,7 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
>  
>  	clk_enable(pcdev->clk);
>  
> -	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
> -	while (ceu_read(pcdev, CSTSR) & 1)
> -		msleep(1);
> +	sh_mobile_ceu_soft_reset(pcdev);
>  
>  	pcdev->icd = icd;
>  err:
> @@ -386,7 +414,7 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
>  
>  	/* disable capture, disable interrupts */
>  	ceu_write(pcdev, CEIER, 0);
> -	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
> +	sh_mobile_ceu_soft_reset(pcdev);
>  
>  	/* make sure active buffer is canceled */
>  	spin_lock_irqsave(&pcdev->lock, flags);
> -- 
> 1.6.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
