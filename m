Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60762 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751747AbdGRTlg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:41:36 -0400
Date: Tue, 18 Jul 2017 22:41:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, pavel@ucw.cz,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 7/7] omap3isp: Skip CSI-2 receiver initialisation in CCP2
 configuration
Message-ID: <20170718194132.t6dqgqwzscyx2a6x@valkosipuli.retiisi.org.uk>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-8-sakari.ailus@linux.intel.com>
 <1967838.Hno52fQ337@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1967838.Hno52fQ337@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Jul 18, 2017 at 11:54:21AM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Tuesday 18 Jul 2017 01:01:16 Sakari Ailus wrote:
> > If the CSI-2 receiver isn't part of the pipeline (or isn't there to begin
> > with), skip its initialisation.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/platform/omap3isp/ispcsiphy.c | 41 +++++++++++++++++---------
> >  1 file changed, 28 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c
> > b/drivers/media/platform/omap3isp/ispcsiphy.c index
> > 2028bb519108..bb2906061884 100644
> > --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> > +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> > @@ -155,6 +155,19 @@ static int csiphy_set_power(struct isp_csiphy *phy, u32
> > power) return 0;
> >  }
> > 
> > +static struct isp_pipeline *phy_to_isp_pipeline(struct isp_csiphy *phy)
> > +{
> > +	if (phy->csi2 && phy->csi2->subdev.entity.pipe)
> > +		return to_isp_pipeline(&phy->csi2->subdev.entity);
> > +
> > +	if (phy->isp->isp_ccp2.subdev.entity.pipe)
> > +		return to_isp_pipeline(&phy->isp->isp_ccp2.subdev.entity);
> > +
> > +	__WARN();
> > +
> > +	return NULL;
> 
> If you changed the phy->csi2 pointer from a isp_csi2_device to a v4l2_subdev 
> or media_entity (and renamed it accordingly, to something like "receiver" for 
> instance, ideas for a better name are welcome) you could store a pointer to 
> the appropriate CSI2 or CCP2 receiver and simplify this function, or even 
> inline it as it is currently, calling to_isp_pipeline(phy->receiver). I think 
> that would simplify the driver.

Yes; I'll store the entity to the phy struct. That way the function can be
indeed removed.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
