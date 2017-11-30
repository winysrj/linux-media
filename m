Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50740 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751701AbdK3MYi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 07:24:38 -0500
Date: Thu, 30 Nov 2017 14:24:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com, yong.zhi@intel.com
Subject: [GIT PULL for 4.16] Intel IPU3 CIO2 CSI-2 receiver driver
Message-ID: <20171130122435.2t5nbpgsux2wq6pm@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the Intel IPU3 CIO2 CSI-2 receiver driver, with the accompanying
format definitions.

Please pull.


The following changes since commit be9b53c83792e3898755dce90f8c632d40e7c83e:

  media: dvb-frontends: complete kernel-doc markups (2017-11-30 04:19:05 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ipu3

for you to fetch changes up to f178207daa68e817ab6fd702d81ed7c8637ab72c:

  intel-ipu3: cio2: add new MIPI-CSI2 driver (2017-11-30 14:19:47 +0200)

----------------------------------------------------------------
Yong Zhi (3):
      videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
      doc-rst: add IPU3 raw10 bayer pixel format definitions
      intel-ipu3: cio2: add new MIPI-CSI2 driver

 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |  335 ++++
 MAINTAINERS                                        |    8 +
 drivers/media/pci/Kconfig                          |    2 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/intel/Makefile                   |    5 +
 drivers/media/pci/intel/ipu3/Kconfig               |   19 +
 drivers/media/pci/intel/ipu3/Makefile              |    1 +
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 2052 ++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  449 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
 include/uapi/linux/videodev2.h                     |    6 +
 12 files changed, 2884 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
 create mode 100644 drivers/media/pci/intel/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
 create mode 100644 drivers/media/pci/intel/ipu3/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
