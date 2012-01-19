Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:50926 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2ASNwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 08:52:22 -0500
Message-ID: <4F182013.90401@mlbassoc.com>
Date: Thu, 19 Jan 2012 06:52:19 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com> <201201191350.51761.laurent.pinchart@ideasonboard.com> <4F181711.1020201@mlbassoc.com> <201201191428.35340.laurent.pinchart@ideasonboard.com> <4F181C24.9030806@mlbassoc.com>
In-Reply-To: <4F181C24.9030806@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-01-19 06:35, Gary Thomas wrote:
> On 2012-01-19 06:28, Laurent Pinchart wrote:
>> Hi Gary,
>>
>> On Thursday 19 January 2012 14:13:53 Gary Thomas wrote:
>>> On 2012-01-19 05:50, Laurent Pinchart wrote:
>>>> On Thursday 19 January 2012 13:41:57 Gary Thomas wrote:
>>>>> On 2012-01-17 08:33, Laurent Pinchart wrote:
>>>>> <snip>
>>>>>>
>>>>>> I already had a couple of YUV support patches in my OMAP3 ISP tree at
>>>>>> git.kernel.org. I've rebased them on top of the lastest V4L/DVB tree
>>>>>> and pushed them to
>>>>>> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp
>>>>>> - omap3isp-yuv. Could you please try them, and see if they're usable
>>>>>> with your sensor ?
>>>>>
>>>>> I just tried this kernel with my board. The media control
>>>>> infrastructure comes up and all of the devices are created, but I can't
>>>>> access them.
>>>>>
>>>>> From the bootup log:
>>>>> Linux media interface: v0.10
>>>>> Linux video capture interface: v2.00
>>>>
>>>> Any message from the omap3isp driver and from the sensor driver ?
>>>
>>> No, it doesn't appear that the sensor was probed (or maybe it failed but
>>> no messages). I'll check into this.
>>
>> Is the omap3-isp driver compiled as a module ? If so, make sure iommu2.ko is
>> loaded first. 'rmmod omap3-isp&& modprobe iommu2&& modprobe omap3-isp' is a
>> quick way to test it.
>
> I have everything compiled in - no modules.
>
> My camera init code is attached. In the previous kernel, the I2C bus was
> probed implicitly when I initialized the OMAP3ISP. I thought I remembered
> some discussion about how that worked (maybe changing), so this is probably
> where the problem starts.
>
> If you have an example, I can check my setup against it.

Note: I reworked how the sensor+I2C was initialized to be
	omap3_init_camera(&cobra3530p73_isp_platform_data);
	omap_register_i2c_bus(cobra3530p73_isp_platform_data.subdevs->subdevs[0].i2c_adapter_id, 400,
                               cobra3530p73_isp_platform_data.subdevs->subdevs[0].board_info, 1);

The TVP5150 is now found, but 'media-ctl -p' still dies :-(

I'm going to see if I can't figure out where the ENXIO is coming from...

>>
>>> Has the way of adding the sensors on the i2c bus changed? I have my
>>> TVP5150 on a i2c-2 all by itself and with the 3.0+ kernel, it was being
>>> added when I initialized the camera subsystem.
>>>
>>> Do you have an example driver (like the BeagleBoard one that was in
>>> your omap3isp-sensors-next branch previously)?
>>>
>>>>> When I try to access the devices:
>>>>> root@cobra3530p73:~# media-ctl -p
>>>>> Opening media device /dev/media0
>>>>> media_open_debug: Can't open media device /dev/media0
>>>>> Failed to open /dev/media0
>>>>
>>>> Could you please strace that ?
>>>
>>> Attached. Looks like it blows up immediately.
>>>
>>> Note: my media-ctl program was built from SRCREV
>>> 7266b1b5433b5644a06f05edf61c36864ab11683
>>>
>>>>> The devices look OK to me:
>>>>> root@cobra3530p73:~# ls -l /dev/v* /dev/med*
>>>>> crw------- 1 root root 252, 0 Nov 8 10:44 /dev/media0
>>>>> crw-rw---- 1 root video 81, 7 Nov 8 10:44 /dev/v4l-subdev0
>>>>> crw-rw---- 1 root video 81, 8 Nov 8 10:44 /dev/v4l-subdev1
>>>>> crw-rw---- 1 root video 81, 9 Nov 8 10:44 /dev/v4l-subdev2
>>>>> crw-rw---- 1 root video 81, 10 Nov 8 10:44 /dev/v4l-subdev3
>>>>> crw-rw---- 1 root video 81, 11 Nov 8 10:44 /dev/v4l-subdev4
>>>>> crw-rw---- 1 root video 81, 12 Nov 8 10:44 /dev/v4l-subdev5
>>>>> crw-rw---- 1 root video 81, 13 Nov 8 10:44 /dev/v4l-subdev6
>>>>> crw-rw---- 1 root video 81, 14 Nov 8 10:44 /dev/v4l-subdev7
>>>>> crw-rw---- 1 root video 81, 15 Nov 8 10:44 /dev/v4l-subdev8
>>>>> crw-rw---- 1 root tty 7, 0 Nov 8 10:44 /dev/vcs
>>>>> crw-rw---- 1 root tty 7, 1 Nov 8 10:44 /dev/vcs1
>>>>> crw-rw---- 1 root tty 7, 128 Nov 8 10:44 /dev/vcsa
>>>>> crw-rw---- 1 root tty 7, 129 Nov 8 10:44 /dev/vcsa1
>>>>> crw-rw---- 1 root video 81, 0 Nov 8 10:44 /dev/video0
>>>>> crw-rw---- 1 root video 81, 1 Nov 8 10:44 /dev/video1
>>>>> crw-rw---- 1 root video 81, 2 Nov 8 10:44 /dev/video2
>>>>> crw-rw---- 1 root video 81, 3 Nov 8 10:44 /dev/video3
>>>>> crw-rw---- 1 root video 81, 4 Nov 8 10:44 /dev/video4
>>>>> crw-rw---- 1 root video 81, 5 Nov 8 10:44 /dev/video5
>>>>> crw-rw---- 1 root video 81, 6 Nov 8 10:44 /dev/video6
>>>>
>>>> Have the device nodes have been created manually ?
>>>
>>> No, automatically created by udev.
>>
>

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
