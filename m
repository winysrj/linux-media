Return-Path: <SRS0=dU+R=OY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73760C43612
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 10:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45A4F206C2
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 10:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbeLOKrX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 05:47:23 -0500
Received: from verein.lst.de ([213.95.11.211]:52658 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbeLOKrX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 05:47:23 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 18A9268D7F; Sat, 15 Dec 2018 11:47:21 +0100 (CET)
Date:   Sat, 15 Dec 2018 11:47:20 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 3/6] sparc: remove the sparc32_dma_ops indirection
Message-ID: <20181215104720.GA1575@lst.de>
References: <20181208174115.16237-1-hch@lst.de> <20181208174115.16237-4-hch@lst.de> <20181215063018.GA11415@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181215063018.GA11415@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 14, 2018 at 10:30:18PM -0800, Guenter Roeck wrote:
> and so on, until qemu is terminated. This is seen with all sparc32
> qemu emulations. Reverting the patch fixes the problem.

Hi Guenter,

can you check which of the three new ops is used in this case?  Or
provide the qemu config and rootfs?
