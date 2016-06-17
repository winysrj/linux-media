Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34068 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbcFQS5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 14:57:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so79152wmz.1
        for <linux-media@vger.kernel.org>; Fri, 17 Jun 2016 11:57:14 -0700 (PDT)
From: Mathias Krause <minipli@googlemail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Mathias Krause <minipli@googlemail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	PaX Team <pageexec@freemail.hu>
Subject: [PATCH] dma-buf: propagate errors from dma_buf_describe() on debugfs read
Date: Fri, 17 Jun 2016 20:57:03 +0200
Message-Id: <1466189823-21489-1-git-send-email-minipli@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The callback function dma_buf_describe() returns an int not void so the
function pointer cast in dma_buf_show() is wrong. dma_buf_describe() can
also fail when acquiring the mutex gets interrupted so always returning
0 in dma_buf_show() is wrong, too.

Fix both issues by casting the function pointer to the correct type and
propagate its return value.

This type mismatch was caught by the PaX RAP plugin.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: PaX Team <pageexec@freemail.hu>
---
 drivers/dma-buf/dma-buf.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 6355ab38d630..0f2a4592fdd2 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -881,10 +881,9 @@ static int dma_buf_describe(struct seq_file *s)
 
 static int dma_buf_show(struct seq_file *s, void *unused)
 {
-	void (*func)(struct seq_file *) = s->private;
+	int (*func)(struct seq_file *) = s->private;
 
-	func(s);
-	return 0;
+	return func(s);
 }
 
 static int dma_buf_debug_open(struct inode *inode, struct file *file)
-- 
1.7.10.4

