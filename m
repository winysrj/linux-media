Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49630 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab2J3QWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 12:22:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jun Nie <niej0001@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC 0/5] Generic panel framework
Date: Tue, 30 Oct 2012 17:23:09 +0100
Message-ID: <1593234.uFiMq7ARmu@avalon>
In-Reply-To: <CAGA24MLnW-i0koFuAsnFQ2mNnrLupkmbxW5T8WYiV3QuoA2vig@mail.gmail.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <3648908.jA5PYymWxV@avalon> <CAGA24MLnW-i0koFuAsnFQ2mNnrLupkmbxW5T8WYiV3QuoA2vig@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jun,

I've finally been able to resume my work on the panel framework (I hope to 
post a v2 at the end of the week).

On Thursday 23 August 2012 14:23:01 Jun Nie wrote:
> Hi Laurent,
>     Do you plan to add an API to get and parse EDID to mode list?

An API to get the raw EDID data is likely needed. Parsing EDID data in the 
panel driver and providing the modes to the caller isn't enough, as EDID 
contains more than just video modes. I'm not sure whether a driver for an 
EDID-aware panel should parse the EDID data internally and provide both modes 
and raw EDID data, or only raw EDID data.

> video mode is tightly coupled with panel that is capable of hot-plug.
> Or you are busy on modifying EDID parsing code for sharing it amoung
> DRM/FB/etc? I see you mentioned this in Mar.

That's needed as well, but -ENOTIME :-S

> It is great if you are considering add more info into video mode, such as
> pixel repeating, 3D timing related parameter.

Please have a look at "[PATCH 2/2 v6] of: add generic videomode description" 
on dri-devel. There's a proposal for a common video mode structure.

> I have some code for CEA modes filtering and 3D parsing, but still tight
> coupled with FB and with a little hack style.
> 
>     My HDMI driver is implemented as lcd device as you mentioned here.
> But more complex than other lcd devices for a kthread is handling
> hot-plug/EDID/HDCP/ASoC etc.
> 
>     I also feel a little weird to add code parsing HDMI audio related
> info in fbmod.c in my current implementation, thought it is the only
> place to handle EDID in kernel. Your panel framework provide a better
> place to add panel related audio/HDCP code. panel notifier can also
> trigger hot-plug related feature, such as HDCP start.

That's a good idea. I was wondering whether to put the common EDID parser in 
drivers/gpu/drm, drivers/video or drivers/media. Putting it wherever the panel 
framework will be might be a good option as well.

>     Looking forward to your hot-plug panel patch. Or I can help add it
> if you would like me to.

I'll try to post a v2 at the end of the week, but likely without much hot-plug 
support. Patches and enhancement proposals will be welcome.

-- 
Regards,

Laurent Pinchart

