Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41375 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757583AbZFJVJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:09:29 -0400
Date: Wed, 10 Jun 2009 23:09:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Subject: mt9t031 (was RE: [PATCH] adding support for setting bus parameters
 in sub device)
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139A08DC3@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0906102303190.4817@axis700.grange>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906102022320.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A08DC3@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2009, Karicheri, Muralidharan wrote:

> Guennadi,
> 
> Thanks for responding. I acknowledge I need to add
> master & slave information in the structure. Querying
> the capabilities from the sub device is a good feature.
> I will look into your references and let you know if I
> have any question.
> 
> I will send an updated patch based on this.
> 
> BTW, I have a question about the mt9t031.c driver. Could
> I use this driver to stream VGA frames from the sensor?

Sure, any size the chip supports (up to 2048x1536) and your host can 
handle.

> Is it possible to configure the driver to stream at a
> specific fps?

No, patches welcome.

> We have a version of the driver used internally
> and it can do capture and stream of Bayer RGB data at VGA,
> 480p, 576p and 720p resolutions. I have started integrating
> your driver with my vpfe capture driver and it wasn't very
> clear to me. Looks like driver calculates the timing parameters
> based on the width and height of the capture area.

Yes, it provides exposure control by setting shutter timing, and it 
emulates autoexposure by calculating shutter times from window geometry.

> We need
> streaming capability in the driver. This is how our driver works
> with mt9t031 sensor
> 		  raw-bus (10 bit)
> vpfe-capture  ----------------- mt9t031 driver
> 	  |					   |
> 	  V				         V
> 	VPFE	 				MT9T031
> 
> VPFE hardware has internal timing and DMA controller to
> copy data frame by frame from the sensor output to SDRAM.
> The PCLK form the sensor is used to generate the internal
> timing.

So, what is missing in the driver apart from the ability to specify 
a frame-rate?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
