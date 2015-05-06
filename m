Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbbEFKrh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 06:47:37 -0400
Message-ID: <5549F147.3050800@suse.cz>
Date: Wed, 06 May 2015 12:47:35 +0200
From: Vlastimil Babka <vbabka@suse.cz>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-mm@kvack.org
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mgorman@suse.de, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 9/9] drm/exynos: Convert g2d_userptr_get_dma_addr() to
 use get_vaddr_frames()
References: <1430897296-5469-1-git-send-email-jack@suse.cz> <1430897296-5469-10-git-send-email-jack@suse.cz>
In-Reply-To: <1430897296-5469-10-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/2015 09:28 AM, Jan Kara wrote:
> Convert g2d_userptr_get_dma_addr() to pin pages using get_vaddr_frames().
> This removes the knowledge about vmas and mmap_sem locking from exynos
> driver. Also it fixes a problem that the function has been mapping user
> provided address without holding mmap_sem.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   drivers/gpu/drm/exynos/exynos_drm_g2d.c | 89 ++++++++++--------------------
>   drivers/gpu/drm/exynos/exynos_drm_gem.c | 97 ---------------------------------
>   2 files changed, 29 insertions(+), 157 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> index 81a250830808..265519c0fe2d 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
...
> @@ -456,65 +458,37 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct drm_device *drm_dev,
>   		return ERR_PTR(-ENOMEM);
>
>   	atomic_set(&g2d_userptr->refcount, 1);
> +	g2d_userptr->size = size;
>
>   	start = userptr & PAGE_MASK;
>   	offset = userptr & ~PAGE_MASK;
>   	end = PAGE_ALIGN(userptr + size);
>   	npages = (end - start) >> PAGE_SHIFT;
> -	g2d_userptr->npages = npages;
> -
> -	pages = drm_calloc_large(npages, sizeof(struct page *));
> -	if (!pages) {
> -		DRM_ERROR("failed to allocate pages.\n");
> -		ret = -ENOMEM;
> +	vec = g2d_userptr->vec = frame_vector_create(npages);
> +	if (!vec)
>   		goto err_free;
> -	}
>
> -	down_read(&current->mm->mmap_sem);
> -	vma = find_vma(current->mm, userptr);
> -	if (!vma) {
> -		up_read(&current->mm->mmap_sem);
> -		DRM_ERROR("failed to get vm region.\n");
> +	ret = get_vaddr_frames(start, npages, 1, 1, vec);

Use true instead of 1.

