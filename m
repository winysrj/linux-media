Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49504 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZLUXZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 18:25:07 -0500
Subject: Re: [linux-dvb] Hauppauge PVR-150 Vertical sync issue?
From: Andy Walls <awalls@radix.net>
To: Robert Longfield <robert.longfield@gmail.com>
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org,
	linux-dvb@linuxtv.org
In-Reply-To: <34373e030912211209r78ff1912vfd0acc6f661e6878@mail.gmail.com>
References: <34373e030911241005r7f499297y1a84a93e0696f550@mail.gmail.com>
	 <1259106230.3069.16.camel@palomino.walls.org>
	 <34373e030912100856r2ba80741yca8f79c84ee730e3@mail.gmail.com>
	 <1260523942.3087.21.camel@palomino.walls.org>
	 <34373e030912181159k32d36a40yc989dfd777504aaa@mail.gmail.com>
	 <83bcf6340912181213i31e455a0tad3ab0b070caf508@mail.gmail.com>
	 <34373e030912211209r78ff1912vfd0acc6f661e6878@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 21 Dec 2009 18:23:17 -0500
Message-Id: <1261437797.3055.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-12-21 at 15:09 -0500, Robert Longfield wrote:
> Well it gets even better.
> So on the weekend I was able to steal a few minutes to properly
> trouble shoot the issue now that I know it was in the mythbuntu box.
> As a long shot I pulled out the Promise Tech Ultra133 TX2 / ATA card I
> am using for the backup drive. With this card removed the sync issue
> went away, when I put the card back in the issue returned. Now this
> card was in the slot right next to the PVR-150 card. I moved the
> controller card as far away as I could get from the PVR-150 and the
> sync issue was gone.
> 
> So it would appear that the Promise Tech card was causing some EM
> interference with the PVR-150 card. I will keep an eye on this to make
> sure that this was indeed the issue.
> 
> Does it seem reasonable that this card would kick out interference like this?

Yes, it is plausible.

Perhaps you may also wish to consider an external (USB connected)
capture device.  A PC can internally have many sources of square waves
that have either fundamental or harmonic frequencies in UHF.  The metal
case of a PC can greatly reduce the EMI on outside of the case.

Regards,
Andy

> -Rob
> 
> On Fri, Dec 18, 2009 at 3:13 PM, Steven Toth <stoth@kernellabs.com> wrote:
> >> So it looks like the problem is restricted to my mythbuntu box.
> >
> > Congrats, that's better news.
> >
> > --
> > Steven Toth - Kernel Labs
> > http://www.kernellabs.com


