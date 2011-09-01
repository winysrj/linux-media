Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33934 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1IAJv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 05:51:59 -0400
Received: by gxk21 with SMTP id 21so1227208gxk.19
        for <linux-media@vger.kernel.org>; Thu, 01 Sep 2011 02:51:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108311833.24394.laurent.pinchart@ideasonboard.com>
References: <4E56734A.3080001@mlbassoc.com>
	<201108311715.33777.laurent.pinchart@ideasonboard.com>
	<CA+2YH7sYsUuEcsu56aG-DzEU4dushzH=_LXKekMb1-zKxoRCOg@mail.gmail.com>
	<201108311833.24394.laurent.pinchart@ideasonboard.com>
Date: Thu, 1 Sep 2011 11:51:58 +0200
Message-ID: <CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Gary Thomas <gary@mlbassoc.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 31, 2011 at 6:33 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> omap3isp-next (sorry for not mentioning it), but the patch set was missing a
> patch. I've sent a v2.

Thanks Laurent, i can confirm it is a step forward. With your tree and
patches (and my tvp5150 patch) i made a step forward:

Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]
Setting up format UYVY 720x628 on pad tvp5150 2-005c/0
Format set: UYVY 720x628
Setting up format UYVY 720x628 on pad OMAP3 ISP CCDC/0
Format set: UYVY 720x628

Now the problem is that i can't get a capture with yavta, it blocks on
the VIDIO_DQBUF ioctl. Probably something wrong in my patch.

I tried also to route it through the resizer but nothing changes.

Is it normal that --enum-formats returns this?

Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
- Available formats:
Video format:  (00000000) 0x0 buffer size 0

Thanks,

Enrico
