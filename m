Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:60390 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab1IAMvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 08:51:04 -0400
Message-ID: <4E5F7FB3.8020405@mlbassoc.com>
Date: Thu, 01 Sep 2011 06:50:59 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Subject: Re: Getting started with OMAP3 ISP
References: <4E56734A.3080001@mlbassoc.com> <201108311715.33777.laurent.pinchart@ideasonboard.com> <CA+2YH7sYsUuEcsu56aG-DzEU4dushzH=_LXKekMb1-zKxoRCOg@mail.gmail.com> <201108311833.24394.laurent.pinchart@ideasonboard.com> <CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
In-Reply-To: <CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-09-01 03:51, Enrico wrote:
> On Wed, Aug 31, 2011 at 6:33 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com>  wrote:
>> On http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
>> omap3isp-next (sorry for not mentioning it), but the patch set was missing a
>> patch. I've sent a v2.
>
> Thanks Laurent, i can confirm it is a step forward. With your tree and
> patches (and my tvp5150 patch) i made a step forward:
>
> Setting up link 16:0 ->  5:0 [1]
> Setting up link 5:1 ->  6:0 [1]
> Setting up format UYVY 720x628 on pad tvp5150 2-005c/0
> Format set: UYVY 720x628
> Setting up format UYVY 720x628 on pad OMAP3 ISP CCDC/0
> Format set: UYVY 720x628

I'm at nearly the same point, but I'm getting a couple of strange messages:
# media-ctl -r -l '"tvp5150m1 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]
# media-ctl -f '"tvp5150m1 2-005c":0[UYVY 720x480], "OMAP3 ISP CCDC":0[UYVY 720x480], "OMAP3 ISP CCDC":1[UYVY 720x480]'
Setting up format UYVY 720x480 on pad tvp5150m1 2-005c/0
Format set: unknown 720x480
Setting up format unknown 720x480 on pad OMAP3 ISP CCDC/0
Format set: unknown 720x480
Setting up format UYVY 720x480 on pad OMAP3 ISP CCDC/0
Format set: UYVY 720x480
Setting up format UYVY 720x480 on pad OMAP3 ISP CCDC/1
Format set: UYVY 720x480

# yavta -f UYVY -s 720x480 -n 6 --capture=6 -F /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: UYVY (59565955) 720x480 buffer size 691200
Video format: UYVY (59565955) 720x480 buffer size 691200
6 buffers requested.
length: 691200 offset: 0
Buffer 0 mapped at address 0x40211000.
length: 691200 offset: 692224
Buffer 1 mapped at address 0x402dc000.
length: 691200 offset: 1384448
Buffer 2 mapped at address 0x4047f000.
length: 691200 offset: 2076672
Buffer 3 mapped at address 0x40614000.
length: 691200 offset: 2768896
Buffer 4 mapped at address 0x40792000.
Buffer 5 mapped at address 0x40854000.
Unable to start streaming: 32.

What does 'Format set: unknown 720x480' mean from media-ctl?
Why 'Unable to start streaming: 32' - is this an EPIPE error?

>
> Now the problem is that i can't get a capture with yavta, it blocks on
> the VIDIO_DQBUF ioctl. Probably something wrong in my patch.
>
> I tried also to route it through the resizer but nothing changes.
>
> Is it normal that --enum-formats returns this?
>
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
> - Available formats:
> Video format:  (00000000) 0x0 buffer size 0
>
> Thanks,
>
> Enrico

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
