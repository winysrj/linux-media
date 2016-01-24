Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58461 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbcAXQ7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2016 11:59:01 -0500
Date: Sun, 24 Jan 2016 17:58:24 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <rainyfeeling@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>
Subject: Re: [PATCH 06/13] atmel-isi: check ISI_SR's flags by polling instead
 of interrupt
In-Reply-To: <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
Message-ID: <Pine.LNX.4.64.1601241757340.16570@axis700.grange>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jan 2016, Josh Wu wrote:

> In current code, we use a interrupt to check whether ISI reset/disable
> action is done. Actually, we also can check ISI SR to check the
> reset/disable action by polling, and it is simpler and straight forward.
> 
> So this patch use isi_hw_wait_status() to check the action status. As
> the interrupt checking the status is useless, so just remove the interrupt
> & completion code.

Sorry, I'm not convinced. Switching from interrupt-driven to polling seems 
counter-productive to me. Why do you want this?

Thanks
Guennadi

> 
> Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
> ---
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 59 ++++++---------------------
>  1 file changed, 13 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index f0508ea..4ddc309 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -12,7 +12,6 @@
>   */
>  
>  #include <linux/clk.h>
> -#include <linux/completion.h>
>  #include <linux/delay.h>
>  #include <linux/fs.h>
>  #include <linux/init.h>
> @@ -81,7 +80,6 @@ struct atmel_isi {
>  	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
>  	bool				enable_preview_path;
>  
> -	struct completion		complete;
>  	/* ISI peripherial clock */
>  	struct clk			*pclk;
>  	unsigned int			irq;
> @@ -281,51 +279,14 @@ static irqreturn_t isi_interrupt(int irq, void *dev_id)
>  	mask = isi_readl(isi, ISI_INTMASK);
>  	pending = status & mask;
>  
> -	if (pending & ISI_CTRL_SRST) {
> -		complete(&isi->complete);
> -		isi_writel(isi, ISI_INTDIS, ISI_CTRL_SRST);
> -		ret = IRQ_HANDLED;
> -	} else if (pending & ISI_CTRL_DIS) {
> -		complete(&isi->complete);
> -		isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
> -		ret = IRQ_HANDLED;
> -	} else {
> -		if (likely(pending & ISI_SR_CXFR_DONE) ||
> -				likely(pending & ISI_SR_PXFR_DONE))
> -			ret = atmel_isi_handle_streaming(isi);
> -	}
> +	if (likely(pending & ISI_SR_CXFR_DONE) ||
> +	    likely(pending & ISI_SR_PXFR_DONE))
> +		ret = atmel_isi_handle_streaming(isi);
>  
>  	spin_unlock(&isi->lock);
>  	return ret;
>  }
>  
> -#define	WAIT_ISI_RESET		1
> -#define	WAIT_ISI_DISABLE	0
> -static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
> -{
> -	unsigned long timeout;
> -	/*
> -	 * The reset or disable will only succeed if we have a
> -	 * pixel clock from the camera.
> -	 */
> -	init_completion(&isi->complete);
> -
> -	if (wait_reset) {
> -		isi_writel(isi, ISI_INTEN, ISI_CTRL_SRST);
> -		isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
> -	} else {
> -		isi_writel(isi, ISI_INTEN, ISI_CTRL_DIS);
> -		isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> -	}
> -
> -	timeout = wait_for_completion_timeout(&isi->complete,
> -			msecs_to_jiffies(500));
> -	if (timeout == 0)
> -		return -ETIMEDOUT;
> -
> -	return 0;
> -}
> -
>  /* ------------------------------------------------------------------
>  	Videobuf operations
>     ------------------------------------------------------------------*/
> @@ -493,8 +454,11 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  	pm_runtime_get_sync(ici->v4l2_dev.dev);
>  
>  	/* Reset ISI */
> -	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
> -	if (ret < 0) {
> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
> +
> +	/* Check Reset status */
> +	ret  = isi_hw_wait_status(isi, ISI_CTRL_SRST, 500);
> +	if (ret) {
>  		dev_err(icd->parent, "Reset ISI timed out\n");
>  		pm_runtime_put(ici->v4l2_dev.dev);
>  		return ret;
> @@ -549,8 +513,11 @@ static void stop_streaming(struct vb2_queue *vq)
>  			ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
>  
>  	/* Disable ISI and wait for it is done */
> -	ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
> -	if (ret < 0)
> +	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> +
> +	/* Check Reset status */
> +	ret  = isi_hw_wait_status(isi, ISI_CTRL_DIS, 500);
> +	if (ret)
>  		dev_err(icd->parent, "Disable ISI timed out\n");
>  
>  	pm_runtime_put(ici->v4l2_dev.dev);
> -- 
> 1.9.1
> 
