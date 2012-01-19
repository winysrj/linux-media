Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52923 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab2ASQNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 11:13:17 -0500
Received: by mail-yw0-f46.google.com with SMTP id o21so57212yho.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jan 2012 08:13:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F182A79.6000603@mlbassoc.com>
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com>
 <201201191350.51761.laurent.pinchart@ideasonboard.com> <4F181711.1020201@mlbassoc.com>
 <201201191428.35340.laurent.pinchart@ideasonboard.com> <4F181C24.9030806@mlbassoc.com>
 <CAAwP0s3_U1tzRM3TcW+hGCVvm+aowwO9f6g6t8_pvZSJxyMrgA@mail.gmail.com> <4F182A79.6000603@mlbassoc.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 19 Jan 2012 17:12:56 +0100
Message-ID: <CAAwP0s0bR2funmWFcHg+o7ydnVQmc81gKTahBy+gO9Z2uDgLvQ@mail.gmail.com>
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
To: Gary Thomas <gary@mlbassoc.com>, Enrico <ebutera@users.berlios.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 19, 2012 at 3:36 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2012-01-19 07:11, Javier Martinez Canillas wrote:
>>
>> On Thu, Jan 19, 2012 at 2:35 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>>>
>>> On 2012-01-19 06:28, Laurent Pinchart wrote:
>>>>
>>>>
>>>> Hi Gary,
>>>>
>>>> On Thursday 19 January 2012 14:13:53 Gary Thomas wrote:
>>>>>
>>>>>
>>>>> On 2012-01-19 05:50, Laurent Pinchart wrote:
>>>>>>
>>>>>>
>>>>>> On Thursday 19 January 2012 13:41:57 Gary Thomas wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 2012-01-17 08:33, Laurent Pinchart wrote:
>>>>>>>      <snip>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> I already had a couple of YUV support patches in my OMAP3 ISP tree
>>>>>>>> at
>>>>>>>> git.kernel.org. I've rebased them on top of the lastest V4L/DVB tree
>>>>>>>> and pushed them to
>>>>>>>>
>>>>>>>>
>>>>>>>> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp
>>>>>>>> - omap3isp-yuv. Could you please try them, and see if they're usable
>>>>>>>> with your sensor ?
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> I just tried this kernel with my board.  The media control
>>>>>>> infrastructure comes up and all of the devices are created, but I
>>>>>>> can't
>>>>>>> access them.
>>>>>>>
>>>>>>>   From the bootup log:
>>>>>>>     Linux media interface: v0.10
>>>>>>>     Linux video capture interface: v2.00
>>>>>>
>>>>>>
>>>>>>
>>>>>> Any message from the omap3isp driver and from the sensor driver ?
>>>>>
>>>>>
>>>>>
>>>>> No, it doesn't appear that the sensor was probed (or maybe it failed
>>>>> but
>>>>> no messages).  I'll check into this.
>>>>
>>>>
>>>>
>>>> Is the omap3-isp driver compiled as a module ? If so, make sure
>>>> iommu2.ko
>>>> is
>>>> loaded first. 'rmmod omap3-isp&&    modprobe iommu2&&    modprobe
>>>> omap3-isp'
>>>> is a
>>>>
>>>> quick way to test it.
>>>
>>>
>>>
>>> I have everything compiled in - no modules.
>>>
>>
>> At least for me, it only worked when compiled both the omap3-isp and
>> tvp5150 drivers as a module. If I compile them built-in, it fails.
>
>
> Can you share your board/sensor init code from your board-init.c
> so I can see how to manage this as a module?
>

Hi Gary,

The board specific init code is the same for both cases
(built-in/module), the only difference is how you compile the
omap3-isp and tvp5150 drivers.

Just set to m the Kconfig symbols CONFIG_VIDEO_OMAP3 and
CONFIG_VIDEO_TVP5150 in your .config file:

CONFIG_VIDEO_OMAP3=m
CONFIG_VIDEO_TVP5150=m

But if it help you, here [1] is the definitions for all the platform
device/data structures needed to register the TVP5150 with the omap3
isp code (isp_platform_data, isp_v4l2_subdevs_group,
isp_subdev_i2c_board_info, etc) and here [2] is the actual camera
initialization configuring the tvp reset and power down GPIO pins and
calling omap3_init_camera().

And take a look to our modified TVP5150 [3] and OMAP3 ISP CCDC [4] drivers.

This is based on an 2.6.37 kernel, but the API has not changed so it
should be also applicable to your kernel.

But I suggested to look at Enrico patches that were forward ported to
3.2, you probably can use those as is.

Hope it helps,

[1]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=blob;f=arch/arm/mach-omap2/exp-igep0022.c;h=475228832412c99a0a52a4652518279a59b87d0c;hb=db3cb47adf10504d3847d54927de50b2fa94c008
[2]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=blob;f=arch/arm/mach-omap2/board-igep00x0.c;h=1051c6fe949b9b8915101c9d8ac324aaed32cd7c;hb=db3cb47adf10504d3847d54927de50b2fa94c008
[3]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=blob;f=drivers/media/video/tvp5150.c;h=0b76e0ead27da45067265bb5c144f17994215db6;hb=db3cb47adf10504d3847d54927de50b2fa94c008
[4]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=blob;f=drivers/media/video/isp/ispccdc.c;h=28579f49a2495d25f675dabf37dadfe34a5218fa;hb=db3cb47adf10504d3847d54927de50b2fa94c008

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
