Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28525 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbcEXPsm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 11:48:42 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O7O00A58UL14C00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 24 May 2016 16:48:37 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: 'Marek Szyprowski' <m.szyprowski@samsung.com>
Subject: [GIT PULL] mem2mem fixes
Date: Tue, 24 May 2016 17:48:36 +0200
Message-id: <004b01d1b5d3$bc9a49d0$35cedd70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit aff093d4bbca91f543e24cde2135f393b8130f4b:

  [media] exynos-gsc: avoid build warning without CONFIG_OF (2016-05-09
18:38:33 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git fixes-20160524

for you to fetch changes up to 8295280677afd409c32839e47b49de2f20ee459a:

  s5p-mfc: fix a typo in s5p_mfc_dec (2016-05-24 16:41:43 +0200)

----------------------------------------------------------------
Javier Martinez Canillas (4):
      s5p-mfc: Don't try to put pm->clock if lookup failed
      s5p-mfc: Set device name for reserved memory region devs
      s5p-mfc: Add release callback for memory region devs
      s5p-mfc: Fix race between s5p_mfc_probe() and s5p_mfc_open()

ayaka (4):
      s5p-mfc: don't close instance after free OUTPUT buffers
      s5p-mfc: Add handling of buffer freeing reqbufs request
      s5p-mfc: remove unnecessary check in try_fmt
      s5p-mfc: fix a typo in s5p_mfc_dec

 drivers/media/platform/s5p-mfc/s5p_mfc.c     | 50
++++++++++++++++++----------
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |  3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 ++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c  |  1 +
 4 files changed, 37 insertions(+), 29 deletions(-)

