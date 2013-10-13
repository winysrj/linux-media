Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49986 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3JMOAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 10:00:30 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so2780130eek.8
        for <linux-media@vger.kernel.org>; Sun, 13 Oct 2013 07:00:29 -0700 (PDT)
Message-ID: <525AA791.1080306@googlemail.com>
Date: Sun, 13 Oct 2013 16:00:49 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost> <5210B2A9.1030803@googlemail.com> <20130818122008.38fac218@samsung.com> <52543116.60509@googlemail.com> <Pine.LNX.4.64.1310081834030.31629@axis700.grange> <5256ACB9.6030800@googlemail.com> <Pine.LNX.4.64.1310101539500.20787@axis700.grange> <20131012064555.380f692e.m.chehab@samsung.com>
In-Reply-To: <20131012064555.380f692e.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[snip]

Am 12.10.2013 05:45, schrieb Mauro Carvalho Chehab:
>
> Changing the input will likely power on the device. The design of the
> old suspend callback were to call it when the device is not being used.
> Any try to use the device makes it to wake up, as it makes no sense to
> use a device in standby state.
>
> Also, changing the power states is a requirement, when switching the
> mode between analog, digital TV (or capture without tuner - although I
> think em28xx will turn the analog tuner on in this case, even not being
> required).
>
> The patches that just rename the previous standby callback to s_power 
> callback did a crap job, as it didn't consider the nuances of the API
> used on that time nor they didn't change the drivers to move the GPIO
> bits into s_power().
>
> Looking with today's view, it would likely be better if those patches
> were just adding a power callback without touching the standby callback.

The main problem is, that since commit 622b828ab7 ("v4l2_subdev: rename
tuner s_standby operation to core s_power") all subdevices are powered
down, not only the tuners.
But other subdevices may not wake up automatically when needed, so this
commit should also have introduced (s_power, 1) calls.
At least for em28xx it seems that this din't cause any regressions up to
now, because none of the subdevs used by this driver did anything
essential in its s_power callbacks (most of them don't support it at all).
But it's of course a ticking bomb.
The introduction of v4l2-clk enabling/disabling in the sensor subdevs'
(soc_cameras') s_power callbacks now let this bomb in em28xx explode.
This time, it only caused scary warnings/traces, but it could be
non-working (never waking up) devices next time.

> I suspect that the solution would be to fork s_power into two different
> callbacks: one asymetric to just put the device into suspend mode (as
> before), and another symmetric one, where the device needs to be explicitly
> enabled before its usage and disabled at suspend or driver exit.
>

Or, if we want to keep the API as is, we have to introduce (s_power, 1)
calls in the affected drivers to avoid regressions due to future subdev
changes.

Regards,
Frank

