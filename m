Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:19746 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaKFKMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:17 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00C5Q4BR88A0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:11:51 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils RFC v3 00/11] Add a plugin for the Exynos4 camera
Date: Thu, 06 Nov 2014 11:11:31 +0100
Message-id: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a third version of the patch series adding a plugin for the 
Exynos4 camera.

Temporarily the plugin doesn't link against libmediactl, but
has its sources compiled in. Currently libmediactl.la is built
after the plugins and this will have to be resolved somehow.

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

The plugin was tested on latest media-tree.git master with patches for
exynos4-is that fix failing open when a sensor sub-device is not
linked [1] [2] [3].

The plugin expects a configuration file:
/var/lib/libv4l/exynos4_capture_conf

Exemplary configuration file:

==========================================

link-conf "s5p-mipi-csis.0":1 -> "FIMC.0":0 [1]
ctrl-to-subdev-conf 0x0098091f -> "fimc.0.capture"
ctrl-to-subdev-conf 0x00980902 -> "S5C73M3"
ctrl-to-subdev-conf 0x00980922 -> "fimc.0.capture"
ctrl-to-subdev-conf 0x009a0914 -> "S5C73M3"

==========================================

With this settings the plugin can be tested on the exynos4412-trats2 board
using following gstreamer pipeline:

gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw,width=960,height=720 ! fbdevsink

In order to avoid fbdevsink element failure the fix [4]
for exynos-drm driver is required.

Thanks,
Jacek Anaszewski

[1] https://patchwork.linuxtv.org/patch/26366/
[2] https://patchwork.linuxtv.org/patch/26367/
[3] https://patchwork.linuxtv.org/patch/26368/
[4] http://www.spinics.net/lists/dri-devel/msg66494.html

Jacek Anaszewski (10):
  mediactl: Introduce ctrl_to_subdev configuration
  mediatext: Add library
  mediactl: Add media device graph helpers
  mediactl: Add media_device creation helpers
  mediactl: Add subdev_fmt property to the media_entity
  mediactl: Add VYUY8_2X8 media bus format
  mediactl: Add support for media device pipelines
  mediactl: Add media device ioctl API
  mediactl: Close only pipeline sub-devices
  Add a libv4l plugin for Exynos4 camera

Sakari Ailus (1):
  mediactl: Separate entity and pad parsing

 configure.ac                                      |    1 +
 lib/Makefile.am                                   |    5 +-
 lib/libv4l-exynos4-camera/Makefile.am             |    7 +
 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c |  599 +++++++++++++++++++++
 libmediatext.pc.in                                |   10 +
 utils/media-ctl/Makefile.am                       |   12 +-
 utils/media-ctl/libmediactl.c                     |  489 ++++++++++++++++-
 utils/media-ctl/libmediatext.pc.in                |   10 +
 utils/media-ctl/libv4l2media_ioctl.c              |  342 ++++++++++++
 utils/media-ctl/libv4l2media_ioctl.h              |   47 ++
 utils/media-ctl/libv4l2subdev.c                   |   66 +++
 utils/media-ctl/mediactl-priv.h                   |   17 +
 utils/media-ctl/mediactl.h                        |  282 ++++++++++
 utils/media-ctl/mediatext-test.c                  |   66 +++
 utils/media-ctl/mediatext.c                       |  303 +++++++++++
 utils/media-ctl/mediatext.h                       |   52 ++
 utils/media-ctl/v4l2subdev.h                      |   27 +
 17 files changed, 2324 insertions(+), 11 deletions(-)
 create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
 create mode 100644 libmediatext.pc.in
 create mode 100644 utils/media-ctl/libmediatext.pc.in
 create mode 100644 utils/media-ctl/libv4l2media_ioctl.c
 create mode 100644 utils/media-ctl/libv4l2media_ioctl.h
 create mode 100644 utils/media-ctl/mediatext-test.c
 create mode 100644 utils/media-ctl/mediatext.c
 create mode 100644 utils/media-ctl/mediatext.h

-- 
1.7.9.5

