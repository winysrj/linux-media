Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24570 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751171AbdLSUhE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 15:37:04 -0500
Message-ID: <1513715821.7000.228.camel@linux.intel.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Kristian Beilke <beilke@posteo.de>
Cc: linux-media@vger.kernel.org, alan@linux.intel.com
Date: Tue, 19 Dec 2017 22:37:01 +0200
In-Reply-To: <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
         <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
> Cc Alan and Andy.
> 
> On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke wrote:
> > Dear all,
> > 
> > I am trying to get the cameras in a Lenovo IdeaPad Miix 320 (Atom
> > x5-Z8350 BayTrail) to work. The front camera is an ov2680. With
> > kernel
> > 4.14.4 and 4.15rc3 I see the following dmesg output:

It seems I forgot to send the rest of the patches I did while ago
against AtomISP code.

It includes switch to normal DMI matching instead of the crap we have
there right now.

WRT to the messages below it seems we have no platform data for that
device. It needs to be added.

In any case, I have no firmware to test BayTrail hardware I have (MRD7).

The driver claims it needs:

Firmware file: shisp_2400b0_v21.bin
Version string: irci_stable_candrpv_0415_20150521_0458

What I have is:

Version string: irci_stable_candrpv_0415_20150423_1753
SHA1: 548d26a9b5daedbeb59a46ea1da69757d92cd4d6  shisp_2400b0_v21.bin

> > [   21.469907] ov2680: module is from the staging directory, the
> > quality
> >  is unknown, you have been warned.
> > [   21.492774] ov2680 i2c-OVTI2680:00: gmin: initializing atomisp
> > module
> > subdev data.PMIC ID 1
> > [   21.492891] acpi OVTI2680:00: Failed to find gmin variable
> > OVTI2680:00_CamClk
> > [   21.492974] acpi OVTI2680:00: Failed to find gmin variable
> > OVTI2680:00_ClkSrc
> > [   21.493090] acpi OVTI2680:00: Failed to find gmin variable
> > OVTI2680:00_CsiPort
> > [   21.493209] acpi OVTI2680:00: Failed to find gmin variable
> > OVTI2680:00_CsiLanes
> > [   21.493511] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V1P8SX
> > not
> > found, using dummy regulator
> > [   21.493550] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V2P8SX
> > not
> > found, using dummy regulator
> > [   21.493569] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V1P2A
> > not
> > found, using dummy regulator
> > [   21.493585] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply
> > VPROG4B
> > not found, using dummy regulator
> > [   21.568134] ov2680 i2c-OVTI2680:00: camera pdata: port: 0 lanes:
> > 1
> > order: 00000002
> > [   21.568257] ov2680 i2c-OVTI2680:00: read from offset 0x300a error
> > -121
> > [   21.568265] ov2680 i2c-OVTI2680:00: sensor_id_high = 0xffff
> > [   21.568269] ov2680 i2c-OVTI2680:00: ov2680_detect err s_config.
> > [   21.568291] ov2680 i2c-OVTI2680:00: sensor power-gating failed
> > 
> > Afterwards I do not get a camera device.
> > 
> > Am I missing some firmware or dependency?

See above.

> >  Can I somehow help to improve
> > the driver?

Yes, definitely, but first of all we need to find at least one device
and corresponding firmware where it actually works.

For me it doesn't generate any interrupt (after huge hacking to make
that firmware loaded and settings / platform data applied).

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
