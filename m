Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57938 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3GDVKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jul 2013 17:10:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jakub Piotr =?utf-8?B?Q8WCYXBh?= <jpc-ml@zenburn.net>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [omap3isp] xclk deadlock
Date: Thu, 04 Jul 2013 23:11:13 +0200
Message-ID: <2398527.WgqgO0AkRo@avalon>
In-Reply-To: <51D5D967.1030306@zenburn.net>
References: <51D37796.2000601@zenburn.net> <51D5D967.1030306@zenburn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jakub,

On Thursday 04 July 2013 22:21:59 Jakub Piotr Cłapa wrote:
> Hi again,
> 
> Sorry for the noise, but I believe the information below may be useful
> until everything is merged into mainline.
> 
> I write to say that I managed to find a fix for the ISP clock deadlock.
>   My branch can be found at:
> https://github.com/LoEE/linux/tree/omap3isp/xclk
> (SHA: 36286390193922d148e7a3db0676747a20f2ed66 at the time of writing)
> 
> For reference:
> 1. This was a known problem since early January [1] (reported by Laurent).
> 2. Mike Turquette had submitted patches that made the clock framework
> (partially) reentrant. [2][3][4]
> 3. My code is just a rebase of the Laurent's omap3isp/xclk branch on the
> Mike's clk-next (so it's based on 3.10-rc3).

The omap3isp/xclk clock branch was used only to push patches to the media 
tree, I should have deleted it afterwards. Mike's reentrancy patches were 
already merged (or scheduled for merge) in mainline at that time, and for 
technical reasons they were not present in the omap3isp/xclk branch.

I've now deleted the branch from the public tree, sorry for the confusion.

> [1]: https://lkml.org/lkml/2013/1/6/169
> [2]: http://thread.gmane.org/gmane.linux.kernel/1448446/focus=1448448
> [3]: http://thread.gmane.org/gmane.linux.ports.arm.kernel/182198
> [4]: http://patches.linaro.org/15676/

-- 
Regards,

Laurent Pinchart

