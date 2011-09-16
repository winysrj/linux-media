Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41933 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1IPCez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 22:34:55 -0400
Received: by qyk30 with SMTP id 30so3161qyk.19
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 19:34:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E726B66.2020808@gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<4E6FC8E8.70008@gmail.com>
	<CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
	<4E70BA97.1090904@samsung.com>
	<CAHG8p1D1jnwRO0ie6xrXGL5Uhu+2YjoNdXzhnnBweZDPRyE1fw@mail.gmail.com>
	<4E726B66.2020808@gmail.com>
Date: Fri, 16 Sep 2011 10:34:54 +0800
Message-ID: <CAHG8p1D=Y0bD-QAtsqtRk2NmW8+tXNgUCr45Ho_Uayspn9=N9w@mail.gmail.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/9/16 Sylwester Nawrocki <snjw23@gmail.com>:
> On 09/15/2011 04:40 AM, Scott Jiang wrote:
>> 2011/9/14 Sylwester Nawrocki<s.nawrocki@samsung.com>:
>>> On 09/14/2011 09:10 AM, Scott Jiang wrote:
>>>>
>>>>>> +                     fmt =&bcap_formats[i];
>>>>>> +                     if (mbus_code)
>>>>>> +                             *mbus_code = fmt->mbus_code;
>>>>>> +                     if (bpp)
>>>>>> +                             *bpp = fmt->bpp;
>>>>>> +                     v4l2_fill_mbus_format(&mbus_fmt, pixfmt,
>>>>>> +                                             fmt->mbus_code);
>>>>>> +                     ret = v4l2_subdev_call(bcap->sd, video,
>>>>>> +                                             try_mbus_fmt,&mbus_fmt);
>>>>>> +                     if (ret<    0)
>>>>>> +                             return ret;
>>>>>> +                     v4l2_fill_pix_format(pixfmt,&mbus_fmt);
>>>>>> +                     pixfmt->bytesperline = pixfmt->width * fmt->bpp;
>>>>>> +                     pixfmt->sizeimage = pixfmt->bytesperline
>>>>>> +                                             * pixfmt->height;
>
> No need to clamp mbus_fmt.width and mbus_fmt.height to some maximum values
> to prevent allocating huge memory buffers ?
>
>>>>>
>>>>> Still pixfmt->pixelformat isn't filled.
>>>>>
>>>> no here pixfmt->pixelformat is passed in
>>>>
>>>>>> +                     return 0;
>>>>>> +             }
>>>>>> +     }
>>>>>> +     return -EINVAL;
>>>>>
>>>>> I think you should return some default format, rather than giving up
>>>>> when the fourcc doesn't match. However I'm not 100% sure this is
>>>>> the specification requirement.
>>>>>
>>>> no, there is no default format for bridge driver because it knows
>>>> nothing about this.
>>>> all the format info bridge needs ask subdevice.
>>>
>>> It's the bridge driver that exports a device node and is responsible for
>>> setting the default format. It should be possible to start streaming right
>>> after opening the device, without VIDIOC_S_FMT, with some reasonable defaults.
>>>
>>> If, as you say, the bridge knows nothing about formats what the bcap_formats[]
>>> array is here for ?
>>>
>> accually this array is to convert mbus to pixformat. ppi supports any formats.
>> Ideally it should contain all formats in v4l2, but it is enough at
>> present for our platform.
>> If I find someone needs more, I will add it.
>> So return -EINVAL means this format is out of range, it can't be supported now.
>
> Ok, fair enough. I guess you rely on subdev driver to return some supported
> value through mbus_try_fmt and then the bridge driver must be able to handle
> this. However it might make sense to validate the resolution in some places
> to prevent allocating insanely huge buffers, when the sensor subdev misbehaves.
>
all the format info is got from sensor, so it isn't out of control

>>
>> about default format, I think I can only call bcap_g_fmt_vid_cap in
>> probe to get this info.
>> Dose anybody have a better solution?
>
> How about doing that when device is opened for the first time ?
>
no, different input and std has different default format, so I think
there is no default format is a good choice.
app should negotiate format before use. I'm not sure all the v4l2 app
will do this step.
v4l2 spec only says driver must implement xx ioctl, but it doesn't say
app must call xx ioctl.
Anyone can tell me how many steps app must call?

> However it
> could make more sense to try to set format at the subdev and then check how
> it was adjusted. Not all subdevs might implement g_mbus_fmt op or some might
> not deliver sane default values.
>
in try_format and s_fmt I have implemented this in bridge driver and
all my sensor drivers have implemented relative callback.
