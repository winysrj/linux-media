Return-path: <mchehab@localhost>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36440 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1GFRNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 13:13:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNX008LB96YI9A0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 18:13:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNX00CKT96X5U@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 18:13:46 +0100 (BST)
Date: Wed, 06 Jul 2011 19:13:38 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/3] s5p-csis driver updates for 3.1
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1309972421-29690-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The following are a few updates for s5p-csis MIPI-CSI receiver driver.
I have originally missed the fact there are multiple voltages to be
supplied externally for the MIPI-CSI receiver and PHY and the driver
have to make sure they are all enabled at PMIC. The patch 1/3 fixes
it by adding a relevant regulator supply.
Patch 2/3 fixes issues with resume from suspend to memory. Finally
patch 3/3 enables a device node for s5p-mipi-csis subdev as 
it is more flexible to control the subdev from library/application
rather than doing this in the kernel.


Sylwester Nawrocki (3):
  s5p-csis: Handle all available power supplies
  s5p-csis: Rework of the system suspend/resume helpers
  s5p-csis: Enable v4l subdev device node

 drivers/media/video/s5p-fimc/mipi-csis.c |   88 +++++++++++++++++-------------
 1 files changed, 50 insertions(+), 38 deletions(-)


Regards,
-
Sylwester Nawrocki
Samsung Poland R&D Center

