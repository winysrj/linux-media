Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86610C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630EF205C9
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m+Cf+HAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390027AbfAKSSD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 13:18:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47540 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfAKSRv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 13:17:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1OVXCR1mjUwq4tLpezy0do9F2yqLN8Ngt8OXoBccdbg=; b=m+Cf+HAs/tuj1zPW6T420dWrV
        zYwtxVEbSoxOaEKDccke0S3tb8J+kpAICy9SmATcqo7h1SW1GVqNtDKjWWwK8x5x6PkaiWnUQd8Xn
        LvvAsZRZsuhpS3kyT4062XKvYQGt71pvh10h7tDg9mvPjK8KVAm3FeHmMtvLuOuq1oEwwXCr7uLb3
        3eHjO1cD2hLZvPuLd4QsIfnhdzsoMRgtX9eQnE+oY+ngbjeLuR4sYRqUjmLyQYVz7zfIblxiiF8Uo
        FSRps+jVE+kD1DfQ83zUydf7+GivJljiZ8SKYFOo+VF8VbORuPRb8zaV1xjslnP/Y/pT9gMo/00Vh
        qF6/KVAaQ==;
Received: from 089144213167.atnat0022.highway.a1.net ([89.144.213.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gi1NB-0000vd-Dk; Fri, 11 Jan 2019 18:17:37 +0000
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
Subject: fix a layering violation in videobuf2 and improve dma_map_resource
Date:   Fri, 11 Jan 2019 19:17:28 +0100
Message-Id: <20190111181731.11782-1-hch@lst.de>
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
implementation to be practically useful.
