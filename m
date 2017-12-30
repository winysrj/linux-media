Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:54376 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdL3VKm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 30 Dec 2017 16:10:42 -0500
Date: Sat, 30 Dec 2017 21:10:25 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kristian Beilke <beilke@posteo.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, alan@linux.intel.com
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
Message-ID: <20171230211025.7aeaafcd@alans-desktop>
In-Reply-To: <1514476996.7000.437.camel@linux.intel.com>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
        <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
        <1513715821.7000.228.camel@linux.intel.com>
        <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
        <1513866211.7000.250.camel@linux.intel.com>
        <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
        <1514476996.7000.437.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> AFAIR Alan has CHT hardware he is developing / testing on.

I have a loaned board from the company Vincent (who did the intial
patches) works for. At the moment it's loading firmware, finding cameras
doing power management but not transferring images.

Unfortunately because of the design of the driver and firmware at the
moment we are reduced to analyzing all the structs by hand between
multiple different driver releases, and playing games to try and find out
why various things are not matching up (assuming the firmware we have
will actually work with the Windows tablet in question in the first
place).

It's nasty because there are complex structs shared between the firmware
and the OS, and in at least one spot the supposedly 'pristine' CHT driver
that was used for the merge we now know could never have worked because
it mismatched its own firmware !

On BYT I can't currently do much as my latest Intel Android tablet has
died and it's getting hard to find more because I guess the rest of those
made have also died.

> > [   21.120554] rt5645 i2c-10EC5645:00: i2c-10EC5645:00 supply avdd not
> > found, using dummy regulator
> > [   21.120587] rt5645 i2c-10EC5645:00: i2c-10EC5645:00 supply cpvdd
> > not
> > found, using dummy regulator

It couldn't figure out how to power managed some of the components.

> > [   21.145141] intel_sst_acpi 808622A8:00: LPE base: 0x91400000
> > size:0x200000
> > [   21.145146] intel_sst_acpi 808622A8:00: IRAM base: 0x914c0000
> > [   21.145241] intel_sst_acpi 808622A8:00: DRAM base: 0x91500000
> > [   21.145250] intel_sst_acpi 808622A8:00: SHIM base: 0x91540000
> > [   21.145262] intel_sst_acpi 808622A8:00: Mailbox base: 0x91544000
> > [   21.145269] intel_sst_acpi 808622A8:00: DDR base: 0x20000000
> > [   21.145403] intel_sst_acpi 808622A8:00: Got drv data max stream 25
> > [   21.892310] atomisp-isp2 0000:00:03.0: Refused to change power
> > state,
> > currently in D3
> > [   21.904537] OVTI2680:00:
> >                ov2680_s_parm:run_mode :2000
> > [   21.919743] atomisp-isp2 0000:00:03.0: Refused to change power
> > state,
> > currently in D3
> > [   21.930399] OVTI2680:00:
> >                ov2680_s_parm:run_mode :2000
> > [   21.956479] atomisp-isp2 0000:00:03.0: Refused to change power
> > state,
> > currently in D3  

The D3 warnings you can ignore I think. PCI D3 is busted but the native
power management should be looking after it.

Alan
