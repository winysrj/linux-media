Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63853 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2GTP2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 11:28:21 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7G00ASQTN87QJ0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 21 Jul 2012 00:28:20 +0900 (KST)
Received: from localhost.localdomain ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M7G00JMBTMU3P30@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 21 Jul 2012 00:28:20 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/2] s5p-mfc: support for dmabuf exporting fix
Date: Fri, 20 Jul 2012 17:28:04 +0200
Message-id: <1342798084-2934-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1342798084-2934-1-git-send-email-k.debski@samsung.com>
References: <1342798084-2934-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added "select DMA_SHARED_BUFFER" to the Kconfig of the MFC.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 99937c9..33057e4 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1200,6 +1200,7 @@ config VIDEO_SAMSUNG_S5P_JPEG
 config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC 5.1 Video Codec"
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
+	select DMA_SHARED_BUFFER
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	help
-- 
1.7.0.4

