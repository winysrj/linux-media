Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27989 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKEKTc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 05:19:32 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEK00CZZA5BA640@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Nov 2014 10:22:23 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NEK007RVA0HTJ50@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Nov 2014 10:19:29 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem changes
Date: Wed, 05 Nov 2014 11:19:28 +0100
Message-id: <15f001cff8e1$fbf32620$f3d97260$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a8f29e89f2b54fbf2c52be341f149bc195b63a8b:

  [media] media/rc: Send sync space information on the lirc device
(2014-11-04 20:41:42 -0200)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-3.19-2

for you to fetch changes up to 9a130b69b89ea646bcd44d415e286eaf899bc573:

  s5p-mfc: fix sparse error (2014-11-05 11:09:25 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      s5p-mfc: fix sparse error

Rasmus Villemoes (1):
      s5p_mfc: Remove redundant casts

 drivers/media/platform/s5p-mfc/s5p_mfc.c     |    4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

