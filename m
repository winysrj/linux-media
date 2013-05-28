Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9659 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009Ab3E1H04 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 03:26:56 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNH00BKWZCGH570@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 May 2013 08:26:54 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
Cc: Jeongtae Park <jtp.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/3] s5p-mfc: separate encoder parameters for h264 and mpeg4
Date: Tue, 28 May 2013 09:26:14 +0200
Message-id: <1369725976-7828-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
References: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes a bug which caused overwriting h264 codec
parameters by mpeg4 parameters during V4L2 control setting.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 202d1d7..098459e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -438,7 +438,7 @@ struct s5p_mfc_enc_params {
 	u32 rc_framerate_num;
 	u32 rc_framerate_denom;
 
-	union {
+	struct {
 		struct s5p_mfc_h264_enc_params h264;
 		struct s5p_mfc_mpeg4_enc_params mpeg4;
 	} codec;
-- 
1.8.1.2

