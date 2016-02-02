Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36817 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbcBBMhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2016 07:37:07 -0500
Received: by mail-ig0-f173.google.com with SMTP id z14so59128952igp.1
        for <linux-media@vger.kernel.org>; Tue, 02 Feb 2016 04:37:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ2oMh+PYXFq__PhzQa72Rtaa0hddtmNBs1evWX3RKRWZK_Mkw@mail.gmail.com>
References: <CAJ2oMh+yZ4KEpq36HgrdHW4FkvQmZ4T_tD7XUGKs0a9K=otMnw@mail.gmail.com>
	<CAJ2oMhK+RS2Z2GVGbo3X_Ov5gWxiCRRvpT6T6YgfVKmp2rM4ew@mail.gmail.com>
	<56AF13EA.2070206@xs4all.nl>
	<CAJ2oMh+5_8Ngtn3G2HxFKw3su-rgQuyUYqjN5oOmgekW2cTrNA@mail.gmail.com>
	<56AF2DB9.8010609@xs4all.nl>
	<CAJ2oMh+PYXFq__PhzQa72Rtaa0hddtmNBs1evWX3RKRWZK_Mkw@mail.gmail.com>
Date: Tue, 2 Feb 2016 14:37:07 +0200
Message-ID: <CAJ2oMhJJEFpB_+6==HB+Qyh4Kyt5o-cztXX6STDH9iynoEvNOQ@mail.gmail.com>
Subject: Re: OS freeze after queue_setup
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 1, 2016 at 1:16 PM, Ran Shalit <ranshalit@gmail.com> wrote:
> On Mon, Feb 1, 2016 at 12:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>>
>> On 02/01/2016 10:07 AM, Ran Shalit wrote:
>>> On Mon, Feb 1, 2016 at 10:14 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>
>>>>
>>>> On 02/01/2016 09:00 AM, Ran Shalit wrote:
>>>>> On Sun, Jan 31, 2016 at 10:35 PM, Ran Shalit <ranshalit@gmail.com> wrote:
>>>>>> Hello,
>>>>>>
>>>>>> Maybe someone will have some idea about the following:
>>>>>> I am using a pci card (not video card, just some dummy pci card), to
>>>>>> check v4l2 template for PCIe card (I used solo6x10 as template for the
>>>>>> driver and moved all hardware related to video into remarks).
>>>>>> I don't use any register read/write to hardware (just dummy functions).
>>>>>>
>>>>>> I get that load/unload of module is successful.
>>>>>> But on trying to start reading video frames (using read method with
>>>>>> v4l API userspace example), I get that the whole operating system is
>>>>>> freezed, and I must reboot the machine.
>>>>>> This is the queue_setup callback:
>>>>>>
>>>>>> static int test_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
>>>>>>   unsigned int *num_buffers, unsigned int *num_planes,
>>>>>>   unsigned int sizes[], void *alloc_ctxs[])
>>>>>> {
>>>>>> struct test_dev *solo_dev = vb2_get_drv_priv(q);
>>>>>> dev_info(&test_dev->pdev->dev,"test_queue_setup\n");
>>>>>> sizes[0] = test_image_size(test_dev);
>>>>>> alloc_ctxs[0] = solo_dev->alloc_ctx;
>>>>>> *num_planes = 1;
>>>>>>
>>>>>> if (*num_buffers < MIN_VID_BUFFERS)
>>>>>> *num_buffers = MIN_VID_BUFFERS;
>>>>>>
>>>>>> return 0;
>>>>>> }
>>>>>>
>>>>>> static const struct vb2_ops test_video_qops = {
>>>>>> .queue_setup = test_queue_setup,
>>>>>> .buf_queue = test_buf_queue,
>>>>>> .start_streaming = test_start_streaming, <- does nothing
>>>>>> .stop_streaming = test_stop_streaming, <- does nothing
>>>>>> .wait_prepare = vb2_ops_wait_prepare,
>>>>>> .wait_finish = vb2_ops_wait_finish,
>>>>>> };
>>>>>>
>>>>>>
>>>>>> I didn't find anything suspicious in the videobuf2 callback that can
>>>>>> explain these freeze.( start_streaming,stop_streaming contains just
>>>>>> printk with function name).
>>>>>> I also can't know where it got stuck (The system is freezed without
>>>>>> any logging on screen, all log is in dmesg).
>>>>>>
>>>>>> Thank for any idea,
>>>>>> Ran
>>>>>
>>>>> On start reading frames (using read or mmap method), it seems as if
>>>>> there is some collisions between the pci video card and another card
>>>>> (becuase the monitor is also printed with strange colors as the moment
>>>>> the OS freezes) .
>>>>> I validated again that the PCIe boards IDs in the table are correct
>>>>> (it matches only the dummy pcie card when it is  connected ).
>>>>> I also tried to comment out the irq request, to be sure that there is
>>>>> no irq collision with another board, but it still get freezed anyway.
>>>>
>>>> I can't tell anything from this, I'd need to see the full source.
>>>>
>>>> Regards,
>>>>
>>>>         Hans
>>>
>>> Thank you Hans,
>>> The source code base on solo6x10 as template , and kernel 3.10.0.229
>>> (I needed to use this kernel version instead of latest as start point
>>> because of other pacakge , Intel's media sdk encoder ) :
>>>
>>> https://drive.google.com/file/d/0B22GsWueReZTSElIUEJJSHplUVU/view?usp=sharing
>>> - This package compiled with the makefile
>>> - relevant changes are in solo6x10-core.c & solo6x10-v4l2.c
>>
>> It would certainly help if you don't try to enable interrupts on your pci
>> card. Basically, don't touch the pci at all. The only purpose of using a
>> dummy PCI card is that your template driver is loaded. But touching the hardware
>> will of course have bad results since it isn't video hardware.
>>
>> Frankly, why not just take the v4l2-pci-skeleton.c as your template instead
>> of trying to strip down the solo driver? The skeleton driver is already stripped
>> down!
>>
>> Much easier.
>>
>> Regards,
>>
>>         Hans
>
> Hi Hans,
>
> Thank you for the suggestions.
> I've tried the skeleton and I got the same behaviour.
> When using vivid device, it works (frame reading) without any issues.
> Since the whole system freezes its hard to know the exact problem.
>
> Regards,
> Ran

Hi,

Just to update for anyone with similar behaviour:
On moving to a newer kernel version (3.16.0) , this issue been
resolved  (both the skeleton and the stripped down template based on
solo6x10.)

Thank you,
Ran
