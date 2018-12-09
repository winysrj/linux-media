Return-Path: <SRS0=qcaw=OS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26376C65BAF
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 04:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBAAF2081F
	for <linux-media@archiver.kernel.org>; Sun,  9 Dec 2018 04:57:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBAAF2081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=davemloft.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbeLIE5f (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 23:57:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36078 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbeLIE5f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 23:57:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F18C141E13FF;
        Sat,  8 Dec 2018 20:57:34 -0800 (PST)
Date:   Sat, 08 Dec 2018 20:57:33 -0800 (PST)
Message-Id: <20181208.205733.639997534873546175.davem@davemloft.net>
To:     hch@lst.de
Cc:     iommu@lists.linux-foundation.org, robin.murphy@arm.com,
        vgupta@synopsys.com, matwey@sai.msu.ru,
        laurent.pinchart@ideasonboard.com,
        linux-snps-arc@lists.infradead.org, ezequiel@collabora.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 1/6] sparc: remove no needed sbus_dma_ops methods
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20181208174115.16237-2-hch@lst.de>
References: <20181208174115.16237-1-hch@lst.de>
        <20181208174115.16237-2-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 08 Dec 2018 20:57:34 -0800 (PST)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Sat,  8 Dec 2018 09:41:10 -0800

> No need to BUG_ON() on the cache maintainance ops - they are no-ops
> by default, and there is nothing in the DMA API contract that prohibits
> calling them on sbus devices (even if such drivers are unlikely to
> ever appear).
> 
> Similarly a dma_supported method that always returns 0 is rather
> pointless.  The only thing that indicates is that no one ever calls
> the method on sbus devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David S. Miller <davem@davemloft.net>
