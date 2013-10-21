Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14758 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3JULO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 07:14:29 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MV000BGXN7A6P90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Oct 2013 12:14:27 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MV0004LKN82G350@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Oct 2013 12:14:27 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.13] mem2mem patches - additional patches
Date: Mon, 21 Oct 2013 13:14:26 +0200
Message-id: <015a01cece4e$b48159b0$1d840d10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are additional mem2mem patches for v3.13.
The Exynos Scaler driver was reviewed by Sylwester and he opted for it to be
included for 3.13.

Best wishes,
Kamil Debski

The following changes since commit 89ef209d3f943ab8039304f7d41de5721dd67ff5:

  s5p-mfc: remove deprecated IRQF_DISABLED (2013-10-18 10:52:42 +0200)

are available in the git repository at:

  git://linuxtv.org/kdebski/media.git for-v3.13

for you to fetch changes up to 43fa53e4fa5f07d45130626e448f5fa313635217:

  exynos-scaler: Add DT bindings for SCALER driver (2013-10-21 13:12:38
+0200)

----------------------------------------------------------------
Shaik Ameer Basha (4):
      exynos-scaler: Add new driver for Exynos5 SCALER
      exynos-scaler: Add core functionality for the SCALER driver
      exynos-scaler: Add m2m functionality for the SCALER driver
      exynos-scaler: Add DT bindings for SCALER driver

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
 9 files changed, 3101 insertions(+)
 create mode 100644
Documentation/devicetree/bindings/media/exynos5-scaler.txt
 create mode 100644 drivers/media/platform/exynos-scaler/Makefile
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-regs.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-regs.h
 create mode 100644 drivers/media/platform/exynos-scaler/scaler.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler.h

