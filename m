Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48427 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab2LQJbE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 04:31:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julien BERAUD <julien.beraud@parrot.com>
Cc: jean-philippe francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Lockup on second streamon with omap3-isp
Date: Mon, 17 Dec 2012 10:32:18 +0100
Message-ID: <1454034.b7COp5DhyG@avalon>
In-Reply-To: <50CB3535.2080400@parrot.com>
References: <CAGGh5h0dVOsT-PCoCBtjj=+rLzViwnM2e9hG+sbWQk5iS-ThEQ@mail.gmail.com> <CAGGh5h23vLD=L1D2PHwQD8XeT8edypcSx=kbf7aATQUCfQ14zg@mail.gmail.com> <50CB3535.2080400@parrot.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julien,

On Friday 14 December 2012 15:18:29 Julien BERAUD wrote:
> Hi Jean-Philippe,
> 
> I have had exactly the same problem and the following workaround has
> caused no regression on our board yet.
> I can't explain exactly why it works and I think that it is internal to
> the isp.
> 
> In function ccdc_set_stream, don't disable the ccdc_subclk when stopping
> capture:
> 
>                  ret = ccdc_disable(ccdc);
>                  if (ccdc->output & CCDC_OUTPUT_MEMORY)
>                          omap3isp_sbl_disable(isp,
> OMAP3_ISP_SBL_CCDC_WRITE);
> -               omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_CCDC);
> +               //omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_CCDC);
> 
> I know that it is still a workaround but I hope that maybe it will help
> someone to understand the real cause of this issue.

Do you get CCDC stop timeouts ? They are reported in the kernel log as "CCDC 
stop timeout!".

> Le 13/12/2012 15:14, jean-philippe francois a �crit :
> > Hi,
> > 
> > I have news on the "IRQ storm on second streamon" problem.
> > Reminder :
> > Given a perfectly fine HSYNC / VSYNC / PIXELCLOK configuration, the
> > omap3-isp (at least until 3.4) will go into an interrupt storm when
> > streamon is called for the second time, unless you are able to stop
> > the sensor when not streaming. I have reproduced this on three
> > different board, with three different sensor.
> > 
> > On board 1, the problem disappeared by itself (in fact not by itself,
> > see below) and the board is not in my possession anymore.
> > On board 2, I implemented a working s_stream operation in the subdev
> > driver, so the problem was solved because the sensor would effectively
> > stop streaming when told to, keeping the ISP + CCDC happy
> > On board 3, I can't stop the streaming, or I did not figure out how to
> > make it stop  yet.
> > 
> > I tried to disable the HS_VS_IRQ, but it did not help, so I came back
> > looking at the code of board 1, which was running fine with a 3.4
> > kernel. And I discovered the problem doesn't happen if I break the
> > pipeline between two consecutive streamon.
> > 
> > In other word if I do the following :
> > 
> > media-ctl -l '16:0->5:0[1], 5:1->6:0[1]'
> > media-ctl -f '16:0 [SBGGR8 2560x800 (0, 0)/2560x800]'
> > yavta ....
> > yavta ...       <--------- board locks up, soft lockup is fired
> > 
> > But if I do this instead :
> > 
> > media-ctl -l '16:0->5:0[0], 5:1->6:0[0]'
> > media-ctl -l '16:0->5:0[1], 5:1->6:0[1]'
> > media-ctl -f '16:0 [SBGGR8 2560x800 (0, 0)/2560x800]'
> > yavta ....
> > media-ctl -l '16:0->5:0[0], 5:1->6:0[0]'
> > media-ctl -l '16:0->5:0[1], 5:1->6:0[1]'
> > media-ctl -f '16:0 [SBGGR8 2560x800 (0, 0)/2560x800]'
> > yavta ...       <--------- image are acquired, board doesn't lock up
> > anymore

Now this really doesn't make much sense to me. Both sequences should produce 
the exact same hardware accesses.

Could you add a printk in isp_reg_writel 
(drivers/media/platform/omap3isp/isp.h) and compare the register writes for 
both sequences ?

> > It would be interesting to go from this workaround to the elimination of
> > the root cause. What can I do / test next to stop this bug from hapenning
> > ?

-- 
Regards,

Laurent Pinchart

