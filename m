Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52184 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2KEJoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 04:44:10 -0500
MIME-Version: 1.0
In-Reply-To: <5096E8D7.4070304@gmail.com>
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com>
	<5096C561.5000108@gmail.com>
	<CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com>
	<5096E8D7.4070304@gmail.com>
Date: Mon, 5 Nov 2012 12:44:09 +0300
Message-ID: <CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
From: Andrey Gusakov <dron0gus@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

>> But documentation on ov9650 is too conflicting and did not cover all
>> registers used in driver.
> Do you mean the OV9650 datasheet, version 1.3, from September 24, 2004 ?
Yes. Also I have datasheet version 1.91 from January 28, 2005 and
Application note 1.1 from 7 December 2004
All can be found here [1].
It seems there is different versions of sensor exist. With VER=0x50
and 0x52. I have second one.

>>> What resolution are you testing with ?
>>
>> 320x240.
>>>
>>> Are you using media-ctl to configure resolution on the camif and sensor
>>> subdev ?
>>
>> I'm using GStreamer:
>> gst-launch -v v4l2src device=/dev/video0 \
>>          ! video/x-raw-yuv, width=320, height=240 \
>>          ! ffmpegcolorspace \
>>          ! fbdevsink
>
>
> AFAIR, in the s3c-camif-v3.5 branch there was a bug that the CAMIF input
> resolution was not being properly set to what was reported by the sensor
> driver (default s3c-camif resolution is 640 x 480). The s3c-camif driver
> is supposed to get format from a sensor subdev and set it on the S3C-CAMIF
> subdev, upon image sensor subdev registration. Please see function
> camif_register_sensor() for details.
>
> The above issue should be fixed in this branch:
> [1] http://git.linuxtv.org/snawrocki/media.git/shortlog/refs/heads/s3c-camif
>
> Also, it could be verified by setting the formats with media-ctl manually,
> before running gst-launch, i.e.
>
> media-ctl --set-v4l2 '"OV9650":0 [fmt: YUYV2X8/320x240]'
> media-ctl --set-v4l2 '"S3C-CAMIF":0 [fmt: YUYV2X8/320x240]'
>
> with your current kernel and the s3c-camif driver.
> media-ctl was integrated in the OSELAS mini2440 BSP and probably is also
> in the mini6440 version.
Thanks. I'll try it. media-ctl from OpenEmbedded for some reason don't
like this params.

>>> And what kernel version is it ?
>>
>> 3.6.0-rc3 with some modifications for mini6410 devboard. Have no time
>> to move my stuff to last samsung kernel.
>
>
> OK, it's recent enough. The patches from s3c-camif branch should apply
> cleanly.
>
>
>>> Can you measure the frequency of the master clock that CAMIF provides
>>> to the sensor ?
>>
>> 16.67 MHz. As i understand this is limitation of divider. Min clock is
>> HCLKx2 (266) / 16 = 16.67 in my case.
>> PCLK is near 4 MHz.
>
>
> Looks fine (16.625).
>
>
>>>> :) I spend two days trying to fix it, and now I'm out of ideas. May be
>>>> you can help me.
>>>> I have some questions.
>>>> Did you have to invert some of camera signals (VSYNC, HREF, PCLK)?
>>>> Maybe you had to make some hardware modifications? (i use CAM130
>>>> module from FriendlyARM).
>>>
>>>
>>>
>>> I'm also using CAM130, attached to mini2440 board without any hardware
>>> modifications. Tomasz, (added at Cc) tested the driver on mini6410 and
>>> it worked with same camera module. VSYNC, PCLK, etc. configuration is
>>> specified in the board patch (as in the below branch).
>>>
>>> Are you using this version of patches:
>>> http://git.linuxtv.org/snawrocki/media.git/shortlog/refs/heads/s3c-camif
>>> ?
>>
>> I'm using patches from
>> https://github.com/snawrocki/linux/commits/s3c-camif-v3.5 wich was in
>> your mail to samsung maillist.
>
>
> I suggest you to update to the s3c-camif branch as above, it includes some
> bug fixes. Sorry, I don't have exact patch for your issue handy right now.
I just try this branch. No luck. Now it fails on __ov965x_set_params
while writing some registers:
...
OV9650: i2c_write: 0x40 : 0xc1. ret: 2
OV9650: i2c_write: 0x29 : 0x3f. ret: 2
OV9650: i2c_write: 0x0F : 0x43. ret: -6
...
If I comment out exits on this errors, following writes in sensors
give -6 (ENXIO) or -111 (ECONNREFUSED) erros. Seems sensors hung after
write to some registers.

>>> I've also added at Cc In-Bae Jeong, who had successfully used the driver
>>> on s3c6410 based board. However I'm not really sure now which board
>>> exactly
>>> was it.
>>
>> I'm using mini6410. But i think there is only one way sensor can be
>> connected to FIMC. Some differents may be in Reset and Power-down
>> signals, but not in interface.
>
>
> Yes, right. But since I2C communication works, the GPIOs and the clock
> should be fine. It looks like there is a mismatch in the sensor and
> the CAMIF registers configuration.
>
>
>> P.S. Try to connect ov2640, but seems it need some modifications in
>> FIMC driver to be connected thrue soc_camera_link.
>
>
> Hmm, this is a general problem in the v4l2 core code. The are two slightly
> incompatible interfaces that sensor subdevs are using. There were attempts
> to make soc_camera subdevs usable with non-soc_camera host drivers, but it
> is not finished yet. I could try to look at that, but I can't promise when
> that happens.
>
> There are pad level ops needed in the ov2640 driver - in addition to or
> instead of g/s/try_mbus_fmt. Regulator supply names are not supposed to be
> passed through platform data, those should be defined with fixed names as
> specified in the sensor datasheet and board code should be providing
> required
> regulator supply names or the dummy regulator should be used. IMO passing
> regulator supply names through platform data is the regulator API misuse.
>
> We need to resolve this issue at the v4l2 core level though, as problems
> like this appear more and more often.
Thanks for the advice. Will probably have to deal with this in the near future.

[1] http://roboforum.ru/forum36/topic7835.html
