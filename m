Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36522 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2FYM5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 08:57:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 10/13] davinci: vpif capture:Add power management support
Date: Mon, 25 Jun 2012 14:57:23 +0200
Message-ID: <2777370.dWcj1X6j2h@avalon>
In-Reply-To: <1340622455-10419-11-git-send-email-manjunath.hadli@ti.com>
References: <1340622455-10419-1-git-send-email-manjunath.hadli@ti.com> <1340622455-10419-11-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

Thank you for the patch.

On Monday 25 June 2012 16:37:32 Manjunath Hadli wrote:
> Implement power management operations - suspend and resume as part of
> dev_pm_ops for VPIF capture driver.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> ---
>  drivers/media/video/davinci/vpif_capture.c |   77 +++++++++++++++++++++----
>  1 files changed, 65 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpif_capture.c
> b/drivers/media/video/davinci/vpif_capture.c index 097e136..f1ee137 100644
> --- a/drivers/media/video/davinci/vpif_capture.c
> +++ b/drivers/media/video/davinci/vpif_capture.c
> @@ -2300,26 +2300,74 @@ static int vpif_remove(struct platform_device
> *device) return 0;
>  }
> 
> +#ifdef CONFIG_PM
>  /**
>   * vpif_suspend: vpif device suspend
> - *
> - * TODO: Add suspend code here
>   */
> -static int
> -vpif_suspend(struct device *dev)
> +static int vpif_suspend(struct device *dev)
>  {
> -	return -1;
> +
> +	struct common_obj *common;
> +	struct channel_obj *ch;
> +	int i;
> +
> +	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
> +		/* Get the pointer to the channel object */
> +		ch = vpif_obj.dev[i];
> +		common = &ch->common[VPIF_VIDEO_INDEX];
> +		if (mutex_lock_interruptible(&common->lock))
> +			return -ERESTARTSYS;

As for the display driver, this should probably be replaced by mutex_lock().

> +		if (ch->usrs && common->io_usrs) {
> +			/* Disable channel */
> +			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
> +				enable_channel0(0);
> +				channel0_intr_enable(0);
> +			}
> +			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
> +			    common->started == 2) {
> +				enable_channel1(0);
> +				channel1_intr_enable(0);
> +			}
> +		}
> +		mutex_unlock(&common->lock);
> +	}
> +
> +	return 0;
>  }
> 
> -/**
> +/*
>   * vpif_resume: vpif device suspend
> - *
> - * TODO: Add resume code here
>   */
> -static int
> -vpif_resume(struct device *dev)
> +static int vpif_resume(struct device *dev)
>  {
> -	return -1;
> +	struct common_obj *common;
> +	struct channel_obj *ch;
> +	int i;
> +
> +	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
> +		/* Get the pointer to the channel object */
> +		ch = vpif_obj.dev[i];
> +		common = &ch->common[VPIF_VIDEO_INDEX];
> +		if (mutex_lock_interruptible(&common->lock))
> +			return -ERESTARTSYS;
> +
> +		if (ch->usrs && common->io_usrs) {
> +			/* Disable channel */
> +			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
> +				enable_channel0(1);
> +				channel0_intr_enable(1);
> +			}
> +			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
> +			    common->started == 2) {
> +				enable_channel1(1);
> +				channel1_intr_enable(1);
> +			}
> +		}
> +		mutex_unlock(&common->lock);
> +	}
> +
> +	return 0;
>  }
> 
>  static const struct dev_pm_ops vpif_dev_pm_ops = {
> @@ -2327,11 +2375,16 @@ static const struct dev_pm_ops vpif_dev_pm_ops = {
>  	.resume = vpif_resume,
>  };
> 
> +#define vpif_pm_ops (&vpif_dev_pm_ops)
> +#else
> +#define vpif_pm_ops NULL
> +#endif
> +
>  static __refdata struct platform_driver vpif_driver = {
>  	.driver	= {
>  		.name	= "vpif_capture",
>  		.owner	= THIS_MODULE,
> -		.pm = &vpif_dev_pm_ops,
> +		.pm	= vpif_pm_ops,
>  	},
>  	.probe = vpif_probe,
>  	.remove = vpif_remove,
-- 
Regards,

Laurent Pinchart

