Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:65138 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0AGTnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2010 14:43:55 -0500
Received: by pxi4 with SMTP id 4so1499905pxi.33
        for <linux-media@vger.kernel.org>; Thu, 07 Jan 2010 11:43:54 -0800 (PST)
To: "Karicheri\, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil\@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source\@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH - v3 4/4] DaVinci - vpfe-capture-converting ccdc drivers to platform driver
References: <1260895054-13232-1-git-send-email-m-karicheri2@ti.com>
	<871vi4rv25.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23952@dlee06.ent.ti.com>
	<87k4vvkyo7.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162C23A3E@dlee06.ent.ti.com>
	<878wcbkx60.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40162D43099@dlee06.ent.ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Thu, 07 Jan 2010 11:43:51 -0800
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40162D43099@dlee06.ent.ti.com> (Muralidharan Karicheri's message of "Thu\, 7 Jan 2010 12\:18\:18 -0600")
Message-ID: <87r5q1ya2w.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Karicheri, Muralidharan" <m-karicheri2@ti.com> writes:

> Kevin,
>
>>
>>OK, I'm not extremely familar with the whole video architecture here,
>>but are all of these drivers expected to be doing clk_get() and
>>clk_enable()?
>>
>
> [MK]Many IPs on DaVinci VPFE would require vpss master clock. So
> it is better to do the way I have done in my patch. So it is expected
> that clk_get, clk_enable etc are called from other drivers as well.

OK, then you are expecting to add clkdev nodes for the other devices
as well.  That's ok.

However, you still haven't answered my original question.  AFAICT,
there are no users of the clkdev nodes "vpss_master" and "vpss_slave".
Why not remove those and replace them with your new nodes instead of
leaving them and adding new ones?

Kevin
