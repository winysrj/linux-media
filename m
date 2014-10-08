Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44336 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbaJHIqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 04:46:43 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND400J5SB1UKXA0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 17:46:42 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC 0/1] Libv4l: Add a plugin for the Exynos4 camera
Date: Wed, 08 Oct 2014 10:46:19 +0200
Message-id: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a plugin for the Exynos4 camera. I wanted to split
at least the parser part to the separate module but encountered
some problems with autotools configuration and therefore I'd like
to ask for an instruction on how to adjust the Makefile.am files
to achieve this.
I also think that the helper functions for discovering device topology
and setting the links are reusable and should be put to the separate
module. I'm wondering what would be the most suitable place.

The plugin was tested on linux-next-20130927 with patches for
exynos4-is that fix failing open when a sensor sub-device is not
linked. This patch series is being submitted in the separate
thread.

The plugin expects a configuration file:
/var/lib/libv4l/exynos4_capture_conf

Exemplary configuration file:

>>>>>>>>>>>>>>

link {
        source_entity: s5p-mipi-csis.0
        source_pad: 1
        sink_entity: FIMC.0
        sink_pad: 0
}

v4l2-controls {
        Color Effects: S5C73M3
        Saturation: S5C73M3
}

<<<<<<<<<<<<<<

With this settings the plugin can be tested on the exynos4412-trats2 board
using following gstreamer pipeline:

gst-launch-0.10 v4l2src device=/dev/video1 ! video/x-raw-rgb,width=960,height=720,format=\(fourcc\)RGBP ! ffmpegcolorspace ! fbdevsink

In order to avoid fbdevsink element failure the fix [1]
for exynos-drm driver is required.

ffmpegcolorspace element shouldn't be normally required but format
negotiation error is reported by gstreamer without it.
I am investigating the issue.

Thanks,
Jacek Anaszewski

[1] http://www.spinics.net/lists/dri-devel/msg66494.html

Jacek Anaszewski (1):
  Add a libv4l plugin for Exynos4 camera

 configure.ac                                       |    1 +
 lib/Makefile.am                                    |    5 +-
 lib/libv4l-exynos4-camera/Makefile.am              |    7 +
 .../libv4l-devconfig-parser.h                      |  145 ++
 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c  | 2486 ++++++++++++++++++++
 5 files changed, 2642 insertions(+), 2 deletions(-)
 create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h
 create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c

-- 
1.7.9.5

