Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:12201 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934647Ab2JYJHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 05:07:34 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCF001D9YO8PZV0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 18:07:33 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCF00DIBYMOU750@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Oct 2012 18:07:33 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	ch.naveen@samsung.com, arun.kk@samsung.com, joshi@samsung.com
Subject: [PATCH] Add MFC device tree support
Date: Thu, 25 Oct 2012 14:54:13 +0530
Message-id: <1351157054-19428-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree support for MFC driver.
The arch side patch for Exynos5250 adding MFC DT node
is applied to linux-samsung tree. [1]

[1]http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg12672.html

Arun Kumar K (1):
  s5p-mfc: Add device tree support

 drivers/media/platform/s5p-mfc/s5p_mfc.c |  100 +++++++++++++++++++++++++-----
 1 files changed, 84 insertions(+), 16 deletions(-)

