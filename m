Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:44889 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0EEEd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 00:33:56 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 5 May 2010 10:03:50 +0530
Subject: RE: [Resubmit: PATCH-V2] AM3517: Add VPFE Capture driver support
Message-ID: <19F8576C6E063C45BE387C64729E7394044E3517E6@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1268991469-2747-1-git-send-email-hvaibhav@ti.com>
 <20100504231810.GS29604@atomide.com>
In-Reply-To: <20100504231810.GS29604@atomide.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Tony Lindgren [mailto:tony@atomide.com]
> Sent: Wednesday, May 05, 2010 4:48 AM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; linux-media@vger.kernel.org
> Subject: Re: [Resubmit: PATCH-V2] AM3517: Add VPFE Capture driver support
> 
> * hvaibhav@ti.com <hvaibhav@ti.com> [100319 02:34]:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > AM3517 and DM644x uses same CCDC IP, so reusing the driver
> > for AM3517.
> >
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  arch/arm/mach-omap2/board-am3517evm.c |  160
> +++++++++++++++++++++++++++++++++
> >  1 files changed, 160 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-
> omap2/board-am3517evm.c
> > index f04311f..d2d2ced 100644
> > --- a/arch/arm/mach-omap2/board-am3517evm.c
> > +++ b/arch/arm/mach-omap2/board-am3517evm.c
> > @@ -30,11 +30,164 @@
> >
> >  #include <plat/board.h>
> >  #include <plat/common.h>
> > +#include <plat/control.h>
> >  #include <plat/usb.h>
> >  #include <plat/display.h>
> >
> > +#include <media/tvp514x.h>
> > +#include <media/ti-media/vpfe_capture.h>
> > +
> 
> At least the mainline kernel does not seem to have media/ti-media/,
> so I'm not taking this.
> 
> Looks like it should be safe to merge via linux-media from omap
> point of view.
[Hiremath, Vaibhav] Tony,

This patch needs to rework, I will have to remove ti-media directory dependency since as of now we have decided not to include ti-media directory, instead we will use SoC name. 

> 
> Acked-by: Tony Lindgren <tony@atomide.com>
[Hiremath, Vaibhav] Thanks for ack, I will resubmit it and ask Mauro to pull this.

Thanks,
Vaibhav

