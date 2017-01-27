Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:36301 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932750AbdA0RQl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 12:16:41 -0500
MIME-Version: 1.0
In-Reply-To: <20161101203346.GE30087@uda0271908>
References: <CAJs94EYkgXtr7P+HLsBnu6=j==g=wWRVFy91vofcdDziSfw60w@mail.gmail.com>
 <20160830183039.GA20056@uda0271908> <CAJs94EZbTT7TyEyc5QjKvybDdR1hORd-z1sD=yyYNj=kzPQ6tw@mail.gmail.com>
 <20160912032826.GB18340@uda0271908> <CAJs94EbNjkjN4eMY03eH3o=xVe+CGB95GQ+a5PsmsNUrDzi8mQ@mail.gmail.com>
 <20160912185709.GL18340@uda0271908> <CAJs94EaNwOiqTASzr2LQDWeCHnzoQQWndDsSg75YUuHLQhcuUw@mail.gmail.com>
 <CAJs94EZXjETQGj44hphs61g9W1r-o9vJc+yy+9CeaxBy7Sa0Tg@mail.gmail.com> <20161101203346.GE30087@uda0271908>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Fri, 27 Jan 2017 20:13:23 +0300
Message-ID: <CAJs94EY==ZYQ38w1L8OUhDt2jdV-JACX5MDCN2s8S_4ZfikSdw@mail.gmail.com>
Subject: Re: musb: isoc pkt loss with pwc
To: Bin Liu <b-liu@ti.com>, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, hdegoede@redhat.com,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-11-01 23:33 GMT+03:00 Bin Liu <b-liu@ti.com>:
> On Sat, Oct 15, 2016 at 10:25:42PM +0300, Matwey V. Kornilov wrote:
>
> [snip]
>
>> >>> > Which means without this commit your camera has been working without
>> >>> > issues, and this is a regression with this commit, right?
>> >>> >
>> >>>
>> >>> Right
>> >>
>> >> Okay, thanks for confirming.
>> >>
>> >> But we cannot just simply add this flag, as it breaks many other use
>> >> cases. I will continue work on this to find a solution which works on
>> >> all use cases.
>> >>
>> >
>> > Ok, thank you.
>> >
>>
>> Excuse me. Any news?
>
> Not solved yet. I used uvc class to exam the issue. uvc_video driver
> takes longer time to execute urb complete() on my platform. Using HCD_BH
> flag doesn't help, because urb->complete() was running with irq disabled
> because of the local_irq. Removing the local_irq as in [1] causes the
> system to lockup - uart and network stop responsing, so hard to debug
> for now.
>
> Right now, I added a workqueue in musb_host to handle urb->complete()
> with local_irq removed. It seems working fine in my test, but it is
> still a long way find the proper fix for upstream. I didn't have much
> time on this issue.
>
> Once I have a proper solution, I will post it to the mailing list.
>

Maybe I could help somehow?

> [1] http://marc.info/?l=linux-usb&m=147560701431267&w=2
>
> Regards,
> -Bin.
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
