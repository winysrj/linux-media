Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60110 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754394AbZDCMlL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2009 08:41:11 -0400
Date: Fri, 3 Apr 2009 14:41:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Darius Augulis <augulis.darius@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V4] Add camera (CSI) driver for MX1
In-Reply-To: <20090403122939.GT23731@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0904031437540.4729@axis700.grange>
References: <20090403113054.11098.67516.stgit@localhost.localdomain>
 <Pine.LNX.4.64.0904031352350.4729@axis700.grange> <20090403122939.GT23731@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 3 Apr 2009, Sascha Hauer wrote:

> On Fri, Apr 03, 2009 at 02:15:34PM +0200, Guennadi Liakhovetski wrote:
> > Wondering, if it still will work then... At least it compiles. BTW, should 
> > it really also work with IMX? Then you might want to change this
> > 
> > 	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
> > 
> > to
> > 
> > 	depends on VIDEO_DEV && (ARCH_MX1 || ARCH_IMX) && SOC_CAMERA
> 
> This shouldn't be necessary. ARCH_IMX does not have the platform part to
> make use of this driver and will never get it.

Confused... Then why the whole that "IMX/MX1" in the driver? And why will 
it never get it - are they compatible or not? Or just there's no demand / 
chips are EOLed or something...

> > but you can do this later, maybe, when you actually get a chance to test 
> > it on IMX (if you haven't done so yet).
> > 
> > Sascha, we need your ack for the ARM part.
> 
> I'm OK with this driver: I have never worked with FIQs though so I can't
> say much to it.

Ok, I take it as an "Acked-by" then:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
