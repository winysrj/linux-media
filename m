Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58294 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdLUO2E (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 09:28:04 -0500
Message-ID: <1513866211.7000.250.camel@linux.intel.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kristian Beilke <beilke@posteo.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        alan@linux.intel.com
Date: Thu, 21 Dec 2017 16:23:31 +0200
In-Reply-To: <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
         <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
         <1513715821.7000.228.camel@linux.intel.com>
         <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-12-21 at 13:54 +0100, Kristian Beilke wrote:
> On Tue, Dec 19, 2017 at 10:37:01PM +0200, Andy Shevchenko wrote:
> > On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
> > > Cc Alan and Andy.
> > > 
> > > On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke wrote:
> > > > Dear all,
> > > > 
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
> > 
> > WRT to the messages below it seems we have no platform data for that
> > device. It needs to be added.
> > 
> > In any case, I have no firmware to test BayTrail hardware I have
> > (MRD7).
> > 
> > The driver claims it needs:
> > 
> > Firmware file: shisp_2400b0_v21.bin
> > Version string: irci_stable_candrpv_0415_20150521_0458
> > 
> > What I have is:
> > 
> > Version string: irci_stable_candrpv_0415_20150423_1753
> > SHA1: 548d26a9b5daedbeb59a46ea1da69757d92cd4d6  shisp_2400b0_v21.bin
> > 
> 
> I am a bit at a loss here. The TODO file says
> 
> 7. The ISP code depends on the exact FW version. The version defined
> in
>    BYT:
>    drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.
> c
>    static const char *release_version =
> STR(irci_stable_candrpv_0415_20150521_0458);
>    CHT:
>    drivers/staging/media/atomisp/pci/atomisp2/css/sh_css_firmware.c
>    static const char *release_version = STR(irci_ecr-
> master_20150911_0724);
> 
> The different files obviously have been merged into the first:
> 
> /* The string STR is a place holder
>  * which will be replaced with the actual RELEASE_VERSION
>  * during package generation. Please do not modify  */
> #ifndef ISP2401
> static const char *release_version =
> STR(irci_stable_candrpv_0415_20150521_0458);
> #else
> static const char *release_version = STR(irci_ecr-
> master_20150911_0724);
> #endif
> 
> Trying to find the firmware files I came up with:
> 
> strings shisp_2400b0_v21.bin | grep irci
> irci_stable_candrpv_0415_20150423_1753
> 
> strings shisp_2401a0_v21.bin | grep irci
> irci_stable_candrpv_0415_20150521_0458
> 
> which seems to be an odd match. The CherryTrail FW is older than the
> one
> expected, but I could not find a newer one. The BayTrail FW is the
> same
> you have (but it should at least be compatible).
> Any hints on where to find the expected FW files? As my hardware is
> no android device, I can not look into an update kit.

For now we are all using that firmware I mentioned (with, of course,
hack-patch applied to make driver swallow it).

>>>> Can I somehow help to improve
> > > > the driver?
> > 
> > Yes, definitely, but first of all we need to find at least one
> > device
> > and corresponding firmware where it actually works.
> > 
> > For me it doesn't generate any interrupt (after huge hacking to make
> > that firmware loaded and settings / platform data applied).
> > 
> 
> What exactly are you looking for?

For anything that *somehow* works.

>  An Android device where the ov2680
> works?

First of all, I most likely do not have hardware with such sensor.
Second, I'm using one of the prototype HW based on BayTrail with PCI
enumerable AtomISP.

>  Some x86_64 hardware, where the matching firmware is available and
> the driver in 4.15 works?

Yes, that's what I would like to have before moving forward with any new
sensor drivers, clean ups or alike type of changes to the driver.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
