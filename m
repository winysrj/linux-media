Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10321 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IQMsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 08:48:16 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MT900IMAST6ILC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Sep 2013 13:46:57 +0100 (BST)
Message-id: <52384F40.4030304@samsung.com>
Date: Tue, 17 Sep 2013 14:46:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL FOR 3.13] videobuf2 updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes videobuf2-dma-sg allocator enhancements, videobuf-core cleanup
and debug logs addition.

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.13-videobuf2

for you to fetch changes up to de727541f8be1de8163bf831b38aaf2181d6284e:

  videobuf2: Add debug print for the output buffer plane lengths checks
(2013-09-17 13:46:54 +0200)

----------------------------------------------------------------
Ricardo Ribalda (3):
      videobuf2: Fix vb2_write prototype
      videobuf2-dma-sg: Allocate pages as contiguous as possible
      videobuf2-dma-sg: Replace vb2_dma_sg_desc with sg_table

Seung-Woo Kim (1):
      videobuf2: Add log for size checking error in __qbuf_userptr

Sylwester Nawrocki (1):
      videobuf2: Add debug print for the output buffer plane lengths checks

 drivers/media/platform/marvell-ccic/mcam-core.c    |   14 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   16 ++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |  149 +++++++++++---------
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   20 +--
 include/media/videobuf2-core.h                     |    4 +-
 include/media/videobuf2-dma-sg.h                   |   10 +-
 6 files changed, 119 insertions(+), 94 deletions(-)

--
Regards,
Sylwester
