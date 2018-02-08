Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:59330 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750941AbeBHIhA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:37:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 00/15] Media Controller compliance fixes
Date: Thu,  8 Feb 2018 09:36:40 +0100
Message-Id: <20180208083655.32248-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

I've been posting random patches fixing various MC problems, but it is
easier to see them all in a single patch series.

All patches except 13 and 14 are identical to was I posted earlier.
For 13 and 14 I decided to drop the requirement that the application
clears the reserved field. Only the driver will clear it.

The only ioctl for which this might be a problem is SETUP_LINK. I don't
think it is worth it adding this requirement for userspace, and I also
think it is too late to do so.

A quick overview of the series:

Patch 1 and 2 fix two vimc bugs. Patch 3 fixes a v4l2-ioctl.c bug.
Patches 4-6 fix v4l2-subdev.c bugs (arguably patch 6 is more of an
enhancement than a bug fix). Patches 7-10 fix documentation bugs.
Patches 11-14 fix various bugs. Please check 13 and 14 if you agree
with how the reserved fields should be handled.

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
  v4l2-ioctl.c: fix VIDIOC_DV_TIMINGS_CAP: don't clear pad
  v4l2-subdev: without controls return -ENOTTY
  v4l2-subdev: clear reserved fields
  v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO ioctl
  subdev-formats.rst: fix incorrect types
  media-ioc-g-topology.rst: fix interface-to-entity link description
  media-types.rst: fix type, small improvements
  media-device.c: zero reserved field
  media.h: fix confusing typo in comment
  media: document and zero reservedX fields in media_v2_topology
  media-ioc-enum-entities/links.rst: document reserved fields
  media.h: reorganize header to make it easier to understand

 .../uapi/mediactl/media-ioc-enum-entities.rst      |  19 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |  18 ++
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |  54 +++-
 Documentation/media/uapi/mediactl/media-types.rst  |  12 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |   6 +-
 drivers/media/media-device.c                       |   6 +
 drivers/media/media-entity.c                       |  16 -
 drivers/media/platform/vimc/vimc-common.c          |   4 +-
 drivers/media/platform/vimc/vimc-debayer.c         |   2 +-
 drivers/media/platform/vimc/vimc-scaler.c          |   2 +-
 drivers/media/platform/vimc/vimc-sensor.c          |  10 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |  42 +++
 include/uapi/linux/media.h                         | 345 ++++++++++-----------
 14 files changed, 314 insertions(+), 224 deletions(-)

-- 
2.15.1
