Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33018 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3LXJzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 04:55:04 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYB0059227P2120@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 Dec 2013 09:55:01 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MYB003TH27O6V90@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 Dec 2013 09:55:01 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.14] mem2mem patches
Date: Tue, 24 Dec 2013 10:55:00 +0100
Message-id: <014501cf008e$364ee590$a2ecb0b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 7d459937dc09bb8e448d9985ec4623779427d8a5:

  [media] Add driver for Samsung S5K5BAF camera sensor (2013-12-21 07:01:36
-0200)

are available in the git repository at:

  git://linuxtv.org/kdebski/media.git master

for you to fetch changes up to 0f6616ebb7a04219ad7aa84dd9ff9c7ac9323529:

  s5p-mfc: Add controls to set vp8 enc profile (2013-12-24 10:37:27 +0100)

----------------------------------------------------------------
Arun Kumar K (1):
      s5p-mfc: Add QP setting support for vp8 encoder

Kiran AVND (1):
      s5p-mfc: Add controls to set vp8 enc profile

Marek Szyprowski (1):
      media: s5p_mfc: remove s5p_mfc_get_node_type() function

Shaik Ameer Basha (4):
      exynos-scaler: Add new driver for Exynos5 SCALER
      exynos-scaler: Add core functionality for the SCALER driver
      exynos-scaler: Add m2m functionality for the SCALER driver
      exynos-scaler: Add DT bindings for SCALER driver

 Documentation/DocBook/media/v4l/controls.xml       |   41 +
 .../devicetree/bindings/media/exynos5-scaler.txt   |   22 +
 drivers/media/platform/Kconfig                     |    8 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/exynos-scaler/Makefile      |    3 +
 drivers/media/platform/exynos-scaler/scaler-m2m.c  |  787 +++++++++++++
 drivers/media/platform/exynos-scaler/scaler-regs.c |  336 ++++++
 drivers/media/platform/exynos-scaler/scaler-regs.h |  331 ++++++
 drivers/media/platform/exynos-scaler/scaler.c      | 1238
++++++++++++++++++++
 drivers/media/platform/exynos-scaler/scaler.h      |  375 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   28 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   14 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   55 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   26 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    5 +
 include/uapi/linux/v4l2-controls.h                 |    5 +
 16 files changed, 3241 insertions(+), 34 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/media/exynos5-scaler.txt
 create mode 100644 drivers/media/platform/exynos-scaler/Makefile
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-regs.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-regs.h
 create mode 100644 drivers/media/platform/exynos-scaler/scaler.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler.h


