Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([185.16.172.187]:54787 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbeIFVBf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 17:01:35 -0400
Date: Thu, 6 Sep 2018 18:24:50 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Archit Taneja <architt@codeaurora.org>,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/10] phy: Add configuration interface
Message-ID: <20180906162450.GA26997@lunn.ch>
References: <cover.ee6158898d563fcc01d45c9652501180bccff0f0.1536138624.git-series.maxime.ripard@bootlin.com>
 <a739a2d623c3e60373a73e1ec206c2aa35c4a742.1536138624.git-series.maxime.ripard@bootlin.com>
 <8397722.XVQDA25ZU6@avalon>
 <20180906144807.pn753tgfyovvheil@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180906144807.pn753tgfyovvheil@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > > +int phy_configure(struct phy *phy, enum phy_mode mode,
> > > +		  union phy_configure_opts *opts)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (!phy)
> > > +		return -EINVAL;
> > > +
> > > +	if (!phy->ops->configure)
> > > +		return 0;
> > 
> > Shouldn't you report an error to the caller ? If a caller expects the PHY to 
> > be configurable, I would assume that silently ignoring the requested 
> > configuration won't work great.
> 
> I'm not sure. I also expect a device having to interact with multiple
> PHYs, some of them needing some configuration while some other do
> not. In that scenario, returning 0 seems to be the right thing to do.

You could return -EOPNOTSUPP. That is common in the network stack. The
caller then has the information to decide if it should keep going, or
return an error.

       Andrew
