Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECDFC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 08:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A943E2087C
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 08:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfC0IZL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 04:25:11 -0400
Received: from verein.lst.de ([213.95.11.211]:40515 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfC0IZL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 04:25:11 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 617CD68B05; Wed, 27 Mar 2019 09:25:01 +0100 (CET)
Date:   Wed, 27 Mar 2019 09:25:01 +0100
From:   " Christoph Hellwig <hch@lst.de>" <hch@lst.de>
To:     Hillf Danton <hdanton@sina.com>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        " Christoph Hellwig <hch@lst.de>" <hch@lst.de>,
        " Marek Szyprowski <m.szyprowski@samsung.com>" 
        <m.szyprowski@samsung.com>,
        " Will Deacon <will.deacon@arm.com>" <will.deacon@arm.com>,
        " Mauro Carvalho Chehab <mchehab@kernel.org>" <mchehab@kernel.org>
Subject: Re: [patch] media: videobuf-dma-sg: Clear dma coherent buf only
 once
Message-ID: <20190327082501.GM20525@lst.de>
References: <20190321103623.99BD968CEC@newverein.lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321103623.99BD968CEC@newverein.lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Mar 21, 2019 at 06:36:21PM +0800, Hillf Danton wrote:
> On both the arch and dma core sides, see commit 6829e274a623 and 518a2f1925c3
> respectively, efforts are paid for clearing memory returned from dma_alloc_*
> functions, so on the driver side we can get our duty offloaded by explicitly
> asking the dma core for a zero-ed buffer.

And why do you think you then need to pass __GFP_ZERO?
