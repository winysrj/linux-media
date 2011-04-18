Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44953 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1DRORR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 10:17:17 -0400
Received: by wya21 with SMTP id 21so3950449wya.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 07:17:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi==Yeniz_Mm4rD2qnGSR5kBE_XCcg@mail.gmail.com>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com>
	<4DA60145.5010301@maxwell.research.nokia.com>
	<BANLkTi=EkJxdtsJ1PQOKZOhf3H1o4xobaQ@mail.gmail.com>
	<201104141111.05245.laurent.pinchart@ideasonboard.com>
	<BANLkTinx2Uogrnz+ttR6G1eKDrTPrBmo5Q@mail.gmail.com>
	<BANLkTinxmEzctGioUy1vy6aK0h9XwKM7ag@mail.gmail.com>
	<BANLkTi==Yeniz_Mm4rD2qnGSR5kBE_XCcg@mail.gmail.com>
Date: Mon, 18 Apr 2011 17:17:15 +0300
Message-ID: <BANLkTikLJQitB6ojQ3NaXnJ9op4GGx+YGA@mail.gmail.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
From: David Cohen <dacohen@gmail.com>
To: Bastian Hecht <hechtb@googlemail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 18, 2011 at 1:43 PM, Bastian Hecht <hechtb@googlemail.com> wrote:
> 2011/4/16 David Cohen <dacohen@gmail.com>:
>> Hi Bastian,
>>
>> On Thu, Apr 14, 2011 at 1:36 PM, Bastian Hecht <hechtb@googlemail.com> wrote:
>>> Yeah!
>>>
>>> Soooo... when I initialized the the camera (loading a 108 bytes
>>> register listing) I just let run the camera and sent images.  So I
>>> first realized a counter overflow  if (count++ > 100000) after a few
>>> seconds. But this seemed to be handled correctly (ignore and delete
>>> HS_VS_IRQ flag) while after 2 or more yavta calls it made the driver
>>> hang.
>>>
>>> I modified my register listing so that the chip gets "booted" silently.
>>> In
>>> static struct v4l2_subdev_video_ops framix_subdev_video_ops = {
>>>        .s_stream       = framix_s_stream, <===============
>>> };
>>> I correctly check the stream status now and enable/disable the camera signals.
>>>
>>> I am unsure whether the isp should be able to handle an ongoing data
>>> stream independently of ISP_PIPELINE_STREAM_STOPPED.
>>
>> streamoff should finish synchronously with last ongoing data. So, it
>> should have no ongoing data afterwards. Was that your question?
>
> I formulated my reply a bit strange. I meant that that the ongoing
> datastream from my camera module (even when the isp-stack is in
> stream_stopped state) produces my problem. The question was if it
> should be allowed for the camera to send data all time long or only
> when it is told to do so by s_stream.

I may assume you are mentioning a pipeline which includes camera
sensor + ISP. In this case there should be no data.

Regards,

David

