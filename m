Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36982 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbcH3Uo4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 16:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <20160830183039.GA20056@uda0271908>
References: <CAJs94EYkgXtr7P+HLsBnu6=j==g=wWRVFy91vofcdDziSfw60w@mail.gmail.com>
 <20160830183039.GA20056@uda0271908>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Tue, 30 Aug 2016 23:44:33 +0300
Message-ID: <CAJs94EZbTT7TyEyc5QjKvybDdR1hORd-z1sD=yyYNj=kzPQ6tw@mail.gmail.com>
Subject: Re: musb: isoc pkt loss with pwc
To: Bin Liu <b-liu@ti.com>, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, hdegoede@redhat.com,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-08-30 21:30 GMT+03:00 Bin Liu <b-liu@ti.com>:
> Hi,
>
> On Sun, Aug 28, 2016 at 01:13:55PM +0300, Matwey V. Kornilov wrote:
>> Hello Bin,
>>
>> I would like to start new thread on my issue. Let me recall where the issue is:
>> There is 100% frame lost in pwc webcam driver due to lots of
>> zero-length packages coming from musb driver.
>
> What is the video resolution and fps?

640x480 YUV420 10 frames per second.
pwc uses proprietary compression during device-host transmission, but
I don't know how effective it is.

>
>> The issue is present in all kernels (including 4.8) starting from the commit:
>>
>> f551e13529833e052f75ec628a8af7b034af20f9 ("Revert "usb: musb:
>> musb_host: Enable HCD_BH flag to handle urb return in bottom half"")
>
> What is the behavior without this commit?

Without this commit all frames are being received correctly. Single
one issue is a number of zero byte package at the beginning of iso
stream (probably during camera internal sync, I have to check how the
stream is started on x86 later). But they are never repeated after
this.

>>
>> The issue is here both when DMA enabled and DMA disabled.
>>
>> Attached here is a plot. The vertical axis designates the value of
>> rx_count variable from function musb_host_packet_rx(). One may see
>> that there are only two possibilities: 0 bytes and 956 bytes.
>> The horizontal axis is the last three digits of the timestamp when
>> musb_host_packet_rx() invoked. I.e for [   38.115379] it is 379. Given
>> that my webcam is USB 1.1 and base time is 1 ms, then all frames
>> should be grouped close to some single value. (Repeating package
>> receive event every 1 ms won't change last tree digits considerably)
>> One may see that it is not true, in practice there are two groups. And
>> receive time strongly correlates with the package size. Packages
>> received near round ms are 956 bytes long, packages received near 400
>> us are 0 bytes long.
>
> When the host IN packet passed the deadline, the device drops the video
> data, so device only sends 0 byte packet (or 12 bytes which is only the
> uvc header without data payload).

Doesn't it mean that free part of the frame, i.e (1 msec - (t_IN -
t_SOF)) is not enough to transmit 956 bytes in device firmware
opinion?

>
>>
>> I don't know how exactly SOF and IN are synchronized in musb, could
>> someone give a hint? But from what I see the time difference between
>> subsequent IN package requests is sometimes more than 1 ms due to
>> heavy urb->complete() callback. After such events only zero length
>
> Why musb delayed the IN packets, it needs to be investigated.  I will
> start to look at this webcam issue with musb soon, after I cleaned up
> the musb patches queued recently. I will update once I have progress in
> my investigation.

The last package in URB has different code path.
IN after the last package of URB is not requested in musb_host_packet_rx().
Instead, IN request is performed in the end of musb_advance_schedule()
by musb_start_urb().
musb_advance_schedule() has the following code:

        qh->is_ready = 0;
        musb_giveback(musb, urb, status);
        qh->is_ready = ready;

Which can be executed pretty long if urb->complete() handler is not
postphoned by HCD_BH.
In my case, it takes about 300 us for pwc urb->complete() to run.
Probably, the logic should be modified here, to run giveback on
current URB after the start of next URB.

>
>> packages are received. Surprisingly, that `synchronization' is
>> recovered sometimes in the middle of URB like the following:
>>
>> [  163.207363] musb int
>> [  163.207380] rx_count 0
>> [  163.207393] req pkt c9c76200 // Expected musb int at 163.208393
>> [  163.207403] int end
>> // No interrupt at 163.208393
>> [  163.209001] musb int
>> [  163.209017] rx_count 956
>> [  163.209108] req pkt c9c76200
>> [  163.209118] int end
>
> It looks like you used plain printk for these debug logs, which normally
> is not a good idea for this type of performance debugging. printk
> changes timing especially if the log is printed via uart console.
>

I think next time I will use tracepoints or something like that. Thank
you for pointing.

>> And then the series of 956 bytes long packages are received until URB
>> giveback will occasionally break it again.
>> Do I understand correctly, that SOF is generated every 1 ms by
>> hardware and should be followed by IN immediately?
>
> My understanding is that is does not have to be 'immediately', for
> example, in a few ns, it should be okay as long as the interval of IN
> packets is fixed, but I forgot what the tolerance is, I haven't read the
> related Specs for a long time.

But, If IN is postponed by 500 usec, then it means that half of frame
is wasted for isochronous transmission. Right?

>
>> If so, it is not clear to me how they should be aligned when the time
>> difference between to subsequent INs is greater than 1ms.
>
> It is up to the device firmware, which should have an internal clock to
> sync the received IN packets, and adjust the data payload to be send.
> This is the basics in video/audio applications.
>
> Regards,
> -Bin.
>
>>
>> --
>> With best regards,
>> Matwey V. Kornilov.
>> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
>> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
>
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
