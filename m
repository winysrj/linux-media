Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63475 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3IIRas (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 13:30:48 -0400
Received: by mail-wi0-f175.google.com with SMTP id ez12so3740189wid.2
        for <linux-media@vger.kernel.org>; Mon, 09 Sep 2013 10:30:47 -0700 (PDT)
Message-ID: <522E05C7.2060203@googlemail.com>
Date: Mon, 09 Sep 2013 19:30:47 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/3] V4L2: fix em28xx ov2640 support
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de> <5224DBB8.1010601@googlemail.com> <Pine.LNX.4.64.1309030821050.14776@axis700.grange> <5228A1BC.7000209@googlemail.com> <20130905124134.29774dbf@samsung.com> <Pine.LNX.4.64.1309051749430.785@axis700.grange> <522E051B.50406@googlemail.com>
In-Reply-To: <522E051B.50406@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.09.2013 19:27, schrieb Frank Schäfer:
> Am 05.09.2013 17:57, schrieb Guennadi Liakhovetski:
>> On Thu, 5 Sep 2013, Mauro Carvalho Chehab wrote:
>>> Rewriting that part of the code would require to test the changes on
>>> several hundreds of different devices, and even if you find someone
>>> with all those devices, I doubt that he would have enough time to
>>> re-test everything.
>>>
>>> So, either the above unbalance check should be removed, or its behavior
>>> should be changed to assume that the devices are ON at probe() time,
>>> as it used to be before the async patches.
>> Ok, we can certainly do any of the above, but just for understanding - how 
>> does it actually work now? I mean - ok, I can accept, that the default 
>> reset state is power on. But the driver then forcedly powers all 
>> subdevices off upon close() or in the end of initialisation, performed 
>> during probing - and _never_ explicitly powers them on! That doesn't seem 
>> right to me. Even if it happens to work.
>>
>> Further, I grepped em28xx for s_power - only callers have those hooks, I 
>> didn't find any subdevices with them actually implemented. ov2640 has it 
>> and it calls soc_camera internal methods, which in the em28xx case also 
>> end up doing nothing. So, how and which subdevices actually save power 
>> there and how are they turned back on?
>>
>> I'll try to look at external subdevice drivers, that are used by em28xx, 
>> but any hints would be appreciated.
> Let's have a look at the commit that introduced the s_power calls:
>
> commit 622b828ab795580903e79acb33fb44f5c9ce7b0f
> Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Date:   Mon Oct 5 10:48:17 2009 -0300
>
>     V4L/DVB (13238): v4l2_subdev: rename tuner s_standby operation to
> core s_power
>    
>     Upcoming I2C v4l2_subdev drivers need a way to control the subdevice
>     power state from the core. This use case is already partially covered by
>     the tuner s_standby operation, but no way to explicitly come back from
>     the standby state is available.
>    
>     Rename the tuner s_standby operation to core s_power, and fix tuner
>     drivers accordingly. The tuner core will call s_power(0) instead of
>     s_standby(). No explicit call to s_power(1) is required for tuners as
>     they are supposed to wake up from standby automatically.
>    
>     [mchehab@redhat.com: CodingStyle fix]
>     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>
>
> So at least tuners are supposed to wake up automatically.
> Yet another reason why these warnings about unbalanced s_power should be
> removed.
> The problem is, that since this commit ALL subdevices (supporting it)
> are put into standby mode, not only the tuners.
Hmm... wait.
What's s_power supposed to do ? Put the device into stand-by mode or
switch power off ?
Are we talking about subdevice register operations or can it also call
power callbacks in the parent driver (like soc_camera does) ?

Regards,
Frank

> Hopefully, this didn't cause any regressions.
>
> Regards,
> Frank
>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/

