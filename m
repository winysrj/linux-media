Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:17576 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752057AbeADRwQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 12:52:16 -0500
Message-ID: <1515088333.7000.708.camel@linux.intel.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Kristian Beilke <beilke@posteo.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, alan@linux.intel.com
Date: Thu, 04 Jan 2018 19:52:13 +0200
In-Reply-To: <20171230211025.7aeaafcd@alans-desktop>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
         <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
         <1513715821.7000.228.camel@linux.intel.com>
         <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
         <1513866211.7000.250.camel@linux.intel.com>
         <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
         <1514476996.7000.437.camel@linux.intel.com>
         <20171230211025.7aeaafcd@alans-desktop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2017-12-30 at 21:10 +0000, Alan Cox wrote:
> > AFAIR Alan has CHT hardware he is developing / testing on.
> 
> I have a loaned board from the company Vincent (who did the intial
> patches) works for. At the moment it's loading firmware, finding
> cameras
> doing power management but not transferring images.
> 
> Unfortunately because of the design of the driver and firmware at the
> moment we are reduced to analyzing all the structs by hand between
> multiple different driver releases, and playing games to try and find
> out
> why various things are not matching up (assuming the firmware we have
> will actually work with the Windows tablet in question in the first
> place).

Maybe we need start over, i.e. find a (presumable old) kernel with
driver _and_ corresponding firmware _and_ hardware it supports to start
with...

> It's nasty because there are complex structs shared between the
> firmware
> and the OS, and in at least one spot the supposedly 'pristine' CHT
> driver
> that was used for the merge we now know could never have worked
> because
> it mismatched its own firmware !

Argh!

> On BYT I can't currently do much as my latest Intel Android tablet has
> died and it's getting hard to find more because I guess the rest of
> those
> made have also died.

I have MRD7 with some BIOS on it I even don't know if there is any newer
still available inside.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
