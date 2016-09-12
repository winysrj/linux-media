Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34973 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751044AbcILTjC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 15:39:02 -0400
MIME-Version: 1.0
In-Reply-To: <20160912185709.GL18340@uda0271908>
References: <CAJs94EYkgXtr7P+HLsBnu6=j==g=wWRVFy91vofcdDziSfw60w@mail.gmail.com>
 <20160830183039.GA20056@uda0271908> <CAJs94EZbTT7TyEyc5QjKvybDdR1hORd-z1sD=yyYNj=kzPQ6tw@mail.gmail.com>
 <20160912032826.GB18340@uda0271908> <CAJs94EbNjkjN4eMY03eH3o=xVe+CGB95GQ+a5PsmsNUrDzi8mQ@mail.gmail.com>
 <20160912185709.GL18340@uda0271908>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Mon, 12 Sep 2016 22:38:40 +0300
Message-ID: <CAJs94EaNwOiqTASzr2LQDWeCHnzoQQWndDsSg75YUuHLQhcuUw@mail.gmail.com>
Subject: Re: musb: isoc pkt loss with pwc
To: Bin Liu <b-liu@ti.com>, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, hdegoede@redhat.com,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-09-12 21:57 GMT+03:00 Bin Liu <b-liu@ti.com>:
> Hi,
>
> On Mon, Sep 12, 2016 at 11:52:46AM +0300, Matwey V. Kornilov wrote:
>> 2016-09-12 6:28 GMT+03:00 Bin Liu <b-liu@ti.com>:
>> > Hi,
>> >
>> > On Tue, Aug 30, 2016 at 11:44:33PM +0300, Matwey V. Kornilov wrote:
>> >> 2016-08-30 21:30 GMT+03:00 Bin Liu <b-liu@ti.com>:
>> >> > Hi,
>> >> >
>> >> > On Sun, Aug 28, 2016 at 01:13:55PM +0300, Matwey V. Kornilov wrote:
>> >> >> Hello Bin,
>> >> >>
>> >> >> I would like to start new thread on my issue. Let me recall where the issue is:
>> >> >> There is 100% frame lost in pwc webcam driver due to lots of
>> >> >> zero-length packages coming from musb driver.
>> >> >
>> >> > What is the video resolution and fps?
>> >>
>> >> 640x480 YUV420 10 frames per second.
>> >> pwc uses proprietary compression during device-host transmission, but
>> >> I don't know how effective it is.
>> >
>> > The data rate for VGA YUV420 @10fps is 640x480*1.5*10 = 4.6MB/s, which
>> > is much higher than full-speed 12Mbps.  So the video data on the bus is
>> > compressed, not YUV420, I believe.
>> >
>> >>
>> >> >
>> >> >> The issue is present in all kernels (including 4.8) starting from the commit:
>> >> >>
>> >> >> f551e13529833e052f75ec628a8af7b034af20f9 ("Revert "usb: musb:
>> >> >> musb_host: Enable HCD_BH flag to handle urb return in bottom half"")
>> >> >
>> >> > What is the behavior without this commit?
>> >>
>> >> Without this commit all frames are being received correctly. Single
>> >
>> > Which means without this commit your camera has been working without
>> > issues, and this is a regression with this commit, right?
>> >
>>
>> Right
>
> Okay, thanks for confirming.
>
> But we cannot just simply add this flag, as it breaks many other use
> cases. I will continue work on this to find a solution which works on
> all use cases.
>

Ok, thank you.

> Regards,
> -Bin.
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
