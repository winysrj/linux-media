Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:52691 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab2ASRXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 12:23:05 -0500
Message-ID: <4F185171.9080504@mlbassoc.com>
Date: Thu, 19 Jan 2012 10:22:57 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com> <201201191350.51761.laurent.pinchart@ideasonboard.com> <4F181711.1020201@mlbassoc.com> <201201191428.35340.laurent.pinchart@ideasonboard.com> <4F181C24.9030806@mlbassoc.com> <CAAwP0s3_U1tzRM3TcW+hGCVvm+aowwO9f6g6t8_pvZSJxyMrgA@mail.gmail.com> <4F182A79.6000603@mlbassoc.com> <4F184E0B.3010402@mlbassoc.com>
In-Reply-To: <4F184E0B.3010402@mlbassoc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-01-19 10:08, Gary Thomas wrote:
> On 2012-01-19 07:36, Gary Thomas wrote:
>> On 2012-01-19 07:11, Javier Martinez Canillas wrote:
>>> On Thu, Jan 19, 2012 at 2:35 PM, Gary Thomas<gary@mlbassoc.com> wrote:
>>>> On 2012-01-19 06:28, Laurent Pinchart wrote:
>>>>>
>>>>> Hi Gary,
>>>>>
>>>>> On Thursday 19 January 2012 14:13:53 Gary Thomas wrote:
>>>>>>
>>>>>> On 2012-01-19 05:50, Laurent Pinchart wrote:
>>>>>>>
>>>>>>> On Thursday 19 January 2012 13:41:57 Gary Thomas wrote:
>>>>>>>>
>>>>>>>> On 2012-01-17 08:33, Laurent Pinchart wrote:
>>>>>>>> <snip>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I already had a couple of YUV support patches in my OMAP3 ISP tree at
>>>>>>>>> git.kernel.org. I've rebased them on top of the lastest V4L/DVB tree
>>>>>>>>> and pushed them to
>>>>>>>>>
>>>>>>>>> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp
>>>>>>>>> - omap3isp-yuv. Could you please try them, and see if they're usable
>>>>>>>>> with your sensor ?
>>>>>>>>
>>>>>>>>
>>>>>>>> I just tried this kernel with my board. The media control
>>>>>>>> infrastructure comes up and all of the devices are created, but I can't
>>>>>>>> access them.
>>>>>>>>
>>>>>>>> From the bootup log:
>>>>>>>> Linux media interface: v0.10
>>>>>>>> Linux video capture interface: v2.00
>>>>>>>
>>>>>>>
>>>>>>> Any message from the omap3isp driver and from the sensor driver ?
>>>>>>
>>>>>>
>>>>>> No, it doesn't appear that the sensor was probed (or maybe it failed but
>>>>>> no messages). I'll check into this.
>>>>>
>>>>>
>>>>> Is the omap3-isp driver compiled as a module ? If so, make sure iommu2.ko
>>>>> is
>>>>> loaded first. 'rmmod omap3-isp&& modprobe iommu2&& modprobe omap3-isp'
>>>>> is a
>>>>>
>>>>> quick way to test it.
>>>>
>>>>
>>>> I have everything compiled in - no modules.
>>>>
>>>
>>> At least for me, it only worked when compiled both the omap3-isp and
>>> tvp5150 drivers as a module. If I compile them built-in, it fails.
>>
>> Can you share your board/sensor init code from your board-init.c
>> so I can see how to manage this as a module?
>>
>> n.b. I really don't like messing with modules - it used to work
>> fine, so IMO it should continue to do so.
>
> I figured out part of the problem - I had tried to reuse my 3.0 kernel
> config. Sadly, this left out major chunks, in particular the OMAP3ISP
> was left out because OMAP_IOVMMU is new. I got this configured and it's
> starting to initialize, but now it fails during boot:
> kernel BUG at /local/pinchartl-media/drivers/media/media-entity.c:348
> [<c02416c4>] (media_entity_create_link+0x60/0x138) from [<c0251c0c>] (isp_probe+0x938/0xba4)
> [<c0251c0c>] (isp_probe+0x938/0xba4) from [<c01e381c>] (platform_drv_probe+0x1c/0x24)
> [<c01e381c>] (platform_drv_probe+0x1c/0x24) from [<c01e24f4>] (driver_probe_device+0xcc/0x1b4)
> [<c01e24f4>] (driver_probe_device+0xcc/0x1b4) from [<c01e1a0c>] (bus_for_each_drv+0x4c/0x8c)
> [<c01e1a0c>] (bus_for_each_drv+0x4c/0x8c) from [<c01e2750>] (device_attach+0x74/0xa0)
> [<c01e2750>] (device_attach+0x74/0xa0) from [<c01e1838>] (bus_probe_device+0x28/0x50)
> [<c01e1838>] (bus_probe_device+0x28/0x50) from [<c01e07f8>] (device_add+0x40c/0x590)
> [<c01e07f8>] (device_add+0x40c/0x590) from [<c01e3e44>] (platform_device_add+0x108/0x168)
> [<c01e3e44>] (platform_device_add+0x108/0x168) from [<c0457c84>] (cobra3530p73_camera_init+0x13c/0x188)
> [<c0457c84>] (cobra3530p73_camera_init+0x13c/0x188) from [<c0008730>] (do_one_initcall+0x94/0x15c)
> [<c0008730>] (do_one_initcall+0x94/0x15c) from [<c044d21c>] (kernel_init+0x78/0x120)
> [<c044d21c>] (kernel_init+0x78/0x120) from [<c00146c8>] (kernel_thread_exit+0x0/0x8)
>
> Any ideas what else I might have missed? My kernel config is attached in case
> that helps.

It turns out that drivers/media/video/tvp5150.c is not the most
recent one posted - it has no v4l2_subdev support in it at all :-(

I copied the one I've been using from my 3.0+ kernel and it
now builds.  I can run media-ctl and configure the pipeline,
etc, but sadly no data is captured at all :-(

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
