Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42320 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2BVObO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 09:31:14 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZS006S4TO1GD@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Feb 2012 14:31:13 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZS0086ETO09S@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Feb 2012 14:31:13 +0000 (GMT)
Date: Wed, 22 Feb 2012 15:31:12 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.4] JPEG control class,
 vb2 and Samsung media driver updates
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4F44FC30.5020604@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Please pull the below change set for v3.4 tree. It contains an addition 
of control class for JPEG codecs and the corresponding patches for 
s5p-jpeg and gspca drivers, updates of various Samsung S5P SoC media 
drivers including, among others, adaptations to upcoming common clock API.
There is also a vb2 update adding USERPTR support for devices using
PFN mapped memory.


The following changes since commit a3db60bcf7671cc011ab4f848cbc40ff7ab52c1e:

  [media] xc5000: declare firmware configuration structures as static const (2012-02-14 17:22:46 -0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung media-for-next

for you to fetch changes up to fb8883bb822be740a9f7dc7cfbeedb1b0e657f64:

  m5mols: Make subdev name independent of the I2C slave address (2012-02-21 10:20:53 +0100)

----------------------------------------------------------------
Andrzej Pietrasiewicz (1):
      s5p-jpeg: Adapt to new controls

Javier Martin (1):
      media: vb2: support userptr for PFN mappings.

Kamil Debski (3):
      s5p-g2d: Added support for clk_prepare
      s5p-mfc: Added support for clk_prepare
      s5p-g2d: Added locking for writing control values to registers

Sachin Kamat (1):
      s5p-g2d: Add HFLIP and VFLIP support

Sylwester Nawrocki (15):
      V4L: Add JPEG compression control class
      V4L: Add JPEG compression control class documentation
      gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
      s5p-jpeg: Use struct v4l2_fh
      s5p-jpeg: Add JPEG controls support
      s5p-fimc: Add driver documentation
      s5p-fimc: convert to clk_prepare()/clk_unprepare()
      s5p-csis: Add explicit dependency on REGULATOR
      s5p-fimc: Convert to the device managed resources
      s5p-fimc: Add support for VIDIOC_PREPARE_BUF/CREATE_BUFS ioctls
      s5p-fimc: Replace the crop ioctls with VIDIOC_S/G_SELECTION
      s5p-csis: Convert to the device managed resources
      s5k6aa: Make subdev name independent of the I2C slave address
      noon010pc30: Make subdev name independent of the I2C slave address
      m5mols: Make subdev name independent of the I2C slave address

 Documentation/DocBook/media/v4l/biblio.xml         |   20 ++
 Documentation/DocBook/media/v4l/compat.xml         |   10 +
 Documentation/DocBook/media/v4l/controls.xml       |  161 ++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 +
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |   16 ++-
 Documentation/video4linux/fimc.txt                 |  178 +++++++++++++++++
 drivers/media/video/Kconfig                        |    3 +-
 drivers/media/video/gspca/zc3xx.c                  |   43 +++--
 drivers/media/video/m5mols/m5mols_core.c           |    2 +-
 drivers/media/video/noon010pc30.c                  |    2 +-
 drivers/media/video/s5k6aa.c                       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c        |  121 +++++++++---
 drivers/media/video/s5p-fimc/fimc-core.c           |   85 +++-----
 drivers/media/video/s5p-fimc/fimc-core.h           |    2 -
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |    7 +-
 drivers/media/video/s5p-fimc/mipi-csis.c           |  109 +++++-------
 drivers/media/video/s5p-g2d/g2d-hw.c               |    5 +
 drivers/media/video/s5p-g2d/g2d.c                  |   63 +++++--
 drivers/media/video/s5p-g2d/g2d.h                  |    6 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c           |  199 ++++++++++++++------
 drivers/media/video/s5p-jpeg/jpeg-core.h           |   11 +-
 drivers/media/video/s5p-jpeg/jpeg-hw.h             |   18 +-
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c           |   24 +++-
 drivers/media/video/v4l2-ctrls.c                   |   24 +++
 drivers/media/video/videobuf2-vmalloc.c            |   70 +++++---
 include/linux/videodev2.h                          |   24 +++
 26 files changed, 935 insertions(+), 279 deletions(-)
 create mode 100644 Documentation/video4linux/fimc.txt

Thank you.

---

Regards,
Sylwester
