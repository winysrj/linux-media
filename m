Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48553 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753549AbdFMUR3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 16:17:29 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hyungwoo.yang@intel.com, divagar.mohandass@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v3 0/3] [PATCH v3 0/3] [media] add IPU3 CIO2 CSI2 driver
Date: Tue, 13 Jun 2017 15:17:13 -0500
Message-Id: <1497385036-1002-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the driver for the CIO2 device found in some the Skylake
and Kaby Kake SoCs. The CIO2 consists of four D-PHY receivers.

The CIO2 driver exposes V4L2, V4L2 sub-device and Media controller
interfaces to the user space.

===========
= history =
===========

More soon for next version.

version 3:
- remove cio2_set_power().
- replace dma_alloc_noncoherent() with dma_alloc_coherent().
- apply ffs tricks at possible places.
- change sensor_vc to local variable.
- move ktime_get_ns() a little earlier in the calling order.
- fix multiple assignments(I.e a = b =c)
- define CIO2_PAGE_SIZE for CIO2 PAGE_SIZE, SENSOR_VIR_CH_DFLT
for default sensor virtual ch.
- rework cio2_csi2_calc_timing().
- update v4l2 async subdev field name from match.fwnode.fwn
  to match.fwnode.fwnode.
- cherry-pick internal fix for triggering different irq on SOF and EOF.
- return -ENOMEM for vb2_dma_sg_plane_desc() in cio2_vb2_buf_init().
- add cio2_link_validate() placeholder for vdev.

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
  videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
  doc-rst: add IPU3 raw10 bayer pixel format definitions
  intel-ipu3: cio2: Add new MIPI-CSI2 driver

 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |   62 +
 drivers/media/pci/Kconfig                          |    2 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/intel/Makefile                   |    5 +
 drivers/media/pci/intel/ipu3/Kconfig               |   17 +
 drivers/media/pci/intel/ipu3/Makefile              |    1 +
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 1779 ++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  434 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
 include/uapi/linux/videodev2.h                     |    5 +
 11 files changed, 2312 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
 create mode 100644 drivers/media/pci/intel/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
 create mode 100644 drivers/media/pci/intel/ipu3/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h

-- 
2.7.4
