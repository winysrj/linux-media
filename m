Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43820 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbbCFJKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2015 04:10:36 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D2B1C2A009F
	for <linux-media@vger.kernel.org>; Fri,  6 Mar 2015 10:10:14 +0100 (CET)
Message-ID: <54F96EF6.2000200@xs4all.nl>
Date: Fri, 06 Mar 2015 10:10:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] v4l2-subdev: removal of duplicate video enum
 ops
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request is identical to the PATCHv2 series posted two days ago:

http://www.spinics.net/lists/linux-media/msg87142.html

except for a tiny comment change as requested by Laurent and with additional
Acked-by lines.

This patch series starts the work of removing several video ops that
are duplicated in as pad ops in the subdev kernel API. This kills the
whole point of the subdev API which is to enable reuse of subdevices by 
different bridge drivers. With duplicate ops the bridge drivers now either
have to check which one to use, or (and that's what happens today) they
make an assumption and just use one of the two.

Duplicate ops should never have been allowed. A lesson for the future.

This patch series gets rid of two duplicate ops (the enum_framesizes
and enum_frameintervals video ops) and prepares the way to remove the
remaining crop video ops. The patch that does that isn't part of this
patch series as it needs more work (testing primarily).

The first patch of this series lays the foundation: the pad ops
use the v4l2_subdev_fh for the try formats. However, bridge drivers that
want to call the pad ops do not have a v4l2_subdev_fh struct available.
It's only used when accessing the 'try' formats that are part of struct
v4l2_subdev_fh. This patch splits off those fields into a separate struct
and uses that instead of v4l2_subdev_fh. This breaks the link between a
file handle and the try formats. If a bridge driver needs to deal with
try formats, then it is the responsibility of the bridge driver to create
a v4l2_subdev_pad_config array.

In practice, bridge drivers for simple, non-MC devices only need to use
the active format, and that doesn't need a v4l2_subdev_pad_config array,
so NULL can be used there instead.

The second and third patch add a 'which' field to the enum struct used
in the pad ops. Currently all enum pad ops assume that it is against the
'try' formats, but simple bridge drivers will want to enum against the
active formats. So add support to select what you want. And frankly, I
think it is more consistent and actually useful for application to see
what the enumeration is against the active format.

The next four patches add support for the new 'which' field where appropriate,
and documents the new which field. The last patch removes the video enum ops
altogether.

Regards,

	Hans

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1g

for you to fetch changes up to ae3da40179c66001afad608f972bdb57d50d1e66:

  v4l2-subdev: remove enum_framesizes/intervals (2015-03-06 10:01:44 +0100)

----------------------------------------------------------------
Hans Verkuil (8):
      v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
      v4l2-subdev.h: add 'which' field for the enum structs
      v4l2-subdev.c: add 'which' checks for enum ops.
      v4l2-subdev: support new 'which' field in enum_mbus_code
      v4l2-subdev: add support for the new enum_frame_size 'which' field.
      DocBook media: document the new 'which' field.
      v4l2-subdev: add support for the new enum_frame_interval 'which' field.
      v4l2-subdev: remove enum_framesizes/intervals

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
 drivers/media/i2c/ov7670.c                                            | 37 +++++++++++++++---------
 drivers/media/i2c/ov9650.c                                            | 16 +++++------
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                              | 72 ++++++++++++++++++++++++++++------------------
 drivers/media/i2c/s5k4ecgx.c                                          | 16 +++++------
 drivers/media/i2c/s5k5baf.c                                           | 38 ++++++++++++------------
 drivers/media/i2c/s5k6a3.c                                            | 18 ++++++------
 drivers/media/i2c/s5k6aa.c                                            | 34 +++++++++++-----------
 drivers/media/i2c/smiapp/smiapp-core.c                                | 80 +++++++++++++++++++++++++--------------------------
 drivers/media/i2c/tvp514x.c                                           | 12 ++++----
 drivers/media/i2c/tvp7002.c                                           | 14 ++++-----
 drivers/media/platform/am437x/am437x-vpfe.c                           |  2 ++
 drivers/media/platform/exynos4-is/fimc-capture.c                      | 22 +++++++-------
 drivers/media/platform/exynos4-is/fimc-isp.c                          | 28 +++++++++---------
 drivers/media/platform/exynos4-is/fimc-lite.c                         | 33 ++++++++++-----------
 drivers/media/platform/exynos4-is/mipi-csis.c                         | 16 +++++------
 drivers/media/platform/marvell-ccic/mcam-core.c                       | 48 ++++++++++++++++++++++++++++---
 drivers/media/platform/omap3isp/ispccdc.c                             | 86 +++++++++++++++++++++++++++----------------------------
 drivers/media/platform/omap3isp/ispccp2.c                             | 46 ++++++++++++++---------------
 drivers/media/platform/omap3isp/ispcsi2.c                             | 42 +++++++++++++--------------
 drivers/media/platform/omap3isp/isppreview.c                          | 70 ++++++++++++++++++++++----------------------
 drivers/media/platform/omap3isp/ispresizer.c                          | 80 +++++++++++++++++++++++++--------------------------
 drivers/media/platform/s3c-camif/camif-capture.c                      | 18 ++++++------
 drivers/media/platform/soc_camera/soc_camera.c                        | 30 +++++++++++++------
 drivers/media/platform/via-camera.c                                   | 15 ++++++++--
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
 include/media/v4l2-subdev.h                                           | 55 +++++++++++++++++++++--------------
 include/uapi/linux/v4l2-subdev.h                                      | 12 ++++++--
 57 files changed, 1012 insertions(+), 865 deletions(-)
