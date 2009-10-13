Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:42451 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZJMJFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 05:05:47 -0400
Received: by yxe26 with SMTP id 26so4164071yxe.4
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 02:05:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910101500.52177.hverkuil@xs4all.nl>
References: <7c34ac520909222330k73380177sbf103345f5d3d7ec@mail.gmail.com>
	 <200910090817.20736.hverkuil@xs4all.nl>
	 <7c34ac520910091834oef10d8fya66e897f71565c8b@mail.gmail.com>
	 <200910101500.52177.hverkuil@xs4all.nl>
Date: Tue, 13 Oct 2009 17:05:10 +0800
Message-ID: <7c34ac520910130205y57bfc3ap443cc64f730c11f8@mail.gmail.com>
Subject: Re: Support on discontinuous planer buffer and stride
From: Jun Nie <niej0001@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/10/10 Hans Verkuil <hverkuil@xs4all.nl>:
> On Saturday 10 October 2009 03:34:27 Jun Nie wrote:
>> 2009/10/9 Hans Verkuil <hverkuil@xs4all.nl>:
>> > On Friday 09 October 2009 07:07:32 Jun Nie wrote:
>> >> 2009/9/23 Jun Nie <niej0001@gmail.com>:
>> >> > Hi,
>> >> >      I re-send this email for the last one is rejected by system. I am
>> >> > sorry if you guys received both.
>> >> >
>> >> >      I am optimizing video playback with overlay with V4L2 driver. The
>> >> > video content is a sub-region of codec output. Thus a memory copy is
>> >> > necessary.
>> >> >     Is there plan to support for stride and discrete YUV planer in
>> >> > kernel? Such as below changes can help much for my usage case.
>> >> >
>> >> > --- a/include/linux/videodev2.h
>> >> > +++ b/include/linux/videodev2.h
>> >> > @@ -529,7 +529,20 @@ struct v4l2_buffer {
>> >> >                 __u32           offset;
>> >> >                 unsigned long   userptr;
>> >> >         } m;
>> >> > +       /* UV/GB location is valid only in planer case */
>> >> > +       union {
>> >> > +               __u32           offset_ug;
>> >> > +               unsigned long   userptr_ug;
>> >> > +       } m_ug;
>> >> > +       union {
>> >> > +               __u32           offset_vb;
>> >> > +               unsigned long   userptr_vb;
>> >> > +       } m_vb;
>> >> >         __u32                   length;
>> >> > +       /* stride of YUV or RGB */
>> >> > +       __u32                   stride_yr;
>> >> > +       __u32                   stride_ug;
>> >> > +       __u32                   stride_vb;
>> >> >         __u32                   input;
>> >> >         __u32                   reserved;
>> >> >  };
>> >> >
>> >> >     If such change is acceptable for everyone, I may help on the implementation.
>> >> >     Any comments are welcome.
>> >> >
>> >> > Jun
>> >> >
>> >>
>> >> Hi, Hans/Guennadi
>> >>
>> >>      What do you think of  supporting this feature?
>> >>
>> >> Jun
>> >>
>> >>
>> >
>> > Well, it is definitely not possible to do it in this manner since changing
>> > the size of struct v4l2_buffer will break the API. Furthermore, something like
>> > this will only work if the DMA engine can handle strides. Is that the case
>> > for your hardware? I don't think you mentioned what the hardware is you use.
>> >
>> > Regards,
>> >
>> >        Hans
>> >
>> > --
>> > Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>> >
>>
>> Hi, Hans
>>
>>      Thanks for your comments. My hardware, PXA168/910 support Y/U/V,
>> three DMA addresses. Y and UV stride can be different with width, such
>> as Y_stride == 336, UV_stride == 168 while width == 320. LCD
>> controller will handle dropping 20 bytes for every line before new
>> line scanning.
>>
>>     Application should query driver for the sub-region capability
>> before use it. Driver that do not support this feature will return
>> false by default, application should copy the sub-region to v4l2
>> buffer in this case.
>>
>>    The v4l2_buffer size change does impact IOCTL entry index value,
>> application re-compilation is needed, but no code change needed. It is
>> a balance between exploration of hardware capability and existing
>> application binary compatibility. I am new to this community. Was
>> there similar problems in community?
>
> It is not allowed to break application binary compatibility. That's just a
> fact of life.
>
> If you use the PXA hardware, does that mean that you use the pxa_camera
> driver? (Just making sure we talk about the same thing :-) )
>
> Anyway, what you are really trying to do is to crop before sending over the
> picture.
>
> The normal sequence for output devices is that with S_FMT you specify the
> size of the input frame and with S_CROP you can specify the target 'window'
> for that frame. Usually the target window is the same size as the input frame,
> but it can be a different size as well and in that case the hardware will
> have to scale the input frame to the size of the target window.
>
> Note that for output windows the S_CROP command is sort of the inverse
> operation of what S_CROP does for capturing. If we would redo the API I'm sure
> we would implement this differently since it is pretty confusing. But so be it.
>
> What you want to do here is to crop the input frame. So we need either some
> new S_PRECROP ioctl or perhaps some new v4l2_buf_type value and use that in
> combination with S_CROP. It should definitely be the responsibility of the
> driver to figure out the strides as that very much depends on the chosen pixel
> format. It's bad API design to put such hardware assumptions in the API.
>
> If we want to keep the symmetry between capture and output streams, then
> S_POSTCROP might be the better name. I.e. for capture streams S_CROP
> determines the source rectangle, S_FMT the output resolution of that rectangle
> and S_POSTCROP the area within that output rectangle that we actually want to
> use. All this reverses for an output stream, so S_POSTCROP would refer to the
> part of the output frame that we want to use. Just brainstorming, mind you :-).
>
> BTW, I noticed you didn't reply to the linux-media list. I recommend that you
> add that the next time you reply since this is of interest for everyone I think.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>

Hi, Hans
     Thanks for your brainstorming! It is really more formal to set
sub-region with CROP control API. I did not even think of it for LCD
never use AWB/AF control, other controls are also neglected by me. I
do not use pxa_camera.c :-)
     I will find a proper control ID or invent one. However, three DMA
buffer address still can not be supported if three planers is not
continuous, for every buffer should have unique addresses which can
not be passed to kernel with control. It seems I have to break
compatibility in our own product.
    Anyway, Thank you, Hans!

Jun
