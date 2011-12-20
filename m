Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37344 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1LTSwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 13:52:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LWI00FPFN3Y0T80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Dec 2011 18:52:46 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LWI00996N3YJW@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Dec 2011 18:52:46 +0000 (GMT)
Date: Tue, 20 Dec 2011 19:51:28 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] VideoBuf2 fixes for v3.3
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1324407088-7328-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Please pull our fixes for videobuf2 framework into your for_v3.3 development branch.

Best regards,
Marek Szyprowski
Samsung Poland R&D Center



The following changes since commit bcc072756e4467dc30e502a311b1c3adec96a0e4:

  [media] STV0900: Query DVB frontend delivery capabilities (2011-12-12 15:04:34 -0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung vb2-fixes

Andrzej Pietrasiewicz (1):
      media: vb2: vmalloc-based allocator user pointer handling

Marek Szyprowski (4):
      media: vb2: fix queueing of userptr buffers with null buffer pointer
      media: vb2: fix potential deadlock in mmap vs. get_userptr handling
      media: vb2: remove plane argument from call_memop and cleanup mempriv usage
      media: vb2: review mem_priv usage and fix potential bugs

 drivers/media/video/videobuf2-core.c    |  118 +++++++++++++++++++------------
 drivers/media/video/videobuf2-dma-sg.c  |    3 +-
 drivers/media/video/videobuf2-memops.c  |   28 +++-----
 drivers/media/video/videobuf2-vmalloc.c |   90 ++++++++++++++++++++---
 4 files changed, 161 insertions(+), 78 deletions(-)
