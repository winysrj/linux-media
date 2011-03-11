Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:41509 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab1CKQuv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 11:50:51 -0500
Message-ID: <4D7A52E8.3010402@ti.com>
Date: Fri, 11 Mar 2011 10:50:48 -0600
From: Sergio Aguirre <saaguirre@ti.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l: soc-camera: Store negotiated buffer settings
References: <1299545388-717-1-git-send-email-saaguirre@ti.com> <Pine.LNX.4.64.1103080818240.3903@axis700.grange> <4D7629F4.6010802@ti.com> <Pine.LNX.4.64.1103111629430.26572@axis700.grange> <4D7A507C.7070602@ti.com> <Pine.LNX.4.64.1103111746560.26572@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103111746560.26572@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/11/2011 10:48 AM, Guennadi Liakhovetski wrote:
> On Fri, 11 Mar 2011, Sergio Aguirre wrote:
>
>> Hi Guennadi,
>>
>> On 03/11/2011 10:36 AM, Guennadi Liakhovetski wrote:
>>> On Tue, 8 Mar 2011, Sergio Aguirre wrote:
>>>
>>>> Hi Guennadi,
>>>>
>>>> On 03/08/2011 01:19 AM, Guennadi Liakhovetski wrote:
>>>>> On Mon, 7 Mar 2011, Sergio Aguirre wrote:
>>>>>
>>>>>> This fixes the problem in which a host driver
>>>>>> sets a personalized sizeimage or bytesperline field,
>>>>>> and gets ignored when doing G_FMT.
>>>>>
>>>>> Can you tell what that personalised value is? Is it not covered by
>>>>> soc_mbus_bytes_per_line()? Maybe something like a JPEG format?
>>>>
>>>> In my case, my omap4_camera driver requires to have a bytesperline which
>>>> is a
>>>> multiple of 32, and sometimes (depending on the internal HW blocks used) a
>>>> page aligned byte offset between lines.
>>>>
>>>> For example, I want to use such configuration that, for an NV12 buffer, I
>>>> require a 4K offset between lines, so the vaues are:
>>>>
>>>> pix->bytesperline = PAGE_SIZE;
>>>> pix->sizeimage = pix->bytesperline * height * 3 / 2;
>>>>
>>>> Which I filled in TRY_FMT/S_FMT ioctl calls.
>>>
>>> Ok, I think, I agree with this. Until now we didn't have drivers, that
>>> wanted to pad data. Even the pxa270 driver adjusts the frame format (see
>>> pxa_camera.c::pxa_camera_try_fmt() and the call to v4l_bound_align_image()
>>> there in the YUV422P case) to avoid padding, even though that's a
>>> different kind of padding - between planes. So, if line padding - as in
>>> your case - is indeed needed, I agree, that the correct way to support
>>> that is to implement driver-specific bytesperline and sizeimage
>>> calculations and, logically, those values should be used in
>>> soc_camera_g_fmt_vid_cap().
>>>
>>> I'll just change your patch a bit - I'll use "u32" types instead of
>>> "__u32" - this is a kernel internal struct and we don't need user-space
>>> exported types.
>>
>> Ok, thanks.
>>
>> You're right about u32 type... my bad.
>>
>> So, I'll change that, rebase to:
>>
>> git://linuxtv.org/media_tree.git	staging/for_v2.6.39
>>
>> And resubmit for review. No problem.
>
> Np, I've already committed (locally, not pushed yet) this patch with only
> changed field types and a bit shuffled lines to group size-related and
> format-related assignments together.

Oh ok. That's good! Thanks for doing that. :)

Thanks,
Sergio


>
> Thanks
> Guennadi
>

<snip>

>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

