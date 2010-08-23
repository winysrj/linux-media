Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:60508 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754002Ab0HWWF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 18:05:28 -0400
Date: Tue, 24 Aug 2010 00:05:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 0/4] mx2_camera: mx25 fixes and enhancements
In-Reply-To: <20100823041117.GA20026@jasper.tkos.co.il>
Message-ID: <Pine.LNX.4.64.1008240002130.13536@axis700.grange>
References: <cover.1280229966.git.baruch@tkos.co.il> <20100823041117.GA20026@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Baruch

On Mon, 23 Aug 2010, Baruch Siach wrote:

> Hi Guennadi,
> 
> On Tue, Jul 27, 2010 at 03:06:06PM +0300, Baruch Siach wrote:
> > The first 3 pathces in this series are fixes for the mx2_camera driver which is 
> > going upstream via the imx git tree. The last patch implements forced active 
> > buffer termination on mx25.
> 
> Ping?

Sorry for taking a bit long to push your patches, but, I think, we still 
have a bit of time. Fixes are ok to go in after -rc2 (or even -rc3, or 
-rc4...), with features we're anyway late for 2.6.36, so, they will have 
to wait until 2.6.37, for which we have some time too. So, I think we're 
doing fine so far. Of the four patches below patch two was unclear, 
whether we want it or not, patches one and three were ok, AFAIR, will have 
to double-check, patch 4 I'll have to decide whether that's a fix or a 
feature;)

> > Baruch Siach (4):
> >   mx2_camera: fix a race causing NULL dereference
> >   mx2_camera: return IRQ_NONE when doing nothing
> >   mx2_camera: fix comment typo
> >   mx2_camera: implement forced termination of active buffer for mx25
> > 
> >  drivers/media/video/mx2_camera.c |   34 ++++++++++++++++++++++++++--------
> >  1 files changed, 26 insertions(+), 8 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
