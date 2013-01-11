Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:63833 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3AKP3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 10:29:45 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGG00FQ1WDKYM40@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jan 2013 00:29:44 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGG00G15WDC1520@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jan 2013 00:29:44 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	a.hajda@samsung.com, Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/3] s5p-mfc: Fix a watchdog bug
Date: Fri, 11 Jan 2013 16:29:32 +0100
Message-id: <1357918174-4651-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed wrong condition in firmware reload function used by the watchdog.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 1682271..2e5f30b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -130,7 +130,7 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
 		release_firmware(fw_blob);
 		return -ENOMEM;
 	}
-	if (dev->fw_virt_addr) {
+	if (!dev->fw_virt_addr) {
 		mfc_err("MFC firmware is not allocated\n");
 		release_firmware(fw_blob);
 		return -EINVAL;
-- 
1.7.9.5

