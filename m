Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33365 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbZKRP76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 10:59:58 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Date: Wed, 18 Nov 2009 21:29:54 +0530
Subject: RE: [PATCH V2] VPFE Capture: Add call back function for interrupt
 clear to vpfe_cfg
Message-ID: <19F8576C6E063C45BE387C64729E7394043702BAC3@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1258559569-1056-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1258559569-1056-1-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hiremath, Vaibhav
> Sent: Wednesday, November 18, 2009 9:23 PM
> To: linux-media@vger.kernel.org
> Cc: hverkuil@xs4all.nl; Karicheri, Muralidharan; Hiremath, Vaibhav
> Subject: [PATCH V2] VPFE Capture: Add call back function for
> interrupt clear to vpfe_cfg
> 
[Hiremath, Vaibhav] Hi Hans and others,

I think I have cleaned up all my VPFE patches today, Can you merge it to your repo. Below is the list - 

[PATCH V2] VPFE Capture: Add call back function for interrupt clear to vpfe_cfg

[PATCH] Davinci VPFE Capture: Add Suspend/Resume Support

[PATCH] DM644x CCDC: Add 10bit BT support


Patches still open -

- Can you comment on the patch "[PATCH] Introducing ti-media directory"?
If all are agree to this then I can move other files to this directory.

- Switch to automode in query_std, I think at the end we mentioned that, if we can put a constraint on application that, user can not query_std when streaming is going on, it should be fine. Can I resubmit the patch?

Thanks,
Vaibhav



> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> For the devices like AM3517, it is expected that driver clears the
> interrupt in ISR. Since this is device spcific, callback function
> added to the platform_data.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  drivers/media/video/davinci/vpfe_capture.c |   24
> ++++++++++++++++++++----
>  include/media/davinci/vpfe_capture.h       |    2 ++
>  2 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpfe_capture.c
> b/drivers/media/video/davinci/vpfe_capture.c
> index 9b6b254..46e2939 100644
> --- a/drivers/media/video/davinci/vpfe_capture.c
> +++ b/drivers/media/video/davinci/vpfe_capture.c
> @@ -563,6 +563,11 @@ static int vpfe_initialize_device(struct
> vpfe_device *vpfe_dev)
>  	ret = ccdc_dev->hw_ops.open(vpfe_dev->pdev);
>  	if (!ret)
>  		vpfe_dev->initialized = 1;
> +
> +	/* Clear all VPFE/CCDC interrupts */
> +	if (vpfe_dev->cfg->clr_intr)
> +		vpfe_dev->cfg->clr_intr(-1);
> +
>  unlock:
>  	mutex_unlock(&ccdc_lock);
>  	return ret;
> @@ -664,7 +669,7 @@ static irqreturn_t vpfe_isr(int irq, void
> *dev_id)
> 
>  	/* if streaming not started, don't do anything */
>  	if (!vpfe_dev->started)
> -		return IRQ_HANDLED;
> +		goto clear_intr;
> 
>  	/* only for 6446 this will be applicable */
>  	if (NULL != ccdc_dev->hw_ops.reset)
> @@ -676,7 +681,7 @@ static irqreturn_t vpfe_isr(int irq, void
> *dev_id)
>  			"frame format is progressive...\n");
>  		if (vpfe_dev->cur_frm != vpfe_dev->next_frm)
>  			vpfe_process_buffer_complete(vpfe_dev);
> -		return IRQ_HANDLED;
> +		goto clear_intr;
>  	}
> 
>  	/* interlaced or TB capture check which field we are in
> hardware */
> @@ -703,7 +708,7 @@ static irqreturn_t vpfe_isr(int irq, void
> *dev_id)
>  			if (field == V4L2_FIELD_SEQ_TB)
>  				vpfe_schedule_bottom_field(vpfe_dev);
> 
> -			return IRQ_HANDLED;
> +			goto clear_intr;
>  		}
>  		/*
>  		 * if one field is just being captured configure
> @@ -723,6 +728,10 @@ static irqreturn_t vpfe_isr(int irq, void
> *dev_id)
>  		 */
>  		vpfe_dev->field_id = fid;
>  	}
> +clear_intr:
> +	if (vpfe_dev->cfg->clr_intr)
> +		vpfe_dev->cfg->clr_intr(irq);
> +
>  	return IRQ_HANDLED;
>  }
> 
> @@ -734,8 +743,11 @@ static irqreturn_t vdint1_isr(int irq, void
> *dev_id)
>  	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nInside
> vdint1_isr...\n");
> 
>  	/* if streaming not started, don't do anything */
> -	if (!vpfe_dev->started)
> +	if (!vpfe_dev->started) {
> +		if (vpfe_dev->cfg->clr_intr)
> +			vpfe_dev->cfg->clr_intr(irq);
>  		return IRQ_HANDLED;
> +	}
> 
>  	spin_lock(&vpfe_dev->dma_queue_lock);
>  	if ((vpfe_dev->fmt.fmt.pix.field == V4L2_FIELD_NONE) &&
> @@ -743,6 +755,10 @@ static irqreturn_t vdint1_isr(int irq, void
> *dev_id)
>  	    vpfe_dev->cur_frm == vpfe_dev->next_frm)
>  		vpfe_schedule_next_buffer(vpfe_dev);
>  	spin_unlock(&vpfe_dev->dma_queue_lock);
> +
> +	if (vpfe_dev->cfg->clr_intr)
> +		vpfe_dev->cfg->clr_intr(irq);
> +
>  	return IRQ_HANDLED;
>  }
> 
> diff --git a/include/media/davinci/vpfe_capture.h
> b/include/media/davinci/vpfe_capture.h
> index fc83d98..5a21265 100644
> --- a/include/media/davinci/vpfe_capture.h
> +++ b/include/media/davinci/vpfe_capture.h
> @@ -104,6 +104,8 @@ struct vpfe_config {
>  	char *ccdc;
>  	/* setup function for the input path */
>  	int (*setup_input)(enum vpfe_subdev_id id);
> +	/* Function for Clearing the interrupt */
> +	void (*clr_intr)(int vdint);
>  	/* number of clocks */
>  	int num_clocks;
>  	/* clocks used for vpfe capture */
> --
> 1.6.2.4

