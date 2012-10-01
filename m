Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63784 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2JAKtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 06:49:49 -0400
Received: by pbbrr4 with SMTP id rr4so7568812pbb.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 03:49:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2377629.Lqpv1qCszQ@avalon>
References: <CAFqH_53EY7BcMjn+fy=KfAhSU9Ut1pcLUyrmu2kiHznrBUB2XQ@mail.gmail.com>
	<1378805.eK71Lgs3H4@avalon>
	<CAFqH_51khWJ6RBv707J8AC9YrMhzwqg5QPuo52EYVnBOmTRpFA@mail.gmail.com>
	<2377629.Lqpv1qCszQ@avalon>
Date: Mon, 1 Oct 2012 12:49:48 +0200
Message-ID: <CAFqH_53nVK_MYwuRxAFWNBtK8P++zHv8MsSGCpiGFvXLbCc9zw@mail.gmail.com>
Subject: Re: omap3isp: wrong image after resizer with mt9v034 sensor
From: =?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/10/1 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Friday 28 September 2012 17:32:36 Enric Balletbò i Serra wrote:
>> 2012/9/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > On Friday 28 September 2012 10:21:56 Enric Balletbò i Serra wrote:
>> >> 2012/9/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >> > On Thursday 27 September 2012 18:05:56 Enric Balletbò i Serra wrote:
>> >> >> 2012/9/27 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >> >> > On Wednesday 26 September 2012 16:15:35 Enric Balletbò i Serra
> wrote:
>
> [snip]
>
>> >> >> >> Nonetheless, I changed the driver to configure for BGGR pattern.
>> >> >> >> Using the Sensor->CCDC->Preview->Resizer pipeline I captured the
>> >> >> >> data with yavta and converted using raw2rgbpnm program.
>> >> >> >>
>> >> >> >>     ./raw2rgbpnm -s 752x480 -f UYVY img-000001.uyvy img-000001.pnm
>> >> >> >>
>> >> >> >> and the result is
>> >> >> >>
>> >> >> >>     http://downloads.isee.biz/pub/files/patterns/img-000002.pnm
>> >> >> >>     http://downloads.isee.biz/pub/files/patterns/img-000002.bin
>> >> >> >>
>> >> >> >> The image looks better than older, not perfect, but better. The
>> >> >> >> image is only a bit yellowish. Could be this a hardware issue ? We
>> >> >> >> are close to ...
>> >> >> >
>> >> >> > It's like a white balance issue. The OMAP3 ISP hardware doesn't
>> >> >> > perform automatic white balance, you will need to implement an AWB
>> >> >> > algorithm in software. You can have a look at the omap3-isp-live
>> >> >> > project for sample code (http://git.ideasonboard.org/omap3-isp-
>> >> >> > live.git).
>> >>
>> >> So you think the sensor is set well now ?
>> >
>> > I think so, yes.
>> >
>> >> The hardware can produce this issue ? Do you know if this algorithm is
>> >> implemented in gstreamer ?
>> >
>> > I don't know, but if it is the implementation will be software-based, and
>> > will thus be slow. The OMAP3 ISP can compute AWB-related statistics in
>> > hardware and can apply per-color gains to the image. The only software
>> > you then need will retrieve the statistics, compute the gains from them
>> > and apply the gains. That's what the sample code in omap3-isp-live does.
>> > This should at some point be integrated as a libv4l plugin.
>>
>> So I can use your software to test if it's a white balance issue ?
>
> Yes, but that's really a test application, it might not work out of the box.
>

I'm getting following error

# ./live
    Device /dev/video6 opened: OMAP3 ISP resizer output (media).
    viewfinder configured for 2011 1024x768
    AEWB: #win 10x7 start 6x0 size 74x68 inc 10x8
    Device /dev/video7 opened: omap_vout ().
    3 buffers requested.
    Buffer 0 mapped at address 0xb6e16000.
    Buffer 1 mapped at address 0xb6c96000.
    Buffer 2 mapped at address 0xb6b16000.
    3 buffers requested.
    Buffer 0 valid.
    Buffer 1 valid.
    Buffer 2 valid.
    unable to retrieve AEWB event: Inappropriate ioctl for device (25).
    unable to retrieve AEWB event: Inappropriate ioctl for device (25).
    unable to retrieve AEWB event: Inappropriate ioctl for device (25).
    ...

and a blue screen appears on my monitor. Maybe I missed a patch ?

>> (as the omap3-isp-live has this support if I understood). I'll try this,
>> do you can provide some tips on how use the omap3-isp-live ?
>
> Just compile and run it :-)
>
> --
> Regards,
>
> Laurent Pinchart
>
