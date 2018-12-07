Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB12C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 17:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279122082D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 17:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V89YIUIX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 279122082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbeLGRMO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 12:12:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59814 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbeLGRMO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 12:12:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cveUhY21evAj175EbvLIvaHXmqv3QWYBYVfgJxSvrwM=; b=V89YIUIXoO+LmjEyY/Dz/wS1N
        H+CSHA89DnsXDIXYQt2ksXbQc2t3E1OCaQ85e8K8FzaXOp24BfiiRoepc2mb9096CNEbx/V4hNZov
        gMLRkf4dxxbin+x2tI5uE/Dgz8aGXb1nyknlhLkqXuRmS3rzc9xkNJ+V+aSrBJTpbecBvHpri/hIM
        iGAoscHggz+LLXzdpFkE0tdus0JegCSP6HZk1UPnTyQ6WRBIuqskwVeZdpwsgVKiXvJ1eZNgAtsMP
        Niu+/Epu5YQ1aovsQCSdvsSn223GFp5ARi6iZOxkT1K8i9Ui3tH2D4Ma4IJpRrNM+0KuVhKCH5PAO
        xa0DKCP2A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVJem-0000g7-K8; Fri, 07 Dec 2018 17:11:16 +0000
Date:   Fri, 7 Dec 2018 09:11:16 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Souptick Joarder <jrdr.linux@gmail.com>, akpm@linux-foundation.org,
        mhocko@suse.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz,
        riel@surriel.com, sfr@canb.auug.org.au, rppt@linux.vnet.ibm.com,
        peterz@infradead.org, linux@armlinux.org.uk,
        iamjoonsoo.kim@lge.com, treding@nvidia.com, keescook@chromium.org,
        m.szyprowski@samsung.com, stefanr@s5r6.in-berlin.de,
        hjc@rock-chips.com, heiko@sntech.de, airlied@linux.ie,
        oleksandr_andrushchenko@epam.com, joro@8bytes.org,
        pawel@osciak.com, kyungmin.park@samsung.com, mchehab@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, xen-devel@lists.xen.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/9] mm: Introduce new vm_insert_range API
Message-ID: <20181207171116.GA29923@bombadil.infradead.org>
References: <20181206183945.GA20932@jordon-HP-15-Notebook-PC>
 <53bbc095-c9f5-5d6a-6e50-6e060d17eb68@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53bbc095-c9f5-5d6a-6e50-6e060d17eb68@arm.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 07, 2018 at 03:34:56PM +0000, Robin Murphy wrote:
> > +int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
> > +			struct page **pages, unsigned long page_count)
> > +{
> > +	unsigned long uaddr = addr;
> > +	int ret = 0, i;
> 
> Some of the sites being replaced were effectively ensuring that vma and
> pages were mutually compatible as an initial condition - would it be worth
> adding something here for robustness, e.g.:
> 
> +	if (page_count != vma_pages(vma))
> +		return -ENXIO;

I think we want to allow this to be used to populate part of a VMA.
So perhaps:

	if (page_count > vma_pages(vma))
		return -ENXIO;

