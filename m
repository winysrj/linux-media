Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40449 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab2JJIvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 04:51:36 -0400
Date: Wed, 10 Oct 2012 17:51:27 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
Message-ID: <20121010085124.GJ17288@opensource.wolfsonmicro.com>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
 <20121005151057.GA5125@pengutronix.de>
 <Pine.LNX.4.64.1210051735360.13761@axis700.grange>
 <20121005160242.GX1322@pengutronix.de>
 <Pine.LNX.4.64.1210080950350.11034@axis700.grange>
 <20121010084006.GQ27665@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010084006.GQ27665@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 10, 2012 at 10:40:06AM +0200, Sascha Hauer wrote:

> Mark, when do we get the same for aSoC? ;)

Well, I'm unlikely to work on it as I don't have any systems which can
boot with device tree.

The big, big problem you've got doing this is lots of dynamic changes at 
runtime and in general complicated systems.  It's trivial to describe
the physical links but they don't provide anything like enough
information to use things.  Quite frankly I'm not sure device tree is a
useful investment of time for advanced audio systems anyway, it's really
not solving any problems people actually have.
