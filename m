Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40726 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753391AbeDIQsG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:06 -0400
Received: by mail-wr0-f193.google.com with SMTP id n2so10254286wrj.7
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:06 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 11/19] [media] ddbridge: fix output buffer check
Date: Mon,  9 Apr 2018 18:47:44 +0200
Message-Id: <20180409164752.641-12-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

A 188 byte gap has to be left between the writer and the consumer. This
requires 2*188 bytes available to be able to write to the output buffers.
So, change ddb_output_free() to report free bytes according to this rule.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index c22537eceee5..e9c2e3e5d64b 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -587,12 +587,12 @@ static u32 ddb_output_free(struct ddb_output *output)
 
 	if (output->dma->cbuf != idx) {
 		if ((((output->dma->cbuf + 1) % output->dma->num) == idx) &&
-		    (output->dma->size - output->dma->coff <= 188))
+		    (output->dma->size - output->dma->coff <= (2 * 188)))
 			return 0;
 		return 188;
 	}
 	diff = off - output->dma->coff;
-	if (diff <= 0 || diff > 188)
+	if (diff <= 0 || diff > (2 * 188))
 		return 188;
 	return 0;
 }
-- 
2.16.1
