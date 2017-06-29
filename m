Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33982 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751637AbdF2HaN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 03:30:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH 0/2] Unified fwnode endpoint parser
Date: Thu, 29 Jun 2017 10:30:08 +0300
Message-Id: <1498721410-28199-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

We have a large influx of new, unmerged, drivers that are now parsing
fwnode endpoints and each one of them is doing this a little bit
differently. The needs are still exactly the same for the graph data
structure is device independent. This is still a non-trivial task and the
majority of the driver implementations are buggy, just buggy in different
ways.

Facilitate parsing endpoints by adding a convenience function for parsing
the endpoints, and make the omap3isp driver use it as an example.

The parser succeeds an essential bugfix in the set.

Sakari Ailus (2):
  v4l: fwnode: link_frequency is an optional property
  v4l: fwnode: Support generic parsing of graph endpoints in V4L2

 drivers/media/platform/omap3isp/isp.c |  91 +++++++------------------
 drivers/media/platform/omap3isp/isp.h |   3 -
 drivers/media/v4l2-core/v4l2-fwnode.c | 124 ++++++++++++++++++++++++++++++----
 include/media/v4l2-async.h            |   4 +-
 include/media/v4l2-fwnode.h           |   9 +++
 5 files changed, 147 insertions(+), 84 deletions(-)

-- 
2.1.4
