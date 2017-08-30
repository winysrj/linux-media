Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35934 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751357AbdH3Ltt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 07:49:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
Subject: [PATCH v6 0/5] Unified fwnode endpoint parser
Date: Wed, 30 Aug 2017 14:49:41 +0300
Message-Id: <20170830114946.17743-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
the endpoints, and make the omap3isp and rcar-vin drivers use them as an
example.

since v5:

- Use v4l2_async_ prefix for static functions as well (4th patch)

- Use memcpy() to copy array rather than a loop

- Document that the v4l2_async_subdev pointer in driver specific struct
  must be the first member

- Improve documentation of the added functions (4th and 5th
  patches)

	- Arguments

	- More thorough explation of the purpose, usage and object
	  lifetime

- Added acks

since v4:

- Prepend the set with three documentation fixes.

- The driver's async struct must begin with struct v4l2_async_subdev. Fix this
  for omap3isp and document it.

- Improve documentation for new functions.

- Don't use devm_ family of functions for allocating memory. Introduce
  v4l2_async_notifier_release() to release memory resources.

- Rework both v4l2_async_notifier_fwnode_parse_endpoints() and
  v4l2_async_notifier_fwnode_parse_endpoint() and the local functions they
  call. This should make the code cleaner. Despite the name, for linking
  and typical usage reasons the functions remain in v4l2-fwnode.c.

- Convert rcar-vin to use v4l2_async_notifier_fwnode_parse_endpoint().

- Use kvmalloc() for allocating the notifier's subdevs array.

- max_subdevs argument for notifier_realloc is now the total maximum
  number of subdevs, not the number of available subdevs.

- Use fwnode_device_is_available() to make sure the device actually
  exists.

- Move the note telling v4l2_async_notifier_fwnode_parse_endpoints()
  should not be used by new drivers to the last patch adding
  v4l2_async_notifier_fwnode_parse_endpoint().

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

Sakari Ailus (5):
  v4l: fwnode: Move KernelDoc documentation to the header
  v4l: async: Add V4L2 async documentation to the documentation build
  docs-rst: v4l: Include Qualcomm CAMSS in documentation build
  v4l: fwnode: Support generic parsing of graph endpoints in a device
  v4l: fwnode: Support generic parsing of graph endpoints in a single
    port

 Documentation/media/kapi/v4l2-async.rst     |   3 +
 Documentation/media/kapi/v4l2-core.rst      |   1 +
 Documentation/media/v4l-drivers/index.rst   |   1 +
 drivers/media/platform/omap3isp/isp.c       | 115 ++++---------
 drivers/media/platform/omap3isp/isp.h       |   5 +-
 drivers/media/platform/rcar-vin/rcar-core.c | 111 ++++--------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  10 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  14 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  |   4 +-
 drivers/media/v4l2-core/v4l2-async.c        |  16 ++
 drivers/media/v4l2-core/v4l2-fwnode.c       | 253 +++++++++++++++++++---------
 include/media/v4l2-async.h                  |  24 ++-
 include/media/v4l2-fwnode.h                 | 178 ++++++++++++++++++-
 13 files changed, 481 insertions(+), 254 deletions(-)
 create mode 100644 Documentation/media/kapi/v4l2-async.rst

-- 
2.11.0
