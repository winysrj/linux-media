Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:53836 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbZG2CcX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 22:32:23 -0400
Subject: Re: Terratec Cinergy HibridT XS
From: hermann pitton <hermann-pitton@arcor.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: efa@iol.it, linux-media@vger.kernel.org
In-Reply-To: <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
References: <4A6F8AA5.3040900@iol.it>
	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 04:28:02 +0200
Message-Id: <1248834482.3377.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 28.07.2009, 20:44 -0400 schrieb Devin Heitmueller:
> On Tue, Jul 28, 2009 at 7:32 PM, Valerio Messina<efa@iol.it> wrote:
> > hi all,
> >
> > I own a Terratec Cinergy HibridT XS
> > with lsusb ID:
> > Bus 001 Device 007:
> > ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid T XS
> >
> > With past kernel and a patch as suggested here:
> > http://www.linuxtv.org/wiki/index.php/TerraTec
> > that link to:
> > http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_Hybrid_T_USB_XS
> > that link to:
> > http://mcentral.de/wiki/index.php5/Main_Page
> > and some troubles for Ubuntu kernel that I solved here:
> > https://bugs.launchpad.net/bugs/322732
> > worked well for a year or more.
> >
> > With last Ubuntu 9.04, kernel 2.6.28-13 seems have native support for the
> > tuner, but from dmesg a file is missing: xc3028-v27.fw
> > (maybe manage I2C for IR?)
> > I found it on a web site, copied in /lib/firmware
> > and now Kaffeine work, but ... no more IR remote command work.
> >
> > More bad now:
> > http://mcentral.de/wiki/index.php5/Installation_Guide
> > sell TV tuner, and do not support anymore the Terratec tuner, the source
> > repository is disappeared, and install instruction is a commercial.

all in all it is really funny.

> > Any chanches?
> >
> > thanks in advace,
> > Valerio
> 
> That device, including full support for the IR, is now supported in
> the mainline v4l-dvb tree (and will appear in kernel 2.6.31).  Just
> follow the directions here to get the code:
> 
> http://linuxtv.org/repo
> 
> Devin
> 

Hopefully nobody is mad enough to buy for such prices.

Cheers,
Hermann


