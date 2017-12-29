Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41438 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751125AbdL2TiP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 14:38:15 -0500
Message-ID: <1514576292.7000.558.camel@linux.intel.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kristian Beilke <beilke@posteo.de>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        alan@linux.intel.com
Date: Fri, 29 Dec 2017 21:38:12 +0200
In-Reply-To: <1514476996.7000.437.camel@linux.intel.com>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
         <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
         <1513715821.7000.228.camel@linux.intel.com>
         <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
         <1513866211.7000.250.camel@linux.intel.com>
         <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
         <1514476996.7000.437.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Cc Hans.

On Thu, 2017-12-28 at 18:03 +0200, Andy Shevchenko wrote:
> On Sat, 2017-12-23 at 01:31 +0100, Kristian Beilke wrote:
> > On 12/21/2017 03:23 PM, Andy Shevchenko wrote:

I spend more time on investigating some additional stuff Sakari gave me, but no result so far.

So, the verbose debug output is here:
https://pastebin.com/RUV8gsUJ

Can anyone tell what's going on?

Note the idle state between 803s - 806s. I pressed Ctrl+C there since no expected IRQ came.

So, was it ever tested on Baytrail???

Who can debug this properly?

For now it's a quite waste of time. I doubt I want to do anything anymore
for this. Consider I'm in postponed state until there will be a *proven* way to test it.

Otherwise, I'm voting 10x times to remove this driver from upstream for good.

P.S. Happy New Year, everyone!

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
