Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbZGTUva (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 16:51:30 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional again
Date: Mon, 20 Jul 2009 16:50:23 -0400
Cc: linux-media@vger.kernel.org
References: <200907201020.47581.jarod@redhat.com> <Pine.LNX.4.58.0907201240490.11911@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0907201240490.11911@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907201650.23749.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 20 July 2009 15:51:27 Trent Piepho wrote:
> On Mon, 20 Jul 2009, Jarod Wilson wrote:
> > The dvb side of the pcHDTV HD-3000 doesn't work since at least 2.6.29.
> > The crux of the problem is this: the HD-3000's device ID matches the
> > modalias for the cx8800 driver, but not the cx8802 driver, which is
> > required to set up the digital side of the card. You can load up
> > cx8802 just fine, but cx88-dvb falls on its face, because the call
> > to cx8802_register_driver() attempts to traverse the cx8802_devlist,
> > which is completely empty. The list is only populated by the
> > cx8802_probe() function, which never gets called for the HD-3000, as
> > its device ID isn't matched by the cx8802 driver, so you wind up
> 
> This isn't right.  The cx8802 has never had anything in its mod alias other
> than the generic 14f1/8802 vendor/device with wildcards for
> sub-vendor/device.  Which should match the HD-3000 as well as all other
> cx88 based digital cards.  So cx8802_probe() should be called with the
> existing id table.  Something else must be going on.  Maybe there is
> something wrong with your PCI and function 2 isn't showing up?  Or it could
> be that function 2 is disabled in the eeprom.  Make sure lspci shows the
> mpeg function listed:
> 
> 02:04.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
>         Subsystem: pcHDTV pcHDTV HD3000 HDTV
>         Flags: bus master, medium devsel, latency 64, IRQ 18
>         Memory at c5000000 (32-bit, non-prefetchable) [size=16M]

Hrm, okay, I'll double-check that... If its not there, perhaps the card
isn't quite seated correctly. Or the machine is bunk. Or the card has
gone belly up. Amusing that it works as much as it does though, if any
of the above is the case...

Thanks for the info!

-- 
Jarod Wilson
jarod@redhat.com
