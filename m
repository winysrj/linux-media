Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34742 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbeCUAiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 20:38:12 -0400
Received: by mail-pg0-f67.google.com with SMTP id m15so1328651pgc.1
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 17:38:12 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 00/13] media: imx: Switch to subdev notifiers
Date: Tue, 20 Mar 2018 17:37:16 -0700
Message-Id: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset converts the imx-media driver and its dependent
subdevs to use subdev notifiers.

There are a couple shortcomings in v4l2-core that prevented
subdev notifiers from working correctly in imx-media:

1. v4l2_async_notifier_fwnode_parse_endpoint() treats a fwnode
   endpoint that is not connected to a remote device as an error.
   But in the case of the video-mux subdev, this is not an error,
   it is OK if some of the mux inputs have no connection. Also,
   Documentation/devicetree/bindings/media/video-interfaces.txt explicitly
   states that the 'remote-endpoint' property is optional. So the first
   patch is a small modification to ignore empty endpoints in
   v4l2_async_notifier_fwnode_parse_endpoint() and allow
   __v4l2_async_notifier_parse_fwnode_endpoints() to continue to
   parse the remaining port endpoints of the device.

2. In the imx-media graph, multiple subdevs will encounter the same
   upstream subdev (such as the imx6-mipi-csi2 receiver), and so
   v4l2_async_notifier_parse_fwnode_endpoints() will add imx6-mipi-csi2
   multiple times. This is treated as an error by
   v4l2_async_notifier_register() later.

   To get around this problem, add an v4l2_async_notifier_add_subdev()
   which first verifies the provided asd does not already exist in the
   given notifier asd list or in other registered notifiers. If the asd
   exists, the function returns -EEXIST and it's up to the caller to
   decide if that is an error (in imx-media case it is never an error).

   Patches 2-4 deal with adding that support.

3. Patch 5 adds v4l2_async_register_fwnode_subdev(), which is a
   convenience function for parsing a subdev's fwnode port endpoints
   for connected remote subdevs, registering a subdev notifier, and
   then registering the sub-device itself.

The remaining patches update the subdev drivers to register a
subdev notifier with endpoint parsing, and the changes to imx-media
to support that.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

History:
v3:
- code optimization in asd_equal(), and remove unneeded braces,
  suggested by Sakari Ailus.
- add a NULL asd pointer check to v4l2_async_notifier_asd_valid().
- fix an error-out path in v4l2_async_register_fwnode_subdev() that
  forgot to put device.

v2:
- don't pass an empty endpoint to the parse_endpoint callback, 
  v4l2_async_notifier_fwnode_parse_endpoint() now just ignores them
  and returns success.
- Fix a couple compile warnings and errors seen in i386 and sh archs.


Steve Longerbeam (13):
  media: v4l2-fwnode: ignore endpoints that have no remote port parent
  media: v4l2: async: Allow searching for asd of any type
  media: v4l2: async: Add v4l2_async_notifier_add_subdev
  media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev
  media: v4l2-fwnode: Add a convenience function for registering subdevs
    with notifiers
  media: platform: video-mux: Register a subdev notifier
  media: imx: csi: Register a subdev notifier
  media: imx: mipi csi-2: Register a subdev notifier
  media: staging/imx: of: Remove recursive graph walk
  media: staging/imx: Loop through all registered subdevs for media
    links
  media: staging/imx: Rename root notifier
  media: staging/imx: Switch to v4l2_async_notifier_add_subdev
  media: staging/imx: TODO: Remove one assumption about OF graph parsing

 drivers/media/pci/intel/ipu3/ipu3-cio2.c          |  10 +-
 drivers/media/platform/video-mux.c                |  36 ++-
 drivers/media/v4l2-core/v4l2-async.c              | 268 ++++++++++++++++------
 drivers/media/v4l2-core/v4l2-fwnode.c             | 231 +++++++++++--------
 drivers/staging/media/imx/TODO                    |  29 +--
 drivers/staging/media/imx/imx-media-csi.c         |  11 +-
 drivers/staging/media/imx/imx-media-dev.c         | 134 +++--------
 drivers/staging/media/imx/imx-media-internal-sd.c |   5 +-
 drivers/staging/media/imx/imx-media-of.c          | 106 +--------
 drivers/staging/media/imx/imx-media.h             |   6 +-
 drivers/staging/media/imx/imx6-mipi-csi2.c        |  31 ++-
 include/media/v4l2-async.h                        |  24 +-
 include/media/v4l2-fwnode.h                       |  65 +++++-
 13 files changed, 534 insertions(+), 422 deletions(-)

-- 
2.7.4
