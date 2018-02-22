Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:44761 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751119AbeBVSxw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 13:53:52 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Media Controller compliance fixes
Message-ID: <ac28888c-b445-fdd5-40ff-edee983d9466@xs4all.nl>
Date: Thu, 22 Feb 2018 19:53:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes various MC/subdev related compliance failures and various documentation
issues.

See the cover letter for details:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg126559.html

Regards,

	Hans

The following changes since commit 4395fb475a27ddcb33c27380e132ef5354ff67c6:

  tda1997x: get rid of an unused var (2018-02-22 12:54:28 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git media-fixes

for you to fetch changes up to 9c38c7f31cef8fd48ee0f4e2928a1e6a126b6fa2:

  media.h: reorganize header to make it easier to understand (2018-02-22 19:50:37 +0100)

----------------------------------------------------------------
Alexandre Courbot (1):
      media: media-types.rst: fix typo

Hans Verkuil (13):
      vimc: fix control event handling
      vimc: use correct subdev functions
      v4l2-subdev: without controls return -ENOTTY
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

 Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst |  19 +++-
 Documentation/media/uapi/mediactl/media-ioc-enum-links.rst    |  18 +++
 Documentation/media/uapi/mediactl/media-ioc-g-topology.rst    |  54 +++++++--
 Documentation/media/uapi/mediactl/media-types.rst             |  12 +-
 Documentation/media/uapi/v4l/subdev-formats.rst               |   6 +-
 drivers/media/media-device.c                                  |   7 ++
 drivers/media/media-entity.c                                  |  16 ---
 drivers/media/platform/vimc/vimc-common.c                     |   4 +-
 drivers/media/platform/vimc/vimc-debayer.c                    |   2 +-
 drivers/media/platform/vimc/vimc-scaler.c                     |   2 +-
 drivers/media/platform/vimc/vimc-sensor.c                     |  10 +-
 drivers/media/v4l2-core/v4l2-subdev.c                         |  37 ++++++
 include/uapi/linux/media.h                                    | 349 +++++++++++++++++++++++++++------------------------------
 13 files changed, 309 insertions(+), 227 deletions(-)
