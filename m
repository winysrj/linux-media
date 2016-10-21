Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:62938 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932814AbcJUO2G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:28:06 -0400
Date: Fri, 21 Oct 2016 15:27:57 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: Re: [PATCH 4/5] drm/i915: Use __sg_alloc_table_from_pages for
 allocating object backing store
Message-ID: <20161021142757.GP25629@nuc-i3427.alporthouse.com>
References: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
 <1477059083-3500-5-git-send-email-tvrtko.ursulin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477059083-3500-5-git-send-email-tvrtko.ursulin@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 21, 2016 at 03:11:22PM +0100, Tvrtko Ursulin wrote:
> @@ -2236,18 +2233,16 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
>  	BUG_ON(obj->base.read_domains & I915_GEM_GPU_DOMAINS);
>  	BUG_ON(obj->base.write_domain & I915_GEM_GPU_DOMAINS);
>  
> -	max_segment = swiotlb_max_size();
> -	if (!max_segment)
> -		max_segment = rounddown(UINT_MAX, PAGE_SIZE);
> -
> -	st = kmalloc(sizeof(*st), GFP_KERNEL);
> -	if (st == NULL)
> -		return -ENOMEM;
> -
>  	page_count = obj->base.size / PAGE_SIZE;
> -	if (sg_alloc_table(st, page_count, GFP_KERNEL)) {
> -		kfree(st);
> +	pages = drm_malloc_gfp(page_count, sizeof(struct page *),
> +			       GFP_TEMPORARY | __GFP_ZERO);
> +	if (!pages)
>  		return -ENOMEM;

Full circle! The whole reason this exists was to avoid that vmalloc. I
don't really want it back...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
