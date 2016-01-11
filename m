Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36436 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760144AbcAKRbs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 12:31:48 -0500
Received: by mail-pa0-f52.google.com with SMTP id yy13so231749660pab.3
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 09:31:47 -0800 (PST)
From: Douglas Anderson <dianders@chromium.org>
To: linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	robin.murphy@arm.com, tfiga@chromium.org, m.szyprowski@samsung.com
Cc: pawel@osciak.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hch@infradead.org, Douglas Anderson <dianders@chromium.org>,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 5/5] s5p-mfc: Set DMA_ATTR_ALLOC_SINGLE_PAGES
Date: Mon, 11 Jan 2016 09:30:27 -0800
Message-Id: <1452533428-12762-6-git-send-email-dianders@chromium.org>
In-Reply-To: <1452533428-12762-1-git-send-email-dianders@chromium.org>
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We do video allocation all the time and we need it to be fast.  Plus TLB
efficiency isn't terribly important for video.

That means we want to set DMA_ATTR_ALLOC_SINGLE_PAGES.

See also the previous change ("ARM: dma-mapping: Use
DMA_ATTR_ALLOC_SINGLE_PAGES hint to optimize allocation").

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
Changes in v6:
- renamed DMA_ATTR_NO_HUGE_PAGE to DMA_ATTR_ALLOC_SINGLE_PAGES

Changes in v5:
- s5p-mfc patch new for v5

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/media/platform/s5p-mfc/s5p_mfc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 927ab4928779..421d25a1aec1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1095,6 +1095,7 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 /* MFC probe function */
 static int s5p_mfc_probe(struct platform_device *pdev)
 {
+	DEFINE_DMA_ATTRS(attrs);
 	struct s5p_mfc_dev *dev;
 	struct video_device *vfd;
 	struct resource *res;
@@ -1164,12 +1165,20 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		}
 	}
 
-	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
+	/*
+	 * We'll do mostly sequential access, so sacrifice TLB efficiency for
+	 * faster allocation.
+	 */
+	dma_set_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, &attrs);
+
+	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx_attrs(dev->mem_dev_l,
+							  &attrs);
 	if (IS_ERR(dev->alloc_ctx[0])) {
 		ret = PTR_ERR(dev->alloc_ctx[0]);
 		goto err_res;
 	}
-	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
+	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx_attrs(dev->mem_dev_r,
+							  &attrs);
 	if (IS_ERR(dev->alloc_ctx[1])) {
 		ret = PTR_ERR(dev->alloc_ctx[1]);
 		goto err_mem_init_ctx_1;
-- 
2.6.0.rc2.230.g3dd15c0

