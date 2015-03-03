Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33286 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbbCCIFj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 03:05:39 -0500
Message-ID: <1425369928.3146.19.camel@pengutronix.de>
Subject: Re: [PATCH v8 0/3] Add of-graph helpers to loop over endpoints and
 find ports by id
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org,
	Darren Etheridge <detheridge@ti.com>, kernel@pengutronix.de,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Grant Likely <grant.likely@linaro.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Tue, 03 Mar 2015 09:05:28 +0100
In-Reply-To: <4784761.VJqXeAqkXK@avalon>
References: <1424688846-10909-1-git-send-email-p.zabel@pengutronix.de>
	 <4784761.VJqXeAqkXK@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Sonntag, den 01.03.2015, 18:20 +0200 schrieb Laurent Pinchart:
> Hi Philipp and all,
> 
> This series has been around for a long time, it seems to be time to get it 
> merged.
> 
> What's the plan ? If we wait for the v4.1 merge window there's a chance we'll 
> get more conflicts, especially on patch 1/3. Could it be merged in v4.0-rc to 
> avoid that ?

I've just sent another pull request to Grant and Rob. My favorite
outcome would be for the tag to be merged in time for v4.0 via the
device tree branch. My second most favorite outcome would be maintainer
approval to merge the same tag into both drm, media, etc. for v4.1.

regards
Philipp

> On Monday 23 February 2015 11:54:03 Philipp Zabel wrote:
> > Hi,
> > 
> > Since there now is a merge conflict in imx-drm-core, I've rebased the series
> > onto v4.0-rc1. Also a new driver touched by this change appeared, so the
> > first patch now includes a fix for am437x-vfpe, too. I'd be happy to get an
> > ack for that.
> > 
> > This series converts all existing users of of_graph_get_next_endpoint that
> > pass a non-NULL prev argument to the function and decrement its refcount
> > themselves to stop doing that. The of_node_put is moved into
> > of_graph_get_next_endpoint instead.
> > This allows to add a for_each_endpoint_of_node helper macro to loop over all
> > endpoints in a device tree node.
> > 
> > Changes since v8:
> >  - Rebased onto v4.0-rc1
> >  - Added fix to am437x-vpfe
> > 
> > The previous version can be found here: https://lkml.org/lkml/2014/12/23/219
> > 
> > regards
> > Philipp
> > 
> > Philipp Zabel (3):
> >   of: Decrement refcount of previous endpoint in
> >     of_graph_get_next_endpoint
> >   of: Add for_each_endpoint_of_node helper macro
> >   of: Add of_graph_get_port_by_id function
> > 
> >  drivers/coresight/of_coresight.c                  | 13 ++-----
> >  drivers/gpu/drm/imx/imx-drm-core.c                | 11 +-----
> >  drivers/gpu/drm/rcar-du/rcar_du_kms.c             | 15 +++------
> >  drivers/media/platform/am437x/am437x-vpfe.c       |  1 -
> >  drivers/media/platform/soc_camera/soc_camera.c    |  3 +-
> >  drivers/of/base.c                                 | 41 +++++++++++++++-----
> >  drivers/video/fbdev/omap2/dss/omapdss-boot-init.c |  7 +---
> >  include/linux/of_graph.h                          | 18 ++++++++++
> >  8 files changed, 61 insertions(+), 48 deletions(-)
> 


