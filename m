Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53750 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaCEJVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 04:21:03 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 0/8] Move device tree graph parsing helpers to drivers/of
Date: Wed,  5 Mar 2014 10:20:34 +0100
Message-Id: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this version of the OF graph helper move series further addresses a few of
Tomi's and Sylwester's comments.

Changes since v5:
 - Fixed spelling errors and a wrong device node name in the link section
 - Added parentless previous endpoint's full name to warning
 - Fixed documentation comment for of_graph_parse_endpoint
 - Unrolled for-loop in of_graph_get_remote_port_parent

Philipp Zabel (8):
  [media] of: move graph helpers from drivers/media/v4l2-core to
    drivers/of
  Documentation: of: Document graph bindings
  of: Warn if of_graph_get_next_endpoint is called with the root node
  of: Reduce indentation in of_graph_get_next_endpoint
  [media] of: move common endpoint parsing to drivers/of
  of: Implement simplified graph binding for single port devices
  of: Document simplified graph binding for single port devices
  of: Warn if of_graph_parse_endpoint is called with the root node

 Documentation/devicetree/bindings/graph.txt   | 137 +++++++++++++++++++++
 drivers/media/i2c/adv7343.c                   |   4 +-
 drivers/media/i2c/mt9p031.c                   |   4 +-
 drivers/media/i2c/s5k5baf.c                   |   3 +-
 drivers/media/i2c/tvp514x.c                   |   3 +-
 drivers/media/i2c/tvp7002.c                   |   3 +-
 drivers/media/platform/exynos4-is/fimc-is.c   |   6 +-
 drivers/media/platform/exynos4-is/media-dev.c |  13 +-
 drivers/media/platform/exynos4-is/mipi-csis.c |   5 +-
 drivers/media/v4l2-core/v4l2-of.c             | 133 +-------------------
 drivers/of/base.c                             | 167 ++++++++++++++++++++++++++
 include/linux/of_graph.h                      |  66 ++++++++++
 include/media/v4l2-of.h                       |  33 +----
 13 files changed, 399 insertions(+), 178 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/graph.txt
 create mode 100644 include/linux/of_graph.h

-- 
1.9.0.rc3

