Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36480 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758947AbbCDJsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 04:48:19 -0500
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 138FF2A0084
	for <linux-media@vger.kernel.org>; Wed,  4 Mar 2015 10:48:02 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 0/8] v4l2-subdev: removal of duplicate video enum ops
Date: Wed,  4 Mar 2015 10:47:53 +0100
Message-Id: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series is based on this v1 series:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/87869

Changes for v2:

- am437 needed to set 'which' to ACTIVE in patches 4 and 5, this was missing.
- The comment of the new v4l2_subdev_pad_config struct has been improved
  in patch 1.
- patch 6/7 of the v1 patch series has been split up in two: one switching
  the last video op to pad op, the second actually removing the video op.

This patch series starts the work of removing several video ops that
are duplicated in as pad ops in the subdev kernel API. This kills the
whole point of the subdev API which is to enable reuse of subdevices by 
different bridge drivers. With duplicate ops bridge drivers now either
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
so NULL can be used there instead. However, this might change in the
future.

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

Hans Verkuil (8):
  v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
  v4l2-subdev.h: add 'which' field for the enum structs
  v4l2-subdev.c: add 'which' checks for enum ops.
  v4l2-subdev: support new 'which' field in enum_mbus_code
  v4l2-subdev: add support for the new enum_frame_size 'which' field.
  DocBook media: document the new 'which' field.
  v4l2-subdev: add support for the new enum_frame_interval 'which'
    field.
  v4l2-subdev: remove enum_framesizes/intervals

 .../v4l/vidioc-subdev-enum-frame-interval.xml      | 13 +++-
 .../media/v4l/vidioc-subdev-enum-frame-size.xml    | 13 +++-
 .../media/v4l/vidioc-subdev-enum-mbus-code.xml     | 11 ++-
 drivers/media/i2c/adv7180.c                        | 10 +--
 drivers/media/i2c/adv7511.c                        | 16 ++--
 drivers/media/i2c/adv7604.c                        | 12 +--
 drivers/media/i2c/m5mols/m5mols_core.c             | 16 ++--
 drivers/media/i2c/mt9m032.c                        | 34 ++++-----
 drivers/media/i2c/mt9p031.c                        | 36 ++++-----
 drivers/media/i2c/mt9t001.c                        | 36 ++++-----
 drivers/media/i2c/mt9v032.c                        | 36 ++++-----
 drivers/media/i2c/noon010pc30.c                    | 17 +++--
 drivers/media/i2c/ov7670.c                         | 37 ++++++----
 drivers/media/i2c/ov9650.c                         | 16 ++--
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 72 +++++++++++-------
 drivers/media/i2c/s5k4ecgx.c                       | 16 ++--
 drivers/media/i2c/s5k5baf.c                        | 38 +++++-----
 drivers/media/i2c/s5k6a3.c                         | 18 ++---
 drivers/media/i2c/s5k6aa.c                         | 34 ++++-----
 drivers/media/i2c/smiapp/smiapp-core.c             | 80 ++++++++++----------
 drivers/media/i2c/tvp514x.c                        | 12 +--
 drivers/media/i2c/tvp7002.c                        | 14 ++--
 drivers/media/platform/am437x/am437x-vpfe.c        |  2 +
 drivers/media/platform/exynos4-is/fimc-capture.c   | 22 +++---
 drivers/media/platform/exynos4-is/fimc-isp.c       | 28 +++----
 drivers/media/platform/exynos4-is/fimc-lite.c      | 33 +++++----
 drivers/media/platform/exynos4-is/mipi-csis.c      | 16 ++--
 drivers/media/platform/marvell-ccic/mcam-core.c    | 48 +++++++++++-
 drivers/media/platform/omap3isp/ispccdc.c          | 86 +++++++++++-----------
 drivers/media/platform/omap3isp/ispccp2.c          | 46 ++++++------
 drivers/media/platform/omap3isp/ispcsi2.c          | 42 +++++------
 drivers/media/platform/omap3isp/isppreview.c       | 70 +++++++++---------
 drivers/media/platform/omap3isp/ispresizer.c       | 80 ++++++++++----------
 drivers/media/platform/s3c-camif/camif-capture.c   | 18 ++---
 drivers/media/platform/soc_camera/soc_camera.c     | 30 +++++---
 drivers/media/platform/via-camera.c                | 15 +++-
 drivers/media/platform/vsp1/vsp1_bru.c             | 42 ++++++-----
 drivers/media/platform/vsp1/vsp1_entity.c          | 16 ++--
 drivers/media/platform/vsp1/vsp1_entity.h          |  4 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            | 18 +++--
 drivers/media/platform/vsp1/vsp1_lif.c             | 22 +++---
 drivers/media/platform/vsp1/vsp1_lut.c             | 22 +++---
 drivers/media/platform/vsp1/vsp1_rwpf.c            | 37 +++++-----
 drivers/media/platform/vsp1/vsp1_rwpf.h            | 12 +--
 drivers/media/platform/vsp1/vsp1_sru.c             | 30 ++++----
 drivers/media/platform/vsp1/vsp1_uds.c             | 30 ++++----
 drivers/media/v4l2-core/v4l2-subdev.c              | 30 +++++---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 51 ++++++-------
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 49 ++++++------
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 83 +++++++++++----------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 59 +++++++--------
 drivers/staging/media/omap4iss/iss_csi2.c          | 42 +++++------
 drivers/staging/media/omap4iss/iss_ipipe.c         | 42 +++++------
 drivers/staging/media/omap4iss/iss_ipipeif.c       | 52 +++++++------
 drivers/staging/media/omap4iss/iss_resizer.c       | 46 ++++++------
 include/media/v4l2-subdev.h                        | 55 ++++++++------
 include/uapi/linux/v4l2-subdev.h                   | 12 ++-
 57 files changed, 1012 insertions(+), 865 deletions(-)

-- 
2.1.4

