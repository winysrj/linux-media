Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55312 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab2F1Jyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 05:54:51 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: RE: [PATCH v3 10/13] davinci: vpif capture:Add power management
 support
Date: Thu, 28 Jun 2012 09:54:42 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E936B23@DBDE01.ent.ti.com>
References: <1340622455-10419-1-git-send-email-manjunath.hadli@ti.com>
 <1340622455-10419-11-git-send-email-manjunath.hadli@ti.com>
 <2777370.dWcj1X6j2h@avalon>
In-Reply-To: <2777370.dWcj1X6j2h@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Jun 25, 2012 at 18:27:23, Laurent Pinchart wrote:
> Hi Manjunath,
> 
> Thank you for the patch.
> 
> On Monday 25 June 2012 16:37:32 Manjunath Hadli wrote:
> > Implement power management operations - suspend and resume as part of 
> > dev_pm_ops for VPIF capture driver.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > ---
> >  drivers/media/video/davinci/vpif_capture.c |   77 +++++++++++++++++++++----
> >  1 files changed, 65 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/media/video/davinci/vpif_capture.c
> > b/drivers/media/video/davinci/vpif_capture.c index 097e136..f1ee137 
> > 100644
> > --- a/drivers/media/video/davinci/vpif_capture.c
> > +++ b/drivers/media/video/davinci/vpif_capture.c
> > @@ -2300,26 +2300,74 @@ static int vpif_remove(struct platform_device
> > *device) return 0;
> >  }
> > 
> > +#ifdef CONFIG_PM
> >  /**
> >   * vpif_suspend: vpif device suspend
> > - *
> > - * TODO: Add suspend code here
> >   */
> > -static int
> > -vpif_suspend(struct device *dev)
> > +static int vpif_suspend(struct device *dev)
> >  {
> > -	return -1;
> > +
> > +	struct common_obj *common;
> > +	struct channel_obj *ch;
> > +	int i;
> > +
> > +	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
> > +		/* Get the pointer to the channel object */
> > +		ch = vpif_obj.dev[i];
> > +		common = &ch->common[VPIF_VIDEO_INDEX];
> > +		if (mutex_lock_interruptible(&common->lock))
> > +			return -ERESTARTSYS;
> 
> As for the display driver, this should probably be replaced by mutex_lock().
> 
  Ok, I'll replace it with mutex_lock().

Thx,
--Manju

> > +		if (ch->usrs && common->io_usrs) {
> > +			/* Disable channel */
> > +			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
> > +				enable_channel0(0);
> > +				channel0_intr_enable(0);
> > +			}
> > +			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
> > +			    common->started == 2) {
> > +				enable_channel1(0);
> > +				channel1_intr_enable(0);
> > +			}
> > +		}
> > +		mutex_unlock(&common->lock);
> > +	}
> > +
> > +	return 0;
> >  }
> > 
> > -/**
> > +/*
> >   * vpif_resume: vpif device suspend
> > - *
> > - * TODO: Add resume code here
> >   */
> > -static int
> > -vpif_resume(struct device *dev)
> > +static int vpif_resume(struct device *dev)
> >  {
> > -	return -1;
> > +	struct common_obj *common;
> > +	struct channel_obj *ch;
> > +	int i;
> > +
> > +	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
> > +		/* Get the pointer to the channel object */
> > +		ch = vpif_obj.dev[i];
> > +		common = &ch->common[VPIF_VIDEO_INDEX];
> > +		if (mutex_lock_interruptible(&common->lock))
> > +			return -ERESTARTSYS;
> > +
> > +		if (ch->usrs && common->io_usrs) {
> > +			/* Disable channel */
> > +			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
> > +				enable_channel0(1);
> > +				channel0_intr_enable(1);
> > +			}
> > +			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
> > +			    common->started == 2) {
> > +				enable_channel1(1);
> > +				channel1_intr_enable(1);
> > +			}
> > +		}
> > +		mutex_unlock(&common->lock);
> > +	}
> > +
> > +	return 0;
> >  }
> > 
> >  static const struct dev_pm_ops vpif_dev_pm_ops = { @@ -2327,11 
> > +2375,16 @@ static const struct dev_pm_ops vpif_dev_pm_ops = {
> >  	.resume = vpif_resume,
> >  };
> > 
> > +#define vpif_pm_ops (&vpif_dev_pm_ops) #else #define vpif_pm_ops NULL 
> > +#endif
> > +
> >  static __refdata struct platform_driver vpif_driver = {
> >  	.driver	= {
> >  		.name	= "vpif_capture",
> >  		.owner	= THIS_MODULE,
> > -		.pm = &vpif_dev_pm_ops,
> > +		.pm	= vpif_pm_ops,
> >  	},
> >  	.probe = vpif_probe,
> >  	.remove = vpif_remove,
> --
> Regards,
> 
> Laurent Pinchart
> 
> 

