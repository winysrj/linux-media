Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52330 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaH1MCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 08:02:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Problems with the omap3isp
Date: Thu, 28 Aug 2014 14:03:27 +0200
Message-ID: <6301052.X8pjVEUngK@avalon>
In-Reply-To: <53FDB1EE.6010107@herbrechtsmeier.net>
References: <53C4FC99.9050308@herbrechtsmeier.net> <5795344.auXD3SfuqM@avalon> <53FDB1EE.6010107@herbrechtsmeier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

On Wednesday 27 August 2014 12:24:46 Stefan Herbrechtsmeier wrote:
> Am 04.08.2014 um 17:25 schrieb Laurent Pinchart:
> > On Monday 04 August 2014 11:24:13 Stefan Herbrechtsmeier wrote:
> >> Hi Laurent,
> >> 
> >> thank you very much for your help.
> >> 
> >> The problem is cross talk on the camera flex cable of the Gumstix Overo.
> >> The XCLKA signal is beside PCLK and VS.
> > 
> > Right, I should have mentioned that. It's a know issue, and there's not
> > much that can be done about it without a hardware redesign. A ground (or
> > power supply) signal should really have been inserted on each side of the
> > XCLKA and PCLK signals.
> 
> Exists a list about knowing issues with the Gumstix Overo? Because I
> have some problems with the MMC3 too.

Not to my knowledge. This crosstalk issue is something I've discovered and 
reported to Gumstix a couple of years ago.

> >> Additionally the OV5647 camera tristate all outputs by default. This
> >> leads to HS_VS_IRQ interrupts.
> > 
> > This should be taken care of by pull-up or pull-down resistors on the
> > camera signals. I've disabled them with the Caspa camera given the low
> > drive strength of the buffer on the camera board, but you could enable
> > them on your system.
>
> I have manually rework my camera adapter and change the camera clock
> from XCLKA to XCLKB. Additionally I have enable the pull-ups in my
> device tree. Now the camera sensor from the Raspberry Pi camera module
> works together with the Gumstix Overo.

Great. Any chance to see a driver for the ov5647 being submitted to the linux-
media mailing list ? :-)

-- 
Regards,

Laurent Pinchart

