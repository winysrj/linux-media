Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41738 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab0CDTnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 14:43:16 -0500
Date: Thu, 4 Mar 2010 20:42:41 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: mx1-camera: compile fix
Message-ID: <20100304194241.GG19843@pengutronix.de>
References: <1267721687-19697-1-git-send-email-u.kleine-koenig@pengutronix.de> <Pine.LNX.4.64.1003041811160.4825@axis700.grange> <20100304192623.GA14587@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100304192623.GA14587@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 04, 2010 at 08:26:23PM +0100, Uwe Kleine-König wrote:
> Hi Guennadi,
> 
> On Thu, Mar 04, 2010 at 06:13:38PM +0100, Guennadi Liakhovetski wrote:
> > > +#undef DMA_BASE 
> > > +#define DMA_BASE MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR)
> > 
> > I don't like this. Why the "undef"? Is DMA_BASE already defined? where and 
> > what is it? If it is - we better use a different name, if not - just 
> > remove the undef, please.
> yes, it's not pretty, but I wanted to make a minimal patch.
> 
> arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h has:
> 
> 	#define DMA_BASE IO_ADDRESS(DMA_BASE_ADDR)

This is only used in the mx1 camera driver, so you can just remove it
from dma-mx1-mx2.h and use MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR) in the camera
driver.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
