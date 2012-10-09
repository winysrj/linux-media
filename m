Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52384 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752756Ab2JIGDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:09 -0400
Date: Tue, 9 Oct 2012 09:03:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com
Subject: Re: [PATCH v3 3/3] omap3isp: Configure CSI-2 phy based on platform
 data
Message-ID: <20121009060304.GJ14107@valkosipuli.retiisi.org.uk>
References: <20121007200730.GD14107@valkosipuli.retiisi.org.uk>
 <1349640472-1425-3-git-send-email-sakari.ailus@iki.fi>
 <1520699.1MmuS9fDen@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520699.1MmuS9fDen@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments.

On Tue, Oct 09, 2012 at 02:33:28AM +0200, Laurent Pinchart wrote:
...
> > @@ -248,10 +203,56 @@ static int csiphy_config(struct isp_csiphy *phy,
> >  	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
> >  		return -EINVAL;
> > 
> > -	mutex_lock(&phy->mutex);
> > -	phy->dphy = *dphy;
> > -	phy->lanes = *lanes;
> > -	mutex_unlock(&phy->mutex);
> > +	csiphy_routing_cfg(phy, subdevs->interface, true,
> > +			   subdevs->bus.ccp2.phy_layer);
> 
> As the second argument is always true, it could make sense to remove it (or to 
> add another call to csiphy_routing_cfg with on set to false).

That's a good point. In principle another call should be added for 3430 to
turn the PHY off. That's not being done on the N900.

I'll see where it could be added.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
