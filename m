Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52074 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751336AbdGRKRH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 06:17:07 -0400
Date: Tue, 18 Jul 2017 13:17:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] omap3isp: Return -EPROBE_DEFER if the required
 regulators can't be obtained
Message-ID: <20170718101702.qi72355jjjuq7jjs@valkosipuli.retiisi.org.uk>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-5-sakari.ailus@linux.intel.com>
 <1652763.9EYemjAvaH@avalon>
 <20170718100352.GA28481@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170718100352.GA28481@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Jul 18, 2017 at 12:03:52PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> > > b/drivers/media/platform/omap3isp/ispccp2.c index
> > > 4f8fd0c00748..47210b102bcb 100644
> > > --- a/drivers/media/platform/omap3isp/ispccp2.c
> > > +++ b/drivers/media/platform/omap3isp/ispccp2.c
> > > @@ -1140,6 +1140,11 @@ int omap3isp_ccp2_init(struct isp_device *isp)
> > >  	if (isp->revision == ISP_REVISION_2_0) {
> > >  		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
> > >  		if (IS_ERR(ccp2->vdds_csib)) {
> > > +			if (PTR_ERR(ccp2->vdds_csib) == -EPROBE_DEFER) {
> > > +				dev_dbg(isp->dev,
> > > +					"Can't get regulator vdds_csib, 
> > deferring probing\n");
> > > +				return -EPROBE_DEFER;
> > > +			}
> > >  			dev_dbg(isp->dev,
> > >  				"Could not get regulator vdds_csib\n");
> > 
> > I would just move this message above the -EPROBE_DEFER check and remove the 
> > one inside the check. Probe deferral debug information can be obtained by 
> > enabling the debug messages in the driver core.
> 
> Actually, in such case perhaps the message in -EPROBE_DEFER could be
> removed. Deferred probing happens all the time. OTOH "Could not get
> regulator" probably should be dev_err(), as it will make device
> unusable?

Isn't this only if you need ccp2?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
