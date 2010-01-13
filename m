Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:30229 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab0AMSdX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 13:33:23 -0500
Received: by qw-out-2122.google.com with SMTP id 9so90662qwb.37
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 10:33:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <eedb5541001040431j3f14ec55g66ed4dd44a2a840e@mail.gmail.com>
References: <1260885686-8478-1-git-send-email-acassis@gmail.com>
	 <37367b3a0912150607v713edc32y3578fa2a0c8c61db@mail.gmail.com>
	 <eedb5541001032340n66205fb8s57e09d2ba413b322@mail.gmail.com>
	 <37367b3a1001040412k280f3366p4868e36f5a7f71e4@mail.gmail.com>
	 <eedb5541001040425h2a3c07dcn534c71a0918b322b@mail.gmail.com>
	 <eedb5541001040431j3f14ec55g66ed4dd44a2a840e@mail.gmail.com>
Date: Wed, 13 Jan 2010 16:33:21 -0200
Message-ID: <37367b3a1001131033u74c30ad6q8da1dbc35982e008@mail.gmail.com>
Subject: Re: [PATCH] RFC: mx27: Add soc_camera support
From: Alan Carvalho de Assis <acassis@gmail.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	mchehab@infradead.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 1/4/10, javier Martin <javier.martin@vista-silicon.com> wrote:
> 2010/1/4 javier Martin <javier.martin@vista-silicon.com>
>
>>
>>
>> 2010/1/4 Alan Carvalho de Assis <acassis@gmail.com>
>>
>> Hi Javier,
>>>
>>> On 1/4/10, javier Martin <javier.martin@vista-silicon.com> wrote:
>>> > Alan,
>>> > please, could you point me against which kernel version did you exactly
>>> test
>>> > this patch?
>>>
>>> It applies on current kernel from
>>> git.pengutronix.de/git/imx/linux-2.6.git
>>>
>>> Thank you for your feedback Alan.
>>
>>> > Also it would be fine to know which video sensor did you use.
>>> >
>>>
>>> I'm planning to use an OV2640 camera.
>>>
>> Does this mean that this patch you are sending has been only
>> compile-tested?
>>
>
> Argh, sorry, you pointed this in your previous mail.
>
> Too bad we don't have any sensor available currently in mainline to do a
> fast test.
>

Unfortunately my camera is not responding to I2C commands, I already
slow it down to 10kbps with no success. I can see on oscilloscope
i.MX27 send I2C commands, but the camera doesn't respond to it.

Then I tested using the MT9T31 driver and change the it to my I2C
commands, as I2C is failing I force the probe to return 0. But the
soc_camera still failing:

Linux video capture interface: v2.00
write: -5
MT9T31 Read register 0xFF = -5
Forcing mt9t031_video_probe to return OK!
mx27-camera mx27-camera.0: initialising
mx27-camera: probe of mx27-camera.0 failed with error -2

Best Regards,

Alan
