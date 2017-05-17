Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbdEQPDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 11:03:45 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        laurent.pinchart@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v1 0/3] v4l: async: Match parent devices
Date: Wed, 17 May 2017 16:03:36 +0100
Message-Id: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

To support using endpoints in the V4L2 Async subdev framework,
we need to be able to parse a fwnode for the device from the
endpoint.

To enable this, provide an alternative of_graph_get_remote_port_parent
which walks up the port hierarchy without parsing the 'remote-endpoint'
first.

Using this new of_graph_get_port_parent() implementation we can then
add the corresponding fwnode_graph_get_port_parent() call for use
by the async framework.

Kieran Bingham (3):
  of: base: Provide of_graph_get_port_parent()
  device property: Add fwnode_graph_get_port_parent
  v4l: async: Match parent devices

 drivers/base/property.c              | 25 ++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-async.c | 20 +++++++++++++++----
 drivers/of/base.c                    | 30 +++++++++++++++++++++--------
 include/linux/of_graph.h             |  1 +-
 include/linux/property.h             |  2 ++-
 5 files changed, 66 insertions(+), 12 deletions(-)

base-commit: ff0b1f922c42a59bbf8ad675df79441790baed86
-- 
git-series 0.9.1
