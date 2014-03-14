Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40695 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbaCNHFc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 03:05:32 -0400
Date: Fri, 14 Mar 2014 08:05:05 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Message-ID: <20140314070505.GV1629@pengutronix.de>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
 <20140307182330.75168C40AE3@trevor.secretlab.ca>
 <20140310102630.3cb1bcd7@samsung.com>
 <20140310143758.3734FC405FA@trevor.secretlab.ca>
 <1394708896.3577.21.camel@paszta.hi.pengutronix.de>
 <20140313113527.GM21483@n2100.arm.linux.org.uk>
 <5321CB04.6090700@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5321CB04.6090700@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, Mar 13, 2014 at 04:13:08PM +0100, Sylwester Nawrocki wrote:
> My experience and feelings are similar, I started to treat mainline
> kernel much less seriously after similar DT related blocking issues.

So how do we proceed now? Philipp implemented any of the suggested
variants now; nevertheless, there doesn't seem to be a consensus.

However, we really need a decision of the oftree maintainers. I think we
are fine with almost any of the available variants, as long as there is
a decision. 

It would be great if we could soon continue to address the technical
issues with the IPU, instead of turning around oftree bindings. There
is really enough complexity left :-)

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
