Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37088 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751475AbdFZNUF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 09:20:05 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Pavel Machek <pavel@ucw.cz>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Rob Herring" <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
Subject: Re: omap3isp camera was Re: [PATCH v1 0/6] Add support of OV9655
 camera
Date: Mon, 26 Jun 2017 13:19:27 +0000
Message-ID: <e725a457-5efc-22fa-ce97-bb7753185d21@st.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <385A82AC-CC23-41BD-9F57-0232F713FED9@goldelico.com>
 <1E453955-0C1A-414B-BBB2-C64B6D0EF378@goldelico.com>
 <20170625091856.GA22791@amd>
 <EDFD663F-37F9-42C2-92A9-66C2508B361E@goldelico.com>
 <20170626083927.GB9621@amd>
In-Reply-To: <20170626083927.GB9621@amd>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <5369098A36BC864388663457045F018A@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nikolaus,
some comments about pixel format/resolution below:

On 06/26/2017 10:39 AM, Pavel Machek wrote:
> On Mon 2017-06-26 08:05:04, H. Nikolaus Schaller wrote:
>> Hi Pavel,
>>
>>> Am 25.06.2017 um 11:18 schrieb Pavel Machek <pavel@ucw.cz>:
>>>
>>> Hi!
>>>
>>>> * unfortunately we still get no image :(
>>>>
>>>> The latter is likely a setup issue of our camera interface (OMAP3 ISP = Image Signal Processor) which
>>>> we were not yet able to solve. Oscilloscoping signals on the interface indicated that signals and
>>>> sync are correct. But we do not know since mplayer only shows a green screen.
>>>
>>> What mplayer command line do you use? How did you set up the pipeline
>>> with media-ctl?
>>>
>>> On kernel.org, I have tree called camera-fw5-6 , where camera works
>>> for me on n900. On gitlab, there's modifed fcam-dev, which can be used
>>> for testing.
>>
>> We did have yet another (non-DT) camera driver and media-ctl working in with 3.12.37,
>> but had no success yet to update it to work with modern kernels or drivers. It
>> is either that the (newer) drivers missing something or the media-ctl has changed.
>>
>> Here is the log of our scripts with Hugues' driver and our latest setup:
>>
>> root@letux:~# ./camera-demo sxga
>> DISPLAY=:0
>> XAUTHORITY=tcp
>> Camera: /dev/v4l-subdev8
>> Setting mode sxga
>> media-ctl -r
>> media-ctl -l '"ov965x":0 -> "OMAP3 ISP CCDC":0[1]'
>> media-ctl -l '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0[1]'
>> media-ctl -V '"ov965x":0 [UYVY2X8 1280x1024]'
>> media-ctl -V '"OMAP3 ISP CCDC":0 [UYVY2X8 1280x1024]'
>> media-ctl -V '"OMAP3 ISP CCDC":1 [UYVY 1280x1024]'
> 
> Ok, so you are using capture, not preview.
> 
> You may want to try this one:
> 
> commit 0eae9d2a8f096f703cbc8f9a0ab155cd3cc14cef
> Author: Pavel <pavel@ucw.cz>
> Date:   Mon Feb 13 21:26:51 2017 +0100
> 
>      omap3isp: fix VP2SDR bit so capture (not preview) works
> 
>      This is neccessary for capture (not preview) to work properly on
>          N900. Why is unknown.
> 	
> 									Pavel
> 
>> ### starting mplayer in sxga mode ###
>> mplayer tv:// -vf rotate=2 -tv driver=v4l2:device=/dev/video2:outfmt=uyvy:width=1280:height=1024:fps=15 -vo x11

=> "outfmt=uyvy:width=1280:height=1024"

Nikolaus,
Be careful that only VGA/RGB565 is coded in this basic version of OV9655,
perhaps this explain partly your troubles ?

>> MPlayer2 2.0-728-g2c378c7-4+b1 (C) 2000-2012 MPlayer Team
>>
>> Playing tv://.
>> Detected file format: TV
>> Selected driver: v4l2
>>   name: Video 4 Linux 2 input
>>   author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>>   comment: first try, more to come ;-)
>> v4l2: ioctl get standard failed: Invalid argument
>> Selected device: OMAP3 ISP CCDC output
>>   Capabilities:  video capture  video output  streaming
>>   supported norms:
>>   inputs: 0 = camera;
>>   Current input: 0
>>   Current format: unknown (0x0)
>> tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
>> v4l2: ioctl enum norm failed: Inappropriate ioctl for device
>> Error: Cannot set norm!
>> Selected input hasn't got a tuner!
>> v4l2: ioctl set mute failed: Inappropriate ioctl for device
>> v4l2: ioctl query control failed: Inappropriate ioctl for device
>> v4l2: ioctl query control failed: Inappropriate ioctl for device
>> v4l2: ioctl query control failed: Inappropriate ioctl for device
>> v4l2: ioctl query control failed: Inappropriate ioctl for device
>> v4l2: ioctl streamon failed: Broken pipe
>> [ass] auto-open
>> Opening video filter: [rotate=2]
>> VIDEO:  1280x1024  15.000 fps    0.0 kbps ( 0.0 kB/s)
>> Could not find matching colorspace - retrying with -vf scale...
>> Opening video filter: [scale]
>> [swscaler @ 0xb5ca9980]using unscaled uyvy422 -> yuv420p special converter
>> VO: [x11] 1024x1280 => 1024x1280 Planar YV12
>> [swscaler @ 0xb5ca9980]No accelerated colorspace conversion found from yuv420p to bgra.
>> Colorspace details not fully supported by selected vo.
>> Selected video codec: RAW UYVY [raw]
>> Audio: no sound
>> Starting playback...
>> V:   0.0  10/ 10 ??% ??% ??,?% 0 0 $<3>
>>
>>
>> MPlayer interrupted by signal 2 in module: filter_video
>> V:   0.0  11/ 11 ??% ??% ??,?% 0 0 $<3>
>> v4l2: ioctl set mute failed: Inappropriate ioctl for device
>> v4l2: 0 frames successfully processed, 0 frames dropped.
>>
>> Exiting... (Quit)
>> root@letux:~#
>>
>> BR and thanks,
>> Nikolaus
>>
> 
> 
> 
