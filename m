Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64217 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3GVNoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 09:44:46 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQC00AHQBDUNSC0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Jul 2013 14:44:43 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MQC003X2BHZJ000@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Jul 2013 14:44:43 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] For 3.12
Date: Mon, 22 Jul 2013 15:44:26 +0200
Message-id: <07e901ce86e1$9518b0f0$bf4a12d0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 348d1299b808a9e68a7dee2a4de6b555600099de:

  s5p-g2d: Fix registration failure (2013-07-22 14:17:28 +0200)

are available in the git repository at:

  git://git.linuxtv.org/kdebski/media.git new-for-3.12

for you to fetch changes up to abe28f650794d42c7cc1d0ff3759156e9cdfae70:

  coda: add CODA7541 decoding support (2013-07-22 14:33:30 +0200)

----------------------------------------------------------------
Philipp Zabel (9):
      mem2mem: add support for hardware buffered queue
      coda: use vb2_set_plane_payload instead of setting
v4l2_planes[0].bytesused directly
      coda: dynamic IRAM setup for encoder
      coda: do not allocate maximum number of framebuffers for encoder
      coda: update CODA7541 to firmware 1.4.50
      coda: add bitstream ringbuffer handling for decoder
      coda: dynamic IRAM setup for decoder
      coda: split encoder specific parts out of device_run and irq_handler
      coda: add CODA7541 decoding support

 drivers/media/platform/coda.c          | 1469
++++++++++++++++++++++++++++----
 drivers/media/platform/coda.h          |  107 ++-
 drivers/media/v4l2-core/v4l2-mem2mem.c |   10 +-
 include/media/v4l2-mem2mem.h           |   13 +
 4 files changed, 1410 insertions(+), 189 deletions(-)


