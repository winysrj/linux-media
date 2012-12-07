Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17613 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423478Ab2LGRsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2012 12:48:32 -0500
Message-ID: <50C22BE8.4080203@nvidia.com>
Date: Fri, 7 Dec 2012 09:48:24 -0800
From: Aaron Plattner <aplattner@nvidia.com>
MIME-Version: 1.0
To: Inki Dae <inki.dae@samsung.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Jerome Glisse <j.glisse@gmail.com>,
	David Airlie <airlied@linux.ie>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] drm/exynos: use prime helpers
References: <1354817271-5121-5-git-send-email-aplattner@nvidia.com> <1354819712-7019-1-git-send-email-aplattner@nvidia.com> <CAAQKjZOomB2TkKtgZpS0DHM=vOzozWM-6AaztuWPMnxDXZx6Rg@mail.gmail.com>
In-Reply-To: <CAAQKjZOomB2TkKtgZpS0DHM=vOzozWM-6AaztuWPMnxDXZx6Rg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/2012 10:36 PM, Inki Dae wrote:
>
> Hi,
>
> CCing media guys.
>
> I agree with you but we should consider one issue released to v4l2.
>
> As you may know, V4L2-based driver uses vb2 as buffer manager and the
> vb2 includes dmabuf feature>(import and export) And v4l2 uses streaming
> concept>(qbuf and dqbuf)
> With dmabuf and iommu, generally qbuf imports a fd into its own buffer
> and maps it with its own iommu table calling dma_buf_map_attachment().
> And dqbuf calls dma_buf_unmap_attachment() to unmap that buffer from its
> own iommu table.
> But now vb2's unmap_dma_buf callback is nothing to do. I think that the
> reason is the below issue,
>
> If qbuf maps buffer with iomm table and dqbuf unmaps it from iommu table
> then it has performance deterioration because qbuf and dqbuf are called
> repeatedly.
> And this means map/unmap are repeated also. So I think media guys moved
> dma_unmap_sg call from its own unmap_dma_buf callback to detach callback
> instead.
> For this, you can refer to vb2_dc_dmabuf_ops_unmap and
> vb2_dc_dmabuf_ops_detach function.
>
> So I added the below patch to avoid that performance deterioration and
> am testing it now.(this patch is derived from videobuf2-dma-contig.c)
> http://git.kernel.org/?p=linux/kernel/git/daeinki/drm-exynos.git;a=commit;h=576b1c3de8b90cf1570b8418b60afd1edaae4e30
>
> Thus, I'm not sure that your common set could cover all the cases
> including other frameworks. Please give me any opinions.

It seems like this adjustment would make perfect sense to add to the 
helper layer I suggested.  E.g., instead of having an exynos_attach 
structure that caches the sgt, there'd be a struct drm_gem_prime_attach 
that would do the same thing, and save the sgt it gets from 
driver->gem_prime_get_sg.  Then it would benefit nouveau and radeon, too.

Alternatively, patch #4 could be dropped and Exynos can continue to 
reimplement all of this core functionality, since the helpers are 
optional, but I don't see anything about this change that should make it 
Exynos-specific, unless I'm missing something.

--
Aaron
