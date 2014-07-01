Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43528 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427AbaGAUXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jul 2014 16:23:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Cc: Enrico <ebutera@users.berlios.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
Date: Tue, 01 Jul 2014 22:24:34 +0200
Message-ID: <5681378.yuhdK56ii4@avalon>
In-Reply-To: <53A9B31A.80607@herbrechtsmeier.net>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com> <CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com> <53A9B31A.80607@herbrechtsmeier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

On Tuesday 24 June 2014 19:19:22 Stefan Herbrechtsmeier wrote:
> Am 24.06.2014 17:19, schrieb Enrico:
> > On Tue, May 27, 2014 at 10:38 AM, Enrico <ebutera@users.berlios.de> wrote:
> >> On Mon, May 26, 2014 at 9:50 PM, Laurent Pinchart wrote:
> >>> Hello,
> >>> 
> >>> This patch sets implements support for BT.656 and interlaced formats in
> >>> the OMAP3 ISP driver. Better late than never I suppose, although given
> >>> how long this has been on my to-do list there's probably no valid
> >>> excuse.
> >> 
> >> Thanks Laurent!
> >> 
> >> I hope to have time soon to test it :)
> > 
> > i wanted to try your patches but i'm having a problem (probably not
> > caused by your patches).
> > 
> > I merged media_tree master and omap3isp branches, applied your patches
> > and added camera platform data in pdata-quirks, but when loading the
> > omap3-isp driver i have:
> > 
> > omap3isp: clk_set_rate for cam_mclk failed
> > 
> > The returned value from clk_set_rate is -22 (EINVAL), but i can't see
> > any other debug message to track it down. Any ides?
> > I'm testing it on an igep proton (omap3530 version).
> 
> Hi Enrico,
> 
> please test the attached patch. It is based on Laurent's patches for the
> clock and boot testes on an Gumstix Overo with an OMAP3530.

The patch looks good to me. Do you plan to submit it to mainline ?

-- 
Regards,

Laurent Pinchart

