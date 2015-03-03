Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52542 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbbCCIAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 03:00:05 -0500
Message-ID: <1425369592.3146.14.camel@pengutronix.de>
Subject: [GIT PULL v2] of: Add of-graph helpers to loop over endpoints and
 find ports by id
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>
Cc: Darren Etheridge <detheridge@ti.com>, kernel@pengutronix.de,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Tue, 03 Mar 2015 08:59:52 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Grant, Rob,

this series has been around for quite some time now, basically unchanged
except for adding fixes for new users of the API that keep appearing
over time in different subsystems.

It would be really helpful to get this merged for v4.0. Could you still
make this happen?

Alternatively, could I please get your ack to allow this tag to be
merged into the other subsystem trees for v4.1 so that patches that
depend on it don't have to wait for yet another merge window?

best regards
Philipp

The following changes since commit
c517d838eb7d07bbe9507871fab3931deccff539:

  Linux 4.0-rc1 (2015-02-22 18:21:14 -0800)

are available in the git repository at:

  git://git.pengutronix.de/git/pza/linux.git tags/of-graph-for-4.0

for you to fetch changes up to bfe446e37c4efd8ade454911e8f80414bcbfc10d:

  of: Add of_graph_get_port_by_id function (2015-02-23 11:42:24 +0100)

----------------------------------------------------------------
of: Add of-graph helpers to loop over endpoints and find ports by id

This series converts of_graph_get_next_endpoint to decrement the
refcount of
the passed prev parameter. This allows to add a
for_each_endpoint_of_node
helper macro to loop over all endpoints in a device tree node.
The of_graph_get_port_by_id function is added to retrieve a port by its
known
port id (contained in the reg property) from the device tree.

----------------------------------------------------------------
Philipp Zabel (3):
      of: Decrement refcount of previous endpoint in
of_graph_get_next_endpoint
      of: Add for_each_endpoint_of_node helper macro
      of: Add of_graph_get_port_by_id function

 drivers/coresight/of_coresight.c                  | 13 ++-----
 drivers/gpu/drm/imx/imx-drm-core.c                | 11 +-----
 drivers/gpu/drm/rcar-du/rcar_du_kms.c             | 15 +++------
 drivers/media/platform/am437x/am437x-vpfe.c       |  1 -
 drivers/media/platform/soc_camera/soc_camera.c    |  3 +-
 drivers/of/base.c                                 | 41
++++++++++++++++++-----
 drivers/video/fbdev/omap2/dss/omapdss-boot-init.c |  7 +---
 include/linux/of_graph.h                          | 18 ++++++++++
 8 files changed, 61 insertions(+), 48 deletions(-)

