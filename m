Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:54506 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbcGRR7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 13:59:30 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	=?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH next] [media] vb2: Fix allocation size of dma_parms
Date: Mon, 18 Jul 2016 19:54:04 +0200
Message-Id: <1468864444-19053-1-git-send-email-vincent.stehle@laposte.net>
In-Reply-To: <1464074167-27330-2-git-send-email-m.szyprowski@samsung.com>
References: <1464074167-27330-2-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When allocating memory to hold the device dma parameters in
vb2_dma_contig_set_max_seg_size(), the requested size is by mistake only
the size of a pointer. Request the correct size instead.

Fixes: 3f0339691896 ("media: vb2-dma-contig: add helper for setting dma max seg size")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---


Hi,

I saw that in linux next-20160718.

Best regards,

Vincent.


 drivers/media/v4l2-core/videobuf2-dma-contig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index b09b2c9..59fa204 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -743,7 +743,7 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
 int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
 {
 	if (!dev->dma_parms) {
-		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
+		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
 		if (!dev->dma_parms)
 			return -ENOMEM;
 	}
-- 
2.8.1

