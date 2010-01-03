Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55792 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753127Ab0ACX3S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jan 2010 18:29:18 -0500
From: Martin Dauskardt <martin.dauskardt@gmx.de>
To: Andy Walls <awalls@radix.net>
Subject: Re: [ivtv-devel] PVR150 Tinny/fuzzy audio w/ patch?
Date: Mon, 4 Jan 2010 00:29:14 +0100
Cc: Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>, Steven Toth <stoth@kernellabs.com>,
	isely@pobox.com, linux-media@vger.kernel.org
References: <200912311815.38865.martin.dauskardt@gmx.de> <1262287607.3055.115.camel@palomino.walls.org> <1262288415.3055.121.camel@palomino.walls.org>
In-Reply-To: <1262288415.3055.121.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001040029.15056.martin.dauskardt@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, 31. Dezember 2009 20:40:15 schrieb Andy Walls:
> On Thu, 2009-12-31 at 14:26 -0500, Andy Walls wrote:
> > On Thu, 2009-12-31 at 18:15 +0100, Martin Dauskardt wrote:
> 
> Some corrections to errors:
> > My preferences in summary, is that not matter what the digitizer chip:
> 
> My preferences are, in summary, that no matter what the digitizer chip:
> > a. I'd like to keep the audio clocks always up to avoid tinny audio.
> >
> > b. I'd also like to inhibit the video clock and add the delay after
> 
>                                                   ^^^
>                                                   refine
> 
> > re-enabling the digitizer to avoid the *potential* for a hung machine.
> 
> A value smaller than 300 ms should work, but a value smaller than 40 ms
> may not work, if my hypothesis is correct.
> 
> > c. I do not care to much about the delay after disbaling the video
> > clock, only that it is empirically "long enough".
> >
> > Thanks for taking the time to test and comment.
> >
> > Regards,
> > Andy
> 
> Regards,
> Andy

I tested various sleep values:
http://home.arcor-online.de/martin.dauskardt/digitizer_msleep.xls

It seems that we only need a total delay of 300ms between the previous actions 
in ivtv-streams.c and the start of the capture. 

This also secures that we don't see disturbance from a previous frequency 
switch. This happens with smaller sleep values:
http://home.arcor-online.de/martin.dauskardt/channelswitch.mpg
and can lead to the infamous flickering problem (http://www.gossamer-
threads.com/lists/ivtv/devel/32970) . The current driver has this problem only 
with cx23415 (PVR350), not cx23416.

My preference is:
-let it how it is (300 ms sleep before the firmware call)
or
-split the 300ms to 150 and 150

Greets,
Martin
