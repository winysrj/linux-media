Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43388 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753206AbZBAWqD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 17:46:03 -0500
Date: Sun, 1 Feb 2009 23:46:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bennet Fischer <bennetfischer@googlemail.com>
cc: linux-media@vger.kernel.org
Subject: Re: PXA Quick capture interface with HV7131RP-Camera
In-Reply-To: <7951d5d30901311349l769195b7x9202b78970b6b8b5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0902012344400.17985@axis700.grange>
References: <7951d5d30901311346i162ce575j76fd660fa0b0e176@mail.gmail.com>
 <7951d5d30901311349l769195b7x9202b78970b6b8b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 31 Jan 2009, Bennet Fischer wrote:

> Hi
> 
> 
> I am trying to get a camera to work together with an PXA270 processor.
> My system has the following specs:
> 
> Platform: Gumstix Verdex Pro
> Camera: HV7131RP
> OS: Linux 2.6.28
> 
> I wrote a simple driver for the camera which omits all the i2c-stuff
> because the camera starts already in a default configuration which
> works fine for me.
> A V4L2-device is generated and everything looks fine. But when i start
> to capture, no data arrives BUT the Quick Capture Interface outputs a
> MCLK and the camera responds with a PCLK, LV and FV (and data of
> couse).
> For getting a bit closer to the origin of the problem I disabled DMA
> in pxa_camera.c and enabled all Interrupts in the CICR0 register. No
> interrupt is generated. Even by disabling DMA and IRQ and looking into
> CISR nothing happens.
> I checked all the CIF registers bitwise. The polarity of the LV and FV
> is correct, the alternate pin functions are correct, the interrupt bit
> is non-masked, the size of the pixel matrix is correct. I'm a bit
> desperate because at the moment I have no idea what to do next. I
> would be thankful for any hint.

Maybe you could post your platform data, i.e., your struct 
pxacamera_platform_data?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
