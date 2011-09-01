Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61678 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1IAKY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 06:24:29 -0400
Received: by gya6 with SMTP id 6so1241919gya.19
        for <linux-media@vger.kernel.org>; Thu, 01 Sep 2011 03:24:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109011155.44516.laurent.pinchart@ideasonboard.com>
References: <4E56734A.3080001@mlbassoc.com>
	<201108311833.24394.laurent.pinchart@ideasonboard.com>
	<CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
	<201109011155.44516.laurent.pinchart@ideasonboard.com>
Date: Thu, 1 Sep 2011 12:24:27 +0200
Message-ID: <CA+2YH7ttb-dUVHqKVA-Bazo0of0vJR7gdhPmz3VLE=TebS0oPQ@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Gary Thomas <gary@mlbassoc.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 1, 2011 at 11:55 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Enrico,
>
> On Thursday 01 September 2011 11:51:58 Enrico wrote:
>> On Wed, Aug 31, 2011 at 6:33 PM, Laurent Pinchart wrote:
>> > On
>> > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
>> > omap3isp-next (sorry for not mentioning it), but the patch set was
>> > missing a patch. I've sent a v2.
>>
>> Thanks Laurent, i can confirm it is a step forward. With your tree and
>> patches (and my tvp5150 patch) i made a step forward:
>>
>> Setting up link 16:0 -> 5:0 [1]
>> Setting up link 5:1 -> 6:0 [1]
>> Setting up format UYVY 720x628 on pad tvp5150 2-005c/0
>> Format set: UYVY 720x628
>> Setting up format UYVY 720x628 on pad OMAP3 ISP CCDC/0
>> Format set: UYVY 720x628
>>
>> Now the problem is that i can't get a capture with yavta, it blocks on
>> the VIDIO_DQBUF ioctl. Probably something wrong in my patch.
>
> Does your tvp5150 generate progressive or interlaced images ?

In the driver it is setup to decode by default in bt656 mode, so interlaced.

I've read on the omap trm that the isp can deinterlace it setting
properly SDOFST, i just noticed in the register dump this:

omap3isp omap3isp: ###CCDC SDOFST=0x00000000

and maybe this is related too:

omap3isp omap3isp: ###CCDC REC656IF=0x00000000

Moreover i just found this [1] old thread about the same problem, i'm
reading it now.

Enrico

[1]: http://www.spinics.net/lists/linux-media/msg28079.html
