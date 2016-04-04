Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60875 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbcDDIQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 04:16:01 -0400
Subject: Re: [PATCH 1/4] mm: add is_highmem_addr() helper
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	<linux-mtd@lists.infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>
References: <1459427384-21374-1-git-send-email-boris.brezillon@free-electrons.com>
 <1459427384-21374-2-git-send-email-boris.brezillon@free-electrons.com>
CC: Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	<dmaengine@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>, Richard Weinberger <richard@nod.at>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-mm@kvack.org>,
	Joerg Roedel <joro@8bytes.org>,
	<iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
From: Vignesh R <vigneshr@ti.com>
Message-ID: <57022253.70400@ti.com>
Date: Mon, 4 Apr 2016 13:44:11 +0530
MIME-Version: 1.0
In-Reply-To: <1459427384-21374-2-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/31/2016 05:59 PM, Boris Brezillon wrote:
> Add an helper to check if a virtual address is in the highmem region.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  include/linux/highmem.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index bb3f329..13dff37 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -41,6 +41,14 @@ void kmap_flush_unused(void);
>  
>  struct page *kmap_to_page(void *addr);
>  
> +static inline bool is_highmem_addr(const void *x)
> +{
> +	unsigned long vaddr = (unsigned long)x;
> +
> +	return vaddr >=  PKMAP_BASE &&
> +	       vaddr < ((PKMAP_BASE + LAST_PKMAP) * PAGE_SIZE);


Shouldn't this be:
		vaddr < (PKMAP_BASE + (LAST_PKMAP * PAGE_SIZE)) ?

-- 
Regards
Vignesh
