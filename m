Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.24]:63878 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaCFLqw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 06:46:52 -0500
Date: Thu, 6 Mar 2014 12:46:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
In-Reply-To: <20140226221939.GC21483@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1403061241560.30001@axis700.grange>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk>
 <E1Vypo6-0007FF-Lb@rmk-PC.arm.linux.org.uk> <Pine.LNX.4.64.1402262144190.10826@axis700.grange>
 <20140226221939.GC21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

Sorry for a long delay.

On Wed, 26 Feb 2014, Russell King - ARM Linux wrote:

[snip]

> Better bindings for imx-drm are currently being worked on.  Philipp
> Zabel of Pengutronix is currently looking at it, and has posted many
> RFC patches on this very subject, including moving the V4L2 OF helpers
> to a more suitable location.  OF people have been involved in that
> discussion over the preceding weeks, and there's a working implementation
> of imx-drm using these helpers from v4l2.

Yes, I'm aware of that patch series, and I do look at the discussion from 
time to time, unfortunately I don't have too much time for it now. But in 
any case if this work is going to be used with imx-drm too, that should be 
a good direction to take, I think.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
