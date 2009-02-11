Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:41306 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341AbZBKBs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 20:48:57 -0500
Subject: Re: [linux-dvb] mt352 no more working after suspend to disk
From: hermann pitton <hermann-pitton@arcor.de>
To: Nico Sabbi <Nicola.Sabbi@poste.it>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200902101511.39175.Nicola.Sabbi@poste.it>
References: <200902091233.26086.Nicola.Sabbi@poste.it>
	 <1234217761.2790.15.camel@pc10.localdom.local>
	 <c74595dc0902100439j66981bd7tc68b4a3d177abbe3@mail.gmail.com>
	 <200902101511.39175.Nicola.Sabbi@poste.it>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 02:49:57 +0100
Message-Id: <1234316997.4463.71.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 10.02.2009, 15:11 +0100 schrieb Nico Sabbi:
> On Tuesday 10 February 2009 13:39:09 Alex Betis wrote:
> > On Tue, Feb 10, 2009 at 12:16 AM, hermann pitton 
> <hermann-pitton@arcor.de>wrote:
> > > Hi Nico,
> > >
> > > Am Montag, den 09.02.2009, 12:33 +0100 schrieb Nico Sabbi:
> > > > Hi,
> > > > if I suspend to disk and next resume I have to manually remove
> > > > and reload my mt352 driver, otherwise it complains of a lot of
> > > > i2c errors.
> > > >
> > > > My kernel is suse's 2.6.27.
> > > >
> > > > Is this problem fixed in recent kernels or in hg?
> > > >
> > > > Thanks,
> > > >       Nico
> > >
> > > don't know on what driver you report it, but since I know you
> > > also have saa7134 driver devices, nobody claimed so far that dvb
> > > is suspend/resume safe.
> > >
> > > I recently reported that people have to stay aware after resume,
> > > that even without using any dvb app actually during suspend,
> > > analog needs to be re-initialized first after that to get the
> > > tda10046 in a proper state for DVB-T again, at least on hybrid
> > > devices. Unshared DVB-S tuners and demods do stand this already.
> > > (medion 8800quad, CTX948, Asus 3in1)
> > >
> > > You can suspend to RAM on analog for example with a running
> > > tvtime and resume, but dma sound on saa7134-alsa is also not
> > > handled yet. Analog sound works.
> > >
> > > That is the status as far I have it.
> > >
> 
> Hi Hermann,
> the only card that gave me problems so was is my Airstar2 PCI card,
> while my Lifeview Trio worked perfectly after resume

Nico, Alex, thanks.

Fine so far then without a running DVB-S app.

That we don't get trouble with those maybe building high end linux media
machines currently, status for me for the other reception methods is as
announced above :)

Cheers,
Hermann


