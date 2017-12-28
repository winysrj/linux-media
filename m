Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:14694 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754571AbdL1RXN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 12:23:13 -0500
Message-ID: <1514481789.7000.458.camel@linux.intel.com>
Subject: Re: IRQ behaivour has been changed from v4.14 to v4.15-rc1
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Ailus, Sakari" <sakari.ailus@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        alan <alan@linux.intel.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 28 Dec 2017 19:23:09 +0200
In-Reply-To: <1514481444.7000.451.camel@intel.com>
References: <1514481444.7000.451.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-12-28 at 19:17 +0200, Andy Shevchenko wrote:
> Hi!
> 
> Experimenting with AtomISP (yes, code is ugly and MSI handling rather
> hackish, though...).
> 
> So, with v4.14 base:

See additional note below.

> 
> [   33.639224] atomisp-isp2 0000:00:03.0: Start stream on pad 1 for
> asd0
> [   33.652355] atomisp-isp2 0000:00:03.0: irq:0x20
> [   33.662456] atomisp-isp2 0000:00:03.0: irq:0x20
> [   33.698064] atomisp-isp2 0000:00:03.0: stream[0] started.
> 
> Ctrl+C
> 
> [   48.185643] atomisp-isp2 0000:00:03.0: <atomisp_dqbuf: -512
> [   48.204641] atomisp-isp2 0000:00:03.0: release device ATOMISP ISP
> CAPTURE output
> ...
> 
> and machine still alive.
> 
> 
> With v4.15-rc1 base (basically your branch + some my hack patches)

Needs a bit of elaboration:
a) nothing had been changed WRT AtomISP driver or media stuff, under
"your branch" one reads Sakari's media_tree.git/atomisp branch;
b) my hack patches has nothing to do with anything except AtomISP
itself;
c) v4.14 base required media/v4.15-1 tag to be merged as well.

>  the IRQ behaviour changed, i.e. I have got:
> 
> 
> [   85.167061] spurious APIC interrupt through vector ff on CPU#0,
> should never happen.
> [   85.199886] atomisp-isp2 0000:00:03.0: stream[0] started.
> 
> and Ctrl+C does NOT work. Machine just hangs.
> 
> It might be related to this:
> https://lkml.org/lkml/2017/12/22/697
> 
> Any comments, Thomas?
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
