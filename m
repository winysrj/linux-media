Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33157 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754390AbdL1RpB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 12:45:01 -0500
Date: Thu, 28 Dec 2017 18:44:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "Ailus, Sakari" <sakari.ailus@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: IRQ behaivour has been changed from v4.14 to v4.15-rc1
In-Reply-To: <1514482448.7000.460.camel@linux.intel.com>
Message-ID: <alpine.DEB.2.20.1712281834520.1899@nanos>
References: <1514481444.7000.451.camel@intel.com>  <alpine.DEB.2.20.1712281820040.1899@nanos> <1514482448.7000.460.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 Dec 2017, Andy Shevchenko wrote:
> On Thu, 2017-12-28 at 18:21 +0100, Thomas Gleixner wrote:
> > > [   85.167061] spurious APIC interrupt through vector ff on CPU#0,
> > > should never happen.
> > > [   85.199886] atomisp-isp2 0000:00:03.0: stream[0] started.
> > > 
> > > and Ctrl+C does NOT work. Machine just hangs.
> > > 
> > > It might be related to this:
> > > https://lkml.org/lkml/2017/12/22/697
> > 
> > I don't think so.
> > 
> > Does the patch below cure it?
> 
> Unfortunately, no.
> 
> Same behaviour.
> 
> Tell me if I need to provide some debug before it hangs. For now I have
> apic=debug (AFAIR it doesn't affect this).

The interesting question is why that spurious APIC interrupt through vector
ff happens. Can you please add the following to the kernel command line:

 'trace_events=irq_vectors:* ftrace_dump_on_oops'

and apply the patch below. That should spill out the trace over serial (I
hope you have that ...)

Thanks,

	tglx

8<---------------
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1978,6 +1978,8 @@ void __init register_lapic_address(unsig
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt through vector %02x on CPU#%d, "
 		"should never happen.\n", vector, smp_processor_id());
+	tracing_off();
+	BUG();
 
 	trace_spurious_apic_exit(vector);
 	exiting_irq();
