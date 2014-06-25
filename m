Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41811 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753169AbaFYIoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 04:44:10 -0400
Date: Wed, 25 Jun 2014 09:43:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Denis Carikli <denis@eukrea.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v14 04/10] imx-drm: use defines for clock polarity
	settings
Message-ID: <20140625084327.GD32514@n2100.arm.linux.org.uk>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-4-git-send-email-denis@eukrea.com> <20140625044845.GK5918@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625044845.GK5918@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 25, 2014 at 06:48:45AM +0200, Sascha Hauer wrote:
> On Mon, Jun 16, 2014 at 12:11:18PM +0200, Denis Carikli wrote:
> > +
> >  /*
> >   * Bitfield of Display Interface signal polarities.
> >   */
> > @@ -37,7 +43,7 @@ struct ipu_di_signal_cfg {
> >  	unsigned clksel_en:1;
> >  	unsigned clkidle_en:1;
> >  	unsigned data_pol:1;	/* true = inverted */
> > -	unsigned clk_pol:1;	/* true = rising edge */
> > +	unsigned clk_pol:1;
> >  	unsigned enable_pol:1;
> >  	unsigned Hsync_pol:1;	/* true = active high */
> >  	unsigned Vsync_pol:1;
> 
> ...can we rename the flags to more meaningful names instead?
> 
> 	unsigned clk_pol_rising_edge:1;
> 	unsigned enable_pol_high:1;
> 	unsigned hsync_active_high:1;
> 	unsigned vsync_active_high:1;

Now look at patch 7, where these become tri-state:
- don't change
- rising edge/active high
- falling edge/active low

So your suggestion is not a good idea.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
