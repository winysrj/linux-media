Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43496 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964812AbaGAUQf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jul 2014 16:16:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
Date: Tue, 01 Jul 2014 22:17:29 +0200
Message-ID: <1463792.AairlWamc8@avalon>
In-Reply-To: <CA+2YH7sa0MubQKPuGDSVV79UYUzw=Ks-MshenaUA61DJhG7H4Q@mail.gmail.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com> <CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com> <CA+2YH7sa0MubQKPuGDSVV79UYUzw=Ks-MshenaUA61DJhG7H4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Thursday 26 June 2014 18:18:53 Enrico wrote:
> On Tue, Jun 24, 2014 at 5:19 PM, Enrico <ebutera@users.berlios.de> wrote:
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
> > Hi Laurent,
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
> Trying it on an igep com module (dm3730) i don't get the clk_set_rate
> error (but there is no tvp hardware connected so i can't go farther).
> 
> So it must be something different between omap3430/omap3630 clocks, i
> tried to use (CM_CAM_MCLK_HZ / 2) with the omap3530 one but i get the
> same error.
> 
> I don't know what else i can try.

Does your platform instantiate clocks through DT or through SoC code ? In the 
first case commit 2febd999764c682e1f125a4307fcb8791df3100e ("ARM: dts: set 
'ti,set-rate-parent' for dpll4_m5 path") might help, and in the second case 
you should apply commit 98d7e1aee6dd534f468993f8c6a1bc730d4cfa81 ("ARM: OMAP3: 
clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 
platforms"). You can just apply both, as well as the patch that Stefan has 
posted in reply to your e-mail, and retry.

-- 
Regards,

Laurent Pinchart


