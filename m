Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab3A1KBX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:01:23 -0500
Message-ID: <51064D17.3090502@redhat.com>
Date: Mon, 28 Jan 2013 11:04:07 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: partial revert of "uvcvideo: set error_idx properly"
References: <CAKbGBLiOuyUUHd+eEm+z=THEu57b2LSDFtoN9frXASZ5BG7Huw@mail.gmail.com> <20121225025648.5208189a@redhat.com> <510255BD.8060605@redhat.com> <201301251140.13707.hverkuil@xs4all.nl> <20130127120629.2662ad60@redhat.com>
In-Reply-To: <20130127120629.2662ad60@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/27/2013 03:06 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 25 Jan 2013 11:40:13 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>> On Fri January 25 2013 10:51:57 Hans de Goede wrote:
>>> <modified the CC list to be more appropriate>
>>>
>>> Hi,
>>>
>>> On 12/25/2012 05:56 AM, Mauro Carvalho Chehab wrote:
>>>
>>>> The pwc driver can currently return -ENOENT at VIDIOC_S_FMT ioctl. This
>>>> doesn't seem right. Instead, it should be getting the closest format to
>>>> the requested one and return 0, passing the selected format back to
>>>> userspace, just like the other drivers do. I'm c/c Hans de Goede for him
>>>> to take a look on it.
>>>
>>> I've been looking into this today, and the ENOENT gets returned by
>>> pwc_set_video_mode and through that by:
>>> 1) Device init
>>> 2) VIDIOC_STREAMON
>>> 3) VIDIOC_S_PARM
>>> 4) VIDIOC_S_FMT
>>>
>>> But only when the requested width + height + pixelformat is an
>>> unsupported combination, and it being a supported combination
>>> already gets enforced by a call to pwc_get_size in
>>> pwc_vidioc_try_fmt, which also gets called from pwc_s_fmt_vid_cap
>>> before it does anything else.
>>>
>>> So the ENOENT can only happen on some internal driver error,
>>> I'm open for suggestions for a better error code to return in
>>> this case.
>>
>> Perhaps returning EINVAL but adding a WARN_ON would be a good compromise.
>>
>>> What I did notice is that pwc_vidioc_try_fmt returns EINVAL when
>>> an unsupported pixelformat is requested. IIRC we agreed that the
>>> correct behavior in this case is to instead just change the
>>> pixelformat to a default format, so I'll write a patch fixing
>>> this.
>>
>> There are issues with that idea in the case of TV capture cards, since
>> some important apps (tvtime and mythtv to a lesser extent) assume -EINVAL
>> in the case of unsupported pixelformats.
>>
>> Webcam apps can't assume that since gspca never returned -EINVAL, so I
>> think it should be OK to fix this in pwc, but Mauro may disagree.
>
> It is known that both MythTV and tvtime have issues.
>
> Well, I don't think that MythTV has webcam support. So, it will likely
> fail with pwc anyway, as it doesn't have a tuner. So, webcam drivers don't
> need to care with breaking anything on it.
>
> Tvtime can work with webcams, if they provide a resolution that it is
> compatible with it and if it supports UVYV or YUYV. This is not the case
> of pwc, that seems to support only pwc proprietary formats and yuv420.
>
> So, neither tvtime or MythTV currently works with pwc cameras.
>
> However, the issue is a little more complex, as we don't really know if
> there aren't any other applications that use a code similar to tvtime
> or MythYV.

I understand. A patch to change pwc to the behavior discussed in Barcelona
(so changing the format to a supported one rather then returning -EINVAL),
is part of my last pull-req, I'll leave it up to you whether you will take
it or not :)

If you don't take it I'll drop it from my tree, so that it does not
show up again in my next pull-req.

Regards,

Hans



>
> Regards,
> Mauro
>
