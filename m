Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:46593 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966208AbeFSQX0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 12:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <20180618145854.2092c6e0@gandalf.local.home>
References: <20180617143625.32133-1-matwey@sai.msu.ru> <20180618145854.2092c6e0@gandalf.local.home>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Tue, 19 Jun 2018 19:23:04 +0300
Message-ID: <CAJs94EZAAuUS4rznPDmD=1aD8B72P0mLft+YDoNs+74pRXr+KA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add TRACE_EVENTs in pwc_isoc_handler()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        linux-media@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,

Thank you for valuable comments.

This is for measuring performance of URB completion callback inside PWC driver.
What do you think about moving events to __usb_hcd_giveback_urb() in
order to make this more generic? Like the following:

        local_irq_save(flags);
// trace urb complete enter
        urb->complete(urb);
// trace urb complete exit
        local_irq_restore(flags);


2018-06-18 21:58 GMT+03:00 Steven Rostedt <rostedt@goodmis.org>:
> On Sun, 17 Jun 2018 17:36:24 +0300
> "Matwey V. Kornilov" <matwey@sai.msu.ru> wrote:
>
> I would prefer a change log here that would explain why these
> tracepoints are being added.
>
>
>> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
>> ---
>>  drivers/media/usb/pwc/pwc-if.c |  7 +++++++
>>  include/trace/events/pwc.h     | 45 ++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 52 insertions(+)
>>  create mode 100644 include/trace/events/pwc.h
>>
>> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
>> index 54b036d39c5b..5775d1f60668 100644
>> --- a/drivers/media/usb/pwc/pwc-if.c
>> +++ b/drivers/media/usb/pwc/pwc-if.c
>> @@ -57,6 +57,9 @@
>>     - Pham Thanh Nam: webcam snapshot button as an event input device
>>  */
>>
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/pwc.h>
>> +
>>  #include <linux/errno.h>
>>  #include <linux/init.h>
>>  #include <linux/mm.h>
>> @@ -260,6 +263,8 @@ static void pwc_isoc_handler(struct urb *urb)
>>       int i, fst, flen;
>>       unsigned char *iso_buf = NULL;
>>
>> +     trace_pwc_handler_enter(urb);
>> +
>>       if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
>>           urb->status == -ESHUTDOWN) {
>>               PWC_DEBUG_OPEN("URB (%p) unlinked %ssynchronously.\n",
>
> Looks like if this is hit, we will return from the function without
> calling trace_pwc_handler_exit().
>
>> @@ -347,6 +352,8 @@ static void pwc_isoc_handler(struct urb *urb)
>>               pdev->vlast_packet_size = flen;
>>       }
>>
>> +     trace_pwc_handler_exit(urb);
>> +
>>  handler_end:
>
> Why not add the tracepoint after handler_end. In fact, why not add some
> exit status to the trace event? I would think that would be useful as
> well.
>
>
>>       i = usb_submit_urb(urb, GFP_ATOMIC);
>>       if (i != 0)
>> diff --git a/include/trace/events/pwc.h b/include/trace/events/pwc.h
>> new file mode 100644
>> index 000000000000..b13d2118bb7a
>> --- /dev/null
>> +++ b/include/trace/events/pwc.h
>> @@ -0,0 +1,45 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#if !defined(_TRACE_PWC_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_PWC_H
>> +
>> +#include <linux/usb.h>
>> +#include <linux/tracepoint.h>
>> +
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM pwc
>> +
>> +TRACE_EVENT(pwc_handler_enter,
>> +     TP_PROTO(struct urb *urb),
>> +     TP_ARGS(urb),
>> +     TP_STRUCT__entry(
>> +             __field(struct urb*, urb)
>> +             __field(int, urb__status)
>> +             __field(u32, urb__actual_length)
>> +     ),
>> +     TP_fast_assign(
>> +             __entry->urb = urb;
>> +             __entry->urb__status = urb->status;
>> +             __entry->urb__actual_length = urb->actual_length;
>
> Is there any other data that may be interesting to record here?
>
> -- Steve
>
>> +     ),
>> +     TP_printk("urb=%p (status=%d actual_length=%u)",
>> +             __entry->urb,
>> +             __entry->urb__status,
>> +             __entry->urb__actual_length)
>> +);
>> +
>> +TRACE_EVENT(pwc_handler_exit,
>> +     TP_PROTO(struct urb *urb),
>> +     TP_ARGS(urb),
>> +     TP_STRUCT__entry(
>> +             __field(struct urb*, urb)
>> +     ),
>> +     TP_fast_assign(
>> +             __entry->urb = urb;
>> +     ),
>> +     TP_printk("urb=%p", __entry->urb)
>> +);
>> +
>> +#endif /* _TRACE_PWC_H */
>> +
>> +/* This part must be outside protection */
>> +#include <trace/define_trace.h>
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
