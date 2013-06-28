Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21556 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3F1OYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 10:24:37 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MP300177XC7RV60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jun 2013 15:24:35 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MP300576XCS4VB0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jun 2013 15:24:35 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem driver changes
Date: Fri, 28 Jun 2013 16:24:26 +0200
Message-id: <01ca01ce740b$32bcf670$9836e350$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 53f501a96b81cedb8449153fd2afd533eeac3172:

  Merge branch 'v4l_for_linus' into patchwork (2013-06-25 15:30:23 +0200)

are available in the git repository at:


  git://git.linuxtv.org/kdebski/media.git master

for you to fetch changes up to f4603fe949a1e4ec61f4900bffb4e1d2f11c27ac:

  coda: add CODA7541 decoding support (2013-06-28 16:18:14 +0200)

----------------------------------------------------------------
Alexander Shiyan (1):
      media: coda: Fix DT driver data pointer for i.MX27

John Sheu (1):
      s5p-mfc: Fix input/output format reporting

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

 drivers/media/platform/coda.c                | 1471
++++++++++++++++++++++----
 drivers/media/platform/coda.h                |  107 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |   79 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   46 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c       |   10 +-
 include/media/v4l2-mem2mem.h                 |   13 +
 6 files changed, 1459 insertions(+), 267 deletions(-)


