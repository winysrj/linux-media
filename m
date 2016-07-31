Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36178 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcGaViB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2016 17:38:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAJs94EYzTXJsr6vPw+MmtHUCzcoyxDmSmU-04YENP-9mZ5MdgA@mail.gmail.com>
References: <1468959677-1768-1-git-send-email-matwey@sai.msu.ru>
 <20160719205600.GA14569@uda0271908> <CAJs94EY_cXLA6eggC391eKiPBS-RVPmfPd7Wh4mhjZTQiCSUrA@mail.gmail.com>
 <20160719213426.GB14569@uda0271908> <CAJs94EbS7C+m_+P61QReAwn=93Yp0B7x4dZ32A8mMAZAM5+osQ@mail.gmail.com>
 <20160720141334.GC14569@uda0271908> <CAJs94Eb-Z4103JgEL6Xu_tesJ+d81F13UKhuCmVc3DPCBZ8z5w@mail.gmail.com>
 <20160720150614.GD14569@uda0271908> <CAJs94Eb42kTp0i=Oagip5uGtVTNh6JgoAp_q--+nNGZufD1chA@mail.gmail.com>
 <CAJs94EZt_gw=xenU8Yt79tZxT_jGUW7w1SQjjh2Oe9aCCXSm7A@mail.gmail.com>
 <CAJs94EYPwWivWfsrUtETJZp5HHmpT5Qvujq0RexcgHm+k657aQ@mail.gmail.com>
 <CAJs94Eb=iPC57N8ecvmOr__1LhTjFTuRtHd1svDbwgVXtYX5=g@mail.gmail.com> <CAJs94EYzTXJsr6vPw+MmtHUCzcoyxDmSmU-04YENP-9mZ5MdgA@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Sun, 31 Jul 2016 23:31:30 +0300
Message-ID: <CAJs94EbpTzpzDeubBGOaqPavwBHzgKhb9E0MN0_v_irWRRwJDQ@mail.gmail.com>
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
To: Bin Liu <b-liu@ti.com>, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
	hdegoede@redhat.com, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've also just found that the same commit breaks cpufreq on BeagleBone Black :)

So, probably without HCD_BH flag musb works correctly only at 1Ghz CPU
frequency, which is unlisted and being set to 720Mhz by cpufreq driver
(as it did whet there was cpufreq driver).

