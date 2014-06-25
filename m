Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42404 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaFYJqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 05:46:55 -0400
Date: Wed, 25 Jun 2014 11:46:28 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Denis Carikli <denis@eukrea.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>,
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
Message-ID: <20140625094628.GS15686@pengutronix.de>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
 <1402913484-25910-4-git-send-email-denis@eukrea.com>
 <20140625044845.GK5918@pengutronix.de>
 <20140625084327.GD32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625084327.GD32514@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 25, 2014 at 09:43:27AM +0100, Russell King - ARM Linux wrote:
> On Wed, Jun 25, 2014 at 06:48:45AM +0200, Sascha Hauer wrote:
> > On Mon, Jun 16, 2014 at 12:11:18PM +0200, Denis Carikli wrote:
> > > +
> > >  /*
> > >   * Bitfield of Display Interface signal polarities.
> > >   */
> > > @@ -37,7 +43,7 @@ struct ipu_di_signal_cfg {
> > >  	unsigned clksel_en:1;
> > >  	unsigned clkidle_en:1;
> > >  	unsigned data_pol:1;	/* true = inverted */
> > > -	unsigned clk_pol:1;	/* true = rising edge */
> > > +	unsigned clk_pol:1;
> > >  	unsigned enable_pol:1;
> > >  	unsigned Hsync_pol:1;	/* true = active high */
> > >  	unsigned Vsync_pol:1;
> > 
> > ...can we rename the flags to more meaningful names instead?
> > 
> > 	unsigned clk_pol_rising_edge:1;
> > 	unsigned enable_pol_high:1;
> > 	unsigned hsync_active_high:1;
> > 	unsigned vsync_active_high:1;
> 
> Now look at patch 7, where these become tri-state:
> - don't change
> - rising edge/active high
> - falling edge/active low
> 
> So your suggestion is not a good idea.

Hm, you're right.

Still I think we should add a prefix to make the context of the flags
clear.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
