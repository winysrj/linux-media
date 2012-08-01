Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53721 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2HAHDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 03:03:01 -0400
Date: Wed, 1 Aug 2012 09:02:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	fabio.estevam@freescale.com,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, linux@arm.linux.org.uk,
	kernel@pengutronix.de
Subject: Re: [PATCH 4/4] media: mx2_camera: Fix clock handling for i.MX27.
In-Reply-To: <20120731174901.GD30009@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1208010850110.5406@axis700.grange>
References: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
 <1343301637-19676-5-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1207311644590.27888@axis700.grange> <20120731174901.GD30009@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha

On Tue, 31 Jul 2012, Sascha Hauer wrote:

> Hi Guennadi,
> 
> On Tue, Jul 31, 2012 at 05:14:25PM +0200, Guennadi Liakhovetski wrote:
> > Hi Javier
> > 
> > > @@ -436,7 +436,8 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
> > >  {
> > >  	unsigned long flags;
> > >  
> > > -	clk_disable(pcdev->clk_csi);
> > > +	if (cpu_is_mx27())
> > > +		clk_disable_unprepare(pcdev->clk_csi);
> > 
> > This tells me, there are already 2 things going on here:
> > 
> > 1. add clock-(un)prepare operations to enable / disable. Is this a problem 
> > atm? is the driver non-functional without this change or is it just an API 
> > correctness change? I thought you replied to this already, but 
> > unfortunately I couldn't find that your reply again, sorry.
> 
> Since the common clock framework clk_prepare is mandatory.

Good, thanks for the clarification. So, this is not a functional, but a 
correctness fix. I think, such fixes are acceptable after -rc1 until 
something like -rc5, but maybe not after that. So, I'd try to push this 
some time within the next couple of weeks, once I get this fix as a 
separate patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
