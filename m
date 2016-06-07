Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10331 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbcFGPcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2016 11:32:03 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O8E00MX4R5AJG80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jun 2016 16:31:58 +0100 (BST)
Received: from AMDN2410 ([106.120.46.21])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTPA id <0O8E0011RR5A2Q80@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jun 2016 16:31:58 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem changes
Date: Tue, 07 Jun 2016 17:31:57 +0200
Message-id: <01c501d1c0d1$baca1a00$305e4e00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 9bd5d8696fd50a10d830e2ad7f9d4e67e0bbbae2:

  [media] s5p-mfc: don't close instance after free OUTPUT buffers
(2016-06-07 10:45:37 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git master-20160607

for you to fetch changes up to 8bc18e6d9b0b97ff32eab2563d94f9f758bc93d4:

  s5p-mfc: fix a typo in s5p_mfc_dec (2016-06-07 16:29:55 +0200)

----------------------------------------------------------------
ayaka (3):
      s5p-mfc: Add handling of buffer freeing reqbufs request
      s5p-mfc: remove unnecessary check in try_fmt
      s5p-mfc: fix a typo in s5p_mfc_dec

 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 +++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

