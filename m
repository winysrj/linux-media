Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34837 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2FYM4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 08:56:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 09/13] davinci: vpif display: Add power management support
Date: Mon, 25 Jun 2012 14:56:22 +0200
Message-ID: <1729355.CdrR2sFBDH@avalon>
In-Reply-To: <1340622455-10419-10-git-send-email-manjunath.hadli@ti.com>
References: <1340622455-10419-1-git-send-email-manjunath.hadli@ti.com> <1340622455-10419-10-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

Thank you for the patch.

On Monday 25 June 2012 16:37:31 Manjunath Hadli wrote:
> Implement power management operations - suspend and resume as part of
> dev_pm_ops for VPIF display driver.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> ---
>  drivers/media/video/davinci/vpif_display.c |   75 +++++++++++++++++++++++++
>  1 files changed, 75 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpif_display.c
> b/drivers/media/video/davinci/vpif_display.c index 4436ef6..7408733 100644
> --- a/drivers/media/video/davinci/vpif_display.c
> +++ b/drivers/media/video/davinci/vpif_display.c
> @@ -1807,10 +1807,85 @@ static int vpif_remove(struct platform_device
> *device) return 0;
>  }
> 
> +#ifdef CONFIG_PM
> +static int vpif_suspend(struct device *dev)
> +{
> +	struct common_obj *common;
> +	struct channel_obj *ch;
> +	int i;
> +
> +	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
> +		/* Get the pointer to the channel object */
> +		ch = vpif_obj.dev[i];
> +		common = &ch->common[VPIF_VIDEO_INDEX];
> +		if (mutex_lock_interruptible(&common->lock))
> +			return -ERESTARTSYS;

I might be wrong, but I don't think the suspend/resume handlers react 
correctly to -ERESTARTSYS. If that's correct you should use mutex_lock() 
instead of mutex_lock_interruptible().

> +
> +		if (atomic_read(&ch->usrs) && common->io_usrs) {
> +			/* Disable channel */
> +			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
> +				enable_channel2(0);
> +				channel2_intr_enable(0);
> +			}
> +			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
> +					common->started == 2) {
> +				enable_channel3(0);
> +				channel3_intr_enable(0);
> +			}
> +		}
> +		mutex_unlock(&common->lock);
> +	}
> +
> +	return 0;
> +}
> +
> +static int vpif_resume(struct device *dev)
> +{
> +
> +	struct common_obj *common;
> +	struct channel_obj *ch;
> +	int i;
> +
> +	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
> +		/* Get the pointer to the channel object */
> +		ch = vpif_obj.dev[i];
> +		common = &ch->common[VPIF_VIDEO_INDEX];
> +		if (mutex_lock_interruptible(&common->lock))
> +			return -ERESTARTSYS;
> +
> +		if (atomic_read(&ch->usrs) && common->io_usrs) {
> +			/* Enable channel */
> +			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
> +				enable_channel2(1);
> +				channel2_intr_enable(1);
> +			}
> +			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
> +					common->started == 2) {
> +				enable_channel3(1);
> +				channel3_intr_enable(1);
> +			}
> +		}
> +		mutex_unlock(&common->lock);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops vpif_pm = {
> +	.suspend        = vpif_suspend,
> +	.resume         = vpif_resume,
> +};
> +
> +#define vpif_pm_ops (&vpif_pm)
> +#else
> +#define vpif_pm_ops NULL
> +#endif
> +
>  static __refdata struct platform_driver vpif_driver = {
>  	.driver	= {
>  			.name	= "vpif_display",
>  			.owner	= THIS_MODULE,
> +			.pm	= vpif_pm_ops,
>  	},
>  	.probe	= vpif_probe,
>  	.remove	= vpif_remove,
-- 
Regards,

Laurent Pinchart

