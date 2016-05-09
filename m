Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60761 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbcEIPRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 11:17:54 -0400
Date: Mon, 9 May 2016 12:17:48 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org"
	<linux-renesas-soc@vger.kernel.org>
Subject: Re: V4L2 SDR compliance test?
Message-ID: <20160509121748.7f1f7472@recife.lan>
In-Reply-To: <SG2PR06MB103883ADEC282AE75D315B3BC3700@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <SG2PR06MB1038A920EEE2D8ED6E239FB4C3700@SG2PR06MB1038.apcprd06.prod.outlook.com>
	<20160509074729.01385647@recife.lan>
	<SG2PR06MB103883ADEC282AE75D315B3BC3700@SG2PR06MB1038.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 9 May 2016 13:59:52 +0000
Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com> escreveu:

> Hi Mauro,
> 
> Thanks for the clarifications.
> 
> > Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com> escreveu:
> >   
> > > Hi Maintainers, All,
> > >
> > > Renesas R-Car SoCs have Digital Radio Interface (DRIF) controllers.
> > > They are receive only SPI slave modules that support I2S format. The 
> > > targeted application of these controllers is SDR.  
> [...]
> > > Two possible cases:
> > > -------------------
> > > 1) Third party tuner driver
> > > 	- The framework does provide support to register tuner as a subdev 
> > > and can be bound to the SDR device using notifier callbacks  
> > 
> > Tuner is usually an i2c subdev, visible by the main SDR driver. No 
> > problem
> > here: the main driver should use the subdev callbacks to direct the 
> > tuner- specific ioctls to the tuner subdev.  
> 
> Yes. The main SDR driver can have code to direct tuner subdev.
>  
> >   
> > > 2) User space Tuner app
> > > 	- We also have cases where the tuner s/w logic can be a vendor 
> > > supplied user space application or library that talks to the chip 
> > > using generic system calls - like i2c read/writes.  
> > 
> > Well, an userspace tuner app is out of the Kernel tree, so I can't see 
> > how it would affect it: it can have whatever API it needs (or even no 
> > API at all). Of course, in this case, the performance will very likely 
> > be worse, as the SDR data should also be handled in userspace.
> > 
> > If, for performance issues, it would require a faster I/O, then such 
> > tuner app should be converted to be a Kernel driver. Usually, it is 
> > not hard to convert those drivers to Kernelspace, as typically it is 
> > just a bunch of registers that should be set to make it to tune into 
> > an specific frequency and to adjust the tuner filters to the desired 
> > bandwidth and modulation type, in order to improve noise rejection.  
> 
> Yes, this is possible. However, this is Tuner chip vendor's decision (NDA, license issues etc.) and it is not in our control.

True, but an independent tuner driver very likely can be written with very
little effort. All it requires is to monitor the traffic at the I2C bus
and to write a driver that reproduces it, identifying what part of the
I2C messages contain the frequency and enable/disable the filters.

We have several such drivers in the Kernel, and that's the procedure used
when the chipset vendor doesn't see the value of having his chipset used
by a Linux-based device.

> As mentioned above, we can have the main SDR (DRIF) driver code to direct tuner subdev if present. However, when we want to upstream the DRIF driver we may not have a real Tuner driver/device to get the compliance test results. Should we run the compliance tests with a dummy stubbed tuner subdev? 

No, an upstream requirement is to have everything tested on real hardware.
What I recommend you is to either convince the tuner provider to send
upstream a driver (or allow you to do so) or to switch to some other vendor
whose driver is already in the Kernel or sees the value of having his
chipset used on Linux.
 
> Please do suggest how to proceed in this case? 
> 

Regards,
Mauro
