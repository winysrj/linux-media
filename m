Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43752 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2GWMOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:14:24 -0400
Date: Mon, 23 Jul 2012 13:14:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] media DT bindings
Message-ID: <20120723121420.GC8302@sirena.org.uk>
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange>
 <5000375B.9060100@gmail.com>
 <Pine.LNX.4.64.1207161257590.18978@axis700.grange>
 <5006EB9F.5010408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5006EB9F.5010408@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 18, 2012 at 07:00:15PM +0200, Sylwester Nawrocki wrote:

> One possible solution would be to have host/bridge drivers to register
> a clkdev entry for I2C client device, so it can acquire the clock through 
> just clk_get(). We would have to ensure the clock is not tried to be
> accessed before it is registered by a bridge. This would require to add
> clock handling code to all sensor/encoder subdev drivers though..

If this is done well it could just be a simple callback, and we could
probably arrange for the framework to just implement the default
behaviour if the driver doesn't do anything explicit.

Of couse this is one of those things where we really need the generic
clock API to be generally available...
