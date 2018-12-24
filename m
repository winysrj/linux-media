Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458EBC64E79
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 15:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08F732184A
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 15:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="TATbDOi3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbeLXPWV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 10:22:21 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53106 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbeLXPWV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 10:22:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MnCBPLk/TWveJ/PPLBS7RWz+axnrCYxLUyWpWEjxPy4=; b=TATbDOi3szvOxUTavPt0X/r70
        vsZj5TZTSx89zhAQEl7pS0fasAu9W4Uive0aLhYKym8rlMr0h3b5qwCBM6UIqLJdkpMS98GpUMDFU
        bc0TulCo/Wa0vECNHHWmPTUklO2uv6AO21/tGIxV+oMKw13XOlxLGMTtHjIrkIyQj253g=;
Received: from n2100.armlinux.org.uk ([2001:4d48:ad52:3201:214:fdff:fe10:4f86]:44267)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1gbS2Y-0007zj-3i; Mon, 24 Dec 2018 15:21:10 +0000
Received: from linux by n2100.armlinux.org.uk with local (Exim 4.90_1)
        (envelope-from <linux@n2100.armlinux.org.uk>)
        id 1gbS2Q-00077T-Hm; Mon, 24 Dec 2018 15:21:02 +0000
Date:   Mon, 24 Dec 2018 15:20:59 +0000
From:   Russell King - ARM Linux <linux@armlinux.org.uk>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     akpm@linux-foundation.org, willy@infradead.org, mhocko@suse.com,
        kirill.shutemov@linux.intel.com, vbabka@suse.cz, riel@surriel.com,
        sfr@canb.auug.org.au, rppt@linux.vnet.ibm.com,
        peterz@infradead.org, robin.murphy@arm.com, iamjoonsoo.kim@lge.com,
        treding@nvidia.com, keescook@chromium.org,
        m.szyprowski@samsung.com, stefanr@s5r6.in-berlin.de,
        hjc@rock-chips.com, heiko@sntech.de, airlied@linux.ie,
        oleksandr_andrushchenko@epam.com, joro@8bytes.org,
        pawel@osciak.com, kyungmin.park@samsung.com, mchehab@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, xen-devel@lists.xen.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        linux1394-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v5 0/9] Use vm_insert_range
Message-ID: <20181224152059.GA26090@n2100.armlinux.org.uk>
References: <20181224131841.GA22017@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181224131841.GA22017@jordon-HP-15-Notebook-PC>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Having discussed with Matthew offlist, I think we've come to the
following conclusion - there's a number of drivers that buggily
ignore vm_pgoff.

So, what I proposed is:

static int __vm_insert_range(struct vm_struct *vma, struct page *pages,
			     size_t num, unsigned long offset)
{
	unsigned long count = vma_pages(vma);
	unsigned long uaddr = vma->vm_start;
	int ret;

	/* Fail if the user requested offset is beyond the end of the object */
	if (offset > num)
		return -ENXIO;

	/* Fail if the user requested size exceeds available object size */
	if (count > num - offset)
		return -ENXIO;

	/* Never exceed the number of pages that the user requested */
	for (i = 0; i < count; i++) {
		ret = vm_insert_page(vma, uaddr, pages[offset + i]);
		if (ret < 0)
			return ret;
		uaddr += PAGE_SIZE;
	}

	return 0;
}

/*
 * Maps an object consisting of `num' `pages', catering for the user's
 * requested vm_pgoff
 */
int vm_insert_range(struct vm_struct *vma, struct page *pages, size_t num)
{
	return __vm_insert_range(vma, pages, num, vma->vm_pgoff);
}

/*
 * Maps a set of pages, always starting at page[0]
 */
int vm_insert_range_buggy(struct vm_struct *vma, struct page *pages, size_t num)
{
	return __vm_insert_range(vma, pages, num, 0);
}

With this, drivers such as iommu/dma-iommu.c can be converted thusly:

 int iommu_dma_mmap(struct page **pages, size_t size, struct vm_area_struct *vma+)
 {
-	unsigned long uaddr = vma->vm_start;
-	unsigned int i, count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	int ret = -ENXIO;
-
-	for (i = vma->vm_pgoff; i < count && uaddr < vma->vm_end; i++) {
-		ret = vm_insert_page(vma, uaddr, pages[i]);
-		if (ret)
-			break;
-		uaddr += PAGE_SIZE;
-	}
-	return ret;
+	return vm_insert_range(vma, pages, PAGE_ALIGN(size) >> PAGE_SHIFT);
}

and drivers such as firewire/core-iso.c:

 int fw_iso_buffer_map_vma(struct fw_iso_buffer *buffer,
 			  struct vm_area_struct *vma)
 {
-	unsigned long uaddr;
-	int i, err;
-
-	uaddr = vma->vm_start;
-	for (i = 0; i < buffer->page_count; i++) {
-		err = vm_insert_page(vma, uaddr, buffer->pages[i]);
-		if (err)
-			return err;
-
-		uaddr += PAGE_SIZE;
-	}
-
-	return 0;
+	return vm_insert_range_buggy(vma, buffer->pages, buffer->page_count);
}

and this gives us something to grep for to find these buggy drivers.

Now, this may not look exactly equivalent, but if you look at
fw_device_op_mmap(), buffer->page_count is basically vma_pages(vma)
at this point, which means this should be equivalent.

We _could_ then at a later date "fix" these drivers to behave according
to the normal vm_pgoff offsetting simply by removing the _buggy suffix
on the function name... and if that causes regressions, it gives us an
easy way to revert (as long as vm_insert_range_buggy() remains
available.)

In the case of firewire/core-iso.c, it currently ignores the mmap offset
entirely, so making the above suggested change would be tantamount to
causing it to return -ENXIO for any non-zero mmap offset.

IMHO, this approach is way simpler, and easier to get it correct at
each call site, rather than the current approach which seems to be
error-prone.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
