Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45310 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750832AbeAPKO3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 05:14:29 -0500
Received: by mail-wr0-f196.google.com with SMTP id 16so14581081wry.12
        for <linux-media@vger.kernel.org>; Tue, 16 Jan 2018 02:14:28 -0800 (PST)
Subject: Re: [PATCH 1/3] dma-buf: make returning the exclusive fence optional
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
To: daniel@ffwll.ch, sumit.semwal@linaro.org, gustavo@padovan.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
References: <20180112094729.17491-1-christian.koenig@amd.com>
Message-ID: <996ce95c-b04f-d32e-f32e-4226c60b4bf3@gmail.com>
Date: Tue, 16 Jan 2018 11:14:26 +0100
MIME-Version: 1.0
In-Reply-To: <20180112094729.17491-1-christian.koenig@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping? Daniel you requested the patch with its user.

Would be nice when I can commit this cause we need it for debugging and 
cleaning up a bunch of other things as well.

Regards,
Christian.

Am 12.01.2018 um 10:47 schrieb Christian König:
> Change reservation_object_get_fences_rcu to make the exclusive fence
> pointer optional.
>
> If not specified the exclusive fence is put into the fence array as
> well.
>
> This is helpful for a couple of cases where we need all fences in a
> single array.
>
> Signed-off-by: Christian König <christian.koenig@amd.com>
> ---
>   drivers/dma-buf/reservation.c | 31 ++++++++++++++++++++++---------
>   1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index b759a569b7b8..461afa9febd4 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -374,8 +374,9 @@ EXPORT_SYMBOL(reservation_object_copy_fences);
>    * @pshared: the array of shared fence ptrs returned (array is krealloc'd to
>    * the required size, and must be freed by caller)
>    *
> - * RETURNS
> - * Zero or -errno
> + * Retrieve all fences from the reservation object. If the pointer for the
> + * exclusive fence is not specified the fence is put into the array of the
> + * shared fences as well. Returns either zero or -ENOMEM.
>    */
>   int reservation_object_get_fences_rcu(struct reservation_object *obj,
>   				      struct dma_fence **pfence_excl,
> @@ -389,8 +390,8 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>   
>   	do {
>   		struct reservation_object_list *fobj;
> -		unsigned seq;
> -		unsigned int i;
> +		unsigned int i, seq;
> +		size_t sz = 0;
>   
>   		shared_count = i = 0;
>   
> @@ -402,9 +403,14 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>   			goto unlock;
>   
>   		fobj = rcu_dereference(obj->fence);
> -		if (fobj) {
> +		if (fobj)
> +			sz += sizeof(*shared) * fobj->shared_max;
> +
> +		if (!pfence_excl && fence_excl)
> +			sz += sizeof(*shared);
> +
> +		if (sz) {
>   			struct dma_fence **nshared;
> -			size_t sz = sizeof(*shared) * fobj->shared_max;
>   
>   			nshared = krealloc(shared, sz,
>   					   GFP_NOWAIT | __GFP_NOWARN);
> @@ -420,13 +426,19 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>   				break;
>   			}
>   			shared = nshared;
> -			shared_count = fobj->shared_count;
> -
> +			shared_count = fobj ? fobj->shared_count : 0;
>   			for (i = 0; i < shared_count; ++i) {
>   				shared[i] = rcu_dereference(fobj->shared[i]);
>   				if (!dma_fence_get_rcu(shared[i]))
>   					break;
>   			}
> +
> +			if (!pfence_excl && fence_excl) {
> +				shared[i] = fence_excl;
> +				fence_excl = NULL;
> +				++i;
> +				++shared_count;
> +			}
>   		}
>   
>   		if (i != shared_count || read_seqcount_retry(&obj->seq, seq)) {
> @@ -448,7 +460,8 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>   
>   	*pshared_count = shared_count;
>   	*pshared = shared;
> -	*pfence_excl = fence_excl;
> +	if (pfence_excl)
> +		*pfence_excl = fence_excl;
>   
>   	return ret;
>   }
