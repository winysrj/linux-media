Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61027 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUKyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 06:54:55 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5X006FQ7N5WT70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 May 2014 11:54:41 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0N5X00AQ37NGX450@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 May 2014 11:54:53 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 3.16] MFC firmware related patches
Date: Wed, 21 May 2014 12:54:53 +0200
Message-id: <06c701cf74e3$18d404e0$4a7c0ea0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a48bcde914d311835ead01d81d25d304a913b718:

  s5p-mfc: Core support for v8 encoder (2014-05-20 15:19:41 +0200)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-3.16-4

for you to fetch changes up to 5ed826e62cd2c96f011075d5757f0040659afda8:

  s5p-mfc: Add init buffer cmd to MFCV6 (2014-05-21 12:25:57 +0200)

----------------------------------------------------------------
Arun Kumar K (3):
      s5p-mfc: Remove duplicate function s5p_mfc_reload_firmware
      s5p-mfc: Support multiple firmware sub-versions
      s5p-mfc: Add init buffer cmd to MFCV6

 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   15 +++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   11 +++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   44
++++++-----------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    6 ++--
 4 files changed, 34 insertions(+), 42 deletions(-)

