Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbeHIUw0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Aug 2018 16:52:26 -0400
Date: Thu, 9 Aug 2018 14:26:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, laurent.pinchart@ideasonboard.com,
        stern@rowland.harvard.edu, ezequiel@collabora.com,
        hdegoede@redhat.com, hverkuil@xs4all.nl, mchehab@kernel.org,
        mingo@redhat.com, isely@pobox.com, bhumirks@gmail.com,
        colin.king@canonical.com, kieran.bingham@ideasonboard.com,
        keiichiw@chromium.org
Subject: Re: [PATCH v4 1/2] media: usb: pwc: Introduce TRACE_EVENTs for
 pwc_isoc_handler()
Message-ID: <20180809142618.34e58d5d@gandalf.local.home>
In-Reply-To: <20180809181103.15437-2-matwey@sai.msu.ru>
References: <20180809181103.15437-1-matwey@sai.msu.ru>
        <20180809181103.15437-2-matwey@sai.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu,  9 Aug 2018 21:11:02 +0300
"Matwey V. Kornilov" <matwey@sai.msu.ru> wrote:

> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> ---
>  drivers/media/usb/pwc/pwc-if.c |  7 +++++
>  include/trace/events/pwc.h     | 65 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+)
>  create mode 100644 include/trace/events/pwc.h
> 
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index 54b036d39c5b..72d2897a4b9f 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -76,6 +76,9 @@
>  #include "pwc-dec23.h"
>  #include "pwc-dec1.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/pwc.h>
> +
>  /* Function prototypes and driver templates */
>  
>  /* hotplug device table support */
> @@ -260,6 +263,8 @@ static void pwc_isoc_handler(struct urb *urb)
>  	int i, fst, flen;
>  	unsigned char *iso_buf = NULL;
>  
> +	trace_pwc_handler_enter(urb, pdev);
> +
>  	if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
>  	    urb->status == -ESHUTDOWN) {
>  		PWC_DEBUG_OPEN("URB (%p) unlinked %ssynchronously.\n",
> @@ -348,6 +353,8 @@ static void pwc_isoc_handler(struct urb *urb)
>  	}
>  
>  handler_end:
> +	trace_pwc_handler_exit(urb, pdev);
> +
>  	i = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (i != 0)
>  		PWC_ERROR("Error (%d) re-submitting urb in pwc_isoc_handler.\n", i);
> diff --git a/include/trace/events/pwc.h b/include/trace/events/pwc.h
> new file mode 100644
> index 000000000000..84807fea2217
> --- /dev/null
> +++ b/include/trace/events/pwc.h
> @@ -0,0 +1,65 @@
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
> +	TP_PROTO(struct urb *urb, struct pwc_device *pdev),
> +	TP_ARGS(urb, pdev),
> +	TP_STRUCT__entry(
> +		__field(struct urb*, urb)
> +		__field(int, urb__status)
> +		__field(u32, urb__actual_length)
> +		__string(name, pdev->v4l2_dev.name)
> +		__field(struct pwc_frame_buf*, fbuf)
> +		__field(int, fbuf__filled)

I should have mentioned this before. The above is a structure, and the
fields of that structure are created in the same order as this list.
It's best to try to make sure there's no "holes". I would recommend:

		__field(struct urb*, urb)
		__field(struct pwc_frame_buf*, fbuf)
		__field(int, urb__status)
		__field(u32, urb__actual_length)
		__field(int, fbuf__filled)
		__string(name, pdev->v4l2_dev.name)

Best to have names at the end, as in the future I may be able to
optimize dynamic arrays (like strings) better, if there's only one and
its at the end of the structure.

> +	),
> +	TP_fast_assign(
> +		__entry->urb = urb;
> +		__entry->urb__status = urb->status;
> +		__entry->urb__actual_length = urb->actual_length;
> +		__assign_str(name, pdev->v4l2_dev.name);
> +		__entry->fbuf = pdev->fill_buf;
> +		__entry->fbuf__filled = (pdev->fill_buf
> +					 ? pdev->fill_buf->filled : 0);
> +	),
> +	TP_printk("dev=%s (fbuf=%p filled=%d) urb=%p (status=%d actual_length=%u)",
> +		__get_str(name),
> +		__entry->fbuf,
> +		__entry->fbuf__filled,
> +		__entry->urb,
> +		__entry->urb__status,
> +		__entry->urb__actual_length)
> +);
> +
> +TRACE_EVENT(pwc_handler_exit,
> +	TP_PROTO(struct urb *urb, struct pwc_device *pdev),
> +	TP_ARGS(urb, pdev),
> +	TP_STRUCT__entry(
> +		__field(struct urb*, urb)
> +		__string(name, pdev->v4l2_dev.name)
> +		__field(struct pwc_frame_buf*, fbuf)
> +		__field(int, fbuf__filled)

This I would just move name to the end.

Thanks!

-- Steve

> +	),
> +	TP_fast_assign(
> +		__entry->urb = urb;
> +		__assign_str(name, pdev->v4l2_dev.name);
> +		__entry->fbuf = pdev->fill_buf;
> +		__entry->fbuf__filled = pdev->fill_buf->filled;
> +	),
> +	TP_printk(" dev=%s (fbuf=%p filled=%d) urb=%p",
> +		__get_str(name),
> +		__entry->fbuf,
> +		__entry->fbuf__filled,
> +		__entry->urb)
> +);
> +
> +#endif /* _TRACE_PWC_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
