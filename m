Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935828AbeFRS65 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 14:58:57 -0400
Date: Mon, 18 Jun 2018 14:58:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, mingo@redhat.com,
        isely@pobox.com, bhumirks@gmail.com, colin.king@canonical.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add TRACE_EVENTs in pwc_isoc_handler()
Message-ID: <20180618145854.2092c6e0@gandalf.local.home>
In-Reply-To: <20180617143625.32133-1-matwey@sai.msu.ru>
References: <20180617143625.32133-1-matwey@sai.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 17 Jun 2018 17:36:24 +0300
"Matwey V. Kornilov" <matwey@sai.msu.ru> wrote:

I would prefer a change log here that would explain why these
tracepoints are being added.


> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> ---
>  drivers/media/usb/pwc/pwc-if.c |  7 +++++++
>  include/trace/events/pwc.h     | 45 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
>  create mode 100644 include/trace/events/pwc.h
> 
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index 54b036d39c5b..5775d1f60668 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -57,6 +57,9 @@
>     - Pham Thanh Nam: webcam snapshot button as an event input device
>  */
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/pwc.h>
> +
>  #include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/mm.h>
> @@ -260,6 +263,8 @@ static void pwc_isoc_handler(struct urb *urb)
>  	int i, fst, flen;
>  	unsigned char *iso_buf = NULL;
>  
> +	trace_pwc_handler_enter(urb);
> +
>  	if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
>  	    urb->status == -ESHUTDOWN) {
>  		PWC_DEBUG_OPEN("URB (%p) unlinked %ssynchronously.\n",

Looks like if this is hit, we will return from the function without
calling trace_pwc_handler_exit().

> @@ -347,6 +352,8 @@ static void pwc_isoc_handler(struct urb *urb)
>  		pdev->vlast_packet_size = flen;
>  	}
>  
> +	trace_pwc_handler_exit(urb);
> +
>  handler_end:

Why not add the tracepoint after handler_end. In fact, why not add some
exit status to the trace event? I would think that would be useful as
well.


>  	i = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (i != 0)
> diff --git a/include/trace/events/pwc.h b/include/trace/events/pwc.h
> new file mode 100644
> index 000000000000..b13d2118bb7a
> --- /dev/null
> +++ b/include/trace/events/pwc.h
> @@ -0,0 +1,45 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#if !defined(_TRACE_PWC_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_PWC_H
> +
> +#include <linux/usb.h>
> +#include <linux/tracepoint.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM pwc
> +
> +TRACE_EVENT(pwc_handler_enter,
> +	TP_PROTO(struct urb *urb),
> +	TP_ARGS(urb),
> +	TP_STRUCT__entry(
> +		__field(struct urb*, urb)
> +		__field(int, urb__status)
> +		__field(u32, urb__actual_length)
> +	),
> +	TP_fast_assign(
> +		__entry->urb = urb;
> +		__entry->urb__status = urb->status;
> +		__entry->urb__actual_length = urb->actual_length;

Is there any other data that may be interesting to record here?

-- Steve

> +	),
> +	TP_printk("urb=%p (status=%d actual_length=%u)",
> +		__entry->urb,
> +		__entry->urb__status,
> +		__entry->urb__actual_length)
> +);
> +
> +TRACE_EVENT(pwc_handler_exit,
> +	TP_PROTO(struct urb *urb),
> +	TP_ARGS(urb),
> +	TP_STRUCT__entry(
> +		__field(struct urb*, urb)
> +	),
> +	TP_fast_assign(
> +		__entry->urb = urb;
> +	),
> +	TP_printk("urb=%p", __entry->urb)
> +);
> +
> +#endif /* _TRACE_PWC_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
