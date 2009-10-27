Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44168 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854AbZJ0QJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 12:09:40 -0400
From: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
To: "santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 27 Oct 2009 11:09:31 -0500
Subject: RE: [PATCH 2/6 v5] Support for TVP7002 in dm365 board
Message-ID: <7A436F7769CA33409C6B44B358BFFF0C012ACE70DC@dlee02.ent.ti.com>
References: <1255617794-1401-1-git-send-email-santiago.nunez@ridgerun.com>
	<87skdk7aul.fsf@deeprootsystems.com> <4AE1E903.4030605@ridgerun.com>
 <87y6mxalep.fsf@deeprootsystems.com>
 <7A436F7769CA33409C6B44B358BFFF0C012ACE7054@dlee02.ent.ti.com>
 <4AE71793.3090502@ridgerun.com>
In-Reply-To: <4AE71793.3090502@ridgerun.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Santiago Nunez-Corrales [mailto:snunez@ridgerun.com]
> Sent: Tuesday, October 27, 2009 11:54 AM
> To: Narnakaje, Snehaprabha
> Cc: Kevin Hilman; davinci-linux-open-source@linux.davincidsp.com;
> todd.fischer@ridgerun.com; linux-media@vger.kernel.org
> Subject: Re: [PATCH 2/6 v5] Support for TVP7002 in dm365 board
> 
> Sneha,
> 
> 
> So, if I got it right, have_tvp7002 is unnecessary since that
> initialization is done via the CPLD interface. Therefore, all I need to
> do is actually remove the logic for the device from board-dm365-evm.h.
> Am I right? If so, should I also remove the logic for tvp5146?


Santiago,

Yes, have_tvp7002 is not necessary. In fact evm_init_cpld() is also not necessary from video input source selection perspective. At this point, you can remove have_tvp7002() and keep the default as TVP5146. The evm_init_cpld() requires some cleanup for have_imager() as well. I am expecting Murali to provide patches for this sometime soon.

This brings up another concern. Your board setup related patches are dependent on one of the old patches from Neil Sikka - to add TVP5146 capture support. That patch is not in the mainline yet and requires re-submission by Murali.

I suggest you complete the TVP7002 sub-device driver (tvp7002.c and tvp7002.h), submit patches and follow up with the approval in the V4L2 community.

Patches corresponding to VPFE and DM365 board setup can be handled by Murali, working with you.

Thanks
Sneha

