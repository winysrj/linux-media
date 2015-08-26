Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:46598 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbbHZU2x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 16:28:53 -0400
Date: Wed, 26 Aug 2015 13:28:49 -0700
From: Tony Lindgren <tony@atomide.com>
To: Michael Allwright <michael.allwright@upb.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH RFC] DT support for omap4-iss
Message-ID: <20150826202849.GJ10928@atomide.com>
References: <CALcgO_6UXp-Xqwim8WpLXz7XWAEpejipR7JNQc0TdH0ETL4JYQ@mail.gmail.com>
 <20150811111604.GD10928@atomide.com>
 <CALcgO_471LouPKvdDAfOSbtWX+ne4iqvbxC-+fMwy-nQM8Go2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALcgO_471LouPKvdDAfOSbtWX+ne4iqvbxC-+fMwy-nQM8Go2w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Michael Allwright <michael.allwright@upb.de> [150811 10:16]:
> On 11 August 2015 at 13:16, Tony Lindgren <tony@atomide.com> wrote:
> > * Michael Allwright <michael.allwright@upb.de> [150810 08:19]:
> >> +
> >> +/*
> >> +We need a better solution for this
> >> +*/
> >> +#include <../arch/arm/mach-omap2/omap-pm.h>
> >
> > Please let's not do things like this, I end up having to deal with
> > all these eventually :(
> >
> >> +static void iss_set_constraints(struct iss_device *iss, bool enable)
> >> +{
> >> +    if (!iss)
> >> +        return;
> >> +
> >> +    /* FIXME: Look for something more precise as a good throughtput limit */
> >> +    omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
> >> +                 enable ? 800000 : -1);
> >> +}
> >> +
> >> +static struct iss_platform_data iss_dummy_pdata = {
> >> +    .set_constraints = iss_set_constraints,
> >> +};
> >
> > If this is one time setting, you could do it based on the
> > compatible string using arch/arm/mach-omap2/pdata-quirks.c.
> >
> > If you need to toggle it, you could populate a function pointer
> > in pdata-quirks.c. Those are easy to fix once there is some Linux
> > generic API available :)
> >
> > Regards,
> >
> > Tony
> 
> Hi Tony,
> 
> Thanks for the suggestion, I'll move that function into
> pdata-quirks.c. Please read on, I really need some help regarding the
> following error, I lost 8-9 hours on this today.
> 
>  [  141.612609] omap4iss 52000000.iss: CSI2: CSI2_96M_FCLK reset timeout!
> 
> This comes from the function: int omap4iss_csi2_reset(struct
> iss_csi2_device *csi2) in iss_csi2.c. I have found that bit 29 in
> REGISTER1 belonging to the CSI2A registers, isn't becoming high after
> doing the reset on kernel 4.1.4. However it does come high in 3.17.
> This bit is a flag indicating that the reset on the CSI2_96M_FCLK is
> complete.
> 
> 3.17
> [   43.399658] omap4-iss 52000000.iss: REGISTER1 = 0x00000000
> [   43.405456] omap4-iss 52000000.iss: REGISTER1 = 0xe002e10e
> 
> 4.1.4
> [  210.331909] omap4iss 52000000.iss: REGISTER1 = 0x00000000
> [  210.338470] omap4iss 52000000.iss: REGISTER1 = 0xc002e10e
> [  210.342609] omap4iss 52000000.iss: CSI2: CSI2_96M_FCLK reset timeout!
> 
> Note: the transition from 0x00000000 to 0xc002e10e would seem to
> indicate that the operation completed, just not successfully...
> 
> I have spent the day sampling at different points in the code,
> checking the contents of all the registers belonging to the ISS and
> CSI PHY to conclude that there are no differences between the two
> instances of the driver running on 3.17 and 4.1.4. Using the internal
> __clk_is_enabled from clk-provider.h I also checked that the muxes
> responsible for providing the clocks to the module were enabled
> before, during and after the reset. I have also confirmed the
> identical issue also occurs on a different board.
> 
> I suspect someone has broken something in the hwmods, or PRCM data
> structures. Although I have not yet been able to find any relevant
> differences in the source files that I have searched through.
> 
> Any suggestions regarding where I should continue to look for this
> issue are welcome. Unfortunately if I can't get some support on this
> soon, I will have to abandon working on this patch.

Sorry I'm a bit behind on emails.. If this is still an issue you
may be able to git bisect it with an additional camera patches. Of
course assuming your camera patches apply and work over a larger
set of kernel versions :) If it does not work, you might be able
to create a minimal test patch for git bisect that just tests the
CSI2_96M_FCLK on boot.

Of course it might make sense to test that with recent main kernel
revisions first before git bisect.

Regards,

Tony
