Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56014 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbcBAIOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2016 03:14:40 -0500
Subject: Re: OS freeze after queue_setup
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMh+yZ4KEpq36HgrdHW4FkvQmZ4T_tD7XUGKs0a9K=otMnw@mail.gmail.com>
 <CAJ2oMhK+RS2Z2GVGbo3X_Ov5gWxiCRRvpT6T6YgfVKmp2rM4ew@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56AF13EA.2070206@xs4all.nl>
Date: Mon, 1 Feb 2016 09:14:34 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhK+RS2Z2GVGbo3X_Ov5gWxiCRRvpT6T6YgfVKmp2rM4ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/01/2016 09:00 AM, Ran Shalit wrote:
> On Sun, Jan 31, 2016 at 10:35 PM, Ran Shalit <ranshalit@gmail.com> wrote:
>> Hello,
>>
>> Maybe someone will have some idea about the following:
>> I am using a pci card (not video card, just some dummy pci card), to
>> check v4l2 template for PCIe card (I used solo6x10 as template for the
>> driver and moved all hardware related to video into remarks).
>> I don't use any register read/write to hardware (just dummy functions).
>>
>> I get that load/unload of module is successful.
>> But on trying to start reading video frames (using read method with
>> v4l API userspace example), I get that the whole operating system is
>> freezed, and I must reboot the machine.
>> This is the queue_setup callback:
>>
>> static int test_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
>>   unsigned int *num_buffers, unsigned int *num_planes,
>>   unsigned int sizes[], void *alloc_ctxs[])
>> {
>> struct test_dev *solo_dev = vb2_get_drv_priv(q);
>> dev_info(&test_dev->pdev->dev,"test_queue_setup\n");
>> sizes[0] = test_image_size(test_dev);
>> alloc_ctxs[0] = solo_dev->alloc_ctx;
>> *num_planes = 1;
>>
>> if (*num_buffers < MIN_VID_BUFFERS)
>> *num_buffers = MIN_VID_BUFFERS;
>>
>> return 0;
>> }
>>
>> static const struct vb2_ops test_video_qops = {
>> .queue_setup = test_queue_setup,
>> .buf_queue = test_buf_queue,
>> .start_streaming = test_start_streaming, <- does nothing
>> .stop_streaming = test_stop_streaming, <- does nothing
>> .wait_prepare = vb2_ops_wait_prepare,
>> .wait_finish = vb2_ops_wait_finish,
>> };
>>
>>
>> I didn't find anything suspicious in the videobuf2 callback that can
>> explain these freeze.( start_streaming,stop_streaming contains just
>> printk with function name).
>> I also can't know where it got stuck (The system is freezed without
>> any logging on screen, all log is in dmesg).
>>
>> Thank for any idea,
>> Ran
> 
> On start reading frames (using read or mmap method), it seems as if
> there is some collisions between the pci video card and another card
> (becuase the monitor is also printed with strange colors as the moment
> the OS freezes) .
> I validated again that the PCIe boards IDs in the table are correct
> (it matches only the dummy pcie card when it is  connected ).
> I also tried to comment out the irq request, to be sure that there is
> no irq collision with another board, but it still get freezed anyway.

I can't tell anything from this, I'd need to see the full source.

Regards,

	Hans
