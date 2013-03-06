Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41104 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3CFM40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 07:56:26 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MJ80028EP9PJHW0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Mar 2013 21:56:24 +0900 (KST)
Received: from chrome-ubuntu.sisodomain.com ([107.108.73.106])
 by mmp1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MJ800A8OP8EHQ90@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Mar 2013 21:56:24 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH] [media] s5p-mfc: Fix encoder control 15 issue
Date: Wed, 06 Mar 2013 08:15:57 -0500
Message-id: <1362575757-22839-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mfc-encoder is not working in the latest kernel giving the
erorr "Adding control (15) failed". Adding the missing step
parameter in this control to fix the issue.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2356fd5..4f6b553 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -232,6 +232,7 @@ static struct mfc_control controls[] = {
 		.minimum = 0,
 		.maximum = 1,
 		.default_value = 0,
+		.step = 1,
 		.menu_skip_mask = 0,
 	},
 	{
-- 
1.7.9.5

