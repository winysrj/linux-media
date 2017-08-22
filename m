Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47234 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932657AbdHVMaZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:30:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
Subject: [PATCH v4 0/3] Unified fwnode endpoint parser
Date: Tue, 22 Aug 2017 15:30:20 +0300
Message-Id: <20170822123023.6149-1-sakari.ailus@linux.intel.com>
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

I plan to include the first and second patch to a pull request soonish, the
third could go in with the first user.

since v3:

- Rebase on current mediatree master.

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


*** BLURB HERE ***

Sakari Ailus (3):
  omap3isp: Drop redundant isp->subdevs field and ISP_MAX_SUBDEVS
  v4l: fwnode: Support generic parsing of graph endpoints in a device
  v4l: fwnode: Support generic parsing of graph endpoints in a single
    port

 drivers/media/platform/omap3isp/isp.c | 115 +++++++---------------
 drivers/media/platform/omap3isp/isp.h |   3 -
 drivers/media/v4l2-core/v4l2-fwnode.c | 176 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h            |   4 +-
 include/media/v4l2-fwnode.h           |  16 ++++
 5 files changed, 230 insertions(+), 84 deletions(-)

-- 
2.11.0
