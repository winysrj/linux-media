Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751428AbdESQQH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 12:16:07 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 0/2] v4l: async: Match parent devices
Date: Fri, 19 May 2017 17:16:01 +0100
Message-Id: <cover.9f22ad082e363959e4679246793bc4698479a44e.1495210364.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

As devices become more complicated, it becomes necessary (and more
accurate) to match devices based on their endpoint, as devices may
have multiple subdevices.

To support using endpoints in the V4L2 async subdev framework, while
some devices still use their device fwnode, we need to be able to parse
a fwnode for the device from the endpoint.

By providing a helper fwnode_graph_get_port_parent(), we can use it in
the match_fwnode to support matches during the transition to endpoint
matching.

This series is dependant upon Sakari's v4l2-acpi and acpi-graph-cleaned
branch

v2:
 - Rebased on top of git.linuxtv.org/sailus/media_tree.git #acpi-graph-cleaned

Kieran Bingham (2):
  device property: Add fwnode_graph_get_port_parent
  v4l: async: Match parent devices

 drivers/base/property.c              | 13 +++++++++++-
 drivers/media/v4l2-core/v4l2-async.c | 33 ++++++++++++++++++++++++-----
 include/linux/property.h             |  2 ++-
 3 files changed, 43 insertions(+), 5 deletions(-)

base-commit: d043978c7c919c727fb76b6593c71d0e697a5d66
-- 
git-series 0.9.1