>
> best regards,
>
> Bastian Hecht
>
>
>> Br,
>>
>> David Cohen
>>
>>> If you decide it should, I will gladly help you find out more, just
>>> ask. It worked on an OMAP3530 before, but I do not know if it is the
>>> hardware or isp software that changed. Unfortunately I can't get an
>>> 3530 anymore (I trashed mine...).
>>>
>>>
>>> You helped me so much! Big thanks.
>>>
>>> Bastian Hecht
>>>
>>>
>>>
>>> 2011/4/14 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>>>> Hi Bastian,
>>>>
>>>> On Thursday 14 April 2011 10:33:12 Bastian Hecht wrote:
>>>>> 2011/4/13 Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>:
>>>>> > Bastian Hecht wrote:
>>>>> >> Hello people,
>>>>> >
>>>>> > Hi Bastian,
>>>>> >
>>>>> > I'm cc'ing Laurent.
>>>>> >
>>>>> >> I switched to the new DM3730 from IGEP and while it's supposed to be
>>>>> >> (almost) the same as the 3530 Version the isp deadlocks
>>>>> >> deterministically after I start capturing the second time with yavta.
>>>>> >
>>>>> > Does the capture work the first time w/o issues?
>>>>>
>>>>> Yes, I can always run yavta once capturing 4 frames (3 skipped, last
>>>>> saved). It usually deadlocks when running yavta the second time but I had
>>>>> 1 successful 2nd try (out of 20 maybe).
>>>>>
>>>>> >> All extra locking debug output is enabled in the kernel .config.
>>>>> >
>>>>> > I'm not fully certain on what this exactly is that you have below, but
>>>>> > it looks like your system is staying in interrupt context all the time.
>>>>> > My guess is that the ISP is producing interrupts that the driver is not
>>>>> > handling properly, causing the interrupt handler to be called again
>>>>> > immediately.
>>>>>
>>>>> Nice! OK, I'd like to fully understand the panic output, maybe you can
>>>>> help there:
>>>>> After
>>>>> [  376.016906] [<c02e3dc4>] (_raw_spin_unlock_irqrestore+0x40/0x44)
>>>>> from [<bf01f678>] (omap3isp_video_queue_streamon+0x80/0x90
>>>>> the IRQs get enabled again. Immediately our offending irq wants to get
>>>>> served but noone is clearing it.
>>>>> At some time, the timer interrupt triggers the watchdog for a kernel panic.
>>>>> So the last exception block is the process context that is currently
>>>>> active. But why are there 2 irq routines displayed? Is the middle one the
>>>>> hardware handling that causes a software irq to be triggered (upper
>>>>> block)?
>>>>>
>>>>> So my next step could be to find the unhandled irq number?
>>>>
>>>> If the problem is caused by an interrupt storm, the following patch will make
>>>> your system responsive again after a couple of seconds (but will kill the ISP
>>>> driver :-)). If it doesn't, the problem is likely caused by something else.
>>>>
>>>> diff --git a/drivers/media/video/omap3isp/isp.c
>>>> b/drivers/media/video/omap3isp/isp.c
>>>> index de2dec5..6497300 100644
>>>> --- a/drivers/media/video/omap3isp/isp.c
>>>> +++ b/drivers/media/video/omap3isp/isp.c
>>>> @@ -462,6 +464,7 @@ static irqreturn_t isp_isr(int irq, void *_isp)
>>>>                                       IRQ0STATUS_CCDC_VD0_IRQ |
>>>>                                       IRQ0STATUS_CCDC_VD1_IRQ |
>>>>                                       IRQ0STATUS_HS_VS_IRQ;
>>>> +       static unsigned int count = 0;
>>>>        struct isp_device *isp = _isp;
>>>>        u32 irqstatus;
>>>>        int ret;
>>>> @@ -469,6 +472,11 @@ static irqreturn_t isp_isr(int irq, void *_isp)
>>>>        irqstatus = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
>>>>        isp_reg_writel(isp, irqstatus, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
>>>>
>>>> +       if (count++ > 100000) {
>>>> +               isp_disable_interrupts(isp);
>>>> +               return IRQ_HANDLED;
>>>> +       }
>>>> +
>>>>        isp_isr_sbl(isp);
>>>>
>>>>        if (irqstatus & IRQ0STATUS_CSIA_IRQ) {
>>>>
>>>>
>>>>> > Do you have the same sensor working on OMAP 3530?
>>>>>
>>>>> I never had this problem on an OMAP 3530, although I better test it
>>>>> again with the current setup. I try to get my hands on an 3530 today.
>>>>>
>>>>> >> I am unsure if this is an ISP thing or a problem in the
>>>>> >> interrupthandling software.
>>>>> >
>>>>> > This has probably something to do with the ISP driver. :-)
>>>>> >
>>>>> >> The first block is the watchdog that detects the deadlock. The last
>>>>> >> block is in the isp-code but how can it hang when trying to UNlock a
>>>>> >> spinlock? I am unsure about the 2nd block.
>>>>> >> The assembler code of __irq_svc is located in
>>>>> >> arch/arm/kernel/entry-armv.S Maybe I should try on
>>>>> >> linux-arm@lists.arm.linux.org.uk but I thought I give it a shot here
>>>>> >> first.
>>>>> >>
>>>>> >> I use the omap3isp-2.6.35.3-omap3isp branch from Laurent.
>>>>> >
>>>>> > Why so old kernel?
>>>>>
>>>>> I tried a newer version, but there I couldn't get it booting with my
>>>>> igep. The kernel unpacked and tried to boot but it froze.
>>>>> I decided to use a version that is officially is supported by the igep
>>>>> team.
>>>>
>>>> The ttyS* OMAP serial devices have been renamed to ttyO* in 2.6.37. Replace
>>>> /dev/ttyS2 with /dev/ttyO2 on your kernel command line (either in the kernel
>>>> config file if you've activated CONFIG_CMDLINE_FORCE, or in the boot loader
>>>> environment variables) and you should be able to boot 2.6.38 without any
>>>> issue. Don't forget to modify /etc/inittab as well.
>>>>
>>>> --
>>>> Regards,
>>>>
>>>> Laurent Pinchart
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
