Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59755 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3B0Vlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 16:41:47 -0500
Message-ID: <512E7D97.4000608@gmail.com>
Date: Wed, 27 Feb 2013 22:41:43 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Lonsn <lonsn2005@gmail.com>
CC: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: SMDKV210 support issue in kernel 3.8 (dma-pl330 and HDMI failed)
References: <51275DF7.4010600@gmail.com> <512CB1BE.1070401@gmail.com> <512D160D.1050706@gmail.com> <512D1BFB.4000700@gmail.com> <512E22AA.8020006@gmail.com> <512E2ABF.1080206@gmail.com>
In-Reply-To: <512E2ABF.1080206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/27/2013 04:48 PM, Lonsn wrote:
> 于 2013/2/27 23:13, Lonsn 写道:
>>> On 02/26/2013 09:07 PM, Sylwester Nawrocki wrote:
>>>> On 02/26/2013 01:59 PM, Lonsn wrote:
[...]
>> Now kernel prints the following HDMI related:
>> m2m-testdev m2m-testdev.0: mem2mem-testdevDevice registered as
>> /dev/video0
>> s5p-jpeg s5p-jpeg.0: encoder device registered as /dev/video1
>> s5p-jpeg s5p-jpeg.0: decoder device registered as /dev/video2
>> s5p-jpeg s5p-jpeg.0: Samsung S5P JPEG codec
>> s5p-mfc s5p-mfc: decoder registered as /dev/video3
>> s5p-mfc s5p-mfc: encoder registered as /dev/video4
>> s5p-hdmi s5pv210-hdmi: probe start
>> s5p-hdmi s5pv210-hdmi: HDMI resource init
>> s5p-hdmiphy 3-0038: probe successful
>> s5p-hdmi s5pv210-hdmi: probe successful
>> Samsung TV Mixer driver, (c) 2010-2011 Samsung Electronics Co., Ltd.
>>
>> s5p-mixer s5p-mixer: probe start
>> s5p-mixer s5p-mixer: resources acquired
>> s5p-mixer s5p-mixer: added output 'S5P HDMI connector' from module
>> 's5p-hdmi'
>> s5p-mixer s5p-mixer: module s5p-sdo provides no subdev!
>> s5p-mixer s5p-mixer: registered layer graph0 as /dev/video5
>> s5p-mixer s5p-mixer: registered layer graph1 as /dev/video6
>> s5p-mixer s5p-mixer: registered layer video0 as /dev/video7
>> s5p-mixer s5p-mixer: probe successful
>>
>> How can I test the HDMI output whether it's OK? Which /dev/video is real
>> HDMI output? I have used
>> http://git.infradead.org/users/kmpark/public-apps hdmi test program buf
>> failed:
>> root@linaro-developer:/opt# ./tvdemo /dev/video7 720 480 0 0
>> ERROR(main.c:80) : VIDIOC_S_FMT failed: Invalid argument

It failed because you've opened device node of the Video Processor, which
supports only NV12/21(MT) formats. I believe the v4l2-hdmi-example
application, which renders some simple test images, needs to be run with one
the graphics layer video nodes as an argument.  Doesn't it work when you 
try
on /dev/video5 or /dev/video6 ?

>> root@linaro-developer:/opt#
>> Maybe I still miss some configuration in mach-smdkv210.c.

I don't think so, it all looks more or less OK now :)

> The kernel print when run tvdemo:
> root@linaro-developer:/opt# ./tvdemo /dev/video7 720 480 0 0
> ERROR(main.c:80) : VIDIOC_S_FMT failed: Invalid argument
> Aborted
> root@linaro-developer:/opt# dmesg
> s5p-mixer s5p-mixer: mxr_video_open:762
> s5p-mixer s5p-mixer: resume - start
> s5p-mixer s5p-mixer: resume - finished
> s5p-hdmi s5pv210-hdmi: hdmi_g_mbus_fmt
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (0, 0)
> s5p-mixer s5p-mixer: src.full_size = (720, 480)
> s5p-mixer s5p-mixer: src.size = (720, 480)
> s5p-mixer s5p-mixer: src.offset = (0, 0)
> s5p-mixer s5p-mixer: dst.full_size = (720, 480)
> s5p-mixer s5p-mixer: dst.size = (720, 480)
> s5p-mixer s5p-mixer: dst.offset = (0, 0)
> s5p-mixer s5p-mixer: ratio = (65536, 65536)
> s5p-mixer s5p-mixer: mxr_s_fmt:322
> s5p-mixer s5p-mixer: not recognized fourcc: 34524742

Yes, it must definitely be incorrect video node. Only the graph0/1
devices support RGB.

Regards,
Sylwester
