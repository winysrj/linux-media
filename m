Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33911 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbcFSMb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2016 08:31:56 -0400
Received: by mail-wm0-f65.google.com with SMTP id 187so7875208wmz.1
        for <linux-media@vger.kernel.org>; Sun, 19 Jun 2016 05:31:55 -0700 (PDT)
From: Mathias Krause <minipli@googlemail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Mathias Krause <minipli@googlemail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 2/3] dma-buf: remove dma_buf directory on bufinfo file creation errors
Date: Sun, 19 Jun 2016 14:31:30 +0200
Message-Id: <1466339491-12639-3-git-send-email-minipli@googlemail.com>
In-Reply-To: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
References: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the error handling in dma_buf_init_debugfs() to remove the
"dma_buf" directory if creating the "bufinfo" file fails. No need to
have an empty debugfs directory around.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/dma-buf/dma-buf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 7094b19bb495..f03e51561199 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -907,8 +907,11 @@ static int dma_buf_init_debugfs(void)
 
 	err = dma_buf_debugfs_create_file("bufinfo", NULL);
 
-	if (err)
+	if (err) {
 		pr_debug("dma_buf: debugfs: failed to create node bufinfo\n");
+		debugfs_remove_recursive(dma_buf_debugfs_dir);
+		dma_buf_debugfs_dir = NULL;
+	}
 
 	return err;
 }
-- 
1.7.10.4

