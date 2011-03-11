Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53146 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1CKQkc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 11:40:32 -0500
Message-ID: <4D7A507C.7070602@ti.com>
Date: Fri, 11 Mar 2011 10:40:28 -0600
From: Sergio Aguirre <saaguirre@ti.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l: soc-camera: Store negotiated buffer settings
References: <1299545388-717-1-git-send-email-saaguirre@ti.com> <Pine.LNX.4.64.1103080818240.3903@axis700.grange> <4D7629F4.6010802@ti.com> <Pine.LNX.4.64.1103111629430.26572@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103111629430.26572@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On 03/11/2011 10:36 AM, Guennadi Liakhovetski wrote:
> On Tue, 8 Mar 2011, Sergio Aguirre wrote:
>
>> Hi Guennadi,
>>
>> On 03/08/2011 01:19 AM, Guennadi Liakhovetski wrote:
>>> On Mon, 7 Mar 2011, Sergio Aguirre wrote:
>>>
>>>> This fixes the problem in which a host driver
>>>> sets a personalized sizeimage or bytesperline field,
>>>> and gets ignored when doing G_FMT.
>>>
>>> Can you tell what that personalised value is? Is it not covered by
>>> soc_mbus_bytes_per_line()? Maybe something like a JPEG format?
>>
>> In my case, my omap4_camera driver requires to have a bytesperline which is a
>> multiple of 32, and sometimes (depending on the internal HW blocks used) a
>> page aligned byte offset between lines.
>>
>> For example, I want to use such configuration that, for an NV12 buffer, I
>> require a 4K offset between lines, so the vaues are:
>>
>> pix->bytesperline = PAGE_SIZE;
>> pix->sizeimage = pix->bytesperline * height * 3 / 2;
>>
>> Which I filled in TRY_FMT/S_FMT ioctl calls.
>
> Ok, I think, I agree with this. Until now we didn't have drivers, that
> wanted to pad data. Even the pxa270 driver adjusts the frame format (see
> pxa_camera.c::pxa_camera_try_fmt() and the call to v4l_bound_align_image()
> there in the YUV422P case) to avoid padding, even though that's a
> different kind of padding - between planes. So, if line padding - as in
> your case - is indeed needed, I agree, that the correct way to support
> that is to implement driver-specific bytesperline and sizeimage
> calculations and, logically, those values should be used in
> soc_camera_g_fmt_vid_cap().
>
> I'll just change your patch a bit - I'll use "u32" types instead of
> "__u32" - this is a kernel internal struct and we don't need user-space
> exported types.

Ok, thanks.

You're right about u32 type... my bad.

So, I'll change that, rebase to:

git://linuxtv.org/media_tree.git	staging/for_v2.6.39

And resubmit for review. No problem.

Regards,
Sergio

>
> Thanks
> Guennadi
>
>> So, next time a driver tries a G_FMT, it currently gets recalculated by
>> a prefixed table (which comes from soc_mbus_bytes_per_line), which won't give
>> me what i had set before. And it will also recalculate a size image based on
>> this wrong bytesperline * height, which is also wrong, (lacks the * 3 / 2 for
>> NV12).
>>
>> Regards,
>> Sergio
>>
>>>
>>> Thanks
>>> Guennadi
>>>
>>>>
>>>> Signed-off-by: Sergio Aguirre<saaguirre@ti.com>
>>>> ---
>>>>    drivers/media/video/soc_camera.c |    9 ++++-----
>>>>    include/media/soc_camera.h       |    2 ++
>>>>    2 files changed, 6 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/soc_camera.c
>>>> b/drivers/media/video/soc_camera.c
>>>> index a66811b..59dc71d 100644
>>>> --- a/drivers/media/video/soc_camera.c
>>>> +++ b/drivers/media/video/soc_camera.c
>>>> @@ -363,6 +363,8 @@ static int soc_camera_set_fmt(struct soc_camera_device
>>>> *icd,
>>>>    	icd->user_width		= pix->width;
>>>>    	icd->user_height	= pix->height;
>>>>    	icd->colorspace		= pix->colorspace;
>>>> +	icd->bytesperline	= pix->bytesperline;
>>>> +	icd->sizeimage		= pix->sizeimage;
>>>>    	icd->vb_vidq.field	=
>>>>    		icd->field	= pix->field;
>>>>
>>>> @@ -608,12 +610,9 @@ static int soc_camera_g_fmt_vid_cap(struct file
>>>> *file, void *priv,
>>>>    	pix->height		= icd->user_height;
>>>>    	pix->field		= icd->vb_vidq.field;
>>>>    	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
>>>> -	pix->bytesperline	= soc_mbus_bytes_per_line(pix->width,
>>>> -						icd->current_fmt->host_fmt);
>>>> +	pix->bytesperline	= icd->bytesperline;
>>>>    	pix->colorspace		= icd->colorspace;
>>>> -	if (pix->bytesperline<   0)
>>>> -		return pix->bytesperline;
>>>> -	pix->sizeimage		= pix->height * pix->bytesperline;
>>>> +	pix->sizeimage		= icd->sizeimage;
>>>>    	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
>>>>    		icd->current_fmt->host_fmt->fourcc);
>>>>    	return 0;
>>>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>>>> index 9386db8..de81370 100644
>>>> --- a/include/media/soc_camera.h
>>>> +++ b/include/media/soc_camera.h
>>>> @@ -30,6 +30,8 @@ struct soc_camera_device {
>>>>    	s32 user_width;
>>>>    	s32 user_height;
>>>>    	enum v4l2_colorspace colorspace;
>>>> +	__u32 bytesperline;	/* for padding, zero if unused */
>>>> +	__u32 sizeimage;
>>>>    	unsigned char iface;		/* Host number */
>>>>    	unsigned char devnum;		/* Device number per host */
>>>>    	struct soc_camera_sense *sense;	/* See comment in struct definition */
>>>> --
>>>> 1.7.1
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

