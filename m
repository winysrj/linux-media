Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46845 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbDFTEY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2015 15:04:24 -0400
Message-ID: <5522D8B5.7050205@codeaurora.org>
Date: Mon, 06 Apr 2015 12:04:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Russell King <rmk+kernel@arm.linux.org.uk>
CC: alsa-devel@alsa-project.org, linux-sh@vger.kernel.org,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Daniel Mack <daniel@zonque.org>, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 03/14] clkdev: get rid of redundant clk_add_alias() prototype
 in linux/clk.h
References: <20150403171149.GC13898@n2100.arm.linux.org.uk> <E1Ye593-0001B1-W4@rmk-PC.arm.linux.org.uk> <87lhi8rrmd.fsf@free.fr>
In-Reply-To: <87lhi8rrmd.fsf@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/15 05:43, Robert Jarzmik wrote:
> Russell King <rmk+kernel@arm.linux.org.uk> writes:
>
>> clk_add_alias() is provided by clkdev, and is not part of the clk API.
>> Howver, it is prototyped in two locations: linux/clkdev.h and
>> linux/clk.h.  This is a mess.  Get rid of the redundant and unnecessary
>> version in linux/clk.h.
>>
>> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>
>
> Actually, this serie fixes a regression I've seen in linux-next, and which was
> triggering the Oops in [1] on lubbock. With your serie, the kernel boots fine.
>
>

Is this with the lubbock_defconfig? Is it a regression in 4.0-rc series
or is it due to some pending -next patches interacting with the per-user
clock patches? It looks like the latter because __clk_get_hw() should be
inlined on lubbock_defconfig where CONFIG_COMMON_CLK=n.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

