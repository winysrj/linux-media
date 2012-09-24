Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57571 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2IXMXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 08:23:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: P Jackson <pej02@yahoo.co.uk>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9t031 driver support on OMAP3 system
Date: Mon, 24 Sep 2012 14:24:19 +0200
Message-ID: <6813233.sAgYNN8Ius@avalon>
In-Reply-To: <Pine.LNX.4.64.1209230001390.26787@axis700.grange>
References: <1348335758.70304.YahooMailNeo@web28902.mail.ir2.yahoo.com> <Pine.LNX.4.64.1209230001390.26787@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pete,

On Sunday 23 September 2012 00:04:20 Guennadi Liakhovetski wrote:
> On Sat, 22 Sep 2012, P Jackson wrote:
> > I'm trying to incorporate an MT9T031-based sensor into a commercial
> > small form-factor OMAP3 DM3730-based system which is supplied with
> > sources for a 2.6.37 kernel and is somewhat out-dated.The application
> > I'm working on requires a single image to be acquired from the sensor
> > every once in a while which is then processed off-line by another
> > algorithm on the OMAP3
> > 
> > I'd appreciate any advice from the list as to what the most suitable up
> > to-date compatible kernel I should use would be and what other work I
> > need to do in order to get things sorted.
> 
> I would certainly advise to use a current kernel (e.g., 3.5). As for
> "how," I know, that Laurent has worked on a similar tasks, you can find
> his posts in mailing list archives, or maybe he'll be able to advise you
> more specifically.

You can have a look at 
http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
sensors-board to see how I've modified the ov772x driver to make it usable 
with the OMAP3 ISP. The patches are not upstreamable as such, I still need to 
work on them. I've explained the issues in detail on the mailing list.

-- 
Regards,

Laurent Pinchart

