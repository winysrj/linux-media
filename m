Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:6557 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936774AbdD2XfB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 19:35:01 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH 0/3] [media] add IPU3 CIO2 CSI2 driver
Date: Sat, 29 Apr 2017 18:34:33 -0500
Message-Id: <cover.1493479141.git.yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the driver for the CIO2 device found in some the Skylake 
and Kaby Kake SoCs. The CIO2 consists of four D-PHY receivers.

The CIO2 driver exposes V4L2, V4L2 sub-device and Media controller 
interfaces to the user space. It depends on Sakari's V4L2 fwnode 
patchset here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>

Yong Zhi (3):
  [media] videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
  [media] doc-rst: add IPU3 raw10 bayer pixel format definitions
  [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver

 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |   61 +
 drivers/media/pci/Kconfig                          |    2 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/ipu3/Kconfig                     |   17 +
 drivers/media/pci/ipu3/Makefile                    |    1 +
 drivers/media/pci/ipu3/ipu3-cio2.c                 | 1813 ++++++++++++++++++++
 drivers/media/pci/ipu3/ipu3-cio2.h                 |  425 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
 include/uapi/linux/videodev2.h                     |    4 +
 10 files changed, 2330 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
 create mode 100644 drivers/media/pci/ipu3/Kconfig
 create mode 100644 drivers/media/pci/ipu3/Makefile
 create mode 100644 drivers/media/pci/ipu3/ipu3-cio2.c
 create mode 100644 drivers/media/pci/ipu3/ipu3-cio2.h

-- 
2.7.4
