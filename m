Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34641 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1IAJzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 05:55:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Subject: Re: Getting started with OMAP3 ISP
Date: Thu, 1 Sep 2011 11:55:44 +0200
Cc: linux-media@vger.kernel.org, Gary Thomas <gary@mlbassoc.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
References: <4E56734A.3080001@mlbassoc.com> <201108311833.24394.laurent.pinchart@ideasonboard.com> <CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
In-Reply-To: <CA+2YH7t9K6PFW-4YvLUx-BfteJ8ORujHppM+iesn4u2qP-Of=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011155.44516.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Thursday 01 September 2011 11:51:58 Enrico wrote:
> On Wed, Aug 31, 2011 at 6:33 PM, Laurent Pinchart wrote:
> > On
> > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> > omap3isp-next (sorry for not mentioning it), but the patch set was
> > missing a patch. I've sent a v2.
> 
> Thanks Laurent, i can confirm it is a step forward. With your tree and
> patches (and my tvp5150 patch) i made a step forward:
> 
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
> Setting up format UYVY 720x628 on pad tvp5150 2-005c/0
> Format set: UYVY 720x628
> Setting up format UYVY 720x628 on pad OMAP3 ISP CCDC/0
> Format set: UYVY 720x628
> 
> Now the problem is that i can't get a capture with yavta, it blocks on
> the VIDIO_DQBUF ioctl. Probably something wrong in my patch.

Does your tvp5150 generate progressive or interlaced images ?

> I tried also to route it through the resizer but nothing changes.
> 
> Is it normal that --enum-formats returns this?
> 
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
> - Available formats:
> Video format:  (00000000) 0x0 buffer size 0

Yes that's normal. Format enumeration on video device nodes isn't supported by 
the OMAP3 ISP driver.

-- 
Regards,

Laurent Pinchart
