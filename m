Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:33335 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdL1VbT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 16:31:19 -0500
Date: Thu, 28 Dec 2017 22:31:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "Ailus, Sakari" <sakari.ailus@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: IRQ behaivour has been changed from v4.14 to v4.15-rc1
In-Reply-To: <1514495025.7000.484.camel@linux.intel.com>
Message-ID: <alpine.DEB.2.20.1712282218080.1899@nanos>
References: <1514481444.7000.451.camel@intel.com>  <alpine.DEB.2.20.1712281820040.1899@nanos>  <1514482448.7000.460.camel@linux.intel.com>  <alpine.DEB.2.20.1712281834520.1899@nanos>  <1514489471.7000.463.camel@linux.intel.com>  <alpine.DEB.2.20.1712282117160.1899@nanos>
 <1514495025.7000.484.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 Dec 2017, Andy Shevchenko wrote:
> On Thu, 2017-12-28 at 21:18 +0100, Thomas Gleixner wrote:
> > Yes, you missed the typo in the command line. It should be:
> > 
> >  'trace_event=irq_vectors:* ftrace_dump_on_oops'
> 
> Indeed.
> 
> So, I had to disable LOCAL_TIMER_VECTOR, CALL_FUNCTION_VECTOR and
> RESCHDULE_VECTOR tracing, otherwise I got a lot of spam and RCU stalls.

Fair enough.

> The result w/o above is (full log is available here https://pastebin.com
> /J5yaTbM9):

Ok. Which irqs are related to that ISP thingy?

Are these interrupts MSI?

Thanks,

	tglx
