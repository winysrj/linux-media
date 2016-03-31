Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57997 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750941AbcCaH0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 03:26:08 -0400
Date: Thu, 31 Mar 2016 09:26:04 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Vignesh R <vigneshr@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	<linux-mtd@lists.infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	<devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
Subject: Re: [v2,4/7] scatterlist: add sg_alloc_table_from_buf() helper
Message-ID: <20160331092604.219cf104@bbrezillon>
In-Reply-To: <56FCAE1B.90206@ti.com>
References: <1459352394-22810-5-git-send-email-boris.brezillon@free-electrons.com>
	<56FCAE1B.90206@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vignesh,

On Thu, 31 Mar 2016 10:26:59 +0530
Vignesh R <vigneshr@ti.com> wrote:

> Hi,
> 
> On 03/30/2016 09:09 PM, Boris BREZILLON wrote:
> 
> [...]
> 
> > +int sg_alloc_table_from_buf(struct sg_table *sgt, const void *buf, size_t len,
> > +			    const struct sg_constraints *constraints,
> > +			    gfp_t gfp_mask)
> > +{
> > +	struct sg_constraints cons = { };
> > +	size_t remaining, chunk_len;
> > +	const void *sg_buf;
> > +	int i, ret;
> > +
> > +	if (constraints)
> > +		cons = *constraints;
> > +
> > +	ret = sg_check_constraints(&cons, buf, len);
> > +	if (ret)
> > +		return ret;
> > +
> > +	sg_buf = buf;
> > +	remaining = len;
> > +	i = 0;
> > +	sg_for_each_chunk_in_buf(sg_buf, remaining, chunk_len, &cons)
> > +		i++;
> > +
> > +	ret = sg_alloc_table(sgt, i, gfp_mask);
> > +	if (ret)
> > +		return ret;
> > +
> > +	sg_buf = buf;
> > +	remaining = len;
> > +	i = 0;
> > +	sg_for_each_chunk_in_buf(sg_buf, remaining, chunk_len, &cons) {
> > +		if (is_vmalloc_addr(sg_buf)) {
> > +			struct page *vm_page;
> > +
> > +			vm_page = vmalloc_to_page(sg_buf);
> > +			if (!vm_page) {
> > +				ret = -ENOMEM;
> > +				goto err_free_table;
> > +			}
> > +
> > +			sg_set_page(&sgt->sgl[i], vm_page, chunk_len,
> > +				    offset_in_page(sg_buf));
> > +		} else {
> > +			sg_set_buf(&sgt->sgl[i], sg_buf, chunk_len);
> > +		}
> > +
> 
> If the buf address is in PKMAP_BASE - PAGE_OFFSET-1 region (I have
> observed that JFFS2 FS provides buffers in above region to MTD layer),
> if CONFIG_DEBUG_SG is set then sg_set_buf() will throw a BUG_ON() as
> virt_addr_is_valid() will return false. Is there a sane way to handle
> buffers of PKMAP_BASE region with sg_*  APIs?
> Or, is the function sg_alloc_table_from_buf() not to be used with such
> buffers?

It should be usable with kmapped buffers too: I'll provide a new version
to support that.
That makes me realize I'm not checking the virtual address consistency
in sg_check_constraints().

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
