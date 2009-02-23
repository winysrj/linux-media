Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:38053 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZBWWs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 17:48:59 -0500
Date: Mon, 23 Feb 2009 16:48:51 -0600
From: David Engel <david@istwok.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>, CityK <cityk@rogers.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090223224851.GA15032@opus.istwok.net>
References: <20090218051945.GA12934@opus.istwok.net> <499C218D.7050406@linuxtv.org> <20090218153422.GC15359@opus.istwok.net> <20090219162820.GA23759@opus.istwok.net> <49A1A8E4.8030307@rogers.com> <20090223183946.GA13608@opus.istwok.net> <49A2F3D0.9080508@linuxtv.org> <20090223201054.GA14056@opus.istwok.net> <49A31AE5.5030801@linuxtv.org> <412bdbff0902231403o3280709aq323f94a0a6acc5d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412bdbff0902231403o3280709aq323f94a0a6acc5d0@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 23, 2009 at 05:03:28PM -0500, Devin Heitmueller wrote:
> On Mon, Feb 23, 2009 at 4:53 PM, Steven Toth <stoth@linuxtv.org> wrote:
> > I'm out of time. Someone else want to jump in and assist?
> >
> > - Steve
> 
> Given David's last summary of results, it seems like the BER indicator
> for that particular demodulator is completely unreliable (which isn't
> terribly surprising).  If you take that out of the equation, it seems
> like the only time there is corruption is when both the 115 and the
> x50 is encoding.

The BER isn't totally unreliable.  Yes, when it's low, it does seem to
be meaningless.  However, when it's high, as in my recent attempts to
try a 115 by itself, it indicates that nothing will work.

> So, it seems like we're back to either an RF issue or a DMA issue.
> Did David attempt to move the cards farther apart, or put any sort of
> shielding between the two cards?  If the shielding has any effect,
> then we're probably talking about an RF issue.  If it had no effect,
> then we are probably talking about a DMA issue.

I tried separating the cards as far as possible.  I tried shoving a
small manual (~1/8 inch thick) between the 115 cards and the x50 cards
to shield them.  Neither action had any effect.  Also, one of the
tests I tried yesterday had the HDTV5 between the 115 and the x50s.
The 115 showed corruption and the HDTV5 didn't even though it was
nearest to the x50s.

> Either way, it seems like we should stop talking about the BER as any
> sort of indicator of a problem.

David
-- 
David Engel
david@istwok.net
