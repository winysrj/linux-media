Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36786 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754166AbeFTI2f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 04:28:35 -0400
MIME-Version: 1.0
In-Reply-To: <20180619123329.52bf6216@gandalf.local.home>
References: <20180617143625.32133-1-matwey@sai.msu.ru> <20180618145854.2092c6e0@gandalf.local.home>
 <CAJs94EZAAuUS4rznPDmD=1aD8B72P0mLft+YDoNs+74pRXr+KA@mail.gmail.com> <20180619123329.52bf6216@gandalf.local.home>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Wed, 20 Jun 2018 11:05:51 +0300
Message-ID: <CAJs94EZTyfh7vuNt3Dsz6wYdhwc93Np6-UbpDKFupHKaHqxgJQ@mail.gmail.com>
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

2018-06-19 19:33 GMT+03:00 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 19 Jun 2018 19:23:04 +0300
> "Matwey V. Kornilov" <matwey@sai.msu.ru> wrote:
>
>> Hi Steven,
>>
>> Thank you for valuable comments.
>>
>> This is for measuring performance of URB completion callback inside PWC driver.
>> What do you think about moving events to __usb_hcd_giveback_urb() in
>> order to make this more generic? Like the following:
>>
>>         local_irq_save(flags);
>> // trace urb complete enter
>>         urb->complete(urb);
>> // trace urb complete exit
>>         local_irq_restore(flags);
>>
>>
>
> If that can work for you, I'm fine with that. Trace events may be
> cheap, but they do come with some cost. I'd like to have all trace
> events be as valuable as possible, and limit the "special case" ones.

What is the cost for events? I suppose one conditional check when
trace is disabled? There is already similar debugging stuff related to
usbmon in __usb_hcd_giveback_urb(), so I don't think that another
conditional check will hurt performance dramatically there. When
discussing second patch in this series I see that the issue that it is
intended to resolve may be common to other USB media drivers.


>
> -- Steve
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
