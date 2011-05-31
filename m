Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58804 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab1EaKBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 06:01:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
Subject: Re: omap3isp - H3A auto white balance
Date: Tue, 31 May 2011 12:01:14 +0200
Cc: linux-media@vger.kernel.org
References: <CA7B7D6C54015B459601D68441548157C5A3FC@prevas1.prevas.se> <201105271647.12503.laurent.pinchart@ideasonboard.com> <CA7B7D6C54015B459601D68441548157C5A401@prevas1.prevas.se>
In-Reply-To: <CA7B7D6C54015B459601D68441548157C5A401@prevas1.prevas.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105311201.15285.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Daniel,

On Tuesday 31 May 2011 11:45:13 Daniel Lundborg wrote:
> > On Thursday 26 May 2011 15:06:17 Daniel Lundborg wrote:
> > > > On Thursday 26 May 2011 10:57:39 Daniel Lundborg wrote:
> > > > > Hello,
> > > > > 
> > > > > I am developing a camera sensor driver for the Aptina MT9V034. I
> > > > > am only using it in snapshot mode and I can successfully trigger
> > > > > the sensor and receive pictures using the latest omap3isp driver
> > > > > from git://linuxtv.org/pinchartl/media.git branch
> > > > > omap3isp-next-sensors with kernel 2.6.38.

[snip]

> > > > > My trouble is that I am always receiving whiter pictures when I
> > > > > wait a moment before triggering the sensor to take a picture. If I
> > > > > take several pictures in a row with for instance 20 ms between
> > > > > them, they all look ok. But if I wait for 100 ms the picture will
> > > > > get much whiter.
> > > > >
> > > > > I have turned off auto exposure and auto gain in the sensor and
> > > > > the LED_OUT signal always have the same length (in this case 8
> > > > > msec).
> > > >
> > > > I assume you've measured it with a scope ?
> > > > 
> > > > Try disabling black level calibration and row noise correction as
> > > > well.
> > > >
> > > > Please also double-check that AEC and AGC are disabled. I've had a
> > > > similar issue with an MT9V032 sensor, where a bug in the driver
> > > > enabled AEC/AGC instead of disabling them.
> > > 
> > > The register on 0xaf (MT9V034_AGC_AEC_ENABLE) is set to 0 and is 0
> > > when I read from it.
> > > bit 0 - AEC enable context A, bit 1 - AGC enable context A, bit 8 -
> > > AEC enable context B, bit 9 - AGC enable context B
> > > 
> > > The register on 0x47 (MT9V034_BL_CALIB_CTRL) is set to 0 and is 0
> > > when I read from it.
> > > bit 0 - (1 = override with programmed values, 0 = normal operation),
> > > bit 7:5 - Frames to average over
> > 
> > If I'm not mistaken "normal operation" means that automatic black
> > level calibration is enabled. Try to set bit 0 to 1 to override the
> > automatic algorithm (and program a zero value in register 0x48).
> 
> This did not work unfortunately.. :( I have solved this by always taking
> 2 pictures and ignoring the first of them...

:-/

Any chance you will submit the driver for inclusion in the kernel ?

-- 
Regards,

Laurent Pinchart
