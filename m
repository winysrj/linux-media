Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62785 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbbJGLfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2015 07:35:37 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NVU006J4LJARN70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Oct 2015 12:35:34 +0100 (BST)
Received: from AMDN2410 ([106.120.46.21])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTPA id <0NVU00JSGLJAII80@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Oct 2015 12:35:34 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: "'open list:ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC)...'"
	<linux-media@vger.kernel.org>
Subject: [GIT PULL] mem2mem changes for 4.4
Date: Wed, 07 Oct 2015 13:35:34 +0200
Message-id: <010c01d100f4$47dea990$d79bfcb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit efe98010b80ec4516b2779e1b4e4a8ce16bf89fe:

  [media] DocBook: Fix remaining issues with VB2 core documentation
(2015-10-05 09:12:56 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-4.4

for you to fetch changes up to 86015d46839da68ac47c063410bdb5a085f750da:

  s5p-mfc: use MFC_BUF_FLAG_EOS to identify last buffers in decoder capture
queue (2015-10-07 13:14:38 +0200)

----------------------------------------------------------------
Andrzej Hajda (2):
      s5p-mfc: end-of-stream handling for newer encoders
      s5p-mfc: use MFC_BUF_FLAG_EOS to identify last buffers in decoder
capture queue

Ingi Kim (1):
      s5p-mfc: fix spelling errors

 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 26 ++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 21 +++++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 13 ++++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 49
+++++++++++++++++--------
 4 files changed, 66 insertions(+), 43 deletions(-)

