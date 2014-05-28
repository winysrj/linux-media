Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:50297 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaE1KIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 06:08:30 -0400
Date: Wed, 28 May 2014 12:07:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] [media] mt9v032: Add support for mt9v022 and mt9v024
In-Reply-To: <1401270626.3054.13.camel@paszta.hi.pengutronix.de>
Message-ID: <Pine.LNX.4.64.1405281155440.27831@axis700.grange>
References: <1401112985-32338-1-git-send-email-p.zabel@pengutronix.de>
 <Pine.LNX.4.64.1405272146260.24747@axis700.grange>
 <1401270626.3054.13.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 May 2014, Philipp Zabel wrote:

> Hi Guennadi,
> 
> Am Dienstag, den 27.05.2014, 21:48 +0200 schrieb Guennadi Liakhovetski:
> > Hi Philipp,
> > 
> > On Mon, 26 May 2014, Philipp Zabel wrote:
> > 
> > > >From the looks of it, mt9v022 and mt9v032 are very similar,
> > > as are mt9v024 and mt9v034. With minimal changes it is possible
> > > to support mt9v02[24] with the same driver.
> > 
> > Are you aware of drivers/media/i2c/soc_camera/mt9v022.c?
> 
> Yes. Unfortunately this driver can't be used in a system without
> soc_camera. It uses soc_camera helpers and doesn't implement pad ops
> among others.

As I mentioned many times, this compatibility is a matter of someone just 
needing and finally doing this. If you need this, please, extend the 
mt9v022 driver to also work with non soc-camera hosts, if you need any 
help - please feel free to ask, I can send you my conversion code, that 
I've done for ov772x, but never managed to finalise testing, 
unfortunately.

> > With this patch you'd duplicate support for both mt9v022 and mt9v024,
> > which doesn't look like a good idea to me.
> 
> While this is true, given that the mt9v02x/3x sensors are so similar,
> the support is already duplicated in all but name.
> Would you suggest we should try to merge the mt9v032 and mt9v022
> drivers?

Out of 3 options:

1. extend mt9v022 to work with non soc-camera hosts
2. extend mt9v032 to also support mt9v022 and mt9v024
3. merge both mt9v022 and mt9v032 drivers

option 2 seems the worst to me. I'm ok with either 1 or 3, whereas 3 is 
more difficult than 1.

Thanks
Guennadi
