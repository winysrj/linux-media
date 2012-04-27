Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44323 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760684Ab2D0PpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 11:45:18 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3500GZHACYHP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 16:43:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M350010TAFFLZ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 16:45:16 +0100 (BST)
Date: Fri, 27 Apr 2012 17:45:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 3.4] videobuf2 and s5p-fimc driver fixes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4F9ABF0B.10407@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit aa6d5f29534a6d1459f9768c591a7a72aadc5941:

  [media] pluto2: remove some dead code (2012-04-19 17:15:32 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_fixes_for_v3.4

for you to fetch changes up to 2b083782a9ba9828488c98ce090e48b73691d07e:

  media: videobuf2-dma-contig: include header for exported symbols (2012-04-27 07:52:58 +0200)


These are videobuf2 and s5p-fimc driver fixes. Please pull for v3.4.
It would be nice to also, if possible, have this patch
http://git.linuxtv.org/media_tree.git/commit/aa333122c9c7d11d7d8486db09869517995af0a8
in 3.4-rc, it's is now in branch staging/for_v3.5.

----------------------------------------------------------------
H Hartley Sweeten (2):
      media: videobuf2-dma-contig: quiet sparse noise about plain integer as NULL pointer
      media: videobuf2-dma-contig: include header for exported symbols

Laurent Pinchart (1):
      media: vb2-memops: Export vb2_get_vma symbol

Sylwester Nawrocki (2):
      s5p-fimc: Fix locking in subdev set_crop op
      s5p-fimc: Correct memory allocation for VIDIOC_CREATE_BUFS

 drivers/media/video/s5p-fimc/fimc-capture.c |   33 +++++++++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 ++--
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
 drivers/media/video/videobuf2-dma-contig.c  |    3 ++-
 drivers/media/video/videobuf2-memops.c      |    1 +
 5 files changed, 27 insertions(+), 16 deletions(-)

--

Regards,
Sylwester
