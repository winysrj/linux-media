Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52637 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbHSWYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 18:24:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Allwright <michael.allwright@upb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH RFC] DT support for omap4-iss
Date: Thu, 20 Aug 2015 01:25:09 +0300
Message-ID: <1547053.A10gsslK9b@avalon>
In-Reply-To: <CALcgO_471LouPKvdDAfOSbtWX+ne4iqvbxC-+fMwy-nQM8Go2w@mail.gmail.com>
References: <CALcgO_6UXp-Xqwim8WpLXz7XWAEpejipR7JNQc0TdH0ETL4JYQ@mail.gmail.com> <20150811111604.GD10928@atomide.com> <CALcgO_471LouPKvdDAfOSbtWX+ne4iqvbxC-+fMwy-nQM8Go2w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Tuesday 11 August 2015 19:13:08 Michael Allwright wrote:
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
> >> +    /* FIXME: Look for something more precise as a good throughtput
> >> limit */ +    omap_pm_set_min_bus_tput(iss->dev, OCP_INITIATOR_AGENT,
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

How about using git bisect to find the root cause ?

-- 
Regards,

Laurent Pinchart

