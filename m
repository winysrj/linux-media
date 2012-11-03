Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:21564 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab2KCLmN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2012 07:42:13 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCW005IJTUB33D0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 03 Nov 2012 20:42:11 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCW007MCTU3NJA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 03 Nov 2012 20:42:10 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, jtp.park@samsung.com,
	sw0312.kim@samsung.com, arun.kk@samsung.com, joshi@samsung.com
Subject: [PATCH v1] Add MFC device tree support
Date: Sat, 03 Nov 2012 17:32:00 +0530
Message-id: <1351944121-4756-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree support for MFC driver.
The arch side patch for Exynos5250 adding MFC DT node
is applied to linux-samsung tree. [1]

[1]http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg12672.html

Changelog:
v1:
- Added device_initialize to dma devices as suggested by Seung-Woo Kim.

Arun Kumar K (1):
  s5p-mfc: Add device tree support

 drivers/media/platform/s5p-mfc/s5p_mfc.c |  114 +++++++++++++++++++++++++-----
 1 files changed, 97 insertions(+), 17 deletions(-)

