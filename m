Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:44210 "EHLO
	relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752500AbcEIN75 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 09:59:57 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org"
	<linux-renesas-soc@vger.kernel.org>
Subject: RE: V4L2 SDR compliance test?
Date: Mon, 9 May 2016 13:59:52 +0000
Message-ID: <SG2PR06MB103883ADEC282AE75D315B3BC3700@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <SG2PR06MB1038A920EEE2D8ED6E239FB4C3700@SG2PR06MB1038.apcprd06.prod.outlook.com>
 <20160509074729.01385647@recife.lan>
In-Reply-To: <20160509074729.01385647@recife.lan>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the clarifications.

> Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com> escreveu:
> 
> > Hi Maintainers, All,
> >
> > Renesas R-Car SoCs have Digital Radio Interface (DRIF) controllers.
> > They are receive only SPI slave modules that support I2S format. The 
> > targeted application of these controllers is SDR.
[...]
> > Two possible cases:
> > -------------------
> > 1) Third party tuner driver
> > 	- The framework does provide support to register tuner as a subdev 
> > and can be bound to the SDR device using notifier callbacks
> 
> Tuner is usually an i2c subdev, visible by the main SDR driver. No 
> problem
> here: the main driver should use the subdev callbacks to direct the 
> tuner- specific ioctls to the tuner subdev.

Yes. The main SDR driver can have code to direct tuner subdev.
 
> 
> > 2) User space Tuner app
> > 	- We also have cases where the tuner s/w logic can be a vendor 
> > supplied user space application or library that talks to the chip 
> > using generic system calls - like i2c read/writes.
> 
> Well, an userspace tuner app is out of the Kernel tree, so I can't see 
> how it would affect it: it can have whatever API it needs (or even no 
> API at all). Of course, in this case, the performance will very likely 
> be worse, as the SDR data should also be handled in userspace.
> 
> If, for performance issues, it would require a faster I/O, then such 
> tuner app should be converted to be a Kernel driver. Usually, it is 
> not hard to convert those drivers to Kernelspace, as typically it is 
> just a bunch of registers that should be set to make it to tune into 
> an specific frequency and to adjust the tuner filters to the desired 
> bandwidth and modulation type, in order to improve noise rejection.

Yes, this is possible. However, this is Tuner chip vendor's decision (NDA, license issues etc.) and it is not in our control.

As mentioned above, we can have the main SDR (DRIF) driver code to direct tuner subdev if present. However, when we want to upstream the DRIF driver we may not have a real Tuner driver/device to get the compliance test results. Should we run the compliance tests with a dummy stubbed tuner subdev? 

Please do suggest how to proceed in this case? 

Thanks,
Ramesh
