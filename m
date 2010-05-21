Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52444 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758634Ab0EUSdV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 14:33:21 -0400
Date: Fri, 21 May 2010 20:33:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] Driver for the i.MX2x CMOS Sensor Interface
In-Reply-To: <20100521072737.GA6967@tarshish>
Message-ID: <Pine.LNX.4.64.1005212023400.8450@axis700.grange>
References: <cover.1273150585.git.baruch@tkos.co.il> <20100521072045.GD17272@pengutronix.de>
 <20100521072737.GA6967@tarshish>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 21 May 2010, Baruch Siach wrote:

> Hi Sascha,
> 
> On Fri, May 21, 2010 at 09:20:45AM +0200, Sascha Hauer wrote:
> > On Thu, May 06, 2010 at 04:09:38PM +0300, Baruch Siach wrote:
> > > This series contains a soc_camera driver for the i.MX25/i.MX27 CSI device, and 
> > > platform code for the i.MX25 and i.MX27 chips. This driver is based on a driver 
> > > for i.MX27 CSI from Sascha Hauer, that  Alan Carvalho de Assis has posted in 
> > > linux-media last December[1]. Since all I have is a i.MX25 PDK paltform I can't 
> > > test the mx27 specific code. Testers and comment are welcome.
> > > 
> > > [1] https://patchwork.kernel.org/patch/67636/
> > > 
> > > Baruch Siach (3):
> > >   mx2_camera: Add soc_camera support for i.MX25/i.MX27
> > >   mx27: add support for the CSI device
> > >   mx25: add support for the CSI device
> > 
> > With the two additions I sent I can confirm this working on i.MX27, so
> > no need to remove the related code.
> 
> Thanks. I'll add your patches to my queue and resend the series next week.

Firstly, Sascha, unfortunately, you've forgotten to CC the maintainer, 
that will have to deal with these patches.

Secondly, I don't think that's a good idea to submit mx27 fixes as 
incremental patches. I'd prefer to have them rolled into the actual driver 
submission patches, where Sascha would just add his Sob / acked-by / 
tested-by / whatever... Or you can first submit an mx25-only driver and 
let Sascha add mx27 to it, in which case this would be a functionality 
extension, but not a fix of a broken driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
