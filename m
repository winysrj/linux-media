Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52388 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753173Ab2JIGIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 02:08:04 -0400
Date: Tue, 9 Oct 2012 09:08:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com
Subject: Re: [PATCH v3 2/3] omap3isp: Add PHY routing configuration
Message-ID: <20121009060800.GK14107@valkosipuli.retiisi.org.uk>
References: <20121007200730.GD14107@valkosipuli.retiisi.org.uk>
 <1349640472-1425-2-git-send-email-sakari.ailus@iki.fi>
 <21772459.IFXEUjhVJS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21772459.IFXEUjhVJS@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent!

Thanks for the comments!

On Tue, Oct 09, 2012 at 02:17:48AM +0200, Laurent Pinchart wrote:
...
> > @@ -32,6 +32,92 @@
> >  #include "ispreg.h"
> >  #include "ispcsiphy.h"
> > 
> > +static void csiphy_routing_cfg_3630(struct isp_csiphy *phy, u32 iface,
> > +				    bool ccp2_strobe)
> > +{
> > +	u32 cam_phy_ctrl =
> 
> If you call the variable "value" or "ctrl" two statements below could fit on 
> one line, but that's up to you :-)

I'll call it "reg". :)


> > +		isp_reg_readl(phy->isp,
> > +			      OMAP3_ISP_IOMEM_3630_CONTROL_CAMERA_PHY_CTRL, 0);
> > +	u32 shift, mode;
> > +
> > +	switch (iface) {
> > +	case ISP_INTERFACE_CCP2B_PHY1:
> > +		cam_phy_ctrl &=
> > +			~OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
> > +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
> > +		break;
> > +	case ISP_INTERFACE_CSI2C_PHY1:
> > +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY1_SHIFT;
> > +		mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY;
> > +		break;
> > +	case ISP_INTERFACE_CCP2B_PHY2:
> > +		cam_phy_ctrl |=
> > +			OMAP3630_CONTROL_CAMERA_PHY_CTRL_CSI1_RX_SEL_PHY2;
> > +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT;
> > +		break;
> > +	case ISP_INTERFACE_CSI2A_PHY2:
> > +		shift = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_PHY2_SHIFT;
> > +		mode = OMAP3630_CONTROL_CAMERA_PHY_CTRL_CAMMODE_DPHY;
> > +		break;
> > +	default:
> > +		pr_warn("bad iface %d\n", iface);
> 
> As you already know, dev_warn() is a better idea. Can this actually happen ?

I don't think so; it's checked in isp.c in isp_register_entities().. I'll
remove it.

Cheers.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
