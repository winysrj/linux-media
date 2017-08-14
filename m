Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50800 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750753AbdHNSt5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 14:49:57 -0400
Date: Mon, 14 Aug 2017 21:49:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH v1.2 1/1] omap3isp: Skip CSI-2 receiver initialisation in
 CCP2 configuration
Message-ID: <20170814184953.wmxvdycbtek4sbhd@valkosipuli.retiisi.org.uk>
References: <20170811095709.3069-1-sakari.ailus@linux.intel.com>
 <29475894.0Ps0lzjic1@avalon>
 <20170814105327.s6hbksmwjjchwejn@valkosipuli.retiisi.org.uk>
 <6578002.YS5YEteNhM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6578002.YS5YEteNhM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 14, 2017 at 04:33:39PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Monday 14 Aug 2017 13:53:27 Sakari Ailus wrote:
> > On Fri, Aug 11, 2017 at 02:32:00PM +0300, Laurent Pinchart wrote:
> > > On Friday 11 Aug 2017 12:57:09 Sakari Ailus wrote:
> > >> If the CSI-2 receiver isn't part of the pipeline (or isn't there to
> > >> begin with), skip its initialisation.
> > > 
> > > I don't think the commit message really describes the patch.
> > > 
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >> Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com> # on
> > >> Beagleboard-xM + MPT9P031 Acked-by: Pavel Machek <pavel@ucw.cz>
> > >> ---
> > >> since v1.1:
> > >> 
> > >> - Assign phy->entity before calling omap3isp_csiphy_config(), for
> > >> 
> > >>   phy->entity is used by omap3isp_csiphy_config(). (Thanks to Pavel for
> > >>   spotting this.)
> > >>  
> > >>  drivers/media/platform/omap3isp/ispccp2.c   |  2 +-
> > >>  drivers/media/platform/omap3isp/ispcsi2.c   |  4 +--
> > >>  drivers/media/platform/omap3isp/ispcsiphy.c | 38 ++++++++++------------
> > >>  drivers/media/platform/omap3isp/ispcsiphy.h |  6 +++--
> > >>  4 files changed, 27 insertions(+), 23 deletions(-)
> > >> 
> 
> [snip]
> 
> > >> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c
> > >> b/drivers/media/platform/omap3isp/ispcsiphy.c index
> > >> 2028bb519108..aedd88fa8246 100644
> > >> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> > >> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> > >> @@ -164,15 +164,18 @@ static int csiphy_set_power(struct isp_csiphy
> > >> *phy, u32 power)
> > >> 
> > >>  static int omap3isp_csiphy_config(struct isp_csiphy *phy)
> > >>  {
> > >> -	struct isp_csi2_device *csi2 = phy->csi2;
> > >> -	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
> > >> -	struct isp_bus_cfg *buscfg = pipe->external->host_priv;
> > >> +	struct isp_pipeline *pipe = to_isp_pipeline(phy->entity);
> > >> +	struct isp_bus_cfg *buscfg;
> > >>  	struct isp_csiphy_lanes_cfg *lanes;
> > >>  	int csi2_ddrclk_khz;
> > >>  	unsigned int num_data_lanes, used_lanes = 0;
> > >>  	unsigned int i;
> > >>  	u32 reg;
> > >> 
> > >> +	if (!pipe)
> > >> +		return -EBUSY;
> > > 
> > > When can this happen ?
> > 
> > It shouldn't. Just in case, it'd be a driver bug if it did. What would you
> > think of adding WARN_ON() here?
> 
> I throw WARN_ON()s in when I believe that driver could get it wrong. In this 
> particular case, given that this function is called from .s_stream() handlers 
> only, I wonder if the check makes sense at all.

Yeah, makes sense; I'll drop it.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
