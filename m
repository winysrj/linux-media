Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990DCC43444
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 11:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EC4B20652
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 11:38:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NM1ZpJGN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfARLhu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 06:37:50 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56800 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfARLhs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 06:37:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OX54bckM/rwEp4H5la6/F38I3bmsjj9BqreNm9vFgKU=; b=NM1ZpJGN9GIEtFPLireLSQM58
        lhPpr/NkFXHPqraZrNpHSvJLMGN3QcWxFpLzHsPoDAuzLVJzJ993PUCF4EPUvJzk4fNQhaBsXonLv
        6Iwd3IME6U01AO10NdOLMhmeTXKyZlI4J427ly8wY3KJouQfjgzRMfwPXxDRaqBfGpxAIJTfjey0e
        WJO8y+debPaWL6RXafOmM5uyii4G8RQxAp4OuF7sjymQWJB5cRHnTP+qQe4x8YakfdKL4pBaAtKL5
        yKcK6uOyCZ4zj+oFyYGnSwLugNEvfkLXjr4e7r537Y3r2CCn6weEt47SUv084M1Dr1TKFS20smn/O
        gG/XOrKmQ==;
Received: from 089144210168.atnat0019.highway.a1.net ([89.144.210.168] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gkSSo-0005OJ-Oj; Fri, 18 Jan 2019 11:37:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: fix a layering violation in videobuf2 and improve dma_map_resource v2
Date:   Fri, 18 Jan 2019 12:37:24 +0100
Message-Id: <20190118113727.3270-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi all,

this series fixes a rather gross layering violation in videobuf2, which
pokes into arm DMA mapping internals to get a DMA address for memory that
does not have a page structure, and to do so fixes up the dma_map_resource
implementation to not provide a somewhat dangerous default and improve
the error handling.

Changes since v1:
 - don't apply bus offsets in dma_direct_map_resource
