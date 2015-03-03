Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:41070 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbbCCP5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 10:57:14 -0500
Message-ID: <54F5D9CA.2010103@xs4all.nl>
Date: Tue, 03 Mar 2015 16:56:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [GIT PULL FOR v4.1] v4l2-subdev: removal of duplicate video enum
 ops
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series prepares for the removal of duplicate video enum ops. See this
post for the background for this series:

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/87869

The patches in this pull request are the same as the posted series, except for
being rebased and with patch 6/7 being dropped. This patch is found here:

https://patchwork.linuxtv.org/patch/28220/

The reason for dropping it is that I don't have an Ack from Jon Corbet yet.
I'm trying to test it myself, at least on my OLPC laptop, but that's painful
and takes longer than I hoped.

So I don't want to wait for that and I am posting the other patches now.
Laurent needs these patches as well so he can rebase his xilinx driver on top
of it.

Patch 6/7 will be posted in a later pull request, once I (or Jon) managed to
test it.

Regards,

	Hans

The following changes since commit 269bd1324fbfaa52832bb3efe9f5105c9146a33a:

  [media] media: adv7604: improve usage of gpiod API (2015-03-03 11:26:40 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1e

for you to fetch changes up to 95d3a905e017568456fa1ec3fd7833987bc9edd3:

  DocBook media: document the new 'which' field. (2015-03-03 16:48:26 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
      v4l2-subdev.h: add 'which' field for the enum structs
      v4l2-subdev.c: add 'which' checks for enum ops.
      v4l2-subdev: support new 'which' field in enum_mbus_code
      v4l2-subdev: add support for the new enum_frame_size 'which' field.
      DocBook media: document the new 'which' field.

 Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml | 13 ++++++---
 Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml     | 13 ++++++---
 Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml      | 11 +++++--
 drivers/media/i2c/adv7180.c                                           | 10 +++----
 drivers/media/i2c/adv7511.c                                           | 16 ++++++-----
 drivers/media/i2c/adv7604.c                                           | 12 ++++----
 drivers/media/i2c/m5mols/m5mols_core.c                                | 16 +++++------
 drivers/media/i2c/mt9m032.c                                           | 34 +++++++++++-----------
 drivers/media/i2c/mt9p031.c                                           | 36 +++++++++++------------
 drivers/media/i2c/mt9t001.c                                           | 36 +++++++++++------------
 drivers/media/i2c/mt9v032.c                                           | 36 +++++++++++------------
 drivers/media/i2c/noon010pc30.c                                       | 17 +++++------
 drivers/media/i2c/ov9650.c                                            | 16 +++++------
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                              | 72 ++++++++++++++++++++++++++++------------------
 drivers/media/i2c/s5k4ecgx.c                                          | 16 +++++------
 drivers/media/i2c/s5k5baf.c                                           | 38 ++++++++++++------------
 drivers/media/i2c/s5k6a3.c                                            | 18 ++++++------
 drivers/media/i2c/s5k6aa.c                                            | 34 +++++++++++-----------
 drivers/media/i2c/smiapp/smiapp-core.c                                | 80 +++++++++++++++++++++++++--------------------------
 drivers/media/i2c/tvp514x.c                                           | 12 ++++----
 drivers/media/i2c/tvp7002.c                                           | 14 ++++-----
 drivers/media/platform/exynos4-is/fimc-capture.c                      | 22 +++++++-------
 drivers/media/platform/exynos4-is/fimc-isp.c                          | 28 +++++++++---------
 drivers/media/platform/exynos4-is/fimc-lite.c                         | 33 ++++++++++-----------
 drivers/media/platform/exynos4-is/mipi-csis.c                         | 16 +++++------
 drivers/media/platform/omap3isp/ispccdc.c                             | 86 +++++++++++++++++++++++++++----------------------------
 drivers/media/platform/omap3isp/ispccp2.c                             | 46 ++++++++++++++---------------
 drivers/media/platform/omap3isp/ispcsi2.c                             | 42 +++++++++++++--------------
 drivers/media/platform/omap3isp/isppreview.c                          | 70 ++++++++++++++++++++++----------------------
 drivers/media/platform/omap3isp/ispresizer.c                          | 80 +++++++++++++++++++++++++--------------------------
 drivers/media/platform/s3c-camif/camif-capture.c                      | 18 ++++++------
 drivers/media/platform/vsp1/vsp1_bru.c                                | 42 ++++++++++++++-------------
 drivers/media/platform/vsp1/vsp1_entity.c                             | 16 +++++------
 drivers/media/platform/vsp1/vsp1_entity.h                             |  4 +--
 drivers/media/platform/vsp1/vsp1_hsit.c                               | 18 ++++++------
 drivers/media/platform/vsp1/vsp1_lif.c                                | 22 ++++++++------
 drivers/media/platform/vsp1/vsp1_lut.c                                | 22 ++++++++------
 drivers/media/platform/vsp1/vsp1_rwpf.c                               | 37 ++++++++++++------------
 drivers/media/platform/vsp1/vsp1_rwpf.h                               | 12 ++++----
 drivers/media/platform/vsp1/vsp1_sru.c                                | 30 ++++++++++---------
 drivers/media/platform/vsp1/vsp1_uds.c                                | 30 ++++++++++---------
 drivers/media/v4l2-core/v4l2-subdev.c                                 | 30 +++++++++++++------
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c                      | 51 ++++++++++++++++-----------------
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c                    | 49 +++++++++++++++----------------
 drivers/staging/media/davinci_vpfe/dm365_isif.c                       | 83 ++++++++++++++++++++++++++---------------------------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c                    | 59 ++++++++++++++++++--------------------
 drivers/staging/media/omap4iss/iss_csi2.c                             | 42 +++++++++++++--------------
 drivers/staging/media/omap4iss/iss_ipipe.c                            | 42 +++++++++++++--------------
 drivers/staging/media/omap4iss/iss_ipipeif.c                          | 52 ++++++++++++++++-----------------
 drivers/staging/media/omap4iss/iss_resizer.c                          | 46 ++++++++++++++---------------
 include/media/v4l2-subdev.h                                           | 50 +++++++++++++++++++-------------
 include/uapi/linux/v4l2-subdev.h                                      | 12 ++++++--
 52 files changed, 906 insertions(+), 834 deletions(-)

