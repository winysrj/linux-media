Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:15345 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934306AbcJUOzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:55:20 -0400
Subject: Re: [Intel-gfx] [PATCH 4/5] drm/i915: Use __sg_alloc_table_from_pages
 for allocating object backing store
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
References: <1477059083-3500-1-git-send-email-tvrtko.ursulin@linux.intel.com>
 <1477059083-3500-5-git-send-email-tvrtko.ursulin@linux.intel.com>
 <20161021142757.GP25629@nuc-i3427.alporthouse.com>
From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Message-ID: <79f299ba-ac59-4932-56e8-687a30ca43e2@linux.intel.com>
Date: Fri, 21 Oct 2016 15:55:11 +0100
MIME-Version: 1.0
In-Reply-To: <20161021142757.GP25629@nuc-i3427.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 21/10/2016 15:27, Chris Wilson wrote:
> On Fri, Oct 21, 2016 at 03:11:22PM +0100, Tvrtko Ursulin wrote:
>> @@ -2236,18 +2233,16 @@ i915_gem_object_get_pages_gtt(struct drm_i915_gem_object *obj)
>>  	BUG_ON(obj->base.read_domains & I915_GEM_GPU_DOMAINS);
>>  	BUG_ON(obj->base.write_domain & I915_GEM_GPU_DOMAINS);
>>
>> -	max_segment = swiotlb_max_size();
>> -	if (!max_segment)
>> -		max_segment = rounddown(UINT_MAX, PAGE_SIZE);
>> -
>> -	st = kmalloc(sizeof(*st), GFP_KERNEL);
>> -	if (st == NULL)
>> -		return -ENOMEM;
>> -
>>  	page_count = obj->base.size / PAGE_SIZE;
>> -	if (sg_alloc_table(st, page_count, GFP_KERNEL)) {
>> -		kfree(st);
>> +	pages = drm_malloc_gfp(page_count, sizeof(struct page *),
>> +			       GFP_TEMPORARY | __GFP_ZERO);
>> +	if (!pages)
>>  		return -ENOMEM;
>
> Full circle! The whole reason this exists was to avoid that vmalloc. I
> don't really want it back...

Yes, it is not ideal.

However all objects under 4 MiB should fall under the kmalloc fast path 
(8 KiB of struct page pointers, which should always be available), and 
possibly bigger ones as well if there is room.

It only fallbacks to vmalloc for objects larger than 4 MiB, when it also 
fails to get the page pointer array from the SLAB (GFP_TEMPORARY).

So perhaps SLAB would most of the time have some nice chunks for us to 
pretty much limit vmalloc apart for the huge objects? And then, is 
creation time for those so performance critical?

I came up with this because I started to dislike my previous 
sg_trim_table approach as too ugly. It had an advantage of simplicity 
after fixing the theoretical chunk overflow in sg_alloc_table_from_pages.

If we choose none of the two, only third option I can think of is to 
allocate the sg table as we add entries to it. I don't think it would be 
hard to do that.

Regards,

Tvrtko
