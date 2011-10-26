Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:44000 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab1JZKgo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 06:36:44 -0400
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LTO005LD5H6NHH0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Oct 2011 19:36:43 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LTO00BMD5H63A00@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Oct 2011 19:36:42 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com,
	"HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [GIT PULL FOR v3.2] m5mols misc fixes about booting time
Date: Wed, 26 Oct 2011 19:36:42 +0900
Message-id: <1319625402-1299-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

the following changes since commit 35a912455ff5640dc410e91279b03e04045265b2:

  merge branch 'v4l_for_linus' into staging/for_v3.2 (2011-10-19 12:41:18 -0200)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-2.6-samsung m5mols

heungjun, kim (5):
      m5mols: add more functions to check busy status
      m5mols: replace irq workqueue to waitqueue only
      m5mols: support for interrupt in the sensor's booting time
      m5mols: add boot flag for not showing the msg of i2c error
      m5mols: relocation the order and count for capture interrupt

 drivers/media/video/m5mols/m5mols.h         |   10 +-
 drivers/media/video/m5mols/m5mols_capture.c |   71 +++----------
 drivers/media/video/m5mols/m5mols_core.c    |  140 ++++++++++++++++-----------
 drivers/media/video/m5mols/m5mols_reg.h     |    3 +-
 4 files changed, 109 insertions(+), 115 deletions(-)
--
Regards,
HeungJun Kim
--
