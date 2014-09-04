Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3702 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaIDQ1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 12:27:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] tw68: drop bogus cpu_to_le32() call
Date: Thu,  4 Sep 2014 18:26:53 +0200
Message-Id: <1409848013-21867-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1409848013-21867-1-git-send-email-hverkuil@xs4all.nl>
References: <1409848013-21867-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

tw_writel maps to writel which maps to __raw_writel(__cpu_to_le32(b),addr).
So tw_writel already calls cpu_to_le32 and it shouldn't be called again
in the code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/tw68/tw68-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 498ead9..5c94ac7 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -348,7 +348,7 @@ int tw68_video_start_dma(struct tw68_dev *dev, struct tw68_buf *buf)
 	 *  a new address can be set.
 	 */
 	tw_clearl(TW68_DMAC, TW68_DMAP_EN);
-	tw_writel(TW68_DMAP_SA, cpu_to_le32(buf->dma));
+	tw_writel(TW68_DMAP_SA, buf->dma);
 	/* Clear any pending interrupts */
 	tw_writel(TW68_INTSTAT, dev->board_virqmask);
 	/* Enable the risc engine and the fifo */
-- 
2.1.0

