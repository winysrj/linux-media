Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47837 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab1IOVRc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 17:17:32 -0400
Received: by fxe4 with SMTP id 4so1020434fxe.19
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2011 14:17:31 -0700 (PDT)
Message-ID: <4E726B66.2020808@gmail.com>
Date: Thu, 15 Sep 2011 23:17:26 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>	<4E6FC8E8.70008@gmail.com>	<CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>	<4E70BA97.1090904@samsung.com> <CAHG8p1D1jnwRO0ie6xrXGL5Uhu+2YjoNdXzhnnBweZDPRyE1fw@mail.gmail.com>
In-Reply-To: <CAHG8p1D1jnwRO0ie6xrXGL5Uhu+2YjoNdXzhnnBweZDPRyE1fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2011 04:40 AM, Scott Jiang wrote:
> 2011/9/14 Sylwester Nawrocki<s.nawrocki@samsung.com>:
>> On 09/14/2011 09:10 AM, Scott Jiang wrote:
>>>
>>>>> +                     fmt =&bcap_formats[i];
>>>>> +                     if (mbus_code)
>>>>> +                             *mbus_code = fmt->mbus_code;
>>>>> +                     if (bpp)
>>>>> +                             *bpp = fmt->bpp;
>>>>> +                     v4l2_fill_mbus_format(&mbus_fmt, pixfmt,
>>>>> +                                             fmt->mbus_code);
>>>>> +                     ret = v4l2_subdev_call(bcap->sd, video,
>>>>> +                                             try_mbus_fmt,&mbus_fmt);
>>>>> +                     if (ret<    0)
>>>>> +                             return ret;
>>>>> +                     v4l2_fill_pix_format(pixfmt,&mbus_fmt);
>>>>> +                     pixfmt->bytesperline = pixfmt->width * fmt->bpp;
>>>>> +                     pixfmt->sizeimage = pixfmt->bytesperline
>>>>> +                                             * pixfmt->height;

No need to clamp mbus_fmt.width and mbus_fmt.height to some maximum values
to prevent allocating huge memory buffers ?

>>>>
>>>> Still pixfmt->pixelformat isn't filled.
>>>>
>>> no here pixfmt->pixelformat is passed in
>>>
>>>>> +                     return 0;
>>>>> +             }
>>>>> +     }
>>>>> +     return -EINVAL;
>>>>
>>>> I think you should return some default format, rather than giving up
>>>> when the fourcc doesn't match. However I'm not 100% sure this is
>>>> the specification requirement.
>>>>
>>> no, there is no default format for bridge driver because it knows
>>> nothing about this.
>>> all the format info bridge needs ask subdevice.
>>
>> It's the bridge driver that exports a device node and is responsible for
>> setting the default format. It should be possible to start streaming right
>> after opening the device, without VIDIOC_S_FMT, with some reasonable defaults.
>>
>> If, as you say, the bridge knows nothing about formats what the bcap_formats[]
>> array is here for ?
>>
> accually this array is to convert mbus to pixformat. ppi supports any formats.
> Ideally it should contain all formats in v4l2, but it is enough at
> present for our platform.
> If I find someone needs more, I will add it.
> So return -EINVAL means this format is out of range, it can't be supported now.

Ok, fair enough. I guess you rely on subdev driver to return some supported
value through mbus_try_fmt and then the bridge driver must be able to handle
this. However it might make sense to validate the resolution in some places
to prevent allocating insanely huge buffers, when the sensor subdev misbehaves.

> 
> about default format, I think I can only call bcap_g_fmt_vid_cap in
> probe to get this info.
> Dose anybody have a better solution?

How about doing that when device is opened for the first time ? However it
could make more sense to try to set format at the subdev and then check how 
it was adjusted. Not all subdevs might implement g_mbus_fmt op or some might
not deliver sane default values.

