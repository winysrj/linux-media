Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35467 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbcCaE6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 00:58:30 -0400
Subject: Re: [v2,4/7] scatterlist: add sg_alloc_table_from_buf() helper
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	<linux-mtd@lists.infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>
References: <1459352394-22810-5-git-send-email-boris.brezillon@free-electrons.com>
CC: Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Vinod Koul <vinod.koul@intel.com>,
	Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
	<linux-spi@vger.kernel.org>, Richard Weinberger <richard@nod.at>,
	<linux-sunxi@googlegroups.com>, Mark Brown <broonie@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kumar Gala <galak@codeaurora.org>, <dmaengine@vger.kernel.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	<linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
From: Vignesh R <vigneshr@ti.com>
Message-ID: <56FCAE1B.90206@ti.com>
Date: Thu, 31 Mar 2016 10:26:59 +0530
MIME-Version: 1.0
In-Reply-To: <1459352394-22810-5-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/30/2016 09:09 PM, Boris BREZILLON wrote:

[...]

> +int sg_alloc_table_from_buf(struct sg_table *sgt, const void *buf, size_t len,
> +			    const struct sg_constraints *constraints,
> +			    gfp_t gfp_mask)
> +{
> +	struct sg_constraints cons = { };
> +	size_t remaining, chunk_len;
> +	const void *sg_buf;
> +	int i, ret;
> +
> +	if (constraints)
> +		cons = *constraints;
> +
> +	ret = sg_check_constraints(&cons, buf, len);
> +	if (ret)
> +		return ret;
> +
> +	sg_buf = buf;
> +	remaining = len;
> +	i = 0;
> +	sg_for_each_chunk_in_buf(sg_buf, remaining, chunk_len, &cons)
> +		i++;
> +
> +	ret = sg_alloc_table(sgt, i, gfp_mask);
> +	if (ret)
> +		return ret;
> +
> +	sg_buf = buf;
> +	remaining = len;
> +	i = 0;
> +	sg_for_each_chunk_in_buf(sg_buf, remaining, chunk_len, &cons) {
> +		if (is_vmalloc_addr(sg_buf)) {
> +			struct page *vm_page;
> +
> +			vm_page = vmalloc_to_page(sg_buf);
> +			if (!vm_page) {
> +				ret = -ENOMEM;
> +				goto err_free_table;
> +			}
> +
> +			sg_set_page(&sgt->sgl[i], vm_page, chunk_len,
> +				    offset_in_page(sg_buf));
> +		} else {
> +			sg_set_buf(&sgt->sgl[i], sg_buf, chunk_len);
> +		}
> +

If the buf address is in PKMAP_BASE - PAGE_OFFSET-1 region (I have
observed that JFFS2 FS provides buffers in above region to MTD layer),
if CONFIG_DEBUG_SG is set then sg_set_buf() will throw a BUG_ON() as
virt_addr_is_valid() will return false. Is there a sane way to handle
buffers of PKMAP_BASE region with sg_*  APIs?
Or, is the function sg_alloc_table_from_buf() not to be used with such
buffers?


-- 
Regards
Vignesh
