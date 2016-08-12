Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:35537 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbcHLO2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 10:28:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5BFE61800A9
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2016 16:28:26 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Remove the g/s_crop subdev ops, convert bridge
 drivers to g/s_selection
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <52067444-bece-3e8a-61b2-0982aefb73f8@xs4all.nl>
Date: Fri, 12 Aug 2016 16:28:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series converts the subdev drivers that still use g/s_crop to
g/s_selection. This in turn makes it possible to convert bridge drivers
to g/s_selection as well.

At the end one patch renames the cropcap subdev op to g_pixelaspect, and the
last two patches update the cropping API so that ENODATA can be returned if
the cropping API isn't valid for the current input, but is valid for another.
It is only vivid that needs this. Without this change Mauro ran into issues with
the vivid+gstreamer combination when I posted this for 4.8 originally.

After this series the only drivers still using g/s_crop are samsung drivers.
These are a bit more complicated and will be converted later.

So after this series we finally got rid of the duplicate crop/selection API
in the subdev drivers, and we're almost there for the bridge drivers.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rmcrop

for you to fetch changes up to 5ba4334b9e043cc2746c57314b45784f6ab7414b:

  media: doc-rst: document ENODATA for cropping ioctls (2016-08-12 16:09:33 +0200)

----------------------------------------------------------------
Hans Verkuil (11):
      v4l2: remove g/s_crop from video ops
      bttv: convert g/s_crop to g/s_selection.
      omap_vout: convert g/s_crop to g/s_selection.
      saa7134: convert g/s_crop to g/s_selection.
      zoran: convert g/s_crop to g/s_selection.
      vpfe_capture: convert g/s_crop to g/s_selection.
      vpbe_display: convert g/s_crop to g/s_selection.
      pvrusb2: convert g/s_crop to g/s_selection.
      v4l2-subdev: rename cropcap to g_pixelaspect
      vivid: return -ENODATA if the current input doesn't support g/s_selection
      media: doc-rst: document ENODATA for cropping ioctls

 Documentation/media/uapi/v4l/vidioc-cropcap.rst          |   3 +
 Documentation/media/uapi/v4l/vidioc-g-crop.rst           |   3 +
 Documentation/media/uapi/v4l/vidioc-g-selection.rst      |   3 +
 drivers/media/i2c/adv7180.c                              |  12 ++--
 drivers/media/i2c/ak881x.c                               |  28 ++++++----
 drivers/media/i2c/soc_camera/imx074.c                    |  42 ++++++--------
 drivers/media/i2c/soc_camera/mt9m001.c                   |  70 ++++++++++++-----------
 drivers/media/i2c/soc_camera/mt9m111.c                   |  57 ++++++++++---------
 drivers/media/i2c/soc_camera/mt9t031.c                   |  54 ++++++++++--------
 drivers/media/i2c/soc_camera/mt9t112.c                   |  60 +++++++++++---------
 drivers/media/i2c/soc_camera/mt9v022.c                   |  68 +++++++++++-----------
 drivers/media/i2c/soc_camera/ov2640.c                    |  41 ++++++--------
 drivers/media/i2c/soc_camera/ov5642.c                    |  53 +++++++++---------
 drivers/media/i2c/soc_camera/ov6650.c                    |  74 ++++++++++++------------
 drivers/media/i2c/soc_camera/ov772x.c                    |  44 +++++++--------
 drivers/media/i2c/soc_camera/ov9640.c                    |  41 ++++++--------
 drivers/media/i2c/soc_camera/ov9740.c                    |  41 ++++++--------
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                |  52 +++++++++--------
 drivers/media/i2c/soc_camera/tw9910.c                    |  47 +++++-----------
 drivers/media/i2c/tvp5150.c                              |  81 +++++++++++++--------------
 drivers/media/pci/bt8xx/bttv-driver.c                    |  59 +++++++++++++-------
 drivers/media/pci/bt8xx/bttvp.h                          |   2 +-
 drivers/media/pci/saa7134/saa7134-video.c                |  39 +++++++++----
 drivers/media/pci/zoran/zoran_driver.c                   | 113 ++++++++++++++++---------------------
 drivers/media/platform/davinci/vpbe_display.c            |  65 ++++++++++++----------
 drivers/media/platform/davinci/vpfe_capture.c            |  52 +++++++++++------
 drivers/media/platform/omap/omap_vout.c                  |  53 +++++++++---------
 drivers/media/platform/omap3isp/ispvideo.c               |  88 ++++++++++++++++++-----------
 drivers/media/platform/rcar-vin/rcar-v4l2.c              |   2 +-
 drivers/media/platform/sh_vou.c                          |  15 +++--
 drivers/media/platform/soc_camera/pxa_camera.c           |  17 ++++--
 drivers/media/platform/soc_camera/rcar_vin.c             |  30 +++++-----
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  38 ++++++-------
 drivers/media/platform/soc_camera/soc_camera.c           | 130 ++++++++++++-------------------------------
 drivers/media/platform/soc_camera/soc_camera_platform.c  |  45 ++++++---------
 drivers/media/platform/soc_camera/soc_scale_crop.c       |  97 ++++++++++++++++++--------------
 drivers/media/platform/soc_camera/soc_scale_crop.h       |   6 +-
 drivers/media/platform/vivid/vivid-vid-cap.c             |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                 |  81 +++++++++++++++++----------
 drivers/staging/media/omap4iss/iss_video.c               |  99 ++++++++++++++++++++++++++++++++
 include/media/soc_camera.h                               |   7 +--
 include/media/v4l2-subdev.h                              |  10 +---
 42 files changed, 1036 insertions(+), 890 deletions(-)
