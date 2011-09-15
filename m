Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39093 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1IOCkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 22:40:53 -0400
Received: by qyk7 with SMTP id 7so2478737qyk.19
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 19:40:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E70BA97.1090904@samsung.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<4E6FC8E8.70008@gmail.com>
	<CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
	<4E70BA97.1090904@samsung.com>
Date: Thu, 15 Sep 2011 10:40:52 +0800
Message-ID: <CAHG8p1D1jnwRO0ie6xrXGL5Uhu+2YjoNdXzhnnBweZDPRyE1fw@mail.gmail.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
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

2011/9/14 Sylwester Nawrocki <s.nawrocki@samsung.com>:
> On 09/14/2011 09:10 AM, Scott Jiang wrote:
>>>> +static int bcap_qbuf(struct file *file, void *priv,
>>>> +                     struct v4l2_buffer *buf)
>>>> +{
>>>> +     struct bcap_device *bcap_dev = video_drvdata(file);
>>>> +     struct v4l2_fh *fh = file->private_data;
>>>> +     struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
>>>> +
>>>> +     if (!bcap_fh->io_allowed)
>>>> +             return -EACCES;
>>>
>>> I suppose -EBUSY would be more appropriate here.
>>>
>> no, io_allowed is to control which file instance has the right to do I/O.
>
> Looks like you are doing here what the v4l2 priority mechanism is meant for.
> Have you considered the access priority (VIDIOC_G_PRIORITY/VIDIOC_S_PRIORITY
> and friends)? Does it have any shortcomings?
>
I refer to davinci driver, perhaps it is not good enough, I'd like to
modify it later.

>>
>>>> +                     fmt =&bcap_formats[i];
>>>> +                     if (mbus_code)
>>>> +                             *mbus_code = fmt->mbus_code;
>>>> +                     if (bpp)
>>>> +                             *bpp = fmt->bpp;
>>>> +                     v4l2_fill_mbus_format(&mbus_fmt, pixfmt,
>>>> +                                             fmt->mbus_code);
>>>> +                     ret = v4l2_subdev_call(bcap->sd, video,
>>>> +                                             try_mbus_fmt,&mbus_fmt);
>>>> +                     if (ret<  0)
>>>> +                             return ret;
>>>> +                     v4l2_fill_pix_format(pixfmt,&mbus_fmt);
>>>> +                     pixfmt->bytesperline = pixfmt->width * fmt->bpp;
>>>> +                     pixfmt->sizeimage = pixfmt->bytesperline
>>>> +                                             * pixfmt->height;
>>>
>>> Still pixfmt->pixelformat isn't filled.
>>>
>> no here pixfmt->pixelformat is passed in
>>
>>>> +                     return 0;
>>>> +             }
>>>> +     }
>>>> +     return -EINVAL;
>>>
>>> I think you should return some default format, rather than giving up
>>> when the fourcc doesn't match. However I'm not 100% sure this is
>>> the specification requirement.
>>>
>> no, there is no default format for bridge driver because it knows
>> nothing about this.
>> all the format info bridge needs ask subdevice.
>
> It's the bridge driver that exports a device node and is responsible for
> setting the default format. It should be possible to start streaming right
> after opening the device, without VIDIOC_S_FMT, with some reasonable defaults.
>
> If, as you say, the bridge knows nothing about formats what the bcap_formats[]
> array is here for ?
>
accually this array is to convert mbus to pixformat. ppi supports any formats.
Ideally it should contain all formats in v4l2, but it is enough at
present for our platform.
If I find someone needs more, I will add it.
So return -EINVAL means this format is out of range, it can't be supported now.

about default format, I think I can only call bcap_g_fmt_vid_cap in
probe to get this info.
Dose anybody have a better solution?
