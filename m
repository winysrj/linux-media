Return-path: <linux-media-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:60276 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab3FAJxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jun 2013 05:53:15 -0400
Message-ID: <1370080390.29224.25.camel@localhost.localdomain>
Subject: [PATCH] dma-buf: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: sumit.semwal@linaro.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:53:10 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -680,10 +680,7 @@ int dma_buf_debugfs_create_file(const ch
 	d = debugfs_create_file(name, S_IRUGO, dma_buf_debugfs_dir,
 			write, &dma_buf_debug_fops);
 
-	if (IS_ERR(d))
-		return PTR_ERR(d);
-
-	return 0;
+	return PTR_RET(d);
 }
 #else
 static inline int dma_buf_init_debugfs(void)


