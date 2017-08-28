Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38250 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbdH1QIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 12:08:55 -0400
Received: by mail-wm0-f66.google.com with SMTP id u26so1040645wma.5
        for <linux-media@vger.kernel.org>; Mon, 28 Aug 2017 09:08:55 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, hverkuil@xs4all.nl, jasmin@anw.at
Subject: [PATCH] [media_build] update v4.7_dma_attrs.patch
Date: Mon, 28 Aug 2017 18:08:51 +0200
Message-Id: <20170828160851.618-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes apply_patches wrt

  commit 5b6f9abe5a49 ("media: vb2: add bidirectional flag in vb2_queue")

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Jasmin Jessich <jasmin@anw.at>
---
Tested and verified by Jasmin on 3.13, 3.4 and 2.6.36, and by me on 4.4.

 backports/v4.7_dma_attrs.patch | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/backports/v4.7_dma_attrs.patch b/backports/v4.7_dma_attrs.patch
index 28d8dbc..40a7e5b 100644
--- a/backports/v4.7_dma_attrs.patch
+++ b/backports/v4.7_dma_attrs.patch
@@ -294,18 +294,18 @@ index 9a144f2..c5e3113 100644
   *		doesn't fill in the @alloc_devs array.
 - * @dma_attrs:	DMA attributes to use for the DMA.
 + * @dma_attrs:	DMA attributes to use for the DMA. May be NULL.
-  * @fileio_read_once:		report EOF after reading the first buffer
-  * @fileio_write_immediately:	queue buffer after each write() call
-  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
+  * @bidirectional: when this flag is set the DMA direction for the buffers of
+  *		this queue will be overridden with DMA_BIDIRECTIONAL direction.
+  *		This is useful in cases where the hardware (firmware) writes to
 @@ -494,7 +494,7 @@ struct vb2_queue {
  	unsigned int			type;
  	unsigned int			io_modes;
  	struct device			*dev;
 -	unsigned long			dma_attrs;
 +	const struct dma_attrs		*dma_attrs;
+ 	unsigned			bidirectional:1;
  	unsigned			fileio_read_once:1;
  	unsigned			fileio_write_immediately:1;
- 	unsigned			allow_zero_bytesused:1;
 diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
 index 5604818..df2aabe 100644
 --- a/include/media/videobuf2-dma-contig.h
-- 
2.13.5
