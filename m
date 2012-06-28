Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:49978 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519Ab2F1J4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 05:56:32 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: RE: [PATCH v3 09/13] davinci: vpif display: Add power management
 support
Date: Thu, 28 Jun 2012 09:56:26 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E936B30@DBDE01.ent.ti.com>
References: <1340622455-10419-1-git-send-email-manjunath.hadli@ti.com>
 <1340622455-10419-10-git-send-email-manjunath.hadli@ti.com>
 <1729355.CdrR2sFBDH@avalon>
In-Reply-To: <1729355.CdrR2sFBDH@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Jun 25, 2012 at 18:26:22, Laurent Pinchart wrote:
> Hi Manjunath,
> 
> Thank you for the patch.
> 
> On Monday 25 June 2012 16:37:31 Manjunath Hadli wrote:
> > Implement power management operations - suspend and resume as part of
> > dev_pm_ops for VPIF display driver.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > ---
> >  drivers/media/video/davinci/vpif_display.c |   75 +++++++++++++++++++++++++
> >  1 files changed, 75 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/davinci/vpif_display.c
> > b/drivers/media/video/davinci/vpif_display.c index 4436ef6..7408733 100644
> > --- a/drivers/media/video/davinci/vpif_display.c
> > +++ b/drivers/media/video/davinci/vpif_display.c
> > @@ -1807,10 +1807,85 @@ static int vpif_remove(struct platform_device
> > *device) return 0;
> >  }
> > 
> > +#ifdef CONFIG_PM
> > +static int vpif_suspend(struct device *dev)
> > +{
> > +	struct common_obj *common;
> > +	struct channel_obj *ch;
> > +	int i;
> > +
> > +	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
> > +		/* Get the pointer to the channel object */
> > +		ch = vpif_obj.dev[i];
> > +		common = &ch->common[VPIF_VIDEO_INDEX];
> > +		if (mutex_lock_interruptible(&common->lock))
> > +			return -ERESTARTSYS;
> 
> I might be wrong, but I don't think the suspend/resume handlers react 
> correctly to -ERESTARTSYS. If that's correct you should use mutex_lock() 
> instead of mutex_lock_interruptible().
> 
  I'll replace it with mutex_lock().

Thx,
--Manju

> > +
> > +		if (atomic_read(&ch->usrs) && common->io_usrs) {
> > +			/* Disable channel */
> > +			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
> > +				enable_channel2(0);
> > +				channel2_intr_enable(0);
> > +			}
> > +			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
> > +					common->started == 2) {
> > +				enable_channel3(0);
> > +				channel3_intr_enable(0);
> > +			}
> > +		}
> > +		mutex_unlock(&common->lock);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int vpif_resume(struct device *dev)
> > +{
> > +
> > +	struct common_obj *common;
> > +	struct channel_obj *ch;
> > +	int i;
> > +
> > +	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
> > +		/* Get the pointer to the channel object */
> > +		ch = vpif_obj.dev[i];
> > +		common = &ch->common[VPIF_VIDEO_INDEX];
> > +		if (mutex_lock_interruptible(&common->lock))
> > +			return -ERESTARTSYS;
> > +
> > +		if (atomic_read(&ch->usrs) && common->io_usrs) {
> > +			/* Enable channel */
> > +			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
> > +				enable_channel2(1);
> > +				channel2_intr_enable(1);
> > +			}
> > +			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
> > +					common->started == 2) {
> > +				enable_channel3(1);
> > +				channel3_intr_enable(1);
> > +			}
> > +		}
> > +		mutex_unlock(&common->lock);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct dev_pm_ops vpif_pm = {
> > +	.suspend        = vpif_suspend,
> > +	.resume         = vpif_resume,
> > +};
> > +
> > +#define vpif_pm_ops (&vpif_pm)
> > +#else
> > +#define vpif_pm_ops NULL
> > +#endif
> > +
> >  static __refdata struct platform_driver vpif_driver = {
> >  	.driver	= {
> >  			.name	= "vpif_display",
> >  			.owner	= THIS_MODULE,
> > +			.pm	= vpif_pm_ops,
> >  	},
> >  	.probe	= vpif_probe,
> >  	.remove	= vpif_remove,
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

