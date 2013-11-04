Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24510 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3KDL3c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 06:29:32 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVQ0044AL8XHC90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 04 Nov 2013 11:29:30 +0000 (GMT)
Message-id: <52778515.6070204@samsung.com>
Date: Mon, 04 Nov 2013 12:29:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, John Sheu <sheu@google.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.chehab@samsung.com,
	Kamil Debski <k.debski@samsung.com>, pawel@osciak.com
Subject: Re: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for
 VIDIOC_{G,S}_CROP to encoder
References: <1381362589-32237-1-git-send-email-sheu@google.com>
 <1381362589-32237-4-git-send-email-sheu@google.com>
 <52564DE6.6090709@xs4all.nl>
 <CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com>
 <CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com>
 <52590184.5030806@xs4all.nl>
 <CAErgknAXZzbBMm0JeASOVzsXNNyu7Af32hd0t_fR8VkPeVrx4A@mail.gmail.com>
 <526001DF.9040309@samsung.com>
 <CAErgknCu2UeEQeY+taSXAbC6F4i=FMTz8t=MhSLUdfQRZXQgAg@mail.gmail.com>
 <CAErgknDhiSg0v_4KvMuoTX4Xcy9t+d2=+QWJu0riM1B0kQVMcg@mail.gmail.com>
 <52606AB7.7020200@gmail.com>
 <CAErgknBEJmVwjG6xs8Es3C8ZkjuDgnM6NUUx07me+Rf2bKdzZg@mail.gmail.com>
 <52777D9B.9000308@xs4all.nl>
In-reply-to: <52777D9B.9000308@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, I missed to reply to this e-mail.

On 04/11/13 11:57, Hans Verkuil wrote:
> Hi John,
> 
> On 10/18/2013 02:03 AM, John Sheu wrote:
>> On Thu, Oct 17, 2013 at 3:54 PM, Sylwester Nawrocki
>> <sylvester.nawrocki@gmail.com> wrote:
>>> On 10/18/2013 12:25 AM, John Sheu wrote:
>>>> On Thu, Oct 17, 2013 at 2:46 PM, John Sheu<sheu@google.com>  wrote:
>>>>>>  Sweet.  Thanks for spelling things out explicitly like this.  The fact
>>>>>>  that the CAPTURE and OUTPUT queues "invert" their sense of "crop-ness"
>>>>>>  when used in a m2m device is definitely all sorts of confusing.
>>>>
>>>> Just to double-check: this means that we have another bug.
>>>>
>>>> In drivers/media/v4l2-core/v4l2-ioctl.c, in v4l_s_crop and v4l_g_crop,
>>>> we "simulate" a G_CROP or S_CROP, if the entry point is not defined
>>>> for that device, by doing the appropriate S_SELECTION or G_SELECTION.
>>>> Unfortunately then, for M2M this is incorrect then.
>>>>
>>>> Am I reading this right?
>>>
>>> You are right, John. Firstly a clear specification needs to be written,
>>> something along the lines of Tomasz's explanation in this thread, once
>>> all agree to that the ioctl code should be corrected if needed.
> 
> I don't understand the problem here. The specification has always been clear:
> s_crop for output devices equals s_selection(V4L2_SEL_TGT_COMPOSE_ACTIVE).
> 
> Drivers should only implement the selection API and the v4l2 core will do the
> correct translation of s_crop.
> 
> Yes, I know it's weird, but that's the way the crop API was defined way back
> and that's what should be used.
> 
> My advise: forget about s_crop and just implement s_selection.
> 
>>>
>>> It seems this [1] RFC is an answer exactly to your question.
>>>
>>> Exact meaning of the selection ioctl is only part of the problem, also
>>> interaction with VIDIOC_S_FMT is not currently defined in the V4L2 spec.
>>>
>>> [1] http://www.spinics.net/lists/linux-media/msg56078.html
>>
>> I think the "inversion" behavior is confusing and we should remove it
>> if at all possible.
>>
>> I took a look through all the drivers in linux-media which implement
>> S_CROP.  Most of them are either OUTPUT or CAPTURE/OVERLAY-only.  Of
>> those that aren't:
>>
>> * drivers/media/pci/zoran/zoran_driver.c : this driver explicitly accepts both
>>   OUTPUT and CAPTURE queues in S_CROP, but they both configure the same state.
>>   No functional difference.
> 
> Yeah, I guess that's a driver bug. This is a very old driver that originally
> used a custom API for these things, and since no selection API existed at the
> time it was just mapped to the crop API. Eventually it should use the selection
> API as well and do it correctly. But to be honest, nobody cares about this driver :-)
> 
> It is however on my TODO list of drivers that need to be converted to the latest
> frameworks, so I might fix this eventually.
> 
>> * drivers/media/platform/davinci/vpfe_capture.c : this driver doesn't specify
>>   the queue, but is a CAPTURE-only device.  Probably an (unrelated) bug.
> 
> Yes, that's a driver bug. It should check the buffer type.
> 
>> * drivers/media/platform/exynos4-is/fimc-m2m.c : this driver is a m2m driver
>>   with both OUTPUT and CAPTURE queues.  It has uninverted behavior:
>>   S_CROP(CAPTURE) -> source
>>   S_CROP(OUTPUT) -> destination

No, that's not true. It seems you got it wrong, cropping in case of this m2m
driver works like this:

S_CROP(OUTPUT) -> source (from HW POV)
S_CROP(CAPTURE) -> destination

I.e. exactly same way as for s5p-g2d, for which it somehow was a reference
implementation.

> This is the wrong behavior.
> 
>> * drivers/media/platform/s5p-g2d/g2d.c : this driver is a m2m driver with both
>>   OUTPUT and CAPTURE queues.  It has inverted behavior:
>>   S_CROP(CAPTURE) -> destination
>>   S_CROP(OUTPUT) -> source
> 
> This is the correct behavior.
> 
>>
>> The last two points above are the most relevant.  So we already have
>> at least one broken driver, regardless of whether we allow inversion
>> or not; I'd think this grants us a certain freedom to redefine the
>> specification to be more logical.  Can we do this please?
> 
> No. The fimc-m2m.c driver needs to be fixed. That's the broken one.

It's not broken, it's easy to figure out if you actually look at the
code, e.g. fimc_m2m_try_crop() function.

--
Regards,
Sylwester

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
