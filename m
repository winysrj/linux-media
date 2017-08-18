Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51640 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751108AbdHRLXT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 07:23:19 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
Subject: [PATCH v3 0/3] Unified fwnode endpoint parser
Date: Fri, 18 Aug 2017 14:23:14 +0300
Message-Id: <20170818112317.30933-1-sakari.ailus@linux.intel.com>
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

I plan to include the first patch to a pull request soonish, the second
could go in with the first user.

since v2:

- Rebase on CCP2 support patches.

- Prepend a patch cleaning up omap3isp driver a little.

since v1:

- The first patch has been merged (it was a bugfix).

- In anticipation that the parsing can take place over several iterations,
  take the existing number of async sub-devices into account when
  re-allocating an array of async sub-devices.

- Rework the first patch to better anticipate parsing single endpoint at a
  time by a driver.

- Add a second patch that adds a function for parsing endpoints one at a
  time based on port and endpoint numbers.

Sakari Ailus (3):
  omap3isp: Drop redundant isp->subdevs field and ISP_MAX_SUBDEVS
  v4l: fwnode: Support generic parsing of graph endpoints in a device
  v4l: fwnode: Support generic parsing of graph endpoints in a single
    port

 drivers/media/platform/omap3isp/isp.c | 116 +++++++---------------
 drivers/media/platform/omap3isp/isp.h |   3 -
 drivers/media/v4l2-core/v4l2-fwnode.c | 176 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h            |   4 +-
 include/media/v4l2-fwnode.h           |  16 ++++
 5 files changed, 231 insertions(+), 84 deletions(-)

-- 
2.11.0