> 
> Regards,
> 
> Narnakaje, Snehaprabha wrote:
> > Santiago, Kevin,
> >
> >
> >> -----Original Message-----
> >> From: Kevin Hilman [mailto:khilman@deeprootsystems.com]
> >> Sent: Monday, October 26, 2009 5:35 PM
> >> To: santiago.nunez@ridgerun.com
> >> Cc: Narnakaje, Snehaprabha; davinci-linux-open-
> >> source@linux.davincidsp.com; todd.fischer@ridgerun.com; linux-
> >> media@vger.kernel.org
> >> Subject: Re: [PATCH 2/6 v5] Support for TVP7002 in dm365 board
> >>
> >> Santiago Nunez-Corrales <snunez@ridgerun.com> writes:
> >>
> >>
> >>> Kevin Hilman wrote:
> >>>
> >>>> <santiago.nunez@ridgerun.com> writes:
> >>>>
> >>>>
> >>>>
> >>>>> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> >>>>>
> >>>>> This patch provides support for TVP7002 in architecture definitions
> >>>>> within DM365.
> >>>>>
> >>>>> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> >>>>> ---
> >>>>>  arch/arm/mach-davinci/board-dm365-evm.c |  170
> >>>>>
> >> ++++++++++++++++++++++++++++++-
> >>
> >>>>>  1 files changed, 166 insertions(+), 4 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c
> b/arch/arm/mach-
> >>>>>
> >> davinci/board-dm365-evm.c
> >>
> >>>>> index a1d5e7d..6c544d3 100644
> >>>>> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> >>>>> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> >>>>> @@ -38,6 +38,11 @@
> >>>>>  #include <mach/common.h>
> >>>>>  #include <mach/mmc.h>
> >>>>>  #include <mach/nand.h>
> >>>>> +#include <mach/gpio.h>
> >>>>> +#include <linux/videodev2.h>
> >>>>> +#include <media/tvp514x.h>
> >>>>> +#include <media/tvp7002.h>
> >>>>> +#include <media/davinci/videohd.h>
> >>>>>    static inline int have_imager(void)
> >>>>> @@ -48,8 +53,11 @@ static inline int have_imager(void)
> >>>>>   static inline int have_tvp7002(void)
> >>>>>  {
> >>>>> -	/* REVISIT when it's supported, trigger via Kconfig */
> >>>>> +#ifdef CONFIG_VIDEO_TVP7002
> >>>>> +	return 1;
> >>>>> +#else
> >>>>>  	return 0;
> >>>>> +#endif
> >>>>>
> >>>>>
> >>>> I've said this before, but I'll say it again.  I don't like the
> >>>> #ifdef-on-Kconfig-option here.
> >>>>
> >>>> Can you add a probe hook to the platform_data so that when the
> tvp7002
> >>>> is found it can call pdata->probe() which could then set a flag
> >>>> for use by have_tvp7002().
> >>>>
> >>>> This will have he same effect without the ifdef since if the driver
> >>>> is not compiled in, its probe can never be triggered.
> >>>>
> >>>> Kevin
> >>>>
> >>>>
> >>>>
> >>> Kevin,
> >>>
> >>> I've been working on this particular implementation. This
> >>> board-dm365-evm.c is specific to the board, therefore I don't still
> >>> get the point of not having those values wired to the board file, but
> >>> I know it'd be nice to have the CPLD configuration triggered upon
> >>> TVP7002 detection. I see two options:
> >>>
> >> Having them in the board file is appropriate, what I object to is the
> >> selection by Kconfig.  Run-time detection is always preferred when
> >> possible.
> >>
> >
> > We have this CPLD init API - evm_init_cpld() called from the
> dm365_evm_init() function. The CPLD init API was trying to initialize the
> CPLD, based on the default configuration. I believe David Brownell had
> this placeholder for have_imager() and have_tvp7002() APIs since, we have
> different CPLD settings for the imager, tvp7002 and tvp5146 for the video
> input source.
> >
> >
> >>> 1. Do the callback function inside pdata and initialize it at driver
> >>> load time (tvp7002_probe). Set tvp5146 as default and override when
> >>> driver loads (and restore when unloads).
> >>>
> >> This is the preferred option to me.
> >>
> >
> > We can decide on the default video input source to be TVP5146. However
> we do not need a new callback function. We already have the VPFE
> .setup_input callback API dm365evm_setup_video_input() for the same
> purpose. The VPFE .setup_input API is called when each of the decoders
> (sub-devices) registered with VPFE capture driver. It is also called when
> the application decides on an input source and switches between the input
> sources.
> >
> > So, TVP5146 remains as the default video input source, only until VPFE
> probe is called, which registers the all decoders (sub-devices) defined in
> the VPFE platform data. This also means that the last decoder in the VPFE
> platform data remains active after boot-up. One can change the order in
> the VPFE platform data if a particular input source needs to remain active
> after boot-up. Note that application can always switch the input-source at
> run time.
> >
> > I quickly tried removing the have_imager() construct in the
> evm_init_cpld() and here is the output -
> >
> > Starting kernel ...
> >
> > Uncompressing
> Linux.....................................................................
> ..........................
> > ........................................ done, booting the kernel.
> > Linux version 2.6.32-rc2-davinci1-dirty
> > ...
> > CPU: Testing write buffer coherency: ok
> > DaVinci: 8 gpio irqs
> > NET: Registered protocol family 16
> > EVM: tvp5146 SD video input
> > bio: create slab <bio-0> at 0
> > SCSI subsystem initialized
> > ...
> > vpfe_init
> > vpfe-capture: vpss clock vpss_master enabled
> > vpfe-capture vpfe-capture: v4l2 device registered
> > vpfe-capture vpfe-capture: video device registered
> > EVM: switch to tvp5146 SD video input
> > tvp514x 1-005d: tvp514x 1-005d decoder driver registered !!
> > vpfe-capture vpfe-capture: v4l2 sub device tvp5146 registered
> > EVM: switch to tvp7002 HD video input
> > tvp7002 1-005c: tvp7002 1-005c decoder driver registered !!
> > vpfe-capture vpfe-capture: v4l2 sub device tvp7002 registered
> > ths7353 1-002e: chip found @ 0x5c (DaVinci I2C adapter)
> > vpfe-capture vpfe-capture: v4l2 sub device ths7353 registered
> > ...
> >
> > As you can see, the default video input source is TVP5146 and it has
> been video input source has been switched to TVP7002.
> >
> > Thanks
> > Sneha
> >
> >
> >>> 2. Add an entry to sysfs such that it can be user-configurable whether
> >>> to activate one of the other regardless of whether tvp5156 or tvp7002
> >>> are actually there (the only result would be fail to access the
> >>> device).
> >>>
> >> Why do you need sysfs options for switching?  Wouldn't building as
> >> modules and loading/unloading the needed modules serve the same
> >> purpose?
> >>
> >> Remeber that the 'probe' isn't going to be called until the
> >> platform_driver
> >> is registered, and that will (usually) happen at module load time.
> >>
> >>
> >>> Sneha, do you have any suggestions on this one?
> >>>
> >> Kevin
> >>
> >>
> >
> >
> 
> 
> --
> Santiago Nunez-Corrales, Eng.
> RidgeRun Engineering, LLC
> 
> Guayabos, Curridabat
> San Jose, Costa Rica
> +(506) 2271 1487
> +(506) 8313 0536
> http://www.ridgerun.com
> 
> 

