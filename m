Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:56859 "EHLO
        resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752348AbcKGXjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Nov 2016 18:39:32 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: s5p-mfc include buffer size in error message
Date: Mon,  7 Nov 2016 16:39:25 -0700
Message-Id: <20161107233925.25070-1-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include buffer size in s5p_mfc_alloc_priv_buf() the error message when it
fails to allocate the buffer.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
Changes since v1:
 - Left debug message as is. v1 removed the debug message.

 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 1e72502..da4f52a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -45,7 +45,8 @@ int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
 	b->virt = dma_alloc_coherent(dev, b->size, &b->dma, GFP_KERNEL);
 
 	if (!b->virt) {
-		mfc_err("Allocating private buffer failed\n");
+		mfc_err("Allocating private buffer of size %zu failed\n",
+			b->size);
 		return -ENOMEM;
 	}
 
-- 
2.7.4

