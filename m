Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:8222 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2HPLyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 07:54:23 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00ANNJQM4OE0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 20:54:22 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8U0072VJOLM8B0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 20:54:22 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, ch.naveen@samsung.com,
	arun.kk@samsung.com, kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH] Add MFC device tree support
Date: Thu, 16 Aug 2012 18:32:30 +0530
Message-id: <1345122151-15514-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch adds device tree support for the MFC driver. 
The ARCH side patch for the device tree support for Exynos4 and 5
SoCs are posted in linux-samsung mailing list [1].
This patch has to be applied over the patchset for MFC v6 support [2].

[1] http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg11872.html
[2] http://www.mail-archive.com/linux-media@vger.kernel.org/msg50204.html

Arun Kumar K (1):
  [media] s5p-mfc: Add device tree support

 drivers/media/video/s5p-mfc/s5p_mfc.c |  106 ++++++++++++++++++++++++++++-----
 1 files changed, 90 insertions(+), 16 deletions(-)

