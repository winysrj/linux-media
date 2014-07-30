Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41687 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaG3XK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 19:10:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Problems with the omap3isp
Date: Thu, 31 Jul 2014 01:10:49 +0200
Message-ID: <5912662.x67xxWZ5ks@avalon>
In-Reply-To: <53C4FC99.9050308@herbrechtsmeier.net>
References: <53C4FC99.9050308@herbrechtsmeier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

Sorry for the late reply.

On Tuesday 15 July 2014 12:04:09 Stefan Herbrechtsmeier wrote:
> Hi Laurent,
> 
> I have some problems with the omap3isp driver. At the moment I use a
> linux-stable 3.14.5 with your fixes for omap3xxx-clocks.dtsi.
> 
> 1. If I change the clock rate to 24 MHz in my camera driver the whole
> system freeze at the clk_prepare_enable. The first enable and disable
> works without any problem. The system freeze during a systemd / udev
> call of media-ctl.

I've never seen that before. Where does your sensor get its clock from ? Is it 
connected to the ISP XCLKA or XCLKB output ? What happens if you don't change 
the clock rate to 24 MHz ? What rate is it set to in that case ?

> 2. If I enable the streaming I get a  "omap3isp omap3isp: CCDC won't
> become idle!" and if I disable streaming I get a "omap3isp omap3isp:
> Unable to stop OMAP3 ISP CCDC". I think the problem is, that I can't
> disable the camera output. Do you change the order of the stream enable
> / disable after Linux 3.4?

Not that I know of.

The two problems might be related, maybe we could concentrate on the first one 
first.

-- 
Regards,

Laurent Pinchart

