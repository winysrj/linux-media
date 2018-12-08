Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E25C64EB1
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D05F52082D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UikEWRKH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D05F52082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbeLHRl0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:41:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbeLHRl0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hObTaIo8xpMKKtq041DL44o7+z+KRG1ghKvacyvzds8=; b=UikEWRKHfvZGceJA/17i1Vx660
        DlmNKNOnIGr+og5N5YRRfLdgc16M6FCxPllQHYcScEoIW2s8LWcbdzurfbOZV1LxN7w+n+GPuu7gS
        65yW3HEKNacBZb9to0/i4XkEiD0t9hnmH6M1xVLuIXWon/JqeSpQ89qzhXsOeb8P6TT3UIUnzuGjO
        t5yF/7bGy7B05i16lWyyycA2kZaxH9On44C+3HKJehXrO9HhDQSgGUMgWZEfcIGa1mTldS731kZBK
        UuZC7MDOd3BYMQNqDMe+IC4MAIda+P4cGTVj+e+PBka11UFR4fr5c8IFgBGGzIwLep4lG5yz7xWhk
        KLUbHYZw==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgbM-0000Yl-Rl; Sat, 08 Dec 2018 17:41:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     iommu@lists.linux-foundation.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH 1/6] sparc: remove no needed sbus_dma_ops methods
Date:   Sat,  8 Dec 2018 09:41:10 -0800
Message-Id: <20181208174115.16237-2-hch@lst.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181208174115.16237-1-hch@lst.de>
References: <20181208174115.16237-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

No need to BUG_ON() on the cache maintainance ops - they are no-ops
by default, and there is nothing in the DMA API contract that prohibits
calling them on sbus devices (even if such drivers are unlikely to
ever appear).

Similarly a dma_supported method that always returns 0 is rather
pointless.  The only thing that indicates is that no one ever calls
the method on sbus devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/sparc/kernel/ioport.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 6799c93c9f27..4b2167a0ec0b 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -391,23 +391,6 @@ static void sbus_unmap_sg(struct device *dev, struct scatterlist *sg, int n,
 	mmu_release_scsi_sgl(dev, sg, n);
 }
 
-static void sbus_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-				 int n,	enum dma_data_direction dir)
-{
-	BUG();
-}
-
-static void sbus_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-				    int n, enum dma_data_direction dir)
-{
-	BUG();
-}
-
-static int sbus_dma_supported(struct device *dev, u64 mask)
-{
-	return 0;
-}
-
 static const struct dma_map_ops sbus_dma_ops = {
 	.alloc			= sbus_alloc_coherent,
 	.free			= sbus_free_coherent,
@@ -415,9 +398,6 @@ static const struct dma_map_ops sbus_dma_ops = {
 	.unmap_page		= sbus_unmap_page,
 	.map_sg			= sbus_map_sg,
 	.unmap_sg		= sbus_unmap_sg,
-	.sync_sg_for_cpu	= sbus_sync_sg_for_cpu,
-	.sync_sg_for_device	= sbus_sync_sg_for_device,
-	.dma_supported		= sbus_dma_supported,
 };
 
 static int __init sparc_register_ioport(void)
-- 
2.19.2

