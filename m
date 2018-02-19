Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:39128 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752377AbeBSKiL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 05:38:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv3 00/15] Media Controller compliance fixes
Date: Mon, 19 Feb 2018 11:37:51 +0100
Message-Id: <20180219103806.17032-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

Here is v3 of this patch series fixing various MC compliance and 
documentation issues.

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

Please check patches 13 and 14 and see if you agree with the proposed
text (i.e. drivers should zero these fields). Or should apps also
zero the fields? Realistically the only time this might make sense is with
the SETUP_LINK ioctl. But since we never documented this as a requirement,
I don't think we should suddenly change this.

Sakari, I dropped your Ack from patch 14 since I changed the wording in
this version.

I kept the controversial VIDIOC_DBG_G_CHIP_INFO patch. In my opinion this
is useful and I see no reason whatsoever not to just fix this API. The
main reason this API was added at the time was to be able to debug video
receivers. And it is still actively used for that to this day. We (Cisco)
would have noticed long ago that this subdev API was missing this ioctl
if it wasn't for the fact that none of our products use the MC (all just
use /dev/videoX).

The current situation is that if I have an adv7604 device then this API
works when used with a non-MC bridge driver through /dev/videoX, but not
when used with an MC platform driver that exposes a /dev/v4l-subdevX.
That makes no sense. Just add these 13 lines of code and be done with it.

Please review the other patches first so we don't get bogged down into
discussions about this patch. It is easy to postpone that patch, it's been
broken for years and the other patches are much more important.

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

 .../uapi/mediactl/media-ioc-enum-entities.rst      |  18 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |  25 ++
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
 13 files changed, 328 insertions(+), 223 deletions(-)

-- 
2.16.1
