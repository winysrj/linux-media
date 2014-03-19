Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59392 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759349AbaCSR1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 13:27:53 -0400
Date: Wed, 19 Mar 2014 17:27:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH RFC 26/46] drivers/base: provide an infrastructure for
	componentised subsystems
Message-ID: <20140319172706.GG7528@n2100.arm.linux.org.uk>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk> <20140226221939.GC21483@n2100.arm.linux.org.uk> <16403654.Dg5ZqMop7H@avalon> <2098368.XZDkvYocrm@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2098368.XZDkvYocrm@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 19, 2014 at 06:22:14PM +0100, Laurent Pinchart wrote:
> Hi Russell,
> 
> (CC'ing Philipp Zabel who might be able to provide feedback as a user of the 
> component framework)
> 
> Could you please have a look at the questions below and provide an answer when 
> you'll have time ? I'd like to bridge the gap between the component and the 
> V4L2 asynchronous registration implementations.

I have a reply partly prepared, but I'm snowed under by the L2 cache stuff
at the moment, sorry.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
