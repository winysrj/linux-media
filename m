Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n7Q8xt3h013856
	for <video4linux-list@redhat.com>; Wed, 26 Aug 2009 04:59:55 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n7Q8xdZl006097
	for <video4linux-list@redhat.com>; Wed, 26 Aug 2009 04:59:40 -0400
Date: Wed, 26 Aug 2009 10:59:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <u1vnorpbi.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0908261053050.5167@axis700.grange>
References: <u1vnorpbi.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/2 v3] sh_mobile_ceu: add soft reset function
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

Hi Morimoto-san

On Fri, 7 Aug 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

I've updated both your patches on the top of my current tree and slightly 
cleaned them up - mainly multi-line comments. Also fixed one error in 
sh_mobile_ceu_add_device() (see below). Please, check if the stack at 
http://download.open-technology.de/soc-camera/20090826/ looks ok and still 
works for you. As usual, you find instructions on which tree and branch to 
use in 0000-base.

> ---
> v2 -> v3
> 
> o use udelay instead
> o return err value
> o print warning if time out
> 
>  drivers/media/video/sh_mobile_ceu_camera.c |   42 ++++++++++++++++++++++++---
>  1 files changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 0db88a5..24f3d28 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -135,6 +135,40 @@ static u32 ceu_read(struct sh_mobile_ceu_dev *priv, unsigned long reg_offs)
>  	return ioread32(priv->base + reg_offs);
>  }
>  
> +static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
> +{
> +	int i, success = 0;
> +	struct soc_camera_device *icd = pcdev->icd;
> +
> +	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
> +
> +	/* wait CSTSR.CPTON bit */
> +	for (i = 0; i < 1000; i++) {
> +		if (!(ceu_read(pcdev, CSTSR) & 1)) {
> +			success++;
> +			break;
> +		}
> +		udelay(1);
> +	}
> +
> +	/* wait CAPSR.CPKIL bit */
> +	for (i = 0; i < 1000; i++) {
> +		if (!(ceu_read(pcdev, CAPSR) & (1 << 16))) {
> +			success++;
> +			break;
> +		}
> +		udelay(1);
> +	}
> +
> +
> +	if (2 != success) {
> +		dev_warn(&icd->dev, "soft reset time out\n");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   *  Videobuf operations
>   */
> @@ -366,11 +400,9 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
>  
>  	clk_enable(pcdev->clk);
>  
> -	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
> -	while (ceu_read(pcdev, CSTSR) & 1)
> -		msleep(1);
> -
>  	pcdev->icd = icd;
> +
> +	ret = sh_mobile_ceu_soft_reset(pcdev);
>  err:
>  	return ret;

This means, even in error case you'd have "pcdev->icd = icd" and a 
repeated call to sh_mobile_ceu_add_device() would return -EBUSY. I fixed 
this in my version.

>  }
> @@ -386,7 +418,7 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
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

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
