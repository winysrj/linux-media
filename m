Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D897C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58E142177E
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550584836;
	bh=uPkYbUQ/h3TVe+N0xaZAuKA5fM/CECnWNMl1th1F/S8=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=Hn9Docok6x5n5pslS/aAjOp1lDXSX1rTDzxVb/X25hbx2c5OKs084WMpcrNvIm+cW
	 TpcBMeNdlxwGrdBoNT2BWjusNEUHxiN5kM8k6d9yVlHD/fCchUNdvCm7sr0WqhUyji
	 e1706f+rrEjxUlIKcM/22DGu/j+sUd2YR3OI5cn4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfBSOAf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:00:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44696 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbfBSOAf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 09:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xv1FtqEtFrd+YgCl0FGr2jk/tp3yOCMzWez/ZJKJcXM=; b=Kl75s3uEVlI5Z/dHXrfsVTq2Ov
        Ov8HQjMS1QiFmB2+c/3IgQma3iDt6DNfNacp9r32rq9sKoapIqaueGVl+lM1Kvjrv/dcY94YqvNlX
        FOUf3otipMrKU1ahInQKpo8GG6fJ8wTLgv1STLoCHz6Xd4e4t7LEtZ8psOp3pNe0onmMlxecTjF9V
        tr1z4R7H7Ys5p1OOqF6864n+De4vUkcdBYGhmGjMRPbL3mh4fixteitIphHzbriqi4HnfQJ7y1w5M
        obJMmm3U+GLdg2C13Wk+x+yGAC+IL41FcVBNNQl+GJsYEIqHNKicBOP7IYe+CS5Bvn9dkiZwyh8Wg
        kyNH7eOQ==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gw5wo-0004zJ-U4; Tue, 19 Feb 2019 14:00:34 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gw5wl-000AbF-Jz; Tue, 19 Feb 2019 09:00:31 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/2] ipu3-mmu: fix some kernel-doc macros
Date:   Tue, 19 Feb 2019 09:00:30 -0500
Message-Id: <e5e51aa53cf377df643845c88170a75f92f230d9.1550584828.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0bdfc56c13c0ffe003f28395fcde2cd9b5ea0622.1550584828.git.mchehab+samsung@kernel.org>
References: <0bdfc56c13c0ffe003f28395fcde2cd9b5ea0622.1550584828.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some kernel-doc markups are wrong. fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/ipu3/ipu3-mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-mmu.c b/drivers/staging/media/ipu3/ipu3-mmu.c
index cd2038b22b55..cfc2bdfb14b3 100644
--- a/drivers/staging/media/ipu3/ipu3-mmu.c
+++ b/drivers/staging/media/ipu3/ipu3-mmu.c
@@ -238,7 +238,7 @@ static int __imgu_mmu_map(struct imgu_mmu *mmu, unsigned long iova,
 	return 0;
 }
 
-/**
+/*
  * The following four functions are implemented based on iommu.c
  * drivers/iommu/iommu.c/iommu_pgsize().
  */
@@ -444,6 +444,7 @@ size_t imgu_mmu_unmap(struct imgu_mmu_info *info, unsigned long iova,
 
 /**
  * imgu_mmu_init() - initialize IPU3 MMU block
+ * @parent:	struct device parent
  * @base:	IOMEM base of hardware registers.
  *
  * Return: Pointer to IPU3 MMU private data pointer or ERR_PTR() on error.
@@ -522,7 +523,7 @@ struct imgu_mmu_info *imgu_mmu_init(struct device *parent, void __iomem *base)
 
 /**
  * imgu_mmu_exit() - clean up IPU3 MMU block
- * @mmu: IPU3 MMU private data
+ * @info: IPU3 MMU private data
  */
 void imgu_mmu_exit(struct imgu_mmu_info *info)
 {
-- 
2.20.1

