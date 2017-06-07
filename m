Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:25742 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751436AbdFGBex (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 21:34:53 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hverkuil@xs4all.nl, hyungwoo.yang@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v2 0/3]  [media] add IPU3 CIO2 CSI2 driver
Date: Tue,  6 Jun 2017 20:34:36 -0500
Message-Id: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the driver for the CIO2 device found in some the Skylake
and Kaby Kake SoCs. The CIO2 consists of four D-PHY receivers.

The CIO2 driver exposes V4L2, V4L2 sub-device and Media controller
interfaces to the user space.

===========
= history =
===========
version 2:
- remove all explicit DMA flush operations
- change dma_free_noncoherent() to dma_free_coherent()
- remove cio2_hw_mipi_lanes()
- replace v4l2_g_ext_ctrls() with v4l2_ctrl_g_ctrl()
  in cio2_csi2_calc_timing().
- use ffs() to iterate the port_status in cio2_irq()
- add static inline file_to_cio2_queue() function
- comment dma_wmb(), cio2_rx_timing() and few other places
- use ktime_get_ns() for vb2_buf.timestamp in cio2_buffer_done()
- use of SET_RUNTIME_PM_OPS() macro for cio2_pm_ops
- use BIT() macro for bit difinitions
- remove un-used macros such as CIO2_QUEUE_WIDTH() in ipu3-cio2.h
- move the MODULE_AUTHOR() to the end of the file
- change file path to drivers/media/pci/intel/ipu3

version 1:
- Initial submission
Yong Zhi (3):
  [media] videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
  [media] doc-rst: add IPU3 raw10 bayer pixel format definitions
  [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver

 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |   62 +
 drivers/media/pci/Kconfig                          |    2 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/intel/Makefile                   |    5 +
 drivers/media/pci/intel/ipu3/Kconfig               |   17 +
 drivers/media/pci/intel/ipu3/Makefile              |    1 +
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 1788 ++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  424 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
 include/uapi/linux/videodev2.h                     |    5 +
 11 files changed, 2311 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
 create mode 100644 drivers/media/pci/intel/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
 create mode 100644 drivers/media/pci/intel/ipu3/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h

-- 
2.7.4
