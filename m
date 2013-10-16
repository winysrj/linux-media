Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:46716 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab3JPTjc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 15:39:32 -0400
Received: by mail-ea0-f182.google.com with SMTP id o10so599180eaj.13
        for <linux-media@vger.kernel.org>; Wed, 16 Oct 2013 12:39:31 -0700 (PDT)
Message-ID: <525EEB88.8050309@googlemail.com>
Date: Wed, 16 Oct 2013 21:39:52 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost> <5210B2A9.1030803@googlemail.com> <20130818122008.38fac218@samsung.com> <52543116.60509@googlemail.com> <Pine.LNX.4.64.1310081834030.31629@axis700.grange> <5256ACB9.6030800@googlemail.com> <Pine.LNX.4.64.1310101539500.20787@axis700.grange> <20131012064555.380f692e.m.chehab@samsung.com> <525AA791.1080306@googlemail.com>
In-Reply-To: <525AA791.1080306@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.10.2013 16:00, schrieb Frank Schäfer:
> [snip]
>
> Am 12.10.2013 05:45, schrieb Mauro Carvalho Chehab:
>> Changing the input will likely power on the device. The design of the
>> old suspend callback were to call it when the device is not being used.
>> Any try to use the device makes it to wake up, as it makes no sense to
>> use a device in standby state.
>>
>> Also, changing the power states is a requirement, when switching the
>> mode between analog, digital TV (or capture without tuner - although I
>> think em28xx will turn the analog tuner on in this case, even not being
>> required).
>>
>> The patches that just rename the previous standby callback to s_power 
>> callback did a crap job, as it didn't consider the nuances of the API
>> used on that time nor they didn't change the drivers to move the GPIO
>> bits into s_power().
>>
>> Looking with today's view, it would likely be better if those patches
>> were just adding a power callback without touching the standby callback.
> The main problem is, that since commit 622b828ab7 ("v4l2_subdev: rename
> tuner s_standby operation to core s_power") all subdevices are powered
> down, not only the tuners.
> But other subdevices may not wake up automatically when needed, so this
> commit should also have introduced (s_power, 1) calls.
> At least for em28xx it seems that this din't cause any regressions up to
> now, because none of the subdevs used by this driver did anything
> essential in its s_power callbacks (most of them don't support it at all).
> But it's of course a ticking bomb.
> The introduction of v4l2-clk enabling/disabling in the sensor subdevs'
> (soc_cameras') s_power callbacks now let this bomb in em28xx explode.
> This time, it only caused scary warnings/traces, but it could be
> non-working (never waking up) devices next time.
>
>> I suspect that the solution would be to fork s_power into two different
>> callbacks: one asymetric to just put the device into suspend mode (as
>> before), and another symmetric one, where the device needs to be explicitly
>> enabled before its usage and disabled at suspend or driver exit.
>>
> Or, if we want to keep the API as is, we have to introduce (s_power, 1)
> calls in the affected drivers to avoid regressions due to future subdev
> changes.
>
> Regards,
> Frank

Ok, I've spent some time digging deeper into the code, checking em28xx,
the subdev drivers (msp3400, saa7115_auto, tvp5150, tvaudio, tuner,
mt9v011, ov2640) an and all the places where we're applying GPIO-sequences.

The em28xx driver is already at least partially aware of the problem,
that GPIO-sequences might change the power states of the subdevices or
reset them.
That's why em28xx_wake_i2c() is called in several places after GPIO
sequences have been applied (see code comments).
As the name already implies, these are places where we want to make sure
that the subdevices are in power-on state.
So adding a (s_power, 1) call at the beginning of this function would be
a good starting point. AFAICS, this can't break things.
This would also make sure that (s_power, 1) is called before the first
(s_power, 0) call and silence the warning about unbalanced
v4l2_clk_disable() calls.

However, I doubt we'll ever get the s_power calls really balanced.
Due to the GPIO-problems, there will likely always be more power-on
calls than power-off calls and hence more v4l2_clk_enable() than
v4l2_clk_disable() calls.

Regards,
Frank

