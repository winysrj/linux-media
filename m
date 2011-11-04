Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25471 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1KDIGg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 04:06:36 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LU400JU5MITC8@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 08:06:29 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU4003V3MITYI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 08:06:29 +0000 (GMT)
Date: Fri, 04 Nov 2011 09:06:23 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] More Samsung patches for v3.2 (updated)
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320393984-24921-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

I've collected various pending patches from Samsung and updated our git
tree. Almost all of the patches are quite important fixes to various
videobuf2 corner cases, so I hope they will find their way into v3.2.

The following changes since commit 31cea59efb3a4210c063f31c061ebcaff833f583:

  [media] saa7134.h: Suppress compiler warnings when CONFIG_VIDEO_SAA7134_RC is not set (2011-11-03 16:58:20 -0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung for_mauro

Kamil Debski (2):
      v4l: s5p-mfc: fix reported capabilities
      v4l: add G2D driver for s5p device family

Marek Szyprowski (3):
      media: vb2: add a check for uninitialized buffer
      media: vb2: set buffer length correctly for all buffer types
      media: vb2: reset queued list on REQBUFS(0) call

 drivers/media/video/Kconfig               |    9 +
 drivers/media/video/Makefile              |    2 +
 drivers/media/video/s5p-g2d/Makefile      |    3 +
 drivers/media/video/s5p-g2d/g2d-hw.c      |  106 ++++
 drivers/media/video/s5p-g2d/g2d-regs.h    |  115 ++++
 drivers/media/video/s5p-g2d/g2d.c         |  824 +++++++++++++++++++++++++++++
 drivers/media/video/s5p-g2d/g2d.h         |   83 +++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    4 +-
 drivers/media/video/videobuf2-core.c      |    6 +-
 10 files changed, 1150 insertions(+), 6 deletions(-)
 create mode 100644 drivers/media/video/s5p-g2d/Makefile
 create mode 100644 drivers/media/video/s5p-g2d/g2d-hw.c
 create mode 100644 drivers/media/video/s5p-g2d/g2d-regs.h
 create mode 100644 drivers/media/video/s5p-g2d/g2d.c
 create mode 100644 drivers/media/video/s5p-g2d/g2d.h
