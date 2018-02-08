Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:42349 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751756AbeBHIvE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 03:51:04 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] media: replace g/s_parm by g/s_frame_interval
Message-ID: <babf3f75-d80a-ef37-d3c1-68addac897b3@xs4all.nl>
Date: Thu, 8 Feb 2018 09:51:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are currently two subdev ops variants to get/set the frame interval:
g/s_parm and g/s_frame_interval.

This patch series replaces all g/s_parm calls by g/s_frame_interval.

The first patch adds helper functions that can be used by bridge drivers.
Only em28xx can't use it and it needs custom code (it uses v4l2_device_call()
to try all subdevs instead of calling a specific subdev).

The next patch converts all non-staging drivers, then come Sakari's
atomisp staging fixes.

The v4l2-subdev.h patch removes the now obsolete g/s_parm ops and the
final patch clarifies the documentation a bit (the core allows for
_MPLANE to be used as well).

I would really like to take the next step and introduce two new ioctls
VIDIOC_G/S_FRAME_INTERVAL (just like the SUBDEV variants that already
exist) and convert all bridge drivers to use that and just have helper
functions in the core for VIDIOC_G/S_PARM.

I hate that ioctl and it always confuses driver developers. It would
also prevent the type of abuse that was present in the atomisp driver.

But that's for later, let's simplify the subdev drivers first.

Regards,

	Hans

The following changes since commit 273caa260035c03d89ad63d72d8cd3d9e5c5e3f1:

  media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs (2018-01-31 03:09:04 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git parm

for you to fetch changes up to 53bb3d95e749adbd01b484af5be41871ae399cee:

  vidioc-g-parm.rst: also allow _MPLANE buffer types (2018-02-08 09:49:46 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      v4l2-common: create v4l2_g/s_parm_cap helpers
      media: convert g/s_parm to g/s_frame_interval in subdevs
      v4l2-subdev.h: remove obsolete g/s_parm
      vidioc-g-parm.rst: also allow _MPLANE buffer types

Sakari Ailus (5):
      staging: atomisp: Kill subdev s_parm abuse
      staging: atomisp: i2c: Disable non-preview configurations
      staging: atomisp: i2c: Drop g_parm support in sensor drivers
      staging: atomisp: mt9m114: Drop empty s_parm callback
      staging: atomisp: Drop g_parm and s_parm subdev ops use

 Documentation/media/uapi/v4l/vidioc-g-parm.rst              |  7 +++--
 drivers/media/i2c/mt9v011.c                                 | 31 +++++++------------
 drivers/media/i2c/ov6650.c                                  | 35 ++++++++-------------
 drivers/media/i2c/ov7670.c                                  | 24 ++++++---------
 drivers/media/i2c/ov7740.c                                  | 31 ++++++-------------
 drivers/media/i2c/tvp514x.c                                 | 39 +++++++++--------------
 drivers/media/i2c/vs6624.c                                  | 29 +++++++-----------
 drivers/media/platform/atmel/atmel-isc.c                    | 10 ++----
 drivers/media/platform/atmel/atmel-isi.c                    | 12 ++------
 drivers/media/platform/blackfin/bfin_capture.c              | 14 +++------
 drivers/media/platform/marvell-ccic/mcam-core.c             | 12 ++++----
 drivers/media/platform/soc_camera/soc_camera.c              | 10 +++---
 drivers/media/platform/via-camera.c                         |  4 +--
 drivers/media/usb/em28xx/em28xx-video.c                     | 36 +++++++++++++++++++---
 drivers/media/v4l2-core/v4l2-common.c                       | 48 +++++++++++++++++++++++++++++
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c          | 53 --------------------------------
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c          | 53 --------------------------------
 drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c         |  6 ----
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c          | 56 ---------------------------------
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c          | 53 --------------------------------
 drivers/staging/media/atomisp/i2c/gc0310.h                  | 43 --------------------------
 drivers/staging/media/atomisp/i2c/gc2235.h                  |  3 +-
 drivers/staging/media/atomisp/i2c/ov2680.h                  | 68 -----------------------------------------
 drivers/staging/media/atomisp/i2c/ov2722.h                  |  2 ++
 drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c   | 54 --------------------------------
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h           |  2 ++
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c    |  9 ++----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c   | 16 ----------
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c | 12 +-------
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c    | 14 ---------
 include/media/v4l2-common.h                                 | 26 ++++++++++++++++
 include/media/v4l2-subdev.h                                 |  6 ----
 32 files changed, 209 insertions(+), 609 deletions(-)
