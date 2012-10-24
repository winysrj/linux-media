Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:32659 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934754Ab2JXOQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 10:16:09 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCE00MS2IAL7LA0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Oct 2012 23:16:08 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCE00657IAB3MA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Oct 2012 23:16:08 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/4] s5p-mfc: Fix vidioc_subscribe_event declaration
Date: Wed, 24 Oct 2012 16:15:36 +0200
Message-id: <1351088137-11472-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1351088137-11472-1-git-send-email-k.debski@samsung.com>
References: <1351088137-11472-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2af6d52..4b01b02 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1542,7 +1542,7 @@ int vidioc_encoder_cmd(struct file *file, void *priv,
 }
 
 static int vidioc_subscribe_event(struct v4l2_fh *fh,
-					struct v4l2_event_subscription *sub)
+				const struct  v4l2_event_subscription *sub)
 {
 	switch (sub->type) {
 	case V4L2_EVENT_EOS:
-- 
1.7.9.5

