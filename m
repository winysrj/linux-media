Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:7081 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752552AbeADR7A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 12:59:00 -0500
Message-ID: <1515088729.7000.714.camel@linux.intel.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Kristian Beilke <beilke@posteo.de>,
        linux-media@vger.kernel.org, alan@linux.intel.com
Date: Thu, 04 Jan 2018 19:58:49 +0200
In-Reply-To: <20171230205712.6e744bb0@alans-desktop>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
         <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
         <1513715821.7000.228.camel@linux.intel.com>
         <20171230205712.6e744bb0@alans-desktop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2017-12-30 at 20:57 +0000, Alan Cox wrote:
> On Tue, 19 Dec 2017 22:37:01 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:

> > > > I am trying to get the cameras in a Lenovo IdeaPad Miix 320
> > > > (Atom
> > > > x5-Z8350 BayTrail) to work. The front camera is an ov2680. With
> > > > kernel
> > > > 4.14.4 and 4.15rc3 I see the following dmesg output:  
> > 
> > It seems I forgot to send the rest of the patches I did while ago
> > against AtomISP code.
> > 
> > It includes switch to normal DMI matching instead of the crap we
> > have
> > there right now.
> 
> The current code expects to be booted on an Android (or ex Android)
> tablet. In which case the various values are buried in the EFI as
> you'd
> expect.

Yes, the logic is left untouched, the code has been cleaned up and allow
to use more natural DMI matching table.

> > WRT to the messages below it seems we have no platform data for that
> > device. It needs to be added.
> 
> Or we need to learn how to parse the ACPI data - except that at least
> on
> some devices the ACPI data is at least half fictional so it's not
> clear
> what the Windows driver really does.

...if we have any specs inside how that ACPI table was being populated.


> > Version string: irci_stable_candrpv_0415_20150423_1753
> > SHA1: 548d26a9b5daedbeb59a46ea1da69757d92cd4d6  shisp_2400b0_v21.bin
> 
> I'll send you a copy: (unfortunately for non Intel people I've not
> managed to get enough people to care about this to get permission to
> put
> the firmware in the public repository ... yet.....)

I've tried firmware with a version that matches the driver, still same
result. I got only "statistics" IRQs (0x20 by value)

$ head -z -n1 shisp_2400b0_v21.bin
irci_stable_candrpv_0415_20150521_0458

$ sha1sum shisp_2400b0_v21.bin
358d7cd31b2e35b6f812c5bdfc0bc28cc23ce674 shisp_2400b0_v21.bin

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
