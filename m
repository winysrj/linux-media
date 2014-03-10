Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:60523 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaCJN0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 09:26:40 -0400
Date: Mon, 10 Mar 2014 10:26:30 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Rob Herring <robh+dt@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Message-id: <20140310102630.3cb1bcd7@samsung.com>
In-reply-to: <20140307182330.75168C40AE3@trevor.secretlab.ca>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
 <20140307182330.75168C40AE3@trevor.secretlab.ca>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 07 Mar 2014 18:23:30 +0000
Grant Likely <grant.likely@linaro.org> escreveu:

> On Thu, 06 Mar 2014 18:13:20 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
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
> > 
> > for you to fetch changes up to d484700a36952c6675aa47dec4d7a536929aa922:
> > 
> >   of: Warn if of_graph_parse_endpoint is called with the root node (2014-03-06 17:41:54 +0100)
> 
> Nak. I made comments that haven't been resolved yet. I've replied with
> more detail tonight. The big issues are how drivers handle the optional
> 'ports' node and I do not agree to the double-linkage in the binding
> description.

If I understood well, you're requesting to revert all those six patches
that were imported via git pull from my tree (and from Greg and Russell),
right?

E. g. reverting those changesets:
	d484700a3695 f2a575f67695 4329b93b283c 6ff60d397b17 4d56ed5a009b fd9fdb78a9bf

as it seems that there's no easy way to revert a git pull.

I suspect that this will likely cause some harm when merging from our
trees upstream.

Regards,
Mauro

> 
> g.
> 
> > 
> > ----------------------------------------------------------------
> > Philipp Zabel (6):
> >       [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
> >       Documentation: of: Document graph bindings
> >       of: Warn if of_graph_get_next_endpoint is called with the root node
> >       of: Reduce indentation in of_graph_get_next_endpoint
> >       [media] of: move common endpoint parsing to drivers/of
> >       of: Warn if of_graph_parse_endpoint is called with the root node
> > 
> >  Documentation/devicetree/bindings/graph.txt   | 129 ++++++++++++++++++++++
> >  drivers/media/i2c/adv7343.c                   |   4 +-
> >  drivers/media/i2c/mt9p031.c                   |   4 +-
> >  drivers/media/i2c/s5k5baf.c                   |   3 +-
> >  drivers/media/i2c/tvp514x.c                   |   3 +-
> >  drivers/media/i2c/tvp7002.c                   |   3 +-
> >  drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
> >  drivers/media/platform/exynos4-is/media-dev.c |  13 ++-
> >  drivers/media/platform/exynos4-is/mipi-csis.c |   5 +-
> >  drivers/media/v4l2-core/v4l2-of.c             | 133 +----------------------
> >  drivers/of/base.c                             | 151 ++++++++++++++++++++++++++
> >  include/linux/of_graph.h                      |  66 +++++++++++
> >  include/media/v4l2-of.h                       |  33 +-----
> >  13 files changed, 375 insertions(+), 178 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/graph.txt
> >  create mode 100644 include/linux/of_graph.h
> > 
> > 
> 


-- 

Regards,
Mauro
