Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:52065 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbG3Ubx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 16:31:53 -0400
Date: Thu, 30 Jul 2015 21:31:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jens Axboe <axboe@kernel.dk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] lib: scatterlist: add sg splitting function
Message-ID: <20150730203138.GT7557@n2100.arm.linux.org.uk>
References: <1438282935-3448-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438282935-3448-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 30, 2015 at 09:02:15PM +0200, Robert Jarzmik wrote:
> Sometimes a scatter-gather has to be split into several chunks, or sub scatter
> lists. This happens for example if a scatter list will be handled by multiple
> DMA channels, each one filling a part of it.
> 
> A concrete example comes with the media V4L2 API, where the scatter list is
> allocated from userspace to hold an image, regardless of the knowledge of how
> many DMAs will fill it :
>  - in a simple RGB565 case, one DMA will pump data from the camera ISP to memory
>  - in the trickier YUV422 case, 3 DMAs will pump data from the camera ISP pipes,
>    one for pipe Y, one for pipe U and one for pipe V
> 
> For these cases, it is necessary to split the original scatter list into
> multiple scatter lists, which is the purpose of this patch.
> 
> The guarantees that are required for this patch are :
>  - the intersection of spans of any couple of resulting scatter lists is empty
>  - the union of spans of all resulting scatter lists is a subrange of the span
>    of the original scatter list
>  - if streaming DMA API operations (mapping, unmapping) should not happen both
>    on both the resulting and the original scatter list. It's either the first or
>    the later ones.

Hmm.

What happens if...

	n = dma_map_sg(dev, sg, nents, dir);

where n < nents (which can happen if you have an IOMMU and it coalesces
the entries)?

This also means that sg_dma_len(sg) may not be equal to sg->length, nor
may sg_dma_address(sg) correspond with sg_phys() etc.

> +	for_each_sg(in, sg, sg_nents(in), i) {
> +		if (skip > sg_dma_len(sg)) {
> +			skip -= sg_dma_len(sg);

sg_dma_len() is undefined before the scatterlist is mapped.  Above, you
say that dma map should not happen on both the initial or the subsequently
split scatterlists, but this requires the original to be DMA-mapped.

Also, as I mention above, the number of scatterlist entries to process
is given by 'n' above, not 'nents'.  I'm not sure that there's any
requirement for dma_map_sg() to mark the new end of the scatterlist as
that'd result in information loss when subsequently unmapping.

> +	for (i = 0, split = splitters; i < nb_splits; i++, split++) {
> +		in_sg = split->in_sg0;
> +		out_sg = split->out_sg;
> +		out[i] = out_sg;
> +		for (j = 0; j < split->nents; j++, out_sg++) {
> +			*out_sg = *in_sg;
> +			if (!j) {
> +				out_sg->offset = split->skip_sg0;
> +				sg_dma_len(out_sg) -= split->skip_sg0;
> +			} else {
> +				out_sg->offset = 0;
> +			}
> +			in_sg = sg_next(in_sg);
> +		}
> +		sg_dma_len(--out_sg) = split->len_last_sg;

Hmm, I'm not sure this is good enough.  If we're talking about a mapped
scatterlist, this won't touch the value returned by sg_dma_address() at
all, which will end up being incorrect.

If this is the state of the code in the media subsystem, then it's very
buggy, and in need of fixing.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
