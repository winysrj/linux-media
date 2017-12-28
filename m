Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2371 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753518AbdL1ReL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 12:34:11 -0500
Message-ID: <1514482448.7000.460.camel@linux.intel.com>
Subject: Re: IRQ behaivour has been changed from v4.14 to v4.15-rc1
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "Ailus, Sakari" <sakari.ailus@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 28 Dec 2017 19:34:08 +0200
In-Reply-To: <alpine.DEB.2.20.1712281820040.1899@nanos>
References: <1514481444.7000.451.camel@intel.com>
         <alpine.DEB.2.20.1712281820040.1899@nanos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-12-28 at 18:21 +0100, Thomas Gleixner wrote:
> On Thu, 28 Dec 2017, Shevchenko, Andriy wrote:
> 
> > Hi!
> > 
> > Experimenting with AtomISP (yes, code is ugly and MSI handling
> > rather
> > hackish, though...).
> > 
> > So, with v4.14 base:
> > 
> > [   33.639224] atomisp-isp2 0000:00:03.0: Start stream on pad 1 for
> > asd0
> > [   33.652355] atomisp-isp2 0000:00:03.0: irq:0x20
> > [   33.662456] atomisp-isp2 0000:00:03.0: irq:0x20
> > [   33.698064] atomisp-isp2 0000:00:03.0: stream[0] started.
> > 
> > Ctrl+C
> > 
> > [   48.185643] atomisp-isp2 0000:00:03.0: <atomisp_dqbuf: -512
> > [   48.204641] atomisp-isp2 0000:00:03.0: release device ATOMISP ISP
> > CAPTURE output
> > ...
> > 
> > and machine still alive.
> > 
> > 
> > With v4.15-rc1 base (basically your branch + some my hack patches)
> > the
> > IR
> > Q behaviour changed, i.e. I have got:
> > 
> > 
> > [   85.167061] spurious APIC interrupt through vector ff on CPU#0,
> > should never happen.
> > [   85.199886] atomisp-isp2 0000:00:03.0: stream[0] started.
> > 
> > and Ctrl+C does NOT work. Machine just hangs.
> > 
> > It might be related to this:
> > https://lkml.org/lkml/2017/12/22/697
> 
> I don't think so.
> 
> Does the patch below cure it?

Unfortunately, no.

Same behaviour.

Tell me if I need to provide some debug before it hangs. For now I have
apic=debug (AFAIR it doesn't affect this).

> 
> Thanks,
> 
> 	tglx
> 8<-----------------
>  arch/x86/kernel/apic/apic_flat_64.c   |    2 +-
>  arch/x86/kernel/apic/probe_32.c       |    2 +-
>  arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/arch/x86/kernel/apic/apic_flat_64.c
> +++ b/arch/x86/kernel/apic/apic_flat_64.c
> @@ -151,7 +151,7 @@ static struct apic apic_flat __ro_after_
>  	.apic_id_valid			=
> default_apic_id_valid,
>  	.apic_id_registered		= flat_apic_id_registered,
>  
> -	.irq_delivery_mode		= dest_LowestPrio,
> +	.irq_delivery_mode		= dest_Fixed,
>  	.irq_dest_mode			= 1, /* logical */
>  
>  	.disable_esr			= 0,
> --- a/arch/x86/kernel/apic/probe_32.c
> +++ b/arch/x86/kernel/apic/probe_32.c
> @@ -105,7 +105,7 @@ static struct apic apic_default __ro_aft
>  	.apic_id_valid			=
> default_apic_id_valid,
>  	.apic_id_registered		=
> default_apic_id_registered,
>  
> -	.irq_delivery_mode		= dest_LowestPrio,
> +	.irq_delivery_mode		= dest_Fixed,
>  	/* logical delivery broadcast to all CPUs: */
>  	.irq_dest_mode			= 1,
>  
> --- a/arch/x86/kernel/apic/x2apic_cluster.c
> +++ b/arch/x86/kernel/apic/x2apic_cluster.c
> @@ -184,7 +184,7 @@ static struct apic apic_x2apic_cluster _
>  	.apic_id_valid			= x2apic_apic_id_valid,
>  	.apic_id_registered		=
> x2apic_apic_id_registered,
>  
> -	.irq_delivery_mode		= dest_LowestPrio,
> +	.irq_delivery_mode		= dest_Fixed,
>  	.irq_dest_mode			= 1, /* logical */
>  
>  	.disable_esr			= 0,
> 
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
