Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59478 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbaA1CCp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 21:02:45 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0LgI0W-1VTSCm152i-00niTn for
 <linux-media@vger.kernel.org>; Tue, 28 Jan 2014 03:02:44 +0100
Date: Tue, 28 Jan 2014 03:02:42 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140128020242.GA31019@minime.bse>
References: <20140122135036.GA14871@minime.bse>
 <52E00AD0.2020402@googlemail.com>
 <20140123132741.GA15756@minime.bse>
 <52E1273F.90207@googlemail.com>
 <20140125152339.GA18168@minime.bse>
 <52E4EFBB.7070504@googlemail.com>
 <20140126125552.GA26918@minime.bse>
 <52E5366A.807@googlemail.com>
 <20140127032044.GA27541@minime.bse>
 <52E6C7A4.8050708@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E6C7A4.8050708@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 27, 2014 at 08:55:00PM +0000, Robert Longbottom wrote:
> >As for the CPLD, there is not much we can do. I count 23 GPIOs going
> >to that chip. And we don't know if some of these are outputs of the
> >CPLD, making it a bit risky to just randomly drive values on those
> >pins.
> 
> Is that because it might do some damage to the card, or to the host
> computer, or both?

If there is damage, it will most likely be restricted to the card.

> Or is it just too hard to make random guesses at
> what it should be doing?

When we cycle through all combinations in one minute, there are about
a hundred PCI cycles per combination left for the chip to be granted
access to the bus. I expect most of the pins to provide a priority
or weighting value for each BT878A, so there should be many combinations
that do something.

> >If we had the original software, we could analyze what it is doing.
> >There is someone on ebay.com selling two of those cards and a cd
> >labled "Rescue Disk Version 1.14 for Linux DVR".
> 
> Ah yes, I've just found that, it seems a little pricey!

Maybe the seller is nice person and provides the contents of the CD for
free.

> There is
> also a listing for an "Avermedia 4 Eyes Pro Capture Card PCI 8604"
> which looks pretty much the same, but it doesn't have any software
> with it and searching around for any more information on that hasn't
> got me anywhere.

It's the same card but it is not the Avermedia 4 Eyes Pro.

  Daniel
