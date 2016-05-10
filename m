Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:47717 "EHLO
	relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750806AbcEJGPp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 02:15:45 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org"
	<linux-renesas-soc@vger.kernel.org>
Subject: RE: V4L2 SDR compliance test?
Date: Tue, 10 May 2016 06:15:39 +0000
Message-ID: <SG2PR06MB103853EC215AF63473923D9DC3710@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <SG2PR06MB1038A920EEE2D8ED6E239FB4C3700@SG2PR06MB1038.apcprd06.prod.outlook.com>
	<20160509074729.01385647@recife.lan>
	<SG2PR06MB103883ADEC282AE75D315B3BC3700@SG2PR06MB1038.apcprd06.prod.outlook.com>
 <20160509121748.7f1f7472@recife.lan>
In-Reply-To: <20160509121748.7f1f7472@recife.lan>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com> escreveu:
> 
> > Hi Mauro,
> >
> > Thanks for the clarifications.
> >
> > > Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> escreveu:
> > >
> > > > Hi Maintainers, All,
> > > >
> > > > Renesas R-Car SoCs have Digital Radio Interface (DRIF) controllers.
> > > > They are receive only SPI slave modules that support I2S format.
> > > > The targeted application of these controllers is SDR.
[...]
> > > If, for performance issues, it would require a faster I/O, then such
> > > tuner app should be converted to be a Kernel driver. Usually, it is
> > > not hard to convert those drivers to Kernelspace, as typically it is
> > > just a bunch of registers that should be set to make it to tune into
> > > an specific frequency and to adjust the tuner filters to the desired
> > > bandwidth and modulation type, in order to improve noise rejection.
> >
> > Yes, this is possible. However, this is Tuner chip vendor's decision
> (NDA, license issues etc.) and it is not in our control.
> 
> True, but an independent tuner driver very likely can be written with very
> little effort. All it requires is to monitor the traffic at the I2C bus
> and to write a driver that reproduces it, identifying what part of the I2C
> messages contain the frequency and enable/disable the filters.

Yes, this is possible. 

> 
> We have several such drivers in the Kernel, and that's the procedure used
> when the chipset vendor doesn't see the value of having his chipset used
> by a Linux-based device.
> 
> > As mentioned above, we can have the main SDR (DRIF) driver code to
> direct tuner subdev if present. However, when we want to upstream the DRIF
> driver we may not have a real Tuner driver/device to get the compliance
> test results. Should we run the compliance tests with a dummy stubbed
> tuner subdev?
> 
> No, an upstream requirement is to have everything tested on real hardware.
> What I recommend you is to either convince the tuner provider to send
> upstream a driver (or allow you to do so) or to switch to some other
> vendor whose driver is already in the Kernel or sees the value of having
> his chipset used on Linux.

Yep, that is a clear mandate. We shall talk to Tuner vendor and decide accordingly.

Thanks for your time and inputs,
Ramesh
