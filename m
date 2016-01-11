Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36374 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbcAKL4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 06:56:30 -0500
Received: by mail-io0-f177.google.com with SMTP id g73so149549900ioe.3
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 03:56:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56939234.3050305@xs4all.nl>
References: <CAJ2oMhKLbDc1xBQgyz0Ga9K6PQ7M8OGTn7_dNywFs=3XrNrP6A@mail.gmail.com>
	<56939234.3050305@xs4all.nl>
Date: Mon, 11 Jan 2016 13:56:29 +0200
Message-ID: <CAJ2oMhLnioF34P18SpLbRbbC7-ET1-Xi4EdPZ+eyEHP03C=dZA@mail.gmail.com>
Subject: Re: Using v4l2 API example as-is for video capture
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 11, 2016 at 1:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 01/08/2016 07:25 AM, Ran Shalit wrote:
>> Hello,
>>
>> I am trying to use v4l2 example from API documentation:
>> inhttp://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html .
>> As a start, I wanted to first try uding it with vivid (virtual device driver).
>> I found excelent vivid documentation in the kernel, which is very helpful:
>> https://www.kernel.org/doc/Documentation/video4linux/vivid.txt
>>
>> But on trying to use the example as-is for capturing video frames into
>> file, and playing the file, I encounter difficulties.
>> I tried the example as-is, and then tried several resolution,
>> pixelformat, different inputs, but it always result with video with a
>> sync problems ( the test bars of the video are keep moving in the
>> horizontal axis, or the text is changing its location for one frame to
>> the next).
>>
>> I compiled the v4l2 API example AS-IS from:
>> http://linuxtv.org/downloads/v4l-dvb-apis/capture-example.html with
>> minor modification in the --force part of the example (I also tried
>> the example as is without modifications but it did not help), so that
>> I choose hd input , and 1920x1080 resolution, V4L2_PIX_FMT_YUV420
>> (also tried V4L2_PIX_FMT_YUV422P) , progressive.
>>
>>   if (force_format) {
>>             input = 3;  // <<-- HD input device
>>             if (-1==xioctl(fd,VIDIOC_S_INPUT,&input))
>>             {
>>              errno_exit("VIDIOC_S_INPUT");
>>             }
>>             fmt.fmt.pix.width       = 1920;
>>             fmt.fmt.pix.height      = 1080;
>>             fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420; // <<-
>> tried also V4L2_PIX_FMT_YUV422P
>>             fmt.fmt.pix.field       = V4L2_FIELD_NONE; // <- trying to
>> capture progressive
>>
>>             if (-1 == xioctl(fd, VIDIOC_S_FMT, &fmt))
>>                     errno_exit("VIDIOC_S_FMT");
>>
>>     } else {
>>
>> I run the application with (the compiled code using pixelformat =
>> V4L2_PIX_FMT_YUV420 trial ):
>>
>> ./v4l2_example -f -o -c 10  > cap_yuv420p.yuv
>
> I'm not sure what you're doing, but this just works for me (I use yuv420p to
> play this back).
>
> Note: you can find the same code in v4l-utils in contrib/test. That's the code
> I used (with you modifications).
>
> Regards,
>
>         Hans
>
Right,
It works for me. I work with Centos 7.2 which comes with kernel
3.10.0. The YUV420 format are missing there, I understood it after
delving into this issue.

Thanks you !
Ran
