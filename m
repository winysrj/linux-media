Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10321 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab3IQMsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 08:48:15 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MT900G8ISSO0AC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Sep 2013 13:46:43 +0100 (BST)
Message-id: <52384F31.4060000@samsung.com>
Date: Tue, 17 Sep 2013 14:46:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] 3.12 (mostly videobuf2) fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are couple regression fixes for 3.12-rc. I'm planning to send backport 
patches of the videobuf2-dma-contig allocator patch for -stable.

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.12-fixes-1

for you to fetch changes up to 99f2689e2d05b42d51bf087850c84da2000ded1e:

  s5p-jpeg: Initialize vfd_decoder->vfl_dir field (2013-09-17 13:21:59 +0200)

----------------------------------------------------------------
Jacek Anaszewski (1):
      s5p-jpeg: Initialize vfd_decoder->vfl_dir field

Marek Szyprowski (1):
      videobuf2-dc: Fix support for mappings without struct page in userptr mode

Sylwester Nawrocki (1):
      vb2: Allow queuing OUTPUT buffers with zeroed 'bytesused'

 drivers/media/platform/s5p-jpeg/jpeg-core.c    |    1 +
 drivers/media/v4l2-core/videobuf2-core.c       |    4 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c |   87 ++++++++++++++++++++++--
 3 files changed, 86 insertions(+), 6 deletions(-)

--
Regards,
Sylwester
