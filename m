Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.netline.ch ([148.251.143.178]:33389 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932517AbeGDJKD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 05:10:03 -0400
Subject: Re: [PATCH] dma-buf: Move BUG_ON from _add_shared_fence to
 _add_shared_inplace
To: christian.koenig@amd.com, Sumit Semwal <sumit.semwal@linaro.org>
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        linux-media@vger.kernel.org
References: <20180626143147.14296-1-michel@daenzer.net>
 <249b84ea-affe-2e27-abdd-81d61da9cce6@gmail.com>
From: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Message-ID: <f6100513-d31b-b7a2-cc9f-104a60127277@daenzer.net>
Date: Wed, 4 Jul 2018 11:09:58 +0200
MIME-Version: 1.0
In-Reply-To: <249b84ea-affe-2e27-abdd-81d61da9cce6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-07-04 10:31 AM, Christian König wrote:
> Am 26.06.2018 um 16:31 schrieb Michel Dänzer:
>> From: Michel Dänzer <michel.daenzer@amd.com>
>>
>> Fixes the BUG_ON spuriously triggering under the following
>> circumstances:
>>
>> * ttm_eu_reserve_buffers processes a list containing multiple BOs using
>>    the same reservation object, so it calls
>>    reservation_object_reserve_shared with that reservation object once
>>    for each such BO.
>> * In reservation_object_reserve_shared, old->shared_count ==
>>    old->shared_max - 1, so obj->staged is freed in preparation of an
>>    in-place update.
>> * ttm_eu_fence_buffer_objects calls reservation_object_add_shared_fence
>>    once for each of the BOs above, always with the same fence.
>> * The first call adds the fence in the remaining free slot, after which
>>    old->shared_count == old->shared_max.
> 
> Well, the explanation here is not correct. For multiple BOs using the
> same reservation object we won't call
> reservation_object_add_shared_fence() multiple times because we move
> those to the duplicates list in ttm_eu_reserve_buffers().
> 
> But this bug can still happen because we call
> reservation_object_add_shared_fence() manually with fences for the same
> context in a couple of places.
> 
> One prominent case which comes to my mind are for the VM BOs during
> updates. Another possibility are VRAM BOs which need to be cleared.

Thanks. How about the following:

* ttm_eu_reserve_buffers calls reservation_object_reserve_shared.
* In reservation_object_reserve_shared, shared_count == shared_max - 1,
  so obj->staged is freed in preparation of an in-place update.
* ttm_eu_fence_buffer_objects calls reservation_object_add_shared_fence,
  after which shared_count == shared_max.
* The amdgpu driver also calls reservation_object_add_shared_fence for
  the same reservation object, and the BUG_ON triggers.

However, nothing bad would happen in
reservation_object_add_shared_inplace, since all fences use the same
context, so they can only occupy a single slot.

Prevent this by moving the BUG_ON to where an overflow would actually
happen (e.g. if a buggy caller didn't call
reservation_object_reserve_shared before).


Also, I'll add a reference to https://bugs.freedesktop.org/106418 in v2,
as I suspect this fix is necessary under the circumstances described
there as well.


-- 
Earthling Michel Dänzer               |               http://www.amd.com
Libre software enthusiast             |             Mesa and X developer
