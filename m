Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:54282 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750927AbdL3U7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 30 Dec 2017 15:59:37 -0500
Date: Sat, 30 Dec 2017 20:57:12 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Kristian Beilke <beilke@posteo.de>,
        linux-media@vger.kernel.org, alan@linux.intel.com
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
Message-ID: <20171230205712.6e744bb0@alans-desktop>
In-Reply-To: <1513715821.7000.228.camel@linux.intel.com>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
        <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
        <1513715821.7000.228.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 Dec 2017 22:37:01 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
> > Cc Alan and Andy.
> > 
> > On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke wrote:  
> > > Dear all,
> > > 
> > > I am trying to get the cameras in a Lenovo IdeaPad Miix 320 (Atom
> > > x5-Z8350 BayTrail) to work. The front camera is an ov2680. With
> > > kernel
> > > 4.14.4 and 4.15rc3 I see the following dmesg output:  
> 
> It seems I forgot to send the rest of the patches I did while ago
> against AtomISP code.
> 
> It includes switch to normal DMI matching instead of the crap we have
> there right now.

The current code expects to be booted on an Android (or ex Android)
tablet. In which case the various values are buried in the EFI as you'd
expect.

The Windows devices seem to use a mix of ACPI, hardcoding and plain magic
in order to decide what hardware they have.

> WRT to the messages below it seems we have no platform data for that
> device. It needs to be added.

Or we need to learn how to parse the ACPI data - except that at least on
some devices the ACPI data is at least half fictional so it's not clear
what the Windows driver really does.

For CHT and maybe some BYT the Windows devices also use ACPI for the power
management to drive the PMIC opregion and thus the PMIC power lines.

> In any case, I have no firmware to test BayTrail hardware I have (MRD7).
> 
> The driver claims it needs:
> 
> Firmware file: shisp_2400b0_v21.bin
> Version string: irci_stable_candrpv_0415_20150521_0458
> 
> What I have is:
> 
> Version string: irci_stable_candrpv_0415_20150423_1753
> SHA1: 548d26a9b5daedbeb59a46ea1da69757d92cd4d6  shisp_2400b0_v21.bin

I'll send you a copy: (unfortunately for non Intel people I've not
managed to get enough people to care about this to get permission to put
the firmware in the public repository ... yet.....)

Alan
