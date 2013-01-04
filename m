Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9196 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3ADTBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 14:01:12 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG4008757HXI340@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 19:01:09 +0000 (GMT)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MG400B3I7HWKI60@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Jan 2013 19:01:09 +0000 (GMT)
Message-id: <50E726F4.7060704@samsung.com>
Date: Fri, 04 Jan 2013 20:01:08 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.9] Exynos SoC media drivers updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following for 3.9, it includes Exynos SoC drivers cleanups and
fixes. DMABUF exporting support for Exynos5 GScaler driver, device tree support
for Exynos MFC driver (platform bits for it got merged already for v3.8).

There is also included a patch removing deprecated image centering controls.

The following changes since commit 8cd7085ff460ead3aba6174052a408f4ad52ac36:

  [media] get_dvb_firmware: Fix the location of firmware for Terratec HTC
(2013-01-01 11:18:26 -0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung media_for_v3.9

for you to fetch changes up to 36073ee2f7b3b5ae91900cb992b292404614243b:

  V4L: Remove deprecated image centering controls (2013-01-04 11:35:43 +0100)

----------------------------------------------------------------
Arun Kumar K (2):
      s5p-mfc: Add device tree support
      s5p-mfc: Flush DPB buffers during stream off

Kamil Debski (4):
      s5p-mfc: Move firmware allocation point to avoid allocation problems
      s5p-mfc: Correct check of vb2_dma_contig_init_ctx return value
      s5p-mfc: Change internal buffer allocation from vb2 ops to dma_alloc_coherent
      s5p-mfc: Context handling in open() bugfix

Sachin Kamat (9):
      s5p-tv: Add missing braces around sizeof in sdo_drv.c
      s5p-tv: Add missing braces around sizeof in mixer_video.c
      s5p-tv: Add missing braces around sizeof in mixer_reg.c
      s5p-tv: Add missing braces around sizeof in mixer_drv.c
      s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
      s5p-tv: Add missing braces around sizeof in hdmi_drv.c
      s5p-mfc: Remove redundant 'break'
      s5p-mfc: Fix a typo in error message in s5p_mfc_pm.c
      s5p-mfc: Fix an error check

Shaik Ameer Basha (1):
      exynos-gsc: Support dmabuf export buffer

Sylwester Nawrocki (5):
      s5p-fimc: Avoid possible NULL pointer dereference in set_fmt op
      s5p-fimc: Prevent potential buffer overflow
      s5p-fimc: Prevent AB-BA deadlock during links reconfiguration
      s5p-tv: Fix return value in sdo_probe() on error paths
      V4L: Remove deprecated image centering controls

Tomasz Stanislawski (1):
      s5p-tv: mixer: fix handling of VIDIOC_S_FMT

Tony Prisk (3):
      s5p-fimc: Fix incorrect usage of IS_ERR_OR_NULL
      s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL
      s5p-g2d: Fix incorrect usage of IS_ERR_OR_NULL

Wei Yongjun (1):
      s5p-mfc: remove unused variable

 Documentation/DocBook/media/v4l/controls.xml    |   23 ---
 drivers/media/platform/exynos-gsc/gsc-m2m.c     |   12 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c  |   58 +++++--
 drivers/media/platform/s5p-fimc/fimc-lite.c     |    6 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c  |  100 +++++-------
 drivers/media/platform/s5p-g2d/g2d.c            |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  148 ++++++++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   31 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  149 ++++++++---------
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h   |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   15 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |   30 ++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    5 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  197 ++++++++---------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  148 ++++++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |    2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c        |   18 +--
 drivers/media/platform/s5p-tv/hdmiphy_drv.c     |    2 +-
 drivers/media/platform/s5p-tv/mixer_drv.c       |   14 +-
 drivers/media/platform/s5p-tv/mixer_reg.c       |    6 +-
 drivers/media/platform/s5p-tv/mixer_video.c     |   22 +--
 drivers/media/platform/s5p-tv/sdo_drv.c         |   29 ++--
 drivers/media/v4l2-core/v4l2-ctrls.c            |    2 -
 include/uapi/linux/v4l2-controls.h              |    4 -
 24 files changed, 503 insertions(+), 525 deletions(-)


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
