Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16346 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754860AbdL2MGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 07:06:15 -0500
Message-ID: <1514549171.7000.512.camel@linux.intel.com>
Subject: Re: IRQ behaivour has been changed from v4.14 to v4.15-rc1
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        "Ailus, Sakari" <sakari.ailus@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 29 Dec 2017 14:06:11 +0200
In-Reply-To: <alpine.DEB.2.20.1712282256240.1899@nanos>
References: <1514481444.7000.451.camel@intel.com>
          <alpine.DEB.2.20.1712281820040.1899@nanos>
          <1514482448.7000.460.camel@linux.intel.com>
          <alpine.DEB.2.20.1712281834520.1899@nanos>
          <1514489471.7000.463.camel@linux.intel.com>
          <alpine.DEB.2.20.1712282117160.1899@nanos>
         <1514495025.7000.484.camel@linux.intel.com>
         <alpine.DEB.2.20.1712282218080.1899@nanos>
         <alpine.DEB.2.20.1712282256240.1899@nanos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-12-28 at 22:59 +0100, Thomas Gleixner wrote:
> On Thu, 28 Dec 2017, Thomas Gleixner wrote:
> > On Thu, 28 Dec 2017, Andy Shevchenko wrote:

> > > The result w/o above is (full log is available here
> > > https://pastebin.com
> > > /J5yaTbM9):
> > 
> > Ok. Which irqs are related to that ISP thingy?
> > 
> > Are these interrupts MSI?

Yes, they are MSI.

> And looking at the log, I see that you can load the driver
> successfully and
> the trouble starts afterwards when you actually use it.

Correct.

> Can you please enable CONFIG_GENERIC_IRQ_DEBUGFS and after login,
> check
> which interrupt is assigned to that atomisp thingy and then provide
> the
> output of
> 
> cat /sys/kernel/debug/irq/irqs/$ATOMISPIRQ

Full log, including output of the above.

https://pastebin.com/4jammqi5

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
