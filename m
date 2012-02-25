Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:37201 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750843Ab2BYXmU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 18:42:20 -0500
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 0/3] Support for AF9035/AF9033
Date: Sun, 26 Feb 2012 00:42:12 +0100
Cc: linux-media@vger.kernel.org
References: <201202222320.56583.hfvogt@gmx.net> <4F4760CB.50400@schinagl.nl> <4F4764DA.4080102@schinagl.nl>
In-Reply-To: <4F4764DA.4080102@schinagl.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201202260042.13053.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, 24. Februar 2012 schrieb Oliver Schinagl:
> On 24-02-12 11:04, Oliver Schinagl wrote:
> > On 23-02-12 23:02, Hans-Frieder Vogt wrote:
> >> Am Donnerstag, 23. Februar 2012 schrieb Oliver Schinagl:
> >>> Hi Hans,
> >>> 
> >>> I also have an AF9035 based device, the Asus 3100 Mini Plus. It has an
> >>> AF9035B demodulator and uses an FCI2580 tuner. I've used the driver
> >>> supplied by afa in the past, but haven't tested it in the last few
> >>> months. I have a git repository for that driver at
> >>> http://git.schinagl.nl/AF903x_SRC.git (it is also linked from
> >>> http://www.linuxtv.org/wiki/index.php/Asus_U3100_Mini_plus_DVB-T).
> >>> 
> >>> So when you say it is also coupled with the same tuner, that's not true
> >>> 
> >>> :) With that driver there where a bunch of other tuners that are used
> >>> 
> >>> with this chip. I think the Asus EEEPC supported a USB dvb tuner at
> >>> some
> >>> point and there are reverences in that code for it.
> >>> 
> >>> As of the legality of the code, that is uncertain. The module (compiled
> >>> from all these sources) is very specifically marked as GPL. Most
> >>> headers/source files have no copyright notice at all, some however do,
> >>> but no license in it.
> >>> 
> >>> I asked about afa-tech and there driver status a while ago, but I guess
> >>> there is no news as of yet?
> >>> 
> >>> To summarize, I would love to test your driver, and I think i can code
> >>> something up for my tuner, once these are split?
> >>> 
> >>> Oliver
> >>> 
> >>> On 22-02-12 23:20, Hans-Frieder Vogt wrote:
> >>>> I have written a driver for the AF9035&   AF9033 (called af903x),
> >>>> based on
> >>>> the various drivers and information floating around for these chips.
> >>>> Currently, my driver only supports the devices that I am able to test.
> >>>> These are
> >>>> - Terratec T5 Ver.2 (also known as T6)
> >>>> - Avermedia Volar HD Nano (A867)
> >>>> 
> >>>> The driver supports:
> >>>> - diversity and dual tuner (when the first frontend is used, it is in
> >>>> diversity mode, when two frontends are used in dual tuner mode)
> >>>> - multiple devices
> >>>> - pid filtering
> >>>> - remote control in NEC and RC-6 mode (currently not switchable, but
> >>>> depending on device)
> >>>> - support for kernel 3.1, 3.2 and 3.3 series
> >>>> 
> >>>> I have not tried to split the driver in a DVB-T receiver (af9035)
> >>>> and a
> >>>> frontend (af9033), because I do not see the sense in doing that for a
> >>>> demodulator, that seems to be always used in combination with the very
> >>>> same receiver.
> >>>> 
> >>>> The patch is split in three parts:
> >>>> Patch 1: support for tuner fitipower FC0012
> >>>> Patch 2: basic driver
> >>>> Patch 3: firmware
> >>>> 
> >>>> Hans-Frieder Vogt                       e-mail: hfvogt<at>   gmx
> >>>> .dot. net
> >> 
> >> Hi Oliver,
> >> 
> >> the AF9035B is in fact a DVB-T demodulator with an integrated USB
> >> interface +
> >> further interfaces (I erroneously called it receiver). It needs a
> >> tuner to be
> >> a full DVB-T stick (it seems that the it9135 is basically the AF9035
> >> + an
> >> integrated tuner).
> >> 
> >> the Terratec T5 Rev. 2 and T6 consists of an AF9035B, an AF9033B (Second
> >> demodulator) and dual FC0012 tuners
> >> the Avermedia Volar HD Nano (A867) uses an AF9035B and an Mxl5007t tuner
> >> your Asus 3100 mini uses the FCI2580 tuner.
> >> 
> >> If there is a driver for the FCI2580 tuner then it is not a big issue
> >> to make
> >> it usable with the af903x driver.
> > 
> > The driver is 'available' but in the AF903x_SRC package. If I would
> > take the endevour into writing a driver for the FCI2580, what driver
> > would be best suited as template you reccon?
> > 
> >> I know of these Afatech drivers, but the main disadvantage of them is
> >> in my
> >> eyes that they
> >> - have a lot of useless and unused code
> >> - define own error codes (instead of using the standard error codes)
> >> - have a compiled in firmware
> > 
> > This bit I don't understand. I have not found any binary image in the
> > source tree at all. If the firmware is compiled from the sources, it
> > is compiled into the driver, and not uploaded to the stick when
> > plugged in.
> > 
> > The other firmware is as mentioned the infrared receive 'table', which
> > provides some mapping I guess?
> 
> I was wrong, there is a headerfile, 'api/firmware.h' that does indeed
> contain binary only data. Very ugly indeed.
> 
> Is this firmware specific for the AF903x chip or for the tuners? Looking
> at the code it seems firmware.h contains firmware for a lot different
> combinations, but I think 1 image is 'used'.  I notice that one of your
> firmwares contains a version number of 0.00.00 and the other one
> v.10.something. Firmware.h lists the version as v.8.something so it
> seems that there's several firmwares in circulation. I wonder if
> firmwares are backwards compatible with various boards...
> 

All firmware that I packed in the firmware files is specific for the AF903x chip 
and probably some configuration of the chip. This is however just a suggestion 
based on the fact that windows drivers for the af9035 typically contain 
several firmwares and several scripts (initialisation code, address/value 
pairs) that are selected based on an unknown logic. Maybe all af9035/af9033 
devices can be run with a single firmware, but for the moment I chose to create 
several firmware files.
The tuner related initialisation is in the af903x-tuners file and should 
therefore not hinder running all af9035 devices (i.e. with various tuner 
types) with a single firmware.

The firmware file dvb-usb-af9035-03.fw was created based on an USB snoop of the 
Terratec T6 driver. The Windows driver has the version 10.09.20.01 and I just 
recorded that in the firmware.
The firmware file dvb-usb-af9035-04.fw was created from the firmware.h file of the 
Avermedia Linux driver v1.0.28. I should have used this version number, but 
(due to laziness) called it simply 00.00.00.00.
To make it more confusing, there is also a "link" version number and an "ofdm" 
version number...

> >> - have all supported tuners directly compiled in, which means that they
> >> prevent tuner support to be shared between various drivers
> >> 
> >> So, you see, there are good reasons to write a new driver for these
> >> devices.
> >> 
> >> The point with the legality: I agree that the AF903X_SRC driver is
> >> unclear in
> >> that respect. The glue code (under src) is explicitly marked as GPL,
> >> but the
> >> api code (under api) isn't marked.
> >> Luckily, there is the it9135-driver from Jason Dong which is clearly
> >> GPL and
> >> which uses the same functions. Therefore there is effectivly example
> >> code from
> >> Afatech/Ite technology available that is under GPL.
> >> 
> >> Cheers,
> >> 
> >> Hans-Frieder Vogt                       e-mail: hfvogt<at>  gmx .dot.
> >> net


Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
