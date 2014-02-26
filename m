Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaBZVBJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 16:01:09 -0500
Date: Wed, 26 Feb 2014 22:00:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
cc: David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH RFC 26/46] drivers/base: provide an infrastructure for
 componentised subsystems
In-Reply-To: <E1Vypo6-0007FF-Lb@rmk-PC.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1402262144190.10826@axis700.grange>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk>
 <E1Vypo6-0007FF-Lb@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell

(I suspect this my email will be rejected by ALKML too like other my 
recent emails, but at least other MLs will pick it up and individual CCs 
too, so, if replying, maybe it would be good to keep my entire reply, all 
the more that it's going to be very short)

On Thu, 2 Jan 2014, Russell King wrote:

> Subsystems such as ALSA, DRM and others require a single card-level
> device structure to represent a subsystem.  However, firmware tends to
> describe the individual devices and the connections between them.
> 
> Therefore, we need a way to gather up the individual component devices
> together, and indicate when we have all the component devices.
> 
> We do this in DT by providing a "superdevice" node which specifies
> the components, eg:
> 
> 	imx-drm {
> 		compatible = "fsl,drm";
> 		crtcs = <&ipu1>;
> 		connectors = <&hdmi>;
> 	};

It is a pity linux-media wasn't CC'ed and apparently V4L developers didn't 
notice this and other related patches in a "clean up" series, and now this 
patch is already in the mainline. But at least I'd like to ask whether the 
bindings, defined in 
Documentation/devicetree/bindings/media/video-interfaces.txt and 
implemented in drivers/media/v4l2-core/v4l2-of.c have been considered for 
this job, and - if so - why have they been found unsuitable? Wouldn't it 
have been better to use and - if needed - extend them to cover any 
deficiencies? Even though the implementation is currently located under 
drivers/media/v4l2-code/ it's pretty generic and should be easily 
transferable to a more generic location.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
