Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48144 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaCFPkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 10:40:07 -0500
Message-ID: <1394120379.3622.37.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to
 drivers/of
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Date: Thu, 06 Mar 2014 16:39:39 +0100
In-Reply-To: <20140306152414.GC21483@n2100.arm.linux.org.uk>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
	 <20140306152414.GC21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 06.03.2014, 15:24 +0000 schrieb Russell King - ARM
Linux:
> On Wed, Mar 05, 2014 at 10:20:34AM +0100, Philipp Zabel wrote:
> > this version of the OF graph helper move series further addresses a few of
> > Tomi's and Sylwester's comments.
> 
> Philipp,
> 
> You mention in your other cover for imx-drm bits that this is available
> via:
> 
> 	git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> 
> What is this tree based upon?

It is based on v3.14-rc5.

regards
Philipp

