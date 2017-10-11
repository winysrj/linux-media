Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:28053 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbdJKNYs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 09:24:48 -0400
Date: Wed, 11 Oct 2017 08:22:59 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, <nm@ti.com>
Subject: Re: [PATCH v4 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20171011132258.GB25400@ti.com>
References: <20170922100823.18184-1-maxime.ripard@free-electrons.com>
 <20170922100823.18184-3-maxime.ripard@free-electrons.com>
 <20170929172709.GA3163@ti.com>
 <20171011092409.ndtr3fdo2oj3zueb@flea.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20171011092409.ndtr3fdo2oj3zueb@flea.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Wed [2017-Oct-11 11:24:09 +0200]:
> Hi Benoit,
> 
> On Fri, Sep 29, 2017 at 05:27:09PM +0000, Benoit Parrot wrote:
> > > +static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
> > > +				struct platform_device *pdev)
> > > +{
> > > +	struct resource *res;
> > > +	unsigned char i;
> > > +	u32 reg;
> > > +
> > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +	csi2rx->base = devm_ioremap_resource(&pdev->dev, res);
> > > +	if (IS_ERR(csi2rx->base))
> > > +		return PTR_ERR(csi2rx->base);
> > > +
> > > +	csi2rx->sys_clk = devm_clk_get(&pdev->dev, "sys_clk");
> > > +	if (IS_ERR(csi2rx->sys_clk)) {
> > > +		dev_err(&pdev->dev, "Couldn't get sys clock\n");
> > > +		return PTR_ERR(csi2rx->sys_clk);
> > > +	}
> > > +
> > > +	csi2rx->p_clk = devm_clk_get(&pdev->dev, "p_clk");
> > > +	if (IS_ERR(csi2rx->p_clk)) {
> > > +		dev_err(&pdev->dev, "Couldn't get P clock\n");
> > > +		return PTR_ERR(csi2rx->p_clk);
> > > +	}
> > > +
> > > +	csi2rx->dphy = devm_phy_optional_get(&pdev->dev, "dphy");
> > > +	if (IS_ERR(csi2rx->dphy)) {
> > > +		dev_err(&pdev->dev, "Couldn't get external D-PHY\n");
> > > +		return PTR_ERR(csi2rx->dphy);
> > > +	}
> > > +
> > > +	/*
> > > +	 * FIXME: Once we'll have external D-PHY support, the check
> > > +	 * will need to be removed.
> > > +	 */
> > > +	if (csi2rx->dphy) {
> > > +		dev_err(&pdev->dev, "External D-PHY not supported yet\n");
> > > +		return -EINVAL;
> > > +	}
> > 
> > I understand that in your current environment you do not have a
> > DPHY. But I am wondering in a real setup where you will have either
> > an internal or an external DPHY, how are they going to interact with
> > this driver or vice-versa?
> 
> It's difficult to give an answer with so little details. How would you
> choose between those two PHYs? Is there a mux, or should we just power
> one of the two? If that's the case, is there any use case were we
> might want to power both? If not, which one should we favor, in which
> situations?

Oops, I guess I should clarify, in this case I did not mean we would
have both an internal and an external DPHY. I just meant one or the other.
Basically just want to see how you would actually handle a DPHY here whether
it's internal or external?

For instance, using direct register access from within this driver or make
use of an separate phy driver...

> 
> I guess all those questions actually depend on the way the integration
> has been done, and we're not quite there yet. I guess we could do
> either a platform specific structure or a glue, depending on the
> complexity. The platform specific compatible will allow us to do that
> as we see fit anyway.
> 

Regards,
Benoit
