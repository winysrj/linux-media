Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:50682 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbcARQR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:17:57 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1500QP0P9R0A20@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:17:55 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 00/15] Add a plugin for Exynos4 camera
Date: Mon, 18 Jan 2016 17:17:25 +0100
Message-id: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a sixth version of the patch series adding a plugin for the 
Exynos4 camera.

The plugin doesn't link against libmediactl, but has its sources
compiled in. Currently utils are built after the plugins, but
libv4l-exynos4-camera plugin depends on the utils. In order to link
the plugin against libmediactl the build system would have to be
modified.

================
Changes from v5:
================

- fixed and tested use cases with S5K6A3 sensor and FIMC-IS-ISP
- added conversion "colorspace id to string"

================
Changes from v4:
================

- removed some redundant functions for traversing media device graph
  and switched over to using existing ones
- avoided accessing struct v4l2_subdev from libmediactl
- applied various improvements

================
Changes from v3:
================

- added struct v4l2_subdev and put entity fd and 
  information about supported controls to it
- improved functions for negotiating and setting
  pipeline format by using available libv4lsubdev API
- applied minor improvements and cleanups

================
Changes from v2:
================

- switched to using mediatext library for parsing
  the media device configuration
- extended libmediactl
- switched to using libmediactl

================
Changes from v1:
================

- removed redundant mbus code negotiation
- split the parser, media device helpers and ioctl wrappers
  to the separate modules
- added mechanism for querying extended controls
- applied various fixes and modifications



The plugin was tested on v4.4 with patches fixing several
issues for Exynos4 camera
(patch set titled "Exynos4-is fixes for libv4l exynos4 camera plugin").

The plugin expects a configuration file:
/var/lib/libv4l/exynos4_capture_conf

Exemplary configuration file for pipeline with sensor
S5C73M3 (rear camera):

==========================================

link-conf "s5p-mipi-csis.0":1 -> "FIMC.0":0 [1]
ctrl-to-subdev-conf 0x0098091f -> "fimc.0.capture"
ctrl-to-subdev-conf 0x00980902 -> "S5C73M3"
ctrl-to-subdev-conf 0x00980922 -> "fimc.0.capture"
ctrl-to-subdev-conf 0x009a0914 -> "S5C73M3"

==========================================

With this settings the plugin can be tested on the exynos4412-trats2 board
using following gstreamer pipeline:

gst-launch-1.0 v4l2src device=/dev/video1 extra-controls="c,rotate=90,color_effects=2" ! video/x-raw,width=960,height=720 ! fbdevsink

Exemplary configuration file for pipeline with sensor
S5K6A3 (front camera):

==========================================

link-conf "s5p-mipi-csis.1":1 -> "FIMC-LITE.1":0 [1]
link-conf "FIMC-LITE.1":2 -> "FIMC-IS-ISP":0 [1]
link-conf "FIMC-IS-ISP":1 -> "FIMC.0":1 [1]

==========================================

gst-launch-1.0 v4l2src device=/dev/video1 extra-controls="c,rotate=270,color_effects=2,horizontal_flip=1" ! video/x-raw,width=960,height=920 ! fbdevsink


Thanks,
Jacek Anaszewski

Jacek Anaszewski (14):
  mediactl: Introduce v4l2_subdev structure
  mediactl: Add support for v4l2-ctrl-redir config
  mediatext: Add library
  mediactl: Add media device graph helpers
  mediactl: Add media_device creation helpers
  mediactl: libv4l2subdev: add VYUY8_2X8 mbus code
  mediactl: Add support for media device pipelines
  mediactl: libv4l2subdev: Add colorspace logging
  mediactl: libv4l2subdev: add support for comparing mbus formats
  mediactl: libv4l2subdev: add support for setting pipeline format
  mediactl: libv4l2subdev: add get_pipeline_entity_by_cid function
  mediactl: Add media device ioctl API
  mediactl: libv4l2subdev: Enable opening/closing pipelines
  Add a libv4l plugin for Exynos4 camera

Sakari Ailus (1):
  mediactl: Separate entity and pad parsing

 configure.ac                                      |    1 +
 lib/Makefile.am                                   |    5 +
 lib/libv4l-exynos4-camera/Makefile.am             |    7 +
 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c |  620 +++++++++++++++++++++
 utils/media-ctl/Makefile.am                       |   12 +-
 utils/media-ctl/libmediactl.c                     |  272 ++++++++-
 utils/media-ctl/libmediatext.pc.in                |   10 +
 utils/media-ctl/libv4l2media_ioctl.c              |  404 ++++++++++++++
 utils/media-ctl/libv4l2media_ioctl.h              |   48 ++
 utils/media-ctl/libv4l2subdev.c                   |  340 ++++++++++-
 utils/media-ctl/mediactl-priv.h                   |   11 +-
 utils/media-ctl/mediactl.h                        |  151 +++++
 utils/media-ctl/mediatext-test.c                  |   64 +++
 utils/media-ctl/mediatext.c                       |  311 +++++++++++
 utils/media-ctl/mediatext.h                       |   52 ++
 utils/media-ctl/v4l2subdev.h                      |  148 +++++
 16 files changed, 2426 insertions(+), 30 deletions(-)
 create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
 create mode 100644 utils/media-ctl/libmediatext.pc.in
 create mode 100644 utils/media-ctl/libv4l2media_ioctl.c
 create mode 100644 utils/media-ctl/libv4l2media_ioctl.h
 create mode 100644 utils/media-ctl/mediatext-test.c
 create mode 100644 utils/media-ctl/mediatext.c
 create mode 100644 utils/media-ctl/mediatext.h

-- 
1.7.9.5

