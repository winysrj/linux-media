Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58868 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab1IST7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 15:59:41 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "martin@neutronstar.dyndns.org" <martin@neutronstar.dyndns.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 20 Sep 2011 01:29:26 +0530
Subject: RE: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based
 camera board.
Message-ID: <19F8576C6E063C45BE387C64729E739404EC811425@dbde02.ent.ti.com>
References: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
 <201109182358.55816.laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E739404EC8111DE@dbde02.ent.ti.com>
 <20110919192442.GE9244@neutronstar.dyndns.org>
In-Reply-To: <20110919192442.GE9244@neutronstar.dyndns.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: martin@neutronstar.dyndns.org [mailto:martin@neutronstar.dyndns.org]
> Sent: Tuesday, September 20, 2011 12:55 AM
> To: Hiremath, Vaibhav
> Cc: Laurent Pinchart; Tony Lindgren; linux-omap@vger.kernel.org; linux-
> media@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based
> camera board.
> 
> On Mon, Sep 19, 2011 at 11:37:37AM +0530, Hiremath, Vaibhav wrote:
> >
> > > -----Original Message-----
> > > From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> > > owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> > > Sent: Monday, September 19, 2011 3:29 AM
> > > To: Martin Hostettler
> > > Cc: Tony Lindgren; linux-omap@vger.kernel.org; linux-
> > > media@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> > > Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032
> based
> > > camera board.
> > >
> > > Hi Martin,
> > >
> > > On Saturday 17 September 2011 11:34:57 Martin Hostettler wrote:
> > > > Adds board support for an MT9M032 based camera to omap3evm.
> > > >
> > > > Sigend-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> > > > ---
> > > >  arch/arm/mach-omap2/Makefile                |    1 +
> > > >  arch/arm/mach-omap2/board-omap3evm-camera.c |  183
> > > > +++++++++++++++++++++++++++ 2 files changed, 184 insertions(+), 0
> > > > deletions(-)
> > > >  create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
> > > >
> > > > Changes in V2:
> > > >  * ported to current mainline
> > > >  * Style fixes
> > > >  * Fix error handling
> > > >
> > > > diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-
> omap2/Makefile
> > > > index f343365..8ae3d25 100644
> > > > --- a/arch/arm/mach-omap2/Makefile
> > > > +++ b/arch/arm/mach-omap2/Makefile
> > > > @@ -202,6 +202,7 @@ obj-$(CONFIG_MACH_OMAP3_TORPEDO)        +=
> > > > board-omap3logic.o \ obj-$(CONFIG_MACH_OVERO)		+= board-
> overo.o \
> > > >  					   hsmmc.o
> > > >  obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o \
> > > > +					   board-omap3evm-camera.o \
> > > >  					   hsmmc.o
> > > >  obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o \
> > > >  					   hsmmc.o
> > > > diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c
> > > > b/arch/arm/mach-omap2/board-omap3evm-camera.c new file mode 100644
> > > > index 0000000..be987d9
> > > > --- /dev/null
> > > > +++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
> > > > @@ -0,0 +1,183 @@
> > > > +/*
> > > > + * Copyright (C) 2010-2011 Lund Engineering
> > > > + * Contact: Gil Lund <gwlund@lundeng.com>
> > > > + * Author: Martin Hostettler <martin@neutronstar.dyndns.org>
> > > > + *
> > [Hiremath, Vaibhav] The file below seems copied from (which is coming
> from all older releases of TI)
> >
> > http://arago-project.org/git/projects/?p=linux-
> omap3.git;a=blob;f=arch/arm/mach-omap2/board-omap3evm-
> camera.c;h=2e6ccfef69027dee880d507b98b5a7998d4bbe7e;hb=adcd067326836777c04
> 9e3cb32a5b7d9d401fc31
> >
> > So I would appreciate if you keep original copyright and authorship of
> the file and add your sign-off to the patch.
> >
> 
> First of all i don't have any problem Adding your name and the TI
> copyright.
> Maybe i should have been more careful when looking at and adeption
> omap3evm_set_mux as i really took that from the TI code.
> 

The best practice it to always keep copy-right of the file intact... I wouldn't mind if you use and modify any part of the code and also add your authorship. 
I feel, Copy-right is important part.
 
> I honestly don't remember if i took any other code from that file or not.
> It ends up doing what the hardware needs anyway. For me it doesn't matter
> with such trival things, but i should have been more careful.
> 
> Do you consider it resolved if use the following at the start?
> 
> /*
>  * Copyright (C) 2010 Texas Instruments Inc

Change it to 2011.

>  * Copyright (C) 2010-2011 Lund Engineering
>  * Contact: Gil Lund <gwlund@lundeng.com>

Not sure do you really need above line...

>  * Authors:
>  *    Vaibhav Hiremath <hvaibhav@ti.com>
>  *    Martin Hostettler <martin@neutronstar.dyndns.org>
>  */
> 
> 
Looks ok to me.

> But then again the copy on my harddisk has these too...
> 
>  * Contributors:
>  *     Anuj Aggarwal <anuj.aggarwal@ti.com>
>  *     Sivaraj R <sivaraj@ti.com>
> 
> Maybe i should add them too.
> 
> Not sure really...
> 
> 

I think we should not pollute source file with all our names, so I would recommend to put copy rights and probably author.

Thanks,
Vaibhav
>  - Martin Hostettler
