Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38344 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab3GOKhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 06:37:13 -0400
Received: by mail-pb0-f44.google.com with SMTP id uo1so11079851pbc.31
        for <linux-media@vger.kernel.org>; Mon, 15 Jul 2013 03:37:12 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linaro-mm-sig@lists.linaro.org
Cc: linux-media@vger.kernel.org, sumit.semwal@linaro.org,
	rusty@rustcorp.com.au, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] dma-buf: Replace PTR_RET with PTR_ERR_OR_ZERO
Date: Mon, 15 Jul 2013 15:51:22 +0530
Message-Id: <1373883682-7723-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PTR_RET is now deprecated. Use PTR_ERR_OR_ZERO instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Compile tested and based on the following tree:
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git (PTR_RET)

Dependent on [1]
[1] http://lkml.indiana.edu/hypermail/linux/kernel/1306.2/00010.html
---
 drivers/base/dma-buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 6687ba7..1219ab7 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -680,7 +680,7 @@ int dma_buf_debugfs_create_file(const char *name,
 	d = debugfs_create_file(name, S_IRUGO, dma_buf_debugfs_dir,
 			write, &dma_buf_debug_fops);
 
-	return PTR_RET(d);
+	return PTR_ERR_OR_ZERO(d);
 }
 #else
 static inline int dma_buf_init_debugfs(void)
-- 
1.7.9.5

