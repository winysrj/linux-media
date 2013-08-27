Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2234 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3H0Nar (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 09:30:47 -0400
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <sumit.semwal@linaro.org>
CC: <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>,
	Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH] dma-buf: Check return value of anon_inode_getfile
Date: Tue, 27 Aug 2013 16:30:38 +0300
Message-ID: <1377610238-2146-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

anon_inode_getfile might fail, so check its return value.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/base/dma-buf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 1219ab7..2d5ac1a 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -133,7 +133,10 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 	dmabuf->exp_name = exp_name;
 
 	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
-
+	if (IS_ERR(file)) {
+		kfree(dmabuf);
+		return ERR_CAST(file);
+	}
 	dmabuf->file = file;
 
 	mutex_init(&dmabuf->lock);
-- 
1.8.1.5

