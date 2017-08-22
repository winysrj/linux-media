Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47318 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932615AbdHVMdK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:33:10 -0400
Date: Tue, 22 Aug 2017 15:33:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/3] omap3isp: Drop redundant isp->subdevs field and
 ISP_MAX_SUBDEVS
Message-ID: <20170822123307.gdgtg33vgppd4fog@valkosipuli.retiisi.org.uk>
References: <20170818112317.30933-1-sakari.ailus@linux.intel.com>
 <20170818112317.30933-2-sakari.ailus@linux.intel.com>
 <3810750.ISKOUEcbCg@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3810750.ISKOUEcbCg@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 22, 2017 at 03:30:22PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 18 August 2017 14:23:15 EEST Sakari Ailus wrote:
> > struct omap3isp.subdevs field and ISP_MAX_SUBDEVS macro are both unused.
> > Remove them.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> The field and macro are still used, you only remove them in patch 2/3. You can 
> squash 1/3 and 2/3 together.

Oh, I missed this indeed. I'll squash the patches.

> 
> > ---
> >  drivers/media/platform/omap3isp/isp.h | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.h
> > b/drivers/media/platform/omap3isp/isp.h index e528df6efc09..848cd96b67ca
> > 100644
> > --- a/drivers/media/platform/omap3isp/isp.h
> > +++ b/drivers/media/platform/omap3isp/isp.h
> > @@ -220,9 +220,6 @@ struct isp_device {
> > 
> >  	unsigned int sbl_resources;
> >  	unsigned int subclk_resources;
> > -
> > -#define ISP_MAX_SUBDEVS		8
> > -	struct v4l2_subdev *subdevs[ISP_MAX_SUBDEVS];
> >  };
> > 
> >  struct isp_async_subdev {
> 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
