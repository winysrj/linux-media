Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34711 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbcGTIWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 04:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAJs94EbS7C+m_+P61QReAwn=93Yp0B7x4dZ32A8mMAZAM5+osQ@mail.gmail.com>
References: <1468959677-1768-1-git-send-email-matwey@sai.msu.ru>
 <20160719205600.GA14569@uda0271908> <CAJs94EY_cXLA6eggC391eKiPBS-RVPmfPd7Wh4mhjZTQiCSUrA@mail.gmail.com>
 <20160719213426.GB14569@uda0271908> <CAJs94EbS7C+m_+P61QReAwn=93Yp0B7x4dZ32A8mMAZAM5+osQ@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Wed, 20 Jul 2016 11:21:48 +0300
Message-ID: <CAJs94EYKgF9t6Vt-xYO9v1oXqsrgeEf_cUegdA5Updf3cGcqNA@mail.gmail.com>
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
To: Bin Liu <b-liu@ti.com>, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
	hdegoede@redhat.com, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-07-20 9:09 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
> 2016-07-20 0:34 GMT+03:00 Bin Liu <b-liu@ti.com>:
>> Hi,
>>
>> On Wed, Jul 20, 2016 at 12:25:44AM +0300, Matwey V. Kornilov wrote:
>>> 2016-07-19 23:56 GMT+03:00 Bin Liu <b-liu@ti.com>:
>>> > Hi,
>>> >
>>> > On Tue, Jul 19, 2016 at 11:21:17PM +0300, matwey@sai.msu.ru wrote:
>>> >> Hello,
>>> >>
>>> >> I have Philips SPC 900 camera (0471:0329) connected to my AM335x based BeagleBoneBlack SBC.
>>> >> I am sure that both of them are fine and work properly.
>>> >> I am running Linux 4.6.4 (my kernel config is available at https://clck.ru/A2kQs ) and I've just discovered, that there is an issue with frame transfer when high resolution formats are used.
>>> >>
>>> >> The issue is the following. I use simple v4l2 example tool (taken from API docs), which source code is available at http://pastebin.com/grcNXxfe
>>> >>
>>> >> When I use (see line 488) 640x480 frames
>>> >>
>>> >>                 fmt.fmt.pix.width       = 640;
>>> >>                 fmt.fmt.pix.height      = 480;
>>> >>
>>> >> then I get "select timeout" and don't get any frames.
>>> >>
>>> >> When I use 320x240 frames
>>> >>
>>> >>                 fmt.fmt.pix.width       = 320;
>>> >>                 fmt.fmt.pix.height      = 240;
>>> >>
>>> >> then about 60% frames are missed. An example outpout of ./a.out -f is available at https://yadi.sk/d/aRka8xWPtSc4y
>>> >> It looks like there are pauses between bulks of frames (frame counter and timestamp as returned from v4l2 API):
>>> >>
>>> >> 3 3705.142553
>>> >> 8 3705.342533
>>> >> 13 3705.542517
>>> >> 110 3708.776208
>>> >> 115 3708.976190
>>> >> 120 3709.176169
>>> >> 125 3709.376152
>>> >> 130 3709.576144
>>> >> 226 3712.807848
>>> >>
>>> >> When I use tiny 160x120 frames
>>> >>
>>> >>                 fmt.fmt.pix.width       = 160;
>>> >>                 fmt.fmt.pix.height      = 120;
>>> >>
>>> >> then more frames are received. See output example at https://yadi.sk/d/DedBmH6ftSc9t
>>> >> That is why I thought that everything was fine in May when used tiny xawtv window to check kernel OOPS presence (see http://www.spinics.net/lists/linux-usb/msg141188.html for reference)
>>> >>
>>> >> Even more. When I introduce USB hub between the host and the webcam, I can not receive even any 320x240 frames.
>>> >>
>>> >> I've managed to use ftrace to see what is going on when no frames are received.
>>> >> I've found that pwc_isoc_handler is called frequently as the following:
>>> >>
>>> >>  0)               |  pwc_isoc_handler [pwc]() {
>>> >>  0)               |    usb_submit_urb [usbcore]() {
>>> >>  0)               |      usb_submit_urb.part.3 [usbcore]() {
>>> >>  0)               |        usb_hcd_submit_urb [usbcore]() {
>>> >>  0)   0.834 us    |          usb_get_urb [usbcore]();
>>> >>  0)               |          musb_map_urb_for_dma [musb_hdrc]() {
>>> >>  0)   0.792 us    |            usb_hcd_map_urb_for_dma [usbcore]();
>>> >>  0)   5.750 us    |          }
>>> >>  0)               |          musb_urb_enqueue [musb_hdrc]() {
>>> >>  0)   0.750 us    |            _raw_spin_lock_irqsave();
>>> >>  0)               |            usb_hcd_link_urb_to_ep [usbcore]() {
>>> >>  0)   0.792 us    |              _raw_spin_lock();
>>> >>  0)   0.791 us    |              _raw_spin_unlock();
>>> >>  0) + 10.500 us   |            }
>>> >>  0)   0.791 us    |            _raw_spin_unlock_irqrestore();
>>> >>  0) + 25.375 us   |          }
>>> >>  0) + 45.208 us   |        }
>>> >>  0) + 51.042 us   |      }
>>> >>  0) + 56.084 us   |    }
>>> >>  0) + 61.292 us   |  }
>>> >>
>>> >> However, pwc_isoc_handler never calls vb2_buffer_done() that is why I get "select timeout" in userspace.
>>> >> Unfortunately, my kernel is not compiled with CONFIG_USB_PWC_DEBUG=y but I can recompile it, if you think that it could provide more information. I am also ready to perform additional tests (use usbmon maybe?).
>>> >>
>>> >> How could this issue be resolved?
>>> >>
>>> >> Thank you.
>>> >
>>> > Do you have CPPI DMA enabled? If so I think you might hit on a known
>>> > issue in CPPI Isoch transfer, in which the MUSB controller only sends IN
>>> > tokens in every other SOF, so only half of the bus bandwidth is
>>> > utilized, which causes video frame drops in higher resolution.
>>> >
>>>
>>> Yes, I do use DMA:
>>>
>>> CONFIG_USB_TI_CPPI41_DMA=y
>>
>> Okay.
>>
>>>
>>> > To confirm this, use a bus analyzer to capture a bus trace, you would
>>> > see no IN tokens in every other SOF while transfering Isoch packets.
>>> >
>>>
>>> I am sorry, I am new to USB debugging. Do you mean I need to use
>>> usbmon or some external hardware device?
>>
>> I barely use usbmon, and not sure if it gives the information I am
>> looking for. But I meant the external test equipment - USB bus protocol
>> analyzer - a bus packet sniffer.
>>
>
> Now I see. I've googled it, they start from $1000, I don't know
> when/whether/where I can get one to try.
> Until that, could I check something else? For instance, disable
> CONFIG_USB_TI_CPPI41_DMA.
>
> I've found that after hours of transmit, the camera stops iso at all
> (until reset). Maybe its brain becomes damaged by the transfer issues
> at the some moment.
>
> I've just also made some usbmon records and see that even when there
> are no frames in userspace there is iso transfer occuring.
>
> 160x140: https://yadi.sk/d/BmUCPP_EtT8SN
> 640x480 (no frames in user space): https://yadi.sk/d/KXLU-g9-tT8T7
>
> Maybe pwc people could give some useful insight looking into the records.
>
> AFAIU pwc camera support transfer compression and  pwc driver
> negotiates automaticly the best possible compression level (older
> kernal provided module option to do it manually).
> However, in pwc_isoc_init(), I see the following
>
>         /* We first try with low compression and then retry with a higher
>            compression setting if there is not enough bandwidth. */
>         ret = pwc_set_video_mode(pdev, pdev->width, pdev->height, pdev->pixfmt,
>                                  pdev->vframes, &compression, 1);
>
> and ret is never checked and is being overwritten a few lines further.
>

I also have part of dmesg output: https://yadi.sk/d/tjr4EljCtTNbV but
not sure that it can help.

>
>
>> Regards,
>> -Bin,
>>
>>>
>>> > Regards,
>>> > -Bin.
>>> >
>>>
>>>
>>>
>>> --
>>> With best regards,
>>> Matwey V. Kornilov.
>>> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
>>> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
>>
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
