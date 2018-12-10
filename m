Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B5AC67839
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 19:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B0B32084C
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 19:25:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B0B32084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbeLJTZK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 14:25:10 -0500
Received: from verein.lst.de ([213.95.11.211]:50698 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbeLJTZK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 14:25:10 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id B9FD068DD2; Mon, 10 Dec 2018 20:25:08 +0100 (CET)
Date:   Mon, 10 Dec 2018 20:25:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 02/10] arm64/iommu: don't remap contiguous allocations
 for coherent devices
Message-ID: <20181210192508.GA31318@lst.de>
References: <20181208173702.15158-1-hch@lst.de> <20181208173702.15158-3-hch@lst.de> <eaf8ce49-ab5e-7c02-a028-74671172b684@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaf8ce49-ab5e-7c02-a028-74671172b684@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Dec 10, 2018 at 07:19:30PM +0000, Robin Murphy wrote:
> On 08/12/2018 17:36, Christoph Hellwig wrote:
>> There is no need to have an additional kernel mapping for a contiguous
>> allocation if the device already is DMA coherent, so skip it.
>
> FWIW, the "need" was that it kept the code in this path simple and the 
> mapping behaviour consistent with the regular iommu_dma_alloc() case. One 
> could quite easily retort that there is no need for the extra complexity of 
> this patch, since vmalloc is cheap on a 64-bit architecture ;)

Heh.  Well, without the remap we do less work, we prepare for a simple
implementation of DMA_ATTR_NON_CONSISTENT, and also prepapre the code
to be better reusable for architectures that don't do remapping of
DMA allocations at all.

>>   		if (addr) {
>>   			memset(addr, 0, size);
>> -			if (!coherent)
>> -				__dma_flush_area(page_to_virt(page), iosize);
>> +			__dma_flush_area(page_to_virt(page), iosize);
>
> Oh poo - seems I missed it at the time but the existing logic here is 
> wrong. Let me send a separate fix to flip those statements into the correct 
> order...

Yes, flushing the remapped alias only after zeroing it looks odd.
