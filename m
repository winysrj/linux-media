Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59577 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbcBVQH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 11:07:57 -0500
Date: Mon, 22 Feb 2016 17:08:57 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <rainyfeeling@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>
Subject: Re: [RFC] Move some soc-camera drivers to staging in preparation for
 removal
Message-ID: <20160222160857.GB2607@odux.rfo.atmel.com>
References: <56C71778.2030706@xs4all.nl>
 <1685709.3nM7dPdDel@avalon>
 <Pine.LNX.4.64.1602221427510.10936@axis700.grange>
 <1864387.TRmC7Phqsl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1864387.TRmC7Phqsl@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 22, 2016 at 04:23:54PM +0200, Laurent Pinchart wrote:
> Hi Guennadi,
> 
> (CC'ing Ludovic Desroches)
> 
> On Monday 22 February 2016 14:39:08 Guennadi Liakhovetski wrote:
> > Hi Laurent,
> > 
> > On Mon, 22 Feb 2016, Laurent Pinchart wrote:
> > 
> > [snip]
> > 
> > > As far as I know Renesas (or at least the kernel upstream team) doesn't
> > > care. The driver is only used on five SH boards, I'd also say it can be
> > > removed.
> > [snip]
> > 
> > >>>> - atmel-isi: ATMEL Image Sensor Interface (ISI)
> > >>>> 
> > >>>>   I believe this is still actively maintained. Would someone be
> > >>>>   willing to convert this? It doesn't look like a complex driver.
> > > 
> > > That would be nice, I would like to avoid dropping this one.
> > 
> > Thanks for clarifying the state of the CEU driver. I did say, that I am
> > fine with dropping soc-camera gradually, and I stay with that. But I see
> > now, that at least two drivers want to stay active: Atmel ISI and PXA270.
> > One possibility is of course to make them independent drivers. If people
> > are prepared to invest work into that - sure, would be great! If we
> > however decide to keep soc-camera, I could propose the following: IIUC,
> > the largest problem is sensor drivers, that cannot be reused for other
> > non-soc-camera bridge drivers. The thing is, out of all the sensor drivers
> > currently under drivers/media/i2c/soc_camera only a couple are in use on
> > those active PXA270 and Atmel boards. I could propose the following:
> > 
> > 1. Remove all bridge drivers, that noone cares about.
> > 2. If anyone ever needs to use any of soc-camera-associated sensor
> >    drivers, take them out of soc-camera and _remove_ any soc-camera
> >    dependencies
> > 3. If any soc-camera boards will need that specific driver, which in
> >    itself is already unlikely, we'll have to fix that by teaching
> >    soc-camera to work with generic sensor drivers!
> 
> That sounds like a good plan.
> 
> Ludovic, any chance someone at Atmel could convert the ISI driver ?

I add Songjun to the cc list. I think he has in mind to do this
conversion.

Songjun, can you confirm?

Full thread here:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/99290

Regards

Ludovic