2016-07-29 21:01 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
> Hello,
>
> I've found that the following commit fixes the issue:
>
> commit 7694ca6e1d6f01122f05039b81f70f64b1ec4063
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Fri Apr 22 16:58:42 2016 +0530
>
>     cpufreq: omap: Use generic platdev driver
>
>     The cpufreq-dt-platdev driver supports creation of cpufreq-dt platform
>     device now, reuse that and remove similar code from platform code.
>
>
> 2016-07-28 19:16 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
>> Hello,
>>
>> I've just bisected commit, which fixed the issue in v4.7
>>
>> commit 9fa64d6424adabf0e3a546ae24d01a62a927b342
>> Merge: f55532a febce40
>> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Date:   Sat Apr 2 01:07:17 2016 +0200
>>
>>     Merge back intel_pstate fixes for v4.6.
>>
>>     * pm-cpufreq:
>>       intel_pstate: Avoid extra invocation of intel_pstate_sample()
>>       intel_pstate: Do not set utilization update hook too early
>>
>> Unfortunately, intel_pstate branch doesn't have
>> f551e13529833e052f75ec628a8af7b034af20f9 applied.
>> I'll try to bisect this branch with the patch manually applied.
>>
>> 2016-07-27 20:34 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
>>> Hello,
>>>
>>> I've just biseced commit, which introduced this issue
>>>
>>> commit f551e13529833e052f75ec628a8af7b034af20f9
>>> Author: Bin Liu <b-liu@ti.com>
>>> Date:   Mon Apr 25 15:53:30 2016 -0500
>>>
>>>     Revert "usb: musb: musb_host: Enable HCD_BH flag to handle urb
>>> return in bottom half"
>>>
>>> I have not checked yet, if it was intentionnaly fixed.
>>>
>>> 2016-07-23 22:24 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
>>>> 2016-07-20 21:56 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
>>>>> 2016-07-20 18:06 GMT+03:00 Bin Liu <b-liu@ti.com>:
>>>>>> Hi,
>>>>>>
>>>>>> On Wed, Jul 20, 2016 at 05:44:56PM +0300, Matwey V. Kornilov wrote:
>>>>>>> 2016-07-20 17:13 GMT+03:00 Bin Liu <b-liu@ti.com>:
>>>>>>> > Hi,
>>>>>>> >
>>>>>>> > On Wed, Jul 20, 2016 at 09:09:42AM +0300, Matwey V. Kornilov wrote:
>>>>>>> >> 2016-07-20 0:34 GMT+03:00 Bin Liu <b-liu@ti.com>:
>>>>>>> >> > Hi,
>>>>>>> >> >
>>>>>>> >> > On Wed, Jul 20, 2016 at 12:25:44AM +0300, Matwey V. Kornilov wrote:
>>>>>>> >> >> 2016-07-19 23:56 GMT+03:00 Bin Liu <b-liu@ti.com>:
>>>>>>> >> >> > Hi,
>>>>>>> >> >> >
>>>>>>> >> >> > On Tue, Jul 19, 2016 at 11:21:17PM +0300, matwey@sai.msu.ru wrote:
>>>>>>> >> >> >> Hello,
>>>>>>> >> >> >>
>>>>>>> >> >> >> I have Philips SPC 900 camera (0471:0329) connected to my AM335x based BeagleBoneBlack SBC.
>>>>>>> >> >> >> I am sure that both of them are fine and work properly.
>>>>>>> >> >> >> I am running Linux 4.6.4 (my kernel config is available at https://clck.ru/A2kQs ) and I've just discovered, that there is an issue with frame transfer when high resolution formats are used.
>>>>>>> >> >> >>
>>>>>>> >> >> >> The issue is the following. I use simple v4l2 example tool (taken from API docs), which source code is available at http://pastebin.com/grcNXxfe
>>>>>>> >> >> >>
>>>>>>> >> >> >> When I use (see line 488) 640x480 frames
>>>>>>> >> >> >>
>>>>>>> >> >> >>                 fmt.fmt.pix.width       = 640;
>>>>>>> >> >> >>                 fmt.fmt.pix.height      = 480;
>>>>>>> >> >> >>
>>>>>>> >> >> >> then I get "select timeout" and don't get any frames.
>>>>>>> >> >> >>
>>>>>>> >> >> >> When I use 320x240 frames
>>>>>>> >> >> >>
>>>>>>> >> >> >>                 fmt.fmt.pix.width       = 320;
>>>>>>> >> >> >>                 fmt.fmt.pix.height      = 240;
>>>>>>> >> >> >>
>>>>>>> >> >> >> then about 60% frames are missed. An example outpout of ./a.out -f is available at https://yadi.sk/d/aRka8xWPtSc4y
>>>>>>> >> >> >> It looks like there are pauses between bulks of frames (frame counter and timestamp as returned from v4l2 API):
>>>>>>> >> >> >>
>>>>>>> >> >> >> 3 3705.142553
>>>>>>> >> >> >> 8 3705.342533
>>>>>>> >> >> >> 13 3705.542517
>>>>>>> >> >> >> 110 3708.776208
>>>>>>> >> >> >> 115 3708.976190
>>>>>>> >> >> >> 120 3709.176169
>>>>>>> >> >> >> 125 3709.376152
>>>>>>> >> >> >> 130 3709.576144
>>>>>>> >> >> >> 226 3712.807848
>>>>>>> >> >> >>
>>>>>>> >> >> >> When I use tiny 160x120 frames
>>>>>>> >> >> >>
>>>>>>> >> >> >>                 fmt.fmt.pix.width       = 160;
>>>>>>> >> >> >>                 fmt.fmt.pix.height      = 120;
>>>>>>> >> >> >>
>>>>>>> >> >> >> then more frames are received. See output example at https://yadi.sk/d/DedBmH6ftSc9t
>>>>>>> >> >> >> That is why I thought that everything was fine in May when used tiny xawtv window to check kernel OOPS presence (see http://www.spinics.net/lists/linux-usb/msg141188.html for reference)
>>>>>>> >> >> >>
>>>>>>> >> >> >> Even more. When I introduce USB hub between the host and the webcam, I can not receive even any 320x240 frames.
>>>>>>> >> >> >>
>>>>>>> >> >> >> I've managed to use ftrace to see what is going on when no frames are received.
>>>>>>> >> >> >> I've found that pwc_isoc_handler is called frequently as the following:
>>>>>>> >> >> >>
>>>>>>> >> >> >>  0)               |  pwc_isoc_handler [pwc]() {
>>>>>>> >> >> >>  0)               |    usb_submit_urb [usbcore]() {
>>>>>>> >> >> >>  0)               |      usb_submit_urb.part.3 [usbcore]() {
>>>>>>> >> >> >>  0)               |        usb_hcd_submit_urb [usbcore]() {
>>>>>>> >> >> >>  0)   0.834 us    |          usb_get_urb [usbcore]();
>>>>>>> >> >> >>  0)               |          musb_map_urb_for_dma [musb_hdrc]() {
>>>>>>> >> >> >>  0)   0.792 us    |            usb_hcd_map_urb_for_dma [usbcore]();
>>>>>>> >> >> >>  0)   5.750 us    |          }
>>>>>>> >> >> >>  0)               |          musb_urb_enqueue [musb_hdrc]() {
>>>>>>> >> >> >>  0)   0.750 us    |            _raw_spin_lock_irqsave();
>>>>>>> >> >> >>  0)               |            usb_hcd_link_urb_to_ep [usbcore]() {
>>>>>>> >> >> >>  0)   0.792 us    |              _raw_spin_lock();
>>>>>>> >> >> >>  0)   0.791 us    |              _raw_spin_unlock();
>>>>>>> >> >> >>  0) + 10.500 us   |            }
>>>>>>> >> >> >>  0)   0.791 us    |            _raw_spin_unlock_irqrestore();
>>>>>>> >> >> >>  0) + 25.375 us   |          }
>>>>>>> >> >> >>  0) + 45.208 us   |        }
>>>>>>> >> >> >>  0) + 51.042 us   |      }
>>>>>>> >> >> >>  0) + 56.084 us   |    }
>>>>>>> >> >> >>  0) + 61.292 us   |  }
>>>>>>> >> >> >>
>>>>>>> >> >> >> However, pwc_isoc_handler never calls vb2_buffer_done() that is why I get "select timeout" in userspace.
>>>>>>> >> >> >> Unfortunately, my kernel is not compiled with CONFIG_USB_PWC_DEBUG=y but I can recompile it, if you think that it could provide more information. I am also ready to perform additional tests (use usbmon maybe?).
>>>>>>> >> >> >>
>>>>>>> >> >> >> How could this issue be resolved?
>>>>>>> >> >> >>
>>>>>>> >> >> >> Thank you.
>>>>>>> >> >> >
>>>>>>> >> >> > Do you have CPPI DMA enabled? If so I think you might hit on a known
>>>>>>> >> >> > issue in CPPI Isoch transfer, in which the MUSB controller only sends IN
>>>>>>> >> >> > tokens in every other SOF, so only half of the bus bandwidth is
>>>>>>> >> >> > utilized, which causes video frame drops in higher resolution.
>>>>>>> >> >> >
>>>>>>> >> >>
>>>>>>> >> >> Yes, I do use DMA:
>>>>>>> >> >>
>>>>>>> >> >> CONFIG_USB_TI_CPPI41_DMA=y
>>>>>>> >> >
>>>>>>> >> > Okay.
>>>>>>> >> >
>>>>>>> >> >>
>>>>>>> >> >> > To confirm this, use a bus analyzer to capture a bus trace, you would
>>>>>>> >> >> > see no IN tokens in every other SOF while transfering Isoch packets.
>>>>>>> >> >> >
>>>>>>> >> >>
>>>>>>> >> >> I am sorry, I am new to USB debugging. Do you mean I need to use
>>>>>>> >> >> usbmon or some external hardware device?
>>>>>>> >> >
>>>>>>> >> > I barely use usbmon, and not sure if it gives the information I am
>>>>>>> >> > looking for. But I meant the external test equipment - USB bus protocol
>>>>>>> >> > analyzer - a bus packet sniffer.
>>>>>>> >> >
>>>>>>> >>
>>>>>>> >> Now I see. I've googled it, they start from $1000, I don't know
>>>>>>> >> when/whether/where I can get one to try.
>>>>>>> >
>>>>>>> > I think you might be able to check it without a sniffer - MUSB
>>>>>>> > controller can generate SOF interrupts, but it is masked in current
>>>>>>> > driver. So I think you could enable SOF interrupt, then if you get a log
>>>>>>> > as
>>>>>>> >         SOF
>>>>>>> >         rx packet
>>>>>>> >         SOF
>>>>>>> >         rx packet
>>>>>>> >         SOF
>>>>>>> >         ...
>>>>>>> > or
>>>>>>> >         SOF
>>>>>>> >         rx packet
>>>>>>> >         rx packet
>>>>>>> >         rx packet
>>>>>>> >         SOF
>>>>>>> >         rx packet
>>>>>>> >         rx packet
>>>>>>> >         rx packet
>>>>>>> >         SOF
>>>>>>> >         ...
>>>>>>> >
>>>>>>> > which means your issue is different from the one I mentioned. But if
>>>>>>> > you get a log as
>>>>>>> >
>>>>>>> >         SOF
>>>>>>> >         rx packet
>>>>>>> >         SOF
>>>>>>> >         SOF     <--- no rx packets in two consecutive SOFs
>>>>>>> >         rx packet
>>>>>>> >         SOF
>>>>>>> >         SOF
>>>>>>> >
>>>>>>> > then you hit on the known issue I mentioned.
>>>>>>> >
>>>>>>> >> Until that, could I check something else? For instance, disable
>>>>>>> >> CONFIG_USB_TI_CPPI41_DMA.
>>>>>>> >
>>>>>>> > You could disable it, but I don't think you will get yuv video stream
>>>>>>> > of 640x480@30fps. PIO mode does not support such high bandwidth. What is
>>>>>>> > your video requirement anyway?
>>>>>>>
>>>>>>> Many thanks for your guidance. I will answer the rest later when will
>>>>>>> be ready to play with SOF interrupt.
>>>>>>> Now, I would like to say that use_dma=0 doesn't change the behaviour:
>>>>>>>
>>>>>>> # cat /sys/module/musb_hdrc/parameters/use_dma
>>>>>>> N
>>>>>>
>>>>>> It sounds like you have a different issue here. With usb_dma=0, I
>>>>>> remembered I can get 320x240 YUV stream @30fps from uvc cameras.
>>>>>>
>>>>>>>
>>>>>>> I would like 640x480@5fps which works with x86 based PC. Issue here,
>>>>>>> that I can not obtain 640x480 at any FPS on musb.
>>>>>>
>>>>>> The current CPPI41 driver should be able to handle this. I think you
>>>>>> really have to debug the pwc driver to figure out why it drops the video
>>>>>> frame. I personally don't have a pwc supported camera, never looked the
>>>>>> pwc driver...
>>>>>
>>>>> Surprisingly, I've found that my 10-year-old laptop (Intel Core Solo
>>>>> T1350) has the similar issue with pwc (kernel 3.16). It drops 80% of
>>>>> 640x480 frames.
>>>>> Vortex86 200Mhz based rugged PC with 2.6.14 works fine.
>>>>> Quad-code Atom E3800 based PC with 4.1 also works fine.
>>>>>
>>>>> So, I even don't know what to say. Probably, the issue depends on CPU
>>>>> latency/performance and it was there for a while.
>>>>> Fortunately, I think, I could use git bisect if I found latest forking
>>>>> kernel for my laptop.
>>>>>
>>>>
>>>> It seems that the issue is gone in 4.7-rc7, so forget it.
>>>>
>>>>>>
>>>>>>>
>>>>>>> >
>>>>>>> >>
>>>>>>> >> I've found that after hours of transmit, the camera stops iso at all
>>>>>>> >> (until reset). Maybe its brain becomes damaged by the transfer issues
>>>>>>> >
>>>>>>> > How did you check that? MUSB stopped generating RX EP interrupt?
>>>>>>>
>>>>>>> Something like that, I suppose. Normally, I see input data flow in
>>>>>>> usbmon, but don't see frames in v4l2.
>>>>>>> But when camera 'hungs', I don't see nor input flow (except the
>>>>>>> control packages exchange) neither frames.
>>>>>>
>>>>>> Fair enough.
>>>>>>
>>>>>> Regards,
>>>>>> -Bin.
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> With best regards,
>>>>> Matwey V. Kornilov.
>>>>> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
>>>>> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
>>>>
>>>>
>>>>
>>>> --
>>>> With best regards,
>>>> Matwey V. Kornilov.
>>>> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
>>>> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
>>>
>>>
>>>
>>> --
>>> With best regards,
>>> Matwey V. Kornilov.
>>> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
>>> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
>>
>>
>>
>> --
>> With best regards,
>> Matwey V. Kornilov.
>> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
>> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
>
>
>
> --
> With best regards,
> Matwey V. Kornilov.
> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
