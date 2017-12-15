Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56448 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755970AbdLOWmf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 17:42:35 -0500
Date: Sat, 16 Dec 2017 00:42:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com, yong.zhi@intel.com
Subject: [GIT PULL for 4.16 v2] Intel IPU3 CIO2 CSI-2 receiver driver
Message-ID: <20171215224231.lrti6eou2jkcu4vu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the Intel IPU3 CIO2 CSI-2 receiver driver, with the accompanying
format definitions.

Since the previous pull request dealing with this, I've squashed Yong's
patch to the patch introducing the driver, addressing two issues:

	- unused "phys" variable and

	- memory allocated on stack based on a function argument.

<URL:https://patchwork.linuxtv.org/patch/45991/>

Please pull.


The following changes since commit b32a2b42f76cdfd06b4b58a1ddf987ba329ae34e:

  media: ddbridge: improve error handling logic on fe attach failures (2017-12-13 10:19:41 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ipu3

for you to fetch changes up to 012b03bf357ecb0807c790e8f0b3bcff7e079ae2:

  intel-ipu3: cio2: add new MIPI-CSI2 driver (2017-12-15 17:56:04 +0200)

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
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 2048 ++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  449 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +
 include/uapi/linux/videodev2.h                     |    6 +
 12 files changed, 2880 insertions(+), 1 deletion(-)
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
