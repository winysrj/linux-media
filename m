Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:58153 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZG3DpY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 23:45:24 -0400
Date: Wed, 29 Jul 2009 22:45:23 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jelle de Jong <jelledejong@powercraft.nl>,
	"linux-media@vger.kernel.org >> \"linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>
Subject: Re: offering bounty for GPL'd dual em28xx support
In-Reply-To: <20090722132204.774d7af3@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0907292235470.23703@cnc.isely.net>
References: <4A6666CC.7020008@eyemagnet.com>
 <829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>
 <4A66E59E.9040502@powercraft.nl> <829197380907220748kab85c63g6ebbaad07084c255@mail.gmail.com>
 <4A6729CF.8080804@powercraft.nl> <829197380907220806p4ed7a02bw3beff7c6776a858a@mail.gmail.com>
 <20090722132204.774d7af3@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Jul 2009, Mauro Carvalho Chehab wrote:

> Em Wed, 22 Jul 2009 11:06:12 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> 
> > On Wed, Jul 22, 2009 at 11:01 AM, Jelle de
> > Jong<jelledejong@powercraft.nl> wrote:
> > > Funky timing of those mails :D.
> > >
> > > I saw only after sending my mail that Steve was talking about analog and
> > > that this is indeed different. Dual analog tuner support should be
> > > possible right? Maybe with some other analog usb chipsets? I don't know
> > > what the usb blocksize is or if they are isochronous transfers or bulk
> > > or control.
> > >
> > > I assume the video must be uncompressed transferred over usb because the
> > > decoding chip is on the usb device is not capable of doing compression
> > > encoding after the analog video decoding? Are there usb devices that do
> > > such tricks?
> > 
> > There were older devices that did compression, mainly designed to fit
> > the stream inside of 12Mbps USB.  However, they required onboard RAM
> > to buffer the frame which added considerable cost (in addition to the
> > overhead of doing the compression), and as a result pretty much all of
> > the USB 2.0 designs I have seen do not do any on-chip compression.
> > 
> > The example which comes to mind is the Hauppauge Win-TV USB which uses
> > the usbvision chipset.
> 
> pvrusb2 also has compression, provided by an external mpeg encoder. Those
> devices are USB 2.0
> 

I know this is a fairly old thread, but I've been away on vacation and 
I'm catching up on e-mail right now.  So forgive me if this has already 
been answered...

The Hauppauge Win-TV PVR-USB2 is the most well-known device in this 
category and it's what the pvrusb2 driver originally targeted.  This 
device uses a dedicated mpeg encoder chip within the device, so the 
video stream coming from the hardware is actually compressed video (mpeg 
format, mostly DVD-style mpeg2).  The question of USB 1.1 vs USB 2.0 is 
actually due to the device's microcontroller (the "bridge chip") not the 
mpeg encoder.  In the pvrusb2 case, that controller is a Cypress FX2 
which includes an on-chip USB 2.0 high-speed device interface.  But the 
mpeg encoder actually doesn't REQUIRE USB 2.0 high-speed.  The default 
encoder settings configured by the pvrusb2 driver actually work quite 
well over USB 1.1, since the resulting video stream requires 
significantly less bandwidth than the 12Mbps that USB 1.1 can 
theoretically supply.  I've actually successfully tested such a 
configuration here.  The hardware works fine over USB 1.1.

  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
