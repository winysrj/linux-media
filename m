Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14003 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab1JFO5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 10:57:15 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LSN00K7PG7DDI@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Oct 2011 15:57:13 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LSN0049JG7D5X@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Oct 2011 15:57:13 +0100 (BST)
Date: Thu, 06 Oct 2011 16:57:05 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] More Samsung patches for v3.2
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1317913025-11534-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

The following changes since commit 2f4cf2c3a971c4d5154def8ef9ce4811d702852d:

  [media] dib9000: release a lock on error (2011-09-30 13:32:56 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung for_mauro

Kamil Debski (2):
      v4l: add G2D driver for s5p device family
      v4l: s5p-mfc: fix reported capabilities

 drivers/media/video/Kconfig               |    9 +
 drivers/media/video/Makefile              |    2 +
 drivers/media/video/s5p-g2d/Makefile      |    3 +
 drivers/media/video/s5p-g2d/g2d-hw.c      |  106 ++++
 drivers/media/video/s5p-g2d/g2d-regs.h    |  115 ++++
 drivers/media/video/s5p-g2d/g2d.c         |  824 +++++++++++++++++++++++++++++
 drivers/media/video/s5p-g2d/g2d.h         |   83 +++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    4 +-
 9 files changed, 1146 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/video/s5p-g2d/Makefile
 create mode 100644 drivers/media/video/s5p-g2d/g2d-hw.c
 create mode 100644 drivers/media/video/s5p-g2d/g2d-regs.h
 create mode 100644 drivers/media/video/s5p-g2d/g2d.c
 create mode 100644 drivers/media/video/s5p-g2d/g2d.h
