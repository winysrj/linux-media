Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40207 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2BQJL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 04:11:28 -0500
Date: Fri, 17 Feb 2012 10:11:17 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Baruch Siach <baruch@tkos.co.il>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	javier.martin@vista-silicon.com
Subject: Re: [PATCH] media: video: mx2_camera: Remove ifdef's
Message-ID: <20120217091117.GR3852@pengutronix.de>
References: <1329416739-23566-1-git-send-email-fabio.estevam@freescale.com>
 <20120216183320.GB3119@tarshish>
 <Pine.LNX.4.64.1202162004060.6033@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1202162004060.6033@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thu, Feb 16, 2012 at 08:06:16PM +0100, Guennadi Liakhovetski wrote:
> Hi
> 
> On Thu, 16 Feb 2012, Baruch Siach wrote:
> 
> > Hi Fabio,
> > 
> > On Thu, Feb 16, 2012 at 04:25:39PM -0200, Fabio Estevam wrote:
> > > As we are able to build a same kernel that supports both mx27 and mx25, we should remove
> > > the ifdef's for CONFIG_MACH_MX27 in the mx2_camera driver.
> > > 
> > > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > Acked-by: Baruch Siach <baruch@tkos.co.il>
> 
> I'm still hoping to merge this
> 
> http://patchwork.linuxtv.org/patch/298/
> 
> patch, after it is suitably updated... Sascha, any progress?

Just sent an updated series. Let me know if I have to rebase it
onto another branch. I tried to do this change mechanically which
means that there might be further cleanups possible after my
series, but I don't want to break a driver which I currently can't
test.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
