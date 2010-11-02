Return-path: <mchehab@gaivota>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:33493 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755324Ab0KBDWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Nov 2010 23:22:32 -0400
Subject: Re: V4L/DVB/IR patches pending merge
From: hermann pitton <hermann-pitton@arcor.de>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-media@vger.kernel.org
In-Reply-To: <87vd4hwd3b.fsf@nemi.mork.no>
References: <4CC25F60.7050106@redhat.com>  <87vd4hwd3b.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 02 Nov 2010 04:06:25 +0100
Message-Id: <1288667185.3146.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Am Montag, den 01.11.2010, 11:30 +0100 schrieb Bjørn Mork:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> > 		== mantis patches - Waiting for Manu Abraham <abraham.manu@gmail.com> == 
> >
> > Apr,15 2010: [5/8] ir-core: convert mantis from ir-functions.c                      http://patchwork.kernel.org/patch/92961   David HÃ¤rdeman <david@hardeman.nu>
> > Jun,20 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/107036  Marko Ristola <marko.ristola@kolumbus.fi>
> > Jun,20 2010: [2/2] DVB/V4L: mantis: remove unused files                             http://patchwork.kernel.org/patch/107062  BjÃ¸rn Mork <bjorn@mork.no>
> > Jun,20 2010: mantis: use dvb_attach to avoid double dereferencing on module removal http://patchwork.kernel.org/patch/107063  BjÃ¸rn Mork <bjorn@mork.no>
> > Jun,21 2010: Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to make modules  http://patchwork.kernel.org/patch/107147  Manu Abraham <abraham.manu@gmail.com>
> > Jul, 3 2010: mantis: Rename gpio_set_bits to mantis_gpio_set_bits                   http://patchwork.kernel.org/patch/109972  Ben Hutchings <ben@decadent.org.uk>
> > Jul, 8 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/110909  Marko Ristola <marko.ristola@kolumbus.fi>
> > Jul, 9 2010: Mantis: append tasklet maintenance for DVB stream delivery             http://patchwork.kernel.org/patch/111090  Marko Ristola <marko.ristola@kolumbus.fi>
> > Jul,10 2010: Mantis driver patch: use interrupt for I2C traffic instead of busy reg http://patchwork.kernel.org/patch/111245  Marko Ristola <marko.ristola@kolumbus.fi>
> > Jul,19 2010: Twinhan DTV Ter-CI (3030 mantis)                                       http://patchwork.kernel.org/patch/112708  Niklas Claesson <nicke.claesson@gmail.com>
> > Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>
> > Oct,10 2010: [v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod   http://patchwork.kernel.org/patch/244201  Tuxoholic <tuxoholic@hotmail.de>
> > Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.kernel.org/patch/105621  Florent AUDEBERT <florent.audebert@anevia.com>
> >
> > What to say? Well, still waiting for Manu to handle those patches. He said he had a problem with
> > his dish and should be working on it next week. Let's hope we can finally have some movement
> > on those patches in time for .37.
> 
> Can we agree that this was yet another useless waiting exercise?  Please
> start learning from experience.  You are just repeating the same mistake
> again and again.  Its rather frustrating to watch.  Like watching a rat
> in a maze banging it's head against the same wall over and over again.
> 
> 
> 
> Bjørn


Bjorn,

you are taking it wrong.

Indeed, neither Manu nor Mauro can do anything on this now.

It got stuck from outside. There is a war.

If you look closer, beside of Mantis stuff, there are drivers for much
more recent chipsets, failing for not having linux support right now,
being able to do the triple performance and even much more.

Without help, neither Manu nor Mauro can "hack" them together.

Cheers,
Hermann







