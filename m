Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n74Guf9I019765
	for <video4linux-list@redhat.com>; Tue, 4 Aug 2009 12:56:41 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n74GtuX2012758
	for <video4linux-list@redhat.com>; Tue, 4 Aug 2009 12:55:57 -0400
Date: Tue, 4 Aug 2009 18:56:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <umy6f52sb.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0908041833470.7572@axis700.grange>
References: <umy6f52sb.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] sh_mobile_ceu_camera: add VBP error cure operation
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

Hello Morimoto-san

A couple of notes to your patch:

On Tue, 4 Aug 2009, Kuninori Morimoto wrote:

> If CEU driver can not receive data from camera,
> CETCR has VBP error state.
> Then, CEU is stopped and cure operation is needed.
> This patch add VBP error cure operation.
> Special thanks to Magnus
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |   33 +++++++++++++++++++++------
>  1 files changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 0db88a5..7ce78a3 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -182,26 +182,42 @@ static void free_buffer(struct videobuf_queue *vq,
>  #define CEU_CETCR_MAGIC 0x0317f313 /* acknowledge magical interrupt sources */
>  #define CEU_CETCR_IGRW (1 << 4) /* prohibited register access interrupt bit */
>  #define CEU_CEIER_CPEIE (1 << 0) /* one-frame capture end interrupt */
> +#define CEU_CEIER_VBP   (1 << 20) /* vbp error */
>  #define CEU_CAPCR_CTNCP (1 << 16) /* continuous capture mode (if set) */
> +#define CEU_CEIER_MASK (CEU_CEIER_CPEIE | CEU_CEIER_VBP)
>  
>  

I think, it would be good to add a coment here, explaining, that the 
return code doesn't reflex the success or failure to queue the new buffer, 
but rather the status of the previous buffer, if any.

> -static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
> +static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  {
>  	struct soc_camera_device *icd = pcdev->icd;
>  	dma_addr_t phys_addr_top, phys_addr_bottom;
> +	u32 status;
> +	int ret = 0;
>  
>  	/* The hardware is _very_ picky about this sequence. Especially
>  	 * the CEU_CETCR_MAGIC value. It seems like we need to acknowledge
>  	 * several not-so-well documented interrupt sources in CETCR.
>  	 */
> -	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~CEU_CEIER_CPEIE);
> -	ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & CEU_CETCR_MAGIC);
> -	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | CEU_CEIER_CPEIE);
> +	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~CEU_CEIER_MASK);
> +	status = ceu_read(pcdev, CETCR);
> +	ceu_write(pcdev, CETCR, ~status & CEU_CETCR_MAGIC);
> +	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | CEU_CEIER_MASK);
>  	ceu_write(pcdev, CAPCR, ceu_read(pcdev, CAPCR) & ~CEU_CAPCR_CTNCP);
>  	ceu_write(pcdev, CETCR, CEU_CETCR_MAGIC ^ CEU_CETCR_IGRW);
>  
> +	/* VBP error */
> +	if (status & CEU_CEIER_VBP) {
> +		/* soft reset */
> +		ceu_write(pcdev, CAPSR, 1 << 16);
> +		while ((1 << 16) & ceu_read(pcdev, CAPSR))
> +			cpu_relax();
> +		while (ceu_read(pcdev, CSTSR) & 1)
> +			cpu_relax();

Let's put some security in these loops - please, add some counter to them. 
Even more importantly, since these loops are also run in IRQ.

> +		ret = -1;

I see, that this ret value is only used internally, still, I think it 
would look better with some -E... errno code.

> +	}
> +
>  	if (!pcdev->active)
> -		return;
> +		return ret;
>  
>  	phys_addr_top = videobuf_to_dma_contig(pcdev->active);
>  	ceu_write(pcdev, CDAYR, phys_addr_top);
> @@ -225,6 +241,8 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  
>  	pcdev->active->state = VIDEOBUF_ACTIVE;
>  	ceu_write(pcdev, CAPSR, 0x1); /* start capture */
> +
> +	return ret;
>  }
>  
>  static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
> @@ -335,9 +353,8 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)

The IRQ handler will exit immediately, if there is no active video buffer, 
without entering sh_mobile_ceu_capture(). Are we sure, that this VBP 
condition cannot happen then?

>  	else
>  		pcdev->active = NULL;
>  
> -	sh_mobile_ceu_capture(pcdev);
> -
> -	vb->state = VIDEOBUF_DONE;
> +	vb->state = sh_mobile_ceu_capture(pcdev) == 0 ?
> +		VIDEOBUF_DONE : VIDEOBUF_ERROR;
>  	do_gettimeofday(&vb->ts);
>  	vb->field_count++;
>  	wake_up(&vb->done);
> -- 
> 1.6.0.4

sh_mobile_ceu_capture() is also called from 
sh_mobile_ceu_videobuf_queue(), maybe just add a small comment there 
explaining, that we're not interested in the return code here, since there 
were no active buffer at that moment.

Last question - do you agree to queue this patch (after you address my 
comments) for 2.6.32 or would you prefer to get it in for 2.6.31 as a 
bug-fix?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
