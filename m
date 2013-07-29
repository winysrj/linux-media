Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52009 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3G2IzB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 04:55:01 -0400
Date: Mon, 29 Jul 2013 10:54:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: phil.edworthy@renesas.com
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
In-Reply-To: <OF0AFD1E8A.88D1196C-ON80257BB7.002B713E-80257BB7.002BDDA1@eu.necel.com>
Message-ID: <Pine.LNX.4.64.1307291051250.14405@axis700.grange>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
 <OF23E0ECB2.378DD339-ON80257BA9.002CD00C-80257BA9.00321DEB@eu.necel.com>
 <Pine.LNX.4.64.1307151114270.16726@axis700.grange>
 <OFD872F119.19A49694-ON80257BA9.003406ED-80257BA9.003467F5@eu.necel.com>
 <Pine.LNX.4.64.1307151141190.16726@axis700.grange>
 <OF0AFD1E8A.88D1196C-ON80257BB7.002B713E-80257BB7.002BDDA1@eu.necel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phil,

On Mon, 29 Jul 2013, phil.edworthy@renesas.com wrote:

> Hi Guennadi,
> 
> > > Ok, now I see. My comment about the sensor output size changing is 
> wrong. 
> > > The sensor doesn't do any scaling, so we are cropping it.
> > 
> > Ah, ok, then you shouldn't change video sizes in your .s_fmt(), just 
> > return the current cropping rectangle.
> 
> I'm reworking the code but realised that the sensor _does_ do both scaling 
> and cropping. Though scaling is only possible by dropping every other scan 
> line when required height is <= 400 pixels.

Right, the so called skipping.

> So does that mean .s_fmt() should select the appropriate mode?

You can use skipping to implement scaling, yes. But you don't have to. 
Drivers don't have to support all hardware capabilities, but what they do 
support they better do correctly :) So, it's up to you actually whether to 
add it now or later. Maybe it would be easier to get a basic version in 
the kernel now with no scaling support and add it later as an incremental 
patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
