Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39359 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753442AbeDBSYm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:42 -0400
Received: by mail-wm0-f68.google.com with SMTP id f125so29013074wme.4
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:42 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 12/20] [media] ddbridge: fix output buffer check
Date: Mon,  2 Apr 2018 20:24:19 +0200
Message-Id: <20180402182427.20918-13-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
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
