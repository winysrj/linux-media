Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47194 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762088AbZFJT7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 15:59:14 -0400
Date: Wed, 10 Jun 2009 21:59:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
In-Reply-To: <200906102149.32244.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0906102153120.4817@axis700.grange>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906102022320.4817@axis700.grange> <200906102149.32244.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2009, Hans Verkuil wrote:

> On Wednesday 10 June 2009 20:32:25 Guennadi Liakhovetski wrote:
> > On Tue, 9 Jun 2009, m-karicheri2@ti.com wrote:
> > > From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
> > >
> > > This patch adds support for setting bus parameters such as bus type
> > > (BT.656, BT.1120 etc), width (example 10 bit raw image data bus)
> > > and polarities (vsync, hsync, field etc) in sub device. This allows
> > > bridge driver to configure the sub device for a specific set of bus
> > > parameters through s_bus() function call.
> >
> > Yes, this is required, but this is not enough. Firstly, you're missing at
> > least one more flag - master or slave. Secondly, it is not enough to
> > provide a s_bus function. Many hosts and sensors can configure one of
> > several alternate configurations - they can select signal polarities,
> > data widths, master / slave role, etc. Whereas others have some or all of
> > these parameters fixed. That's why we have a query method in soc-camera,
> > which delivers all supported configurations, and then the host can select
> > some mutually acceptable subset. No, just returning an error code is not
> > enough.
> 
> Why would you want to query this? I would expect this to be fixed settings: 
> something that is determined by the architecture. Actually, I would expect 
> this to be part of the platform_data in many cases and setup when the i2c 
> driver is initialized and not touched afterwards.
> 
> If we want to negotiate these bus settings, then we indeed need something 
> more. But it seems unnecessarily complex to me to implement autonegotiation 
> when this is in practice a fixed setting determined by how the sensor is 
> hooked up to the host.

On the platform level I have so far seen two options: signal connected 
directly or via an inverter. For that you need platform data, yes. But 
otherwise - why? say, if both your sensor and your host can select hsync 
polarity in software - what should platform tell about it? This knowledge 
belongs in the respective drivers - they know, that they can configure 
arbitrary polarity and they advertise that. Another sensor, that is 
statically active high - what does platform have to do with it? The driver 
knows perfectly, that it can only do one polarity, and it negotiates that. 
Earlier we also had this flags configured in platform code, but then we 
realised that this wasn't correct. This information and configuration 
methods are chip-specific, not platform-specific.

And the negotiation code is not that complex - just copy respective 
soc-camera functions, later the originals will be removed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
