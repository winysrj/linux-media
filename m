Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:41360 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbeECAHG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2018 20:07:06 -0400
Received: by mail-pf0-f193.google.com with SMTP id v63so13146846pfk.8
        for <linux-media@vger.kernel.org>; Wed, 02 May 2018 17:07:06 -0700 (PDT)
From: Daniel Rosenberg <drosen@google.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>,
        Divya Ponnusamy <pdivya@codeaurora.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] drivers: dma-buf: Change %p to %pK in debug messages
Date: Wed,  2 May 2018 17:03:00 -0700
Message-Id: <20180503000300.90083-1-drosen@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The format specifier %p can leak kernel addresses
while not valuing the kptr_restrict system settings.
Use %pK instead of %p, which also evaluates whether
kptr_restrict is set.

Signed-off-by: Divya Ponnusamy <pdivya@codeaurora.org>
Signed-off-by: Daniel Rosenberg <drosen@google.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/dma-buf/sync_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/sync_debug.c b/drivers/dma-buf/sync_debug.c
index c4c8ecb24aa9..d8d340542a79 100644
--- a/drivers/dma-buf/sync_debug.c
+++ b/drivers/dma-buf/sync_debug.c
@@ -133,7 +133,7 @@ static void sync_print_sync_file(struct seq_file *s,
 	char buf[128];
 	int i;
 
-	seq_printf(s, "[%p] %s: %s\n", sync_file,
+	seq_printf(s, "[%pK] %s: %s\n", sync_file,
 		   sync_file_get_name(sync_file, buf, sizeof(buf)),
 		   sync_status_str(dma_fence_get_status(sync_file->fence)));
 
-- 
2.17.0.441.gb46fe60e1d-goog
