Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20857 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab2GYMLr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 08:11:47 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7P001GQTWD0J40@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jul 2012 13:12:13 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M7P00LSUTVKY680@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jul 2012 13:11:45 +0100 (BST)
Message-id: <500FE280.9030403@samsung.com>
Date: Wed, 25 Jul 2012 14:11:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR 3.6] s5p-fimc, m5mols driver updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 931efdf58bd83af8d0578a6cc53421675daf6d41:

  Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-07-14 15:45:44 -0300)

are available in the git repository at:


  git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-next

for you to fetch changes up to 267a16d95d66aa1314e158359c9c5af95ed2f72f:

  m5mols: Correct reported ISO values (2012-07-24 17:12:07 +0200)

----------------------------------------------------------------
Sachin Kamat (1):
      s5p-fimc: Replace custom err() macro with v4l2_err() macro

Sylwester Nawrocki (3):
      s5p-fimc: Remove V4L2_FL_LOCK_ALL_FOPS flag
      s5p-fimc: Use switch statement for better readability
      m5mols: Correct reported ISO values

 drivers/media/video/m5mols/m5mols_controls.c |    4 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |   78 +++++++++++++++++---------
 drivers/media/video/s5p-fimc/fimc-core.h     |    3 -
 drivers/media/video/s5p-fimc/fimc-m2m.c      |   45 +++++++++++----
 drivers/media/video/s5p-fimc/fimc-reg.c      |   20 ++++---
 5 files changed, 100 insertions(+), 50 deletions(-)

---
Regards,
Sylwester
