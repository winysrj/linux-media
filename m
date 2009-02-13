Return-path: <linux-media-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:33816 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZBMTu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 14:50:57 -0500
Subject: Re: [linux-dvb] Mantis Update was Re: Twinhan DTV Ter-CI (3030
 Mantis) ???
From: Bob Deblier <bob.deblier@gmail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <499476F4.6010907@gmail.com>
References: <4984E294.6020401@gmail.com> <498B7945.4060200@gmail.com>
	 <498DEDA9.7010905@freenet.de>  <499476F4.6010907@gmail.com>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 20:44:44 +0100
Message-Id: <1234554284.4027.13.camel@bxl-bob.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-02-12 at 23:22 +0400, Manu Abraham wrote:
> Ruediger Dohmhardt wrote:
> > Manu Abraham schrieb:
> >> Have added initial support for this card, as well as a large
> >> overhaul of the driver for a couple of performance impacts.
> >>
> >> Please do test with the latest updates from http://jusst.de/hg/mantis.
> >>   
> > Hi Manu
> > the versions from January and February 2009 compile fine on the
> > SUSE-11.1 kernel 2.6.27.7-9-default x86_64.
> > The modules for my Twinhan AD-CP300 (2033) load fine, too.
> > 
> > However, the devices below /dev/dvb are NOT created, and hence vdr-1.7
> > does not work.
> > The card works with the s2-liplianin driver.
> > 
> > I assume it is interrupt related as listed in the lines from
> > /var/log/messages
> > 
> > 
> > Feb  7 21:03:38 mt40 su: (to root) rudi on /dev/pts/1
> > Feb  7 21:03:48 mt40 kernel: vendor=1002 device=4371
> > Feb  7 21:03:48 mt40 kernel: Mantis 0000:02:01.0: PCI INT A -> GSI 21
> > (level, low) -> IRQ 21
> > Feb  7 21:03:48 mt40 kernel: DVB: registering new adapter (Mantis DVB
> > adapter)
> > Feb  7 21:03:48 mt40 kernel: vendor=1002 device=4371
> > Feb  7 21:03:48 mt40 kernel: Mantis 0000:02:01.0: PCI INT A disabled
> > Feb  7 21:03:48 mt40 kernel: Mantis: probe of 0000:02:01.0 failed with
> > error -1
> > Feb  7 21:05:03 mt40 vdr: [4320] cTimeMs: using monotonic clock
> > (resolution is 1 ns)
> > Feb  7 21:05:03 mt40 vdr: [4320] VDR version 1.7.0 started
> > Feb  7 21:05:03 mt40 vdr: [4320] codeset is 'UTF-8' - known
> > Feb  7 21:05:03 mt40 vdr: [4320] ERROR: ./locale: Datei oder Verzeichnis
> > nicht gefunden
> > Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'deu,ger'
> > Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'slv,slo'
> > Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'ita'
> > Feb  7 21:05:05 mt40 vdr: [4320] no DVB device found
> > 
> > I wonder whether I can check something more to get your driver back to work
> >
> 
> I guess it should work now. Some silly things cropped up in the
> previous overhaul .. It brings in some added reliability to I2C
> communications. Please try the latest changes.
> 
> 
> Regards,
> Manu

Compiled with kernel 2.6.28; there's was a minor glitch that I was able
to work around: a missing macro definition in saa7134-alsa.c
(alsa_assert).

Driver loads and the card is recognized.

I'll keep you informed of stability issues. Thanks for the fix!

Regards,

Bob


