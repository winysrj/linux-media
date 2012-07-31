Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48187 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2GaRtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 13:49:10 -0400
Date: Tue, 31 Jul 2012 19:49:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	fabio.estevam@freescale.com,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, linux@arm.linux.org.uk,
	kernel@pengutronix.de
Subject: Re: [PATCH 4/4] media: mx2_camera: Fix clock handling for i.MX27.
Message-ID: <20120731174901.GD30009@pengutronix.de>
References: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
 <1343301637-19676-5-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1207311644590.27888@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207311644590.27888@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tue, Jul 31, 2012 at 05:14:25PM +0200, Guennadi Liakhovetski wrote:
> Hi Javier
> 
> > @@ -436,7 +436,8 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
> >  {
> >  	unsigned long flags;
> >  
> > -	clk_disable(pcdev->clk_csi);
> > +	if (cpu_is_mx27())
> > +		clk_disable_unprepare(pcdev->clk_csi);
> 
> This tells me, there are already 2 things going on here:
> 
> 1. add clock-(un)prepare operations to enable / disable. Is this a problem 
> atm? is the driver non-functional without this change or is it just an API 
> correctness change? I thought you replied to this already, but 
> unfortunately I couldn't find that your reply again, sorry.

Since the common clock framework clk_prepare is mandatory.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
