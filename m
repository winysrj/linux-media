Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1347 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3CBXqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:46:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 18/20] solo6x10: use correct __GFP_DMA32 flags.
Date: Sun,  3 Mar 2013 00:45:34 +0100
Message-Id: <19e289c7ca253f648bb3c997343e1a4d0372556a.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/enc.c |    4 ++--
 drivers/staging/media/solo6x10/p2m.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/solo6x10/enc.c b/drivers/staging/media/solo6x10/enc.c
index de50259..667c20a6 100644
--- a/drivers/staging/media/solo6x10/enc.c
+++ b/drivers/staging/media/solo6x10/enc.c
@@ -99,7 +99,7 @@ static void solo_capture_config(struct solo_dev *solo_dev)
 	solo_reg_write(solo_dev, SOLO_VE_OSD_OPT, 0);
 
 	/* Clear OSG buffer */
-	buf = kzalloc(OSG_BUFFER_SIZE, GFP_KERNEL);
+	buf = kzalloc(OSG_BUFFER_SIZE, GFP_KERNEL | __GFP_DMA32);
 	if (!buf)
 		return;
 
@@ -130,7 +130,7 @@ int solo_osd_print(struct solo_enc_dev *solo_enc)
 		return 0;
 	}
 
-	buf = kzalloc(SOLO_EOSD_EXT_SIZE, GFP_KERNEL);
+	buf = kzalloc(SOLO_EOSD_EXT_SIZE, GFP_KERNEL | __GFP_DMA32);
 	if (!buf)
 		return -ENOMEM;
 
diff --git a/drivers/staging/media/solo6x10/p2m.c b/drivers/staging/media/solo6x10/p2m.c
index 58ab61b..65911fa 100644
--- a/drivers/staging/media/solo6x10/p2m.c
+++ b/drivers/staging/media/solo6x10/p2m.c
@@ -50,7 +50,7 @@ int solo_p2m_dma(struct solo_dev *solo_dev, u8 id, int wr,
 int solo_p2m_dma_t(struct solo_dev *solo_dev, u8 id, int wr,
 		   dma_addr_t dma_addr, u32 ext_addr, u32 size)
 {
-	struct p2m_desc *desc = kzalloc(sizeof(*desc) * 2, GFP_DMA);
+	struct p2m_desc *desc = kzalloc(sizeof(*desc) * 2, GFP_KERNEL | __GFP_DMA32);
 	int ret;
 
 	if (desc == NULL)
@@ -194,13 +194,13 @@ static unsigned long long p2m_test(struct solo_dev *solo_dev, u8 id,
 	int i;
 	unsigned long long err_cnt = 0;
 
-	wr_buf = kmalloc(size, GFP_KERNEL);
+	wr_buf = kmalloc(size, GFP_KERNEL | __GFP_DMA32);
 	if (!wr_buf) {
 		printk(SOLO6X10_NAME ": Failed to malloc for p2m_test\n");
 		return size;
 	}
 
-	rd_buf = kmalloc(size, GFP_KERNEL);
+	rd_buf = kmalloc(size, GFP_KERNEL | __GFP_DMA32);
 	if (!rd_buf) {
 		printk(SOLO6X10_NAME ": Failed to malloc for p2m_test\n");
 		kfree(wr_buf);
-- 
1.7.10.4

