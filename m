Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39519 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1F2Lck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 07:32:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alex Gershgorin <alexg@meprolight.com>
Subject: Re: FW: OMAP 3 ISP
Date: Wed, 29 Jun 2011 13:32:55 +0200
Cc: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	"'Michael Jones'" <michael.jones@matrix-vision.de>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
References: <4875438356E7CA4A8F2145FCD3E61C0B2A5D211E42@MEP-EXCH.meprolight.com>
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2A5D211E42@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291332.56241.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Alex,

On Wednesday 29 June 2011 13:18:10 Alex Gershgorin wrote:
> Hi Laurent,
> 
> From previous correspondence:
> 
> My video source is not the video camera and performs many other functions.
> For this purpose I have RS232 port.
> As for the video, it runs continuously and is not subject to control except
> for the power supply.
> 
> > As a quick hack, you can create an I2C driver for your video source that
> > doesn't access the device and just returns fixed format and frame size.
> > 
> > The correct fix is to implement support for platform subdevs in the V4L2
> > core.
> 
> Yes, I wrote a simple driver, now it looks like this:
> 
> [    2.029754] Linux media interface: v0.10
> [    2.034851] Linux video capture interface: v2.00
> [    2.041015] My_probe I2C subdev probed

Are you sure that's the probe method ? Isn't it the init method ?

> [    2.047058] omap3isp omap3isp: Revision 2.0 found
> [    2.052307] omap-iommu omap-iommu.0: isp: version 1.1
> [    2.069854] i2c i2c-3: Failed to register i2c client my-te at 0x21 -16)

Make sure you don't already have an I2C device at address 0x21 on the same 
bus.

> [    2.077301] isp_register_subdev_group: Unable to register subdev my-te
> 
> I see now that, subdev probed but the same problem stays.
> 
> Really I do not have a physical I2C address 0x21, he was selected for
> registration
> 
> may be a 'problem in this?

-- 
Regards,

Laurent Pinchart
