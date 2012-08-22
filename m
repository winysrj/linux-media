Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35447 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab2HVPbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 11:31:55 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9500EVHXTVIJB0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 16:32:19 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M950031JXT4OI90@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 16:31:52 +0100 (BST)
Message-id: <5034FB67.5060401@samsung.com>
Date: Wed, 22 Aug 2012 17:31:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	Sungchun Kang <sungchun.kang@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
Subject: [GIT PATCHES FOR v3.7] V4L: Exynos5 SoC GScaler driver
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


The following changes since commit 01b0c11a1ba49ac96f58b7bc92772c2b469d6caa:

  [media] Kconfig: Fix b2c2 common code selection (2012-08-21 08:38:31 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l-exynos-gsc

for you to fetch changes up to 231560807f44daf9d1c2913e749c8a8609fc3c66:

  gscaler: Add Makefile for G-Scaler Driver (2012-08-22 10:36:49 +0200)


This is a mem-to-mem driver for Exynos5 SoC series GScaler devices
and an addition of multi-planar YVU420 fourcc.

----------------------------------------------------------------
Shaik Ameer Basha (2):
      v4l: Add new YVU420 multi planar fourcc definition
      gscaler: Add Makefile for G-Scaler Driver

Sungchun Kang (3):
      gscaler: Add new driver for generic scaler
      gscaler: Add core functionality for the G-Scaler driver
      gscaler: Add m2m functionality for the G-Scaler driver

 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml |  154 ++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 drivers/media/platform/Kconfig                     |    8 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/exynos-gsc/gsc-core.c       | 1253
++++++++++++++++++++++++++++++
 drivers/media/platform/exynos-gsc/gsc-core.h       |  527 +++++++++++++
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  771 ++++++++++++++++++
 drivers/media/platform/exynos-gsc/gsc-regs.c       |  425 ++++++++++
 drivers/media/platform/exynos-gsc/gsc-regs.h       |  172 ++++
 include/linux/videodev2.h                          |    1 +
 10 files changed, 3313 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-core.c
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-core.h
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-m2m.c
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-regs.c
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-regs.h

---

Regards,
Sylwester
