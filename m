Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51004 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbdEHJLp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 05:11:45 -0400
Subject: [PATCH 1/4] dma-buf: Combine two function calls into one in
 dma_buf_debug_show()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, Gustavo Padovan <gustavo@padovan.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
Message-ID: <b8a85220-039a-e4bb-c74b-d76baab234e8@users.sourceforge.net>
Date: Mon, 8 May 2017 11:11:37 +0200
MIME-Version: 1.0
In-Reply-To: <3d972fa2-787a-d1f2-ff86-5c05494e00d3@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 8 May 2017 10:32:44 +0200

A bit of data was put into a sequence by two separate function calls.
Print the same data by a single function call instead.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/dma-buf/dma-buf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 512bdbc23bbb..53257c166f4d 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1122,9 +1122,7 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 		attach_count = 0;
 
 		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
-			seq_puts(s, "\t");
-
-			seq_printf(s, "%s\n", dev_name(attach_obj->dev));
+			seq_printf(s, "\t%s\n", dev_name(attach_obj->dev));
 			attach_count++;
 		}
 
-- 
2.12.2
