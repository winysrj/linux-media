Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42046 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaAGQ6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 11:58:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Cc: florian.vaussard@epfl.ch,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp device tree support
Date: Tue, 07 Jan 2014 17:59:01 +0100
Message-ID: <5728278.SyrhtX3J9t@avalon>
In-Reply-To: <CA+2YH7sHg-D9hrTOZ5h03YcAaywZz5tme5omguxPtHdyCb5A4A@mail.gmail.com>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com> <CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com> <CA+2YH7sHg-D9hrTOZ5h03YcAaywZz5tme5omguxPtHdyCb5A4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Friday 03 January 2014 12:30:33 Enrico wrote:
> On Wed, Dec 18, 2013 at 11:09 AM, Enrico wrote:
> > On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard wrote:
> >> So I converted the iommu to DT (patches just sent),

Florian, I've used your patches as a base for OMAP3 ISP DT work and they seem 
pretty good (although patch 1/7 will need to be reworked, but that's not a 
blocker). I've just had to fix a problem with the OMAP3 IOMMU, please see

http://git.linuxtv.org/pinchartl/media.git/commit/d3abafde0277f168df0b2912b5d84550590d80b2

I'd appreciate your comments on that. I can post the patch already if you 
think that would be helpful.

You can find my work-in-progress branch at

http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp/dt

(the last three patches are definitely not complete yet).

> >> used pdata quirks for the isp / mtv9032 data, added a few patches from
> >> other people (mainly clk to fix a crash when deferring the omap3isp
> >> probe), and a few small hacks. I get a 3.13-rc3 (+ board-removal part
> >> from Tony Lindgren) to boot on DT with a working MT9V032 camera. The
> >> missing part is the DT binding for the omap3isp, but I guess that we will
> >> have to wait a bit more for this.
> >> 
> >> If you want to test, I have a development tree here [1]. Any feedback is
> >> welcome.
> >> 
> >> Cheers,
> >> 
> >> Florian
> >> 
> >> [1] https://github.com/vaussard/linux/commits/overo-for-3.14/iommu/dt
> > 
> > Thanks Florian,
> > 
> > i will report what i get with my setup.
> 
> And here i am.
> 
> I can confirm it works, video source is tvp5150 (with platform data in
> pdata-quirks.c) in bt656 mode.
> 
> Laurent, i used the two bt656 patches from your omap3isp/bt656 tree so
> if you want to push it you can add a Tested-by me.

The second patch is not clean enough in my opinion. I need to find time to 
work on it. I had set some time aside for OMAP3 ISP development last week but 
I've ended up working on DT support (not done yet, I've worked with Sakari and 
he might finish the job in the upcoming weeks) instead of BT.656. I'm afraid 
this will have to wait for around three weeks.

> There is only one problem, but it's unrelated to your DT work.
> 
> It's an old problem (see for example [1] and [2]), seen by other
> people too and it seems it's still there.
> Basically if i capture with yavta while the system is idle then it
> just waits without getting any frame.
> If i add some cpu load (usually i do a "cat /dev/zero" in a ssh
> terminal) it starts capturing correctly.
> 
> The strange thing is that i do get isp interrupts in the idle case, so
> i don't know why they don't "propagate" to yavta.
> 
> Any hints on how to debug this?
> 
> Enrico
> 
> [1]: https://linuxtv.org/patch/7836/
> [2]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg44923.html
-- 
Regards,

Laurent Pinchart

