Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59470 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755805Ab0E1IVP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 04:21:15 -0400
Date: Fri, 28 May 2010 10:21:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alex Deucher <alexdeucher@gmail.com>
cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Idea of a v4l -> fb interface driver
In-Reply-To: <AANLkTin_ia3Ym3z7FOu40voZkjCeMqSDZjuE_1aBjwOW@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1005272216380.1703@axis700.grange>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
 <AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
 <Pine.LNX.4.64.1005270809110.2293@axis700.grange>
 <AANLkTin_ia3Ym3z7FOu40voZkjCeMqSDZjuE_1aBjwOW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 May 2010, Alex Deucher wrote:

> On Thu, May 27, 2010 at 2:56 AM, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

...

> > Ok, let me explain what exactly I meant. Above I referred to "display
> > drivers," which is not the same as a "framebuffer controller driver" or
> > whatever you would call it. By framebuffer controller driver I mean a
> > driver for the actual graphics engine on a certain graphics card or an
> > SoC. This is the part, that reads data from the actual framebuffer and
> > outputs it to some hardware interface to a display device. Now this
> > interface can be a VGA or a DVI connector, it can be one of several bus
> > types, used with various LCD displays. In many cases this is all you have
> > to do to get the output to your display. But in some cases the actual
> > display on the other side of this bus also requires a driver. That can be
> > some kind of a smart display, it can be a panel with an attached display
> > controller, that must be at least configured, say, over SPI, it can be a
> > display, attached to the host over the MIPI DSI bus, and implementing some
> > proprietary commands. In each of these cases you will have to write a
> > display driver for this specific display or controller type, and your
> > framebuffer driver will have to interface with that display driver. Now,
> > obviously, those displays can be connected to a variety of host systems,
> > in which case you will want to reuse that display driver. This means,
> > there has to be a standard fb-driver - display-driver API. AFAICS, this is
> > currently not implemented in fbdev, please, correct me if I am wrong.
> 
> 
> Another API to consider in the drm kms (kernel modesetting) interface.
>  The kms API deals properly with advanced display hardware and
> properly handles crtcs, encoders, and connectors.  It also provides
> fbdev api emulation.

Well, is KMS planned as a replacement for both fbdev and user-space 
graphics drivers? I mean, if you'd be writing a new fb driver for a 
relatively simple embedded SoC, would KMS apriori be a preferred API?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
