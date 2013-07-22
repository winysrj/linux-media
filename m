Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64217 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3GVNop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 09:44:45 -0400
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
Subject: [GIT PULL] Fixes for 3.11
Date: Mon, 22 Jul 2013 15:44:21 +0200
Message-id: <07e801ce86e1$9394f720$babee560$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit cab602f1930b2c3fb023ff82d371a915f2168457:

  Linux 3.11-rc2 (2013-07-22 14:32:12 +0200)

are available in the git repository at:

  git://git.linuxtv.org/kdebski/media.git fixes-for-3.11

for you to fetch changes up to 55f8d96dc132fef5b2c3f3d9b4d891d673e8ce33:

  s5p-g2d: Fix registration failure (2013-07-22 14:32:14 +0200)

----------------------------------------------------------------
Alexander Shiyan (1):
      media: coda: Fix DT driver data pointer for i.MX27

John Sheu (1):
      s5p-mfc: Fix input/output format reporting

Sachin Kamat (1):
      s5p-g2d: Fix registration failure

 drivers/media/platform/coda.c                |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c         |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |   79
++++++++++----------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   46 ++++++---------
 4 files changed, 50 insertions(+), 78 deletions(-)


