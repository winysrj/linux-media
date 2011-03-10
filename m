Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:59885 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab1CJPsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 10:48:09 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 10 Mar 2011 21:17:46 +0530
Subject: RE: mt9p031 support for Beagleboard.
Message-ID: <19F8576C6E063C45BE387C64729E739404E1F52A88@dbde02.ent.ti.com>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
 <Pine.LNX.4.64.1103101632260.18816@axis700.grange>
 <201103101644.23547.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103101644.23547.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Thursday, March 10, 2011 9:14 PM
> To: Guennadi Liakhovetski
> Cc: javier Martin; Linux Media Mailing List; Mauro Carvalho Chehab
> Subject: Re: mt9p031 support for Beagleboard.
> 
> Hi Guennadi,
> 
> On Thursday 10 March 2011 16:36:36 Guennadi Liakhovetski wrote:
> > On Thu, 10 Mar 2011, javier Martin wrote:
> > > Hi,
> > > we are going to receive a Beagleaboard xM board in a couple of days.
> > > One of the things we would like to test is video capture.
> > >
> > > When it comes to the DM3730 SoC, it seems the support is given through
> > > these two files:
> > >
> http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video/davinci/vpfe_cap
> > > ture.c --> to capture from sensor
> > >
> http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video/davinci/dm644x_c
> > > cdc.c --> to convert from Bayer RGB to YUV
> > >
> > > On the other hand, the sensor we would like to test is mt9p031 which
> > > comes with LI-5M03, a module that can be attached to Beagleboard xM
> > > directly:
> > > https://www.leopardimaging.com/Beagle_Board_xM_Camera.html
> > >
> > > By a lot of googling I found this version of a driver for mt9p031
> > > which is developed by Guennadi Liakhovetski. It is located in a 2.6.32
> > > based branch:
> > That's a back-port of my patches by a "third party";) Probably, never
> > actually tested.
> >
> > > http://arago-project.org/git/projects/?p=linux-
> davinci.git;a=blob;f=drive
> > >
> rs/media/video/mt9p031.c;h=66b5e54d0368052bf76796aa846e9464e42204bb;hb=HE
> > > AD
> > >
> > > The question is, what does this driver lack for not entering into
> > > mainline? We would be very interested on helping it make it.
> >
> > I'm waiting for media-controller to be pulled by Mauro (I think, they
> > needed some updates by Laurent, not sure about the current state). As
> soon
> > as that's in the mainline, I'll try to find some time to update, clean
> up
> > and submit my beagle-board and mt9p031 patches.
> 
> I'll submit Aptina sensor drivers as well. I'll review your patches.
> 
> I'm curious about the Beagleboard code, as the camera module is an
> expansion
> board you obviously can't hardcode support for it in the board file. How
> do
> you plan to handle that ?
> 
[Hiremath, Vaibhav] Laurent,

I did not understand your concern here, I already have MT9V113 sensor running with Media-controller (YUV format) on top of beagleXm board.

Thanks,
Vaibhav

> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
