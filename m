Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17817 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbbCEKuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 05:50:10 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKQ0001CJMCH330@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Mar 2015 10:54:12 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NKQ00HQSJFKCD10@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Mar 2015 10:50:08 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] s5p-mfc fixes
Date: Thu, 05 Mar 2015 11:50:07 +0100
Message-id: <082701d05732$25b47870$711d6950$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following fixes for the MFC driver.

The following changes since commit 41f03a00536ebb3d72c051f9e7efe2d4ab76ebc8:

  [media] s5p-mfc: Fix NULL pointer dereference caused by not set q->lock
(2015-03-04 08:59:58 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git v4.0-fixes

for you to fetch changes up to af702f22d9879856ea936ac41a7baea0706fa56a:

  media: s5p-mfc: fix broken pointer cast on 64bit arch (2015-03-05 11:02:52
+0100)

----------------------------------------------------------------
Marek Szyprowski (2):
      media: s5p-mfc: fix mmap support for 64bit arch
      media: s5p-mfc: fix broken pointer cast on 64bit arch

 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    6 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

Best wishes,
Kamil Debski

