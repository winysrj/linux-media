Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:57299 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935243AbdKPPtM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 10:49:12 -0500
Received: by mail-lf0-f66.google.com with SMTP id g35so16442452lfi.13
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 07:49:11 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 16 Nov 2017 16:49:09 +0100
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 2/2] v4l: rcar-vin: Wait for device access to
 complete before unplugging
Message-ID: <20171116154909.GO12677@bigcity.dyn.berto.se>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171116003349.19235-3-laurent.pinchart+renesas@ideasonboard.com>
 <20171116123624.swjichq5hcywaht4@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171116123624.swjichq5hcywaht4@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 2017-11-16 14:36:24 +0200, Sakari Ailus wrote:
> On Thu, Nov 16, 2017 at 02:33:49AM +0200, Laurent Pinchart wrote:
> > To avoid races between device access and unplug, call the
> > video_device_unplug() function in the platform driver remove handler.
> > This will unsure that all device access completes before the remove
> > handler proceeds to free resources.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index bd7976efa1fb..c5210f1d09ed 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -1273,6 +1273,7 @@ static int rcar_vin_remove(struct platform_device *pdev)
> >  
> >  	pm_runtime_disable(&pdev->dev);
> >  
> > +	video_device_unplug(&vin->vdev);
> 
> Does this depend on another patch?

I believe this patch is on top of the R-Car VIN Gen3 enablement series.

> 
> >  
> >  	if (!vin->info->use_mc) {
> >  		v4l2_async_notifier_unregister(&vin->notifier);
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> 
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

-- 
Regards,
Niklas Söderlund
