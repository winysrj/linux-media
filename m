Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40439 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2KDWOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 17:14:54 -0500
Message-ID: <5096E8D7.4070304@gmail.com>
Date: Sun, 04 Nov 2012 23:14:47 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Andrey Gusakov <dron0gus@gmail.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com> <5096C561.5000108@gmail.com> <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com>
In-Reply-To: <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

Cc: LMML

On 11/04/2012 09:43 PM, Andrey Gusakov wrote:
> Hi all.
>
>>> I'm testing your FIMC driver on S3C6410 hardware with OV9650 (in plans
>>> OV2640).
>>> I fixed some register definition, gpio init, fixed IRQ handling for
>>> S3C6410. So now i can get test frames from internal pattern generator.
>>> But when i try to read from external sensor i got blue or green trash.
>> Does it change when external light conditions change ? Or is it completely
>> random ?
> Yes. When it's dark - almost all picture is green. when I light on
> sensor, picture become more noisy with more blue pixels.
> If i comment out ov965x_init_regs write to sensor, I get black and
> white noise, like on TV when no signal.
> My opinion is there is some mistmatch in formats between sensor and FIMC.

Yes, I also suspect this is the root cause.

> But documentation on ov9650 is too conflicting and did not cover all
> registers used in driver.

Do you mean the OV9650 datasheet, version 1.3, from September 24, 2004 ?

>> What resolution are you testing with ?
> 320x240.
>> Are you using media-ctl to configure resolution on the camif and sensor
>> subdev ?
> I'm using GStreamer:
> gst-launch -v v4l2src device=/dev/video0 \
>          ! video/x-raw-yuv, width=320, height=240 \
>          ! ffmpegcolorspace \
>          ! fbdevsink

AFAIR, in the s3c-camif-v3.5 branch there was a bug that the CAMIF input
resolution was not being properly set to what was reported by the sensor
driver (default s3c-camif resolution is 640 x 480). The s3c-camif driver
is supposed to get format from a sensor subdev and set it on the S3C-CAMIF
subdev, upon image sensor subdev registration. Please see function
camif_register_sensor() for details.

The above issue should be fixed in this branch:
[1] http://git.linuxtv.org/snawrocki/media.git/shortlog/refs/heads/s3c-camif

Also, it could be verified by setting the formats with media-ctl manually,
before running gst-launch, i.e.

media-ctl --set-v4l2 '"OV9650":0 [fmt: YUYV2X8/320x240]'
media-ctl --set-v4l2 '"S3C-CAMIF":0 [fmt: YUYV2X8/320x240]'

with your current kernel and the s3c-camif driver.
media-ctl was integrated in the OSELAS mini2440 BSP and probably is also
in the mini6440 version.

>> And what kernel version is it ?
> 3.6.0-rc3 with some modifications for mini6410 devboard. Have no time
> to move my stuff to last samsung kernel.

OK, it's recent enough. The patches from s3c-camif branch should apply
cleanly.

>> Can you measure the frequency of the master clock that CAMIF provides
>> to the sensor ?
> 16.67 MHz. As i understand this is limitation of divider. Min clock is
> HCLKx2 (266) / 16 = 16.67 in my case.
> PCLK is near 4 MHz.

Looks fine (16.625).

>>> :) I spend two days trying to fix it, and now I'm out of ideas. May be
>>> you can help me.
>>> I have some questions.
>>> Did you have to invert some of camera signals (VSYNC, HREF, PCLK)?
>>> Maybe you had to make some hardware modifications? (i use CAM130
>>> module from FriendlyARM).
>>
>>
>> I'm also using CAM130, attached to mini2440 board without any hardware
>> modifications. Tomasz, (added at Cc) tested the driver on mini6410 and
>> it worked with same camera module. VSYNC, PCLK, etc. configuration is
>> specified in the board patch (as in the below branch).
>>
>> Are you using this version of patches:
>> http://git.linuxtv.org/snawrocki/media.git/shortlog/refs/heads/s3c-camif ?
> I'm using patches from
> https://github.com/snawrocki/linux/commits/s3c-camif-v3.5 wich was in
> your mail to samsung maillist.

I suggest you to update to the s3c-camif branch as above, it includes some
bug fixes. Sorry, I don't have exact patch for your issue handy right now.

>> I've also added at Cc In-Bae Jeong, who had successfully used the driver
>> on s3c6410 based board. However I'm not really sure now which board exactly
>> was it.
> I'm using mini6410. But i think there is only one way sensor can be
> connected to FIMC. Some differents may be in Reset and Power-down
> signals, but not in interface.

Yes, right. But since I2C communication works, the GPIOs and the clock
should be fine. It looks like there is a mismatch in the sensor and
the CAMIF registers configuration.

> P.S. Try to connect ov2640, but seems it need some modifications in
> FIMC driver to be connected thrue soc_camera_link.

Hmm, this is a general problem in the v4l2 core code. The are two slightly
incompatible interfaces that sensor subdevs are using. There were attempts
to make soc_camera subdevs usable with non-soc_camera host drivers, but it
is not finished yet. I could try to look at that, but I can't promise when
that happens.

There are pad level ops needed in the ov2640 driver - in addition to or
instead of g/s/try_mbus_fmt. Regulator supply names are not supposed to be
passed through platform data, those should be defined with fixed names as
specified in the sensor datasheet and board code should be providing 
required
regulator supply names or the dummy regulator should be used. IMO passing
regulator supply names through platform data is the regulator API misuse.

We need to resolve this issue at the v4l2 core level though, as problems
like this appear more and more often.

> Best regards.
> Andrey.

--

Regards,
Sylwester
