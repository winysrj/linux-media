Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56340 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1FIMFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 08:05:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LMI00JX4UWKEG90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Jun 2011 13:05:11 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMI007HZUWJA0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Jun 2011 13:05:07 +0100 (BST)
Date: Thu, 09 Jun 2011 14:05:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 3.0] s5p-fimc and m5mols driver fixes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4DF0B6F3.6010804@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro, please pull the following s5p-fimc and m5mols driver updates.


The following changes since commit 215c52702775556f4caf5872cc84fa8810e6fc7d:

  [media] V4L/videobuf2-memops: use pr_debug for debug messages (2011-06-01
18:20:34 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p-fimc

HeungJun, Kim (4):
      m5mols: Fix capture image size register definition
      m5mols: add m5mols_read_u8/u16/u32() according to I2C byte width
      m5mols: remove union in the m5mols_get_version(), and VERSION_SIZE
      m5mols: Use proper email address format

Sylwester Nawrocki (7):
      s5p-fimc: Fix possible memory leak during capture devnode registration
      s5p-fimc: Fix V4L2_PIX_FMT_RGB565X description
      s5p-fimc: Fix data structures documentation and cleanup debug trace
      s5p-fimc: Fix wrong buffer size in queue_setup
      s5p-fimc: Remove empty buf_init operation
      s5p-fimc: Use pix_mp for the color format lookup
      s5p-fimc: Update copyright notices

 drivers/media/video/m5mols/m5mols.h          |   57 +++++-----
 drivers/media/video/m5mols/m5mols_capture.c  |   22 ++--
 drivers/media/video/m5mols/m5mols_controls.c |    6 +-
 drivers/media/video/m5mols/m5mols_core.c     |  144 ++++++++++++++++----------
 drivers/media/video/m5mols/m5mols_reg.h      |   21 +++-
 drivers/media/video/s5p-fimc/fimc-capture.c  |   21 +---
 drivers/media/video/s5p-fimc/fimc-core.c     |   28 ++----
 drivers/media/video/s5p-fimc/fimc-core.h     |   29 +++---
 include/media/m5mols.h                       |    4 +-
 9 files changed, 176 insertions(+), 156 deletions(-)


Thanks,

Sylwester Nawrocki
