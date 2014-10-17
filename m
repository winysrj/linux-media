Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46131 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaJQOyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 10:54:55 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDL00KPHG3IV730@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Oct 2014 23:54:54 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v2 0/4] Libv4l: Add a plugin for the Exynos4 camera
Date: Fri, 17 Oct 2014 16:54:38 +0200
Message-id: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a second version of the patch series adding a plugin for the 
Exynos4 camera.

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

link {
        source_entity: s5p-mipi-csis.0
        source_pad: 1
        sink_entity: FIMC.0
        sink_pad: 0
}

v4l2-controls {
        Color Effects: fimc.0.capture
        Saturation: S5C73M3
        Image Stabilization: S5C73M3
        White Balance, Auto & Preset: S5C73M3
        Exposure, Metering Mode: S5C73M3
}

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

Jacek Anaszewski (4):
  Add a media device configuration file parser.
  Add media device related data structures and API.
  Add wrappers for media device related ioctl calls.
  Add a libv4l plugin for Exynos4 camera

 configure.ac                                      |    1 +
 lib/Makefile.am                                   |    5 +-
 lib/include/libv4l2-mdev-ioctl.h                  |   45 +
 lib/include/libv4l2-mdev.h                        |  195 +++++
 lib/include/libv4l2-media-conf-parser.h           |  148 ++++
 lib/libv4l-exynos4-camera/Makefile.am             |    8 +
 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c |  569 ++++++++++++
 lib/libv4l2/Makefile.am                           |    5 +-
 lib/libv4l2/libv4l2-mdev-ioctl.c                  |  329 +++++++
 lib/libv4l2/libv4l2-mdev.c                        |  975 +++++++++++++++++++++
 lib/libv4l2/libv4l2-media-conf-parser.c           |  441 ++++++++++
 11 files changed, 2718 insertions(+), 3 deletions(-)
 create mode 100644 lib/include/libv4l2-mdev-ioctl.h
 create mode 100644 lib/include/libv4l2-mdev.h
 create mode 100644 lib/include/libv4l2-media-conf-parser.h
 create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
 create mode 100644 lib/libv4l2/libv4l2-mdev-ioctl.c
 create mode 100644 lib/libv4l2/libv4l2-mdev.c
 create mode 100644 lib/libv4l2/libv4l2-media-conf-parser.c

-- 
1.7.9.5

