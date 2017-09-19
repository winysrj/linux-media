Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:54540 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751503AbdISMlm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:41:42 -0400
Date: Tue, 19 Sep 2017 15:41:38 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing
 fwnode endpoints
Message-ID: <20170919124138.scdpj7ebdoimb34j@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-7-sakari.ailus@linux.intel.com>
 <1555926.RTv2yyCEgl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555926.RTv2yyCEgl@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!

On Tue, Sep 19, 2017 at 02:40:29PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 15 September 2017 17:17:05 EEST Sakari Ailus wrote:
> > Instead of using driver implementation, use
> 
> Did you mean s/using driver implementation/using a driver implementation/ (or 
> perhaps "custom driver implementation") ?

I think "custom driver implementation" best describes this. I'll use it.

> 
> > v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoints
> > of the device.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/platform/omap3isp/isp.c | 115 ++++++++++---------------------
> >  drivers/media/platform/omap3isp/isp.h |   5 +-
> >  2 files changed, 37 insertions(+), 83 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 1a428fe9f070..a546cf774d40
> > 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> 
> [snip]
> 
> > @@ -2256,7 +2210,9 @@ static int isp_probe(struct platform_device *pdev)
> >  	if (ret)
> >  		return ret;
> > 
> > -	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> > +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> > +		isp_fwnode_parse);
> >  	if (ret < 0)
> 
> The documentation in patch 05/25 states that v4l2_async_notifier_release() 
> should be called even if v4l2_async_notifier_parse_fwnode_endpoints() fails. I 
> don't think that's needed here, so you might want to update the documentation 
> (and possibly the implementation of the function).
> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

> 
> >  		return ret;
> > 
> > @@ -2407,6 +2363,7 @@ static int isp_probe(struct platform_device *pdev)
> >  	__omap3isp_put(isp, false);
> >  error:
> >  	mutex_destroy(&isp->isp_mutex);
> > +	v4l2_async_notifier_release(&isp->notifier);
> > 
> >  	return ret;
> >  }
> 
> [snip]
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
