Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34513 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbcG0HhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2016 03:37:11 -0400
Received: by mail-lf0-f65.google.com with SMTP id l69so1583971lfg.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2016 00:37:10 -0700 (PDT)
Date: Wed, 27 Jul 2016 10:37:06 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: m.szyprowski@samsung.com, s.nawrocki@samsung.com,
	mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: media: vb2-dma-contig: fix sizeof(pointer) allocation
Message-ID: <20160727073706.GA15733@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/media/v4l2-core/videobuf2-dma-contig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -749,7 +749,7 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
 {
 	if (!dev->dma_parms) {
-		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
+		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
 		if (!dev->dma_parms)
 			return -ENOMEM;
 	}
