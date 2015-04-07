Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:50359 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755830AbbDGOUr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 10:20:47 -0400
Message-ID: <5523E7B7.9010005@free-electrons.com>
Date: Tue, 07 Apr 2015 16:20:39 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Lunn <andrew@lunn.ch>, alsa-devel@alsa-project.org,
	Jason Cooper <jason@lakedaemon.net>, linux-sh@vger.kernel.org,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	Mike Turquette <mturquette@linaro.org>,
	Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 10/14] ARM: orion: use clkdev_create()
References: <20150403171149.GC13898@n2100.arm.linux.org.uk> <E1Ye59d-0001BZ-Sv@rmk-PC.arm.linux.org.uk> <20150404001729.GA14824@lunn.ch> <5523D985.60800@free-electrons.com> <20150407140117.GN4027@n2100.arm.linux.org.uk>
In-Reply-To: <20150407140117.GN4027@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On 07/04/2015 16:01, Russell King - ARM Linux wrote:
> On Tue, Apr 07, 2015 at 03:20:05PM +0200, Gregory CLEMENT wrote:
>> Hi Andrew, Russell,
>>
>> On 04/04/2015 02:17, Andrew Lunn wrote:
>>> On Fri, Apr 03, 2015 at 06:13:13PM +0100, Russell King wrote:
>>>> clkdev_create() is a shorter way to write clkdev_alloc() followed by
>>>> clkdev_add().  Use this instead.
>>>>
>>>> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>>>
>>> Acked-by: Andrew Lunn <andrew@lunn.ch>
>>
>> This change makes sens however what about Thomas' comment: removing
>> orion_clkdev_add() entirely and directly using lkdev_create() all over
>> the place:
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2015-March/327294.html
>>
>> Then what would be the path for this patch?
>>
>> As there is a dependency on the 6th patch of this series: "clkdev: add
>> clkdev_create() helper" which should be merged through the clk tree, I
>> think the best option is that this patch would be also managed by the
>> clk tree maintainer (I added them in CC).
> 
> Let me remind people that clkdev is *NOT* part of clk, and that I'm the
> maintainer for clkdev.

Sorry for the confusion, I quickly had a look on the MAINTAINERS file and
didn't realized that the drivers/clk/clkdev.c file was not part of clk
(even if actually it was mentioned).

> 
> I'm getting rather pissed off with people taking work away from me, even
> when I'm named in the MAINTAINERS file.  These patches are going through
> my tree unless there's a good reason for them not to.  They are _not_
> going through the clk tree.

So, as you are going to take care of all the patches it is even simpler.
You can take this one too: in mvebu there is no change on this file for
this release so there won't be any conflict.

Thanks,

Gregory




-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
