Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52861 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759106Ab0ECODf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 10:03:35 -0400
Date: Mon, 3 May 2010 16:03:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: ATMEL camera interface
In-Reply-To: <4BDED3A8.4090606@atmel.com>
Message-ID: <Pine.LNX.4.64.1005031556570.4231@axis700.grange>
References: <4BD9AA8A.7030306@atmel.com> <Pine.LNX.4.64.1004291824200.4666@axis700.grange>
 <4BDED3A8.4090606@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 3 May 2010, Sedji Gaouaou wrote:

> Hi,
> 
> I will try to write a soc driver(it seems easier ;)).
> 
> Are the mx?_camera.c a good starting point?

In principle - yes. But think about one pretty important distinction - 
what videobuf implementation is your driver going to use? Are you going to 
support scatter-gather or only contiguous buffers? If SG - the only such 
example in the mainline is pxa_camera.c. If contiguous - feel free to use 
any one of the rest. Further, mx3_camera uses the dmaengine API, others 
don't. Hope, this will simplify your choice a bit;)

Thanks
Guennadi

> Regards,
> Sedji
> 
> Le 4/29/2010 6:35 PM, Guennadi Liakhovetski a écrit :
> > Hi Sedji
> > 
> > On Thu, 29 Apr 2010, Sedji Gaouaou wrote:
> > 
> > > Hi,
> > > 
> > > I need to re-work my driver so I could commit it to the community.
> > > Is there a git tree that I can use?
> > 
> > Nice to hear that! As far as soc-camera is concerned, the present APIs are
> > pretty stable. Just use the Linus' git tree, or, if you like, you can use
> > the v4l-dvb git tree at git://linuxtv.org/v4l-dvb.git. In fact, you don't
> > have to use the soc-camera API these days, you can just write a complete
> > v4l2-device driver, using the v4l2-subdev API to interface to video
> > clients (sensors, decoders, etc.) However, you can still write your driver
> > as an soc-camera host driver, which would make your task a bit easier at
> > the cost of some reduced flexibility, it's up to you to decide.
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
