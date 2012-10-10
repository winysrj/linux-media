Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36594 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978Ab2JJKqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 06:46:24 -0400
Date: Wed, 10 Oct 2012 19:46:16 +0900
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
Message-ID: <20121010104615.GK17288@opensource.wolfsonmicro.com>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
 <20121005151057.GA5125@pengutronix.de>
 <Pine.LNX.4.64.1210051735360.13761@axis700.grange>
 <20121005160242.GX1322@pengutronix.de>
 <Pine.LNX.4.64.1210080950350.11034@axis700.grange>
 <20121010084006.GQ27665@pengutronix.de>
 <20121010085124.GJ17288@opensource.wolfsonmicro.com>
 <20121010092115.GW27665@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010092115.GW27665@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 10, 2012 at 11:21:15AM +0200, Sascha Hauer wrote:
> On Wed, Oct 10, 2012 at 05:51:27PM +0900, Mark Brown wrote:

> > Well, I'm unlikely to work on it as I don't have any systems which can
> > boot with device tree.

> If it's only that I'm sure we could spare a i.MX53 LOCO ;)

Well, something with Wolfson hardware would be helpful.

> > The big, big problem you've got doing this is lots of dynamic changes at 
> > runtime and in general complicated systems.  It's trivial to describe
> > the physical links but they don't provide anything like enough
> > information to use things.  Quite frankly I'm not sure device tree is a
> > useful investment of time for advanced audio systems anyway, it's really
> > not solving any problems people actually have.

> Right now the i.MX audmux binding is only enough to say which ports
> should be connected, but not which format should be used. Just today

Why should that be in DT?  For most things it's either fixed by the
hardware or makes no odds.

> we had the problem where a codec has two DAIs and wanted to add the
> information on which port our SSI unit is connected to the devicetree.

There's nothing stopping you doing that right now, the existing DT 

> So I think it's worthwile to do, but that would be a big big task...

For simple devices there's already stuff there and it's not hard to add
new machine bindings, it's trying to cover the general case that's far
too much effort.
