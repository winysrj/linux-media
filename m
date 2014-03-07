Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:52619 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaCGMUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 07:20:41 -0500
Date: Fri, 07 Mar 2014 09:20:31 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Grant Likely <grant.likely@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Message-id: <20140307092031.68cd985d@samsung.com>
In-reply-to: <20140307115517.GI21483@n2100.arm.linux.org.uk>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
 <20140307115517.GI21483@n2100.arm.linux.org.uk>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 07 Mar 2014 11:55:17 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> escreveu:

> On Thu, Mar 06, 2014 at 06:13:20PM +0100, Philipp Zabel wrote:
> > Hi Mauro, Russell,
> > 
> > I have temporarily removed the simplified bindings at Sylwester's
> > request and updated the branch with the acks. The following changes
> > since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:
> > 
> >   Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)
> > 
> > are available in the git repository at:
> > 
> >   git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> 
> Okay, this has all gone wrong.  Mauro has applied your changes as patches,
> and I've pulled this set of changes.  So we're going to be all set for
> merge conflicts....... just fscking great.
> 
> I really don't know why I bother trying to do the right thing sometimes.
> 

I just reverted my tree to the previous state before applying the patches
and did a git pull instead, in order to avoid merge conflicts when the
imx-drm patches arrive via staging tree.

Regards,
Mauro
