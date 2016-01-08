Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35832 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633AbcAHXF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2016 18:05:58 -0500
Received: by mail-pf0-f174.google.com with SMTP id 65so15829585pff.2
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2016 15:05:57 -0800 (PST)
From: Douglas Anderson <dianders@chromium.org>
To: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/5] [media] s5p-mfc: Set DMA_ATTR_NO_HUGE_PAGE
Date: Fri,  8 Jan 2016 15:05:32 -0800
Message-Id: <1452294332-23415-6-git-send-email-dianders@chromium.org>
In-Reply-To: <1452294332-23415-1-git-send-email-dianders@chromium.org>
References: <1452294332-23415-1-git-send-email-dianders@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We do video allocation all the time and we need it to be fast.  Plus TLB
efficiency isn't terribly important for video.

That means we want to set DMA_ATTR_NO_HUGE_PAGE.

See also the previous change ("ARM: dma-mapping: Use
DMA_ATTR_NO_HUGE_PAGE hint to optimize allocation").

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
Changes in v5:
- s5p-mfc patch new for v5

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/media/platform/s5p-mfc/s5p_mfc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 927ab4928779..7ea5d0d262bb 100644
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
+	dma_set_attr(DMA_ATTR_NO_HUGE_PAGE, &attrs);
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

