Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42033 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751523AbZDQHsJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 03:48:09 -0400
Date: Fri, 17 Apr 2009 09:48:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
In-Reply-To: <5e9665e10904170029g56c0be23i9116c28b4a723314@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904170941540.5119@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <5e9665e10904170029g56c0be23i9116c28b4a723314@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Apr 2009, Dongsoo, Nathaniel Kim wrote:

> I've got one more thing to ask.
> Is SoC camera framework supporting for selecting video standards
> between camera interface and external camera module? I mean ITU-R BT
> 601 and 656 things.
> Or any different way that I'm not aware is supported?

I thought someone did it already, maybe there were some patches that 
didn't make it in yet, cannot find ATM. In any case, we do have a pretty 
advanced (!:-)) bus parameter negotiation infrastructure, so, you would 
just have a couple more SOCAM_* flags, like SOCAM_BT601, SOCAM_BT656 or 
similar and use them to configure your host-camera link, depending upon 
their capabilities and platform flags. See for example how SOCAM_MASTER / 
SOCAM_SLAVE is selected. Also don't forget to extend the 
soc_camera_bus_param_compatible() function.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
