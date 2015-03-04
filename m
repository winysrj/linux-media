Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45530 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbbCDNzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 08:55:37 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKO004DQXJH1GA0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Mar 2015 13:59:41 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/2] media: s5p-mfc: fix mmap support for 64bit arch
Date: Wed, 04 Mar 2015 14:55:21 +0100
Message-id: <1425477322-5162-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1425477322-5162-1-git-send-email-m.szyprowski@samsung.com>
References: <1425477322-5162-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TASK_SIZE is depends on the systems architecture (32 or 64 bits) and it
should not be used for defining offset boundary for mmaping buffers for
CAPTURE and OUTPUT queues. This patch fixes support for MMAP calls on
the CAPTURE queue on 64bit architectures (like ARM64).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 15f7663..24262bb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -29,7 +29,7 @@
 
 /* Offset base used to differentiate between CAPTURE and OUTPUT
 *  while mmaping */
-#define DST_QUEUE_OFF_BASE      (TASK_SIZE / 2)
+#define DST_QUEUE_OFF_BASE	(1 << 30)
 
 #define MFC_BANK1_ALLOC_CTX	0
 #define MFC_BANK2_ALLOC_CTX	1
-- 
1.9.2

