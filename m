Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:45807 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZGEINL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 04:13:11 -0400
Date: Sun, 5 Jul 2009 01:13:14 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>,
	Andrzej Hajda <andrzej.hajda@wp.pl>
Subject: Re: [PATCH 1/2] Compatibility layer for hrtimer API
In-Reply-To: <20090703224652.339a63e7@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0907050109420.6411@shell2.speakeasy.net>
References: <20090703224652.339a63e7@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 3 Jul 2009, Jean Delvare wrote:
> Kernels 2.6.22 to 2.6.24 (inclusive) need some compatibility quirks
> for the hrtimer API. For older kernels, some required functions were
> not exported so there's nothing we can do. This means that drivers
> using the hrtimer infrastructure will no longer work for kernels older
> than 2.6.22.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  v4l/compat.h |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> --- a/v4l/compat.h
> +++ b/v4l/compat.h
> @@ -480,4 +480,22 @@ static inline unsigned long v4l_compat_f
>  }
>  #endif
>
> +/*
> + * Compatibility code for hrtimer API
> + * This will make hrtimer usable for kernels 2.6.22 and later.
> + * For earlier kernels, not all required functions are exported
> + * so there's nothing we can do.
> + */
> +
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25) && \
> +	LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
> +#include <linux/hrtimer.h>

Instead of including hrtimer.h from compat.h it's better if you check if it
has already been included and only enable the compat code in that case.
That way hrtimer doesn't get included for files that don't need it and
might define something that conflicts with something from hrtimer.  And it
prevents someone from forgetting to include hrtimer when they needed it,
but having the error masked because compat.h is doing it for them.

> +/* Forward a hrtimer so it expires after the hrtimer's current now */
> +static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
> +						ktime_t interval)
> +{
> +	return hrtimer_forward(timer, timer->base->get_time(), interval);
> +}
> +#endif
> +
>  #endif /*  _COMPAT_H */
