Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34805 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934248AbeBUPcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:32:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv4 00/15] Media Controller compliance fixes
Date: Wed, 21 Feb 2018 16:32:03 +0100
Message-Id: <20180221153218.15654-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

Here is v4 of this patch series fixing various MC compliance and 
documentation issues.

Changes since v3:
- Added Acks from Sakari
- Incorporated Sakari's comments for the final patch (media.h).

Changes since v2:

- I dropped "v4l2-ioctl.c: fix VIDIOC_DV_TIMINGS_CAP: don't clear pad"
  as it is already included in the pull request for the tda1997x driver
  which needs this fix.
- I added a TODO as requested by Sakari to "v4l2-subdev: without controls 
  return -ENOTTY"
- The "media: document and zero reservedX fields in media_v2_topology"
  patch has been split up in separate code and doc patches.
- I now also zero the reserved field of struct media_links_enum.
  (Thanks Sakari!)
- Rebased and added Acks from Sakari.
- Added missing documentation for the reserved field of struct
  media_links_enum.
- Instead of requiring that apps and drivers zero the reserved fields,
  now change that to just drivers.

I plan to post a pull request later this week if there are no more
comments.

Note regarding patch 4 ("v4l2-subdev: clear reserved fields"): this is
also present in the g/s_frame_interval pull request:

https://patchwork.linuxtv.org/patch/47296/

since it is a prerequisite for that patch series. Whichever gets merged
first wins...

The final patch reorganizes media.h so it is actually understandable.
See here for how it looks after the patch is applied:

https://git.linuxtv.org/hverkuil/media_tree.git/plain/include/uapi/linux/media.h?h=media-fixes

The patch itself is hard to read, so looking at the reorganized header
is easier.

The two core changes in media.h are:

1) all functions are now grouped together
2) all legacy defines are now all moved to the end of the header

I would really like to see this merged soon. This fixes the most immediate
problems that I found.

Regards,

	Hans

Alexandre Courbot (1):
  media: media-types.rst: fix typo

Hans Verkuil (14):
  vimc: fix control event handling
  vimc: use correct subdev functions
  v4l2-subdev: without controls return -ENOTTY
  v4l2-subdev: clear reserved fields
  v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO ioctl
  subdev-formats.rst: fix incorrect types
  media-ioc-g-topology.rst: fix interface-to-entity link description
  media-types.rst: fix type, small improvements
  media-device.c: zero reserved fields
  media.h: fix confusing typo in comment
  media: zero reservedX fields in media_v2_topology
  media: document the reservedX fields in media_v2_topology
  media-ioc-enum-entities/links.rst: document reserved fields
  media.h: reorganize header to make it easier to understand

 .../uapi/mediactl/media-ioc-enum-entities.rst      |  19 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |  18 ++
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |  54 +++-
 Documentation/media/uapi/mediactl/media-types.rst  |  12 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |   6 +-
 drivers/media/media-device.c                       |   7 +
 drivers/media/media-entity.c                       |  16 -
 drivers/media/platform/vimc/vimc-common.c          |   4 +-
 drivers/media/platform/vimc/vimc-debayer.c         |   2 +-
 drivers/media/platform/vimc/vimc-scaler.c          |   2 +-
 drivers/media/platform/vimc/vimc-sensor.c          |  10 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |  50 +++
 include/uapi/linux/media.h                         | 345 ++++++++++-----------
 13 files changed, 322 insertions(+), 223 deletions(-)

-- 
2.16.1
