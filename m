Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay-pt1.poste.it ([62.241.4.164]:57649 "EHLO
	relay-pt1.poste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZBJOcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 09:32:14 -0500
Received: from nico2.od.loc (93.63.225.36) by relay-pt1.poste.it (7.3.122) (authenticated as Nicola.Sabbi@poste.it)
        id 4990D21200005F60 for linux-media@vger.kernel.org; Tue, 10 Feb 2009 15:11:39 +0100
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] mt352 no more working after suspend to disk
Date: Tue, 10 Feb 2009 15:11:39 +0100
References: <200902091233.26086.Nicola.Sabbi@poste.it> <1234217761.2790.15.camel@pc10.localdom.local> <c74595dc0902100439j66981bd7tc68b4a3d177abbe3@mail.gmail.com>
In-Reply-To: <c74595dc0902100439j66981bd7tc68b4a3d177abbe3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902101511.39175.Nicola.Sabbi@poste.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 February 2009 13:39:09 Alex Betis wrote:
> On Tue, Feb 10, 2009 at 12:16 AM, hermann pitton 
<hermann-pitton@arcor.de>wrote:
> > Hi Nico,
> >
> > Am Montag, den 09.02.2009, 12:33 +0100 schrieb Nico Sabbi:
> > > Hi,
> > > if I suspend to disk and next resume I have to manually remove
> > > and reload my mt352 driver, otherwise it complains of a lot of
> > > i2c errors.
> > >
> > > My kernel is suse's 2.6.27.
> > >
> > > Is this problem fixed in recent kernels or in hg?
> > >
> > > Thanks,
> > >       Nico
> >
> > don't know on what driver you report it, but since I know you
> > also have saa7134 driver devices, nobody claimed so far that dvb
> > is suspend/resume safe.
> >
> > I recently reported that people have to stay aware after resume,
> > that even without using any dvb app actually during suspend,
> > analog needs to be re-initialized first after that to get the
> > tda10046 in a proper state for DVB-T again, at least on hybrid
> > devices. Unshared DVB-S tuners and demods do stand this already.
> > (medion 8800quad, CTX948, Asus 3in1)
> >
> > You can suspend to RAM on analog for example with a running
> > tvtime and resume, but dma sound on saa7134-alsa is also not
> > handled yet. Analog sound works.
> >
> > That is the status as far I have it.
> >

Hi Hermann,
the only card that gave me problems so was is my Airstar2 PCI card,
while my Lifeview Trio worked perfectly after resume
