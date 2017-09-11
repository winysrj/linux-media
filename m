Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:56833 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751029AbdIKN5j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:57:39 -0400
Subject: Re: [PATCH] build: Added missing functions nsecs_to_jiffies(64)
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: d.scheller@gmx.net
References: <1505082197-11962-1-git-send-email-jasmin@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <77d16f09-c450-737a-40d2-b1c268548d5d@xs4all.nl>
Date: Mon, 11 Sep 2017 15:57:35 +0200
MIME-Version: 1.0
In-Reply-To: <1505082197-11962-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2017 12:23 AM, Jasmin J. wrote:
> From: Jasmin Jessich <jasmin@anw.at>
> 
> Several modules expect the functions nsecs_to_jiffies64 and
> nsecs_to_jiffies to be available when they get loaded. For Kernels prior
> to 3.16, this symbol is not exported in time.c .
> Copied the functions to compat.h, so that they get already resolved during
> compilation. Define also a macro with a name conversion, because the
> mentioned functions are defined as extern in include/linux/jiffies.h,
> which gives an error when the are re-defined as static.
> 
> Signed-off-by: Jasmin Jessich <jasmin@anw.at>
> ---
>  v4l/compat.h | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/v4l/compat.h b/v4l/compat.h
> index 7a49551..3dedf26 100644
> --- a/v4l/compat.h
> +++ b/v4l/compat.h
> @@ -2118,4 +2118,41 @@ static inline int pm_runtime_get_if_in_use(struct device *dev)
>  	.subvendor = (subvend), .subdevice = (subdev)
>  #endif
>  
> +
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 16, 0)
> +/*
> + * copied from kernel/time/time.c
> + */
> +static inline u64 nsecs_to_jiffies64_static(u64 n)
> +{
> +#if (NSEC_PER_SEC % HZ) == 0
> +    /* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
> +    return div_u64(n, NSEC_PER_SEC / HZ);
> +#elif (HZ % 512) == 0
> +    /* overflow after 292 years if HZ = 1024 */
> +    return div_u64(n * HZ / 512, NSEC_PER_SEC / 512);
> +#else
> +    /*
> +     * Generic case - optimized for cases where HZ is a multiple of 3.
> +     * overflow after 64.99 years, exact for HZ = 60, 72, 90, 120 etc.
> +     */
> +    return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
> +#endif
> +}
> +
> +static inline unsigned long nsecs_to_jiffies_static(u64 n)
> +{
> +    return (unsigned long)nsecs_to_jiffies64_static(n);
> +}
> +
> +/*
> + * linux/jiffies.h defines nsecs_to_jiffies64 and nsecs_to_jiffies
> + * as externals. To get rid of the compiler error, we redefine the
> + * functions to the static variant just defined above.
> + */
> +#define nsecs_to_jiffies64(_n) nsecs_to_jiffies64_static(_n)
> +#define nsecs_to_jiffies(_n) nsecs_to_jiffies_static(_n)

For this to work reliably I think you should include jiffies.h before these
defines. If the defines come before the header is included I would expect
that the extern functions then become extern nsecs_to_jiffies64_static and
you will have the same problem again.

It is probably included already via another header, but it doesn't hurt to
be safe.

Looks good otherwise.

Regards,

	Hans

> +
> +#endif
> +
>  #endif /*  _COMPAT_H */
> 
