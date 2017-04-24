Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:54816 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1174384AbdDXUZW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 16:25:22 -0400
Subject: Re: [PATCH 2/2] [media] vb2: Fix error handling in
 '__vb2_buf_mem_alloc'
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170423214030.14854-1-christophe.jaillet@wanadoo.fr>
 <20170424142335.GR7456@valkosipuli.retiisi.org.uk>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <030bab0d-0c5d-b65e-a7aa-54662bf42eb1@wanadoo.fr>
Date: Mon, 24 Apr 2017 22:25:18 +0200
MIME-Version: 1.0
In-Reply-To: <20170424142335.GR7456@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 24/04/2017 à 16:23, Sakari Ailus a écrit :
> Hi Christophe,
>
> On Sun, Apr 23, 2017 at 11:40:30PM +0200, Christophe JAILLET wrote:
>> 'call_ptr_memop' can return NULL, so we must test its return value with
>> 'IS_ERR_OR_NULL'. Otherwise, the test 'if (mem_priv)' is meaningless.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> Note that error checking after 'call_ptr_memop' calls is not consistent
>> in this file. I guess that 'IS_ERR_OR_NULL' should be used everywhere
>> and that the corresponding error handling code should be tweaked just as
>> the code in this function.
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index c0175ea7e7ad..d1d3f5dd57b9 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -210,7 +210,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>   		mem_priv = call_ptr_memop(vb, alloc,
>>   				q->alloc_devs[plane] ? : q->dev,
>>   				q->dma_attrs, size, dma_dir, q->gfp_flags);
>> -		if (IS_ERR(mem_priv)) {
>> +		if (IS_ERR_OR_NULL(mem_priv)) {
>>   			if (mem_priv)
>>   				ret = PTR_ERR(mem_priv);
>>   			goto free;
> If NULL will always equate -ENOMEM, shouldn't call_ptr_memop() be changed
> instead to convert NULL to ERR_PTR(-ENOMEM)?
>
I agree with you, but in fact, I don't know if "NULL will always equate 
-ENOMEM"

The return value of 'call_ptr_memop' is likely the result of a function 
called via a function pointer. I don't know if this function can return 
NULL or not.
I don't know the code enough to see if it would be safe and if this 
assertion is correct.

So the easiest for me is to just propose a fix to accept NULL.


*** Digging deeper ***

In 'videobuf2-core.h', there is:

/**
  * struct vb2_mem_ops - memory handling/memory allocator operations
  * @alloc:      allocate video memory and, optionally, allocator 
private data,
  *              return ERR_PTR() on failure or a pointer to allocator 
private,
  *              per-buffer data on success; the returned private structure
  *              will then be passed as @buf_priv argument to other ops 
in this
  *              structure. Additional gfp_flags to use when allocating the
  *              are also passed to this operation. These flags are from the
  *              gfp_flags field of vb2_queue.

So the 'alloc' function should return an ERR_PTR in case of error.
'vb2_vmalloc_alloc', 'vb2_dc_alloc' and 'vb2_dma_sg_alloc' does. 
(confirmed by code inspection, based on the 'standard' list of alloc 
functions found in see https://lwn.net/Articles/447435/)

But what if a module implements its own set of functions and returns 
NULL in such a case?

Anyway, I will propose a patch that returns ERR_PTR(-ENOMEM) instead of 
NULL, but I won't be able to test it on my own.

Thanks,

CJ
