Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr40137.outbound.protection.outlook.com ([40.107.4.137]:59885
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754257AbeCPP1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 11:27:34 -0400
Subject: Re: [PATCH][RFC] kernel.h: provide array iterator
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Abbott <abbotti@mev.co.uk>
References: <1521108052-26861-1-git-send-email-kieran.bingham@ideasonboard.com>
From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <b6af11b9-d697-59ec-6acc-80f0657a3e11@prevas.dk>
Date: Fri, 16 Mar 2018 16:27:28 +0100
MIME-Version: 1.0
In-Reply-To: <1521108052-26861-1-git-send-email-kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-03-15 11:00, Kieran Bingham wrote:
> Simplify array iteration with a helper to iterate each entry in an array.
> Utilise the existing ARRAY_SIZE macro to identify the length of the array
> and pointer arithmetic to process each item as a for loop.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> ---
>  include/linux/kernel.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> The use of static arrays to store data is a common use case throughout the
> kernel. Along with that is the obvious need to iterate that data.
> 
> In fact there are just shy of 5000 instances of iterating a static array:
> 	git grep "for .*ARRAY_SIZE" | wc -l
> 	4943
> 
> When working on the UVC driver - I found that I needed to split one such
> iteration into two parts, and at the same time felt that this could be
> refactored to be cleaner / easier to read. 

About that, it would be helpful if you first converted to the new
iterator, so that one can more easily see they are equivalent. And then
split in two, adding the flush_workqueue call. Or do it the other way
around. But please don't mix the two in one patch, especially not if
it's supposed to act as an example of how to use the new helper.

> I do however worry that this simple short patch might not be desired or could
> also be heavily bikeshedded due to it's potential wide spread use (though
> perhaps that would be a good thing to have more users) ...  but here it is,
> along with an example usage below which is part of a separate series.

I think it can be useful, and it does have the must_be_array protection
built in, so code doesn't silently break if one changes from a
fixed-size allocation to e.g. a kmalloc-based one. Just don't attempt a
tree-wide mass conversion, but obviously starting to make use of it when
refactoring code anyway is fine.

And now, the bikeshedding you expected :)

> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index ce51455e2adf..95d7dae248b7 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -70,6 +70,16 @@
>   */
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>  
> +/**
> + * for_each_array_element - Iterate all items in an array
> + * @elem: pointer of array type for iteration cursor

Hm, "pointer of array type" sounds wrong; it's not a "pointer to array".
But "pointer of array elements' type" is clumsy. Maybe just "@elem:
iteration cursor" is clear enough.

> + * @array: array to be iterated
> + */
> +#define for_each_array_element(elem, array) \
> +	for (elem = &(array)[0]; \
> +	     elem < &(array)[ARRAY_SIZE(array)]; \
> +	     ++elem)
> +

Please parenthesize elem as well.

Rasmus
