Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37268 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750723AbdK3M3w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 07:29:52 -0500
Date: Thu, 30 Nov 2017 10:29:46 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>, Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3 26/26] kfifo: DECLARE_KIFO_PTR(fifo, u64) does not
 work on arm 32 bit
Message-ID: <20171130102946.7168e93c@vento.lan>
In-Reply-To: <1507622382.6064.2.camel@seibold.net>
References: <cover.1507618840.git.sean@mess.org>
        <1507622382.6064.2.camel@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Oct 2017 09:59:42 +0200
Sean Young <sean@mess.org> escreveu:

> If you try to store u64 in a kfifo (or a struct with u64 members),
> then the buf member of __STRUCT_KFIFO_PTR will cause 4 bytes
> padding due to alignment (note that struct __kfifo is 20 bytes
> on 32 bit).
> 
> That in turn causes the __is_kfifo_ptr() to fail, which is caught
> by kfifo_alloc(), which now returns EINVAL.
> 
> So, ensure that __is_kfifo_ptr() compares to the right structure.
> 
> Signed-off-by: Sean Young <sean@mess.org>
> Acked-by: Stefani Seibold <stefani@seibold.net>

Hi Stefani/Andrew,

As this patch is required for the LIRC rework, would be ok if I would
merge it via the media tree?

Thanks!
Mauro


> 
> ---
>  include/linux/kfifo.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> index 41eb6fdf87a8..86b5fb08e96c 100644
> --- a/include/linux/kfifo.h
> +++ b/include/linux/kfifo.h
> @@ -113,7 +113,8 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
>   * array is a part of the structure and the fifo type where the array is
>   * outside of the fifo structure.
>   */
> -#define	__is_kfifo_ptr(fifo)	(sizeof(*fifo) == sizeof(struct __kfifo))
> +#define	__is_kfifo_ptr(fifo) \
> +	(sizeof(*fifo) == sizeof(STRUCT_KFIFO_PTR(typeof(*(fifo)->type))))
>  
>  /**
>   * DECLARE_KFIFO_PTR - macro to declare a fifo pointer object



Thanks,
Mauro
