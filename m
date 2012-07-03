Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56778 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab2GCPNo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 11:13:44 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6L008OMBMLYY10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Jul 2012 00:13:42 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6L00LKCBMMDF90@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Jul 2012 00:13:42 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] m5mols: Correct reported ISO values
Date: Tue, 03 Jul 2012 17:13:31 +0200
Message-id: <1341328411-24958-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_ISO_SENSITIVITY control values should be standard
ISO values multiplied by 1000. Multiply all menu items by 1000
so ISO is properly reported as 50...3200 range.

Cc: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_controls.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 54f597a..17dc280 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -547,9 +547,8 @@ static const struct v4l2_ctrl_ops m5mols_ctrl_ops = {

 /* Supported manual ISO values */
 static const s64 iso_qmenu[] = {
-	/* AE_ISO: 0x01...0x07 */
-	50, 100, 200, 400, 800, 1600, 3200
+	/* AE_ISO: 0x01...0x07 (ISO: 50...3200) */
+	50000, 100000, 200000, 400000, 800000, 1600000, 3200000
 };

 /* Supported Exposure Bias values, -2.0EV...+2.0EV */
--
1.7.10

