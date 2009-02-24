Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:40427 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbZBXQkM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 11:40:12 -0500
Date: Tue, 24 Feb 2009 10:40:04 -0600
From: David Engel <david@istwok.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>,
	pat-lkml <pat-lkml@erley.org>, Andy Walls <awalls@radix.net>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>, CityK <cityk@rogers.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090224164004.GA18138@opus.istwok.net>
References: <20090218153422.GC15359@opus.istwok.net> <20090219162820.GA23759@opus.istwok.net> <49A1A8E4.8030307@rogers.com> <20090223183946.GA13608@opus.istwok.net> <49A2F3D0.9080508@linuxtv.org> <20090223201054.GA14056@opus.istwok.net> <49A31AE5.5030801@linuxtv.org> <412bdbff0902231403o3280709aq323f94a0a6acc5d0@mail.gmail.com> <20090223224851.GA15032@opus.istwok.net> <412bdbff0902231458x41c1298cv4fd15d1f0bf5600d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235433917.3097.77.camel@palomino.walls.org> <49A34F88.3080708@erley.org> <412bdbff0902231458x41c1298cv4fd15d1f0bf5600d@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 23, 2009 at 05:58:54PM -0500, Devin Heitmueller wrote:
> On Mon, Feb 23, 2009 at 5:48 PM, David Engel <david@istwok.net> wrote:
> > The BER isn't totally unreliable.  Yes, when it's low, it does seem to
> > be meaningless.  However, when it's high, as in my recent attempts to
> > try a 115 by itself, it indicates that nothing will work.
> 
> Maybe I am missing something.  Your last summary said you had a high
> BER even the 115 is the only card in the system.  That would lead me
> to believe that it's always screwed up.

I should have been clearer about BER when the 115 doesn't work at all.
In those cases, BER is something like 00007ff8 and UNC is 000000ff.
In the cases where the 115 does work (with or without corruption), the
BER is typically less than 00000200 and UNC is always 00000000.

> Anyway, I don't have the card and all my suggestions were very
> general.  If you can't find a developer with the card willing to debug
> the issue then you're probably SOL.

FWIW, my expectation was to be SOL.  I'm very appreciative of all the
help I've received so far.

On Mon, Feb 23, 2009 at 08:38:16PM -0500, pat-lkml wrote:
> David said that the original system died with these cards in it.  And that
> the cards don't seem to work without another device in the system hooked up
> to the same splitter.  This makes it sound like the shielding pin on these
> cards has been disconnected some how, and when the other device (pvrx50 in
> this case) is hooked up, the shielding is electrically connected through the
> bus somehow.  When the pvrs start recording, they likely change the load on
> the shielding in some way that causes interference for the 115 cards.  
> 
> David, do you happen to have another device you could test in the system with
> the 2 115s, without the x50s?  If this case works fine, it REALLY points to
> something being wrong with your 115s electrically.  I'd try ohming out the
> shielding trace to the connector on the back of the board, if possible.

Yes, I have a Fusion HDTV5.  I tried the HDTV5 with one of the 115s
and the 115 did not work in that configuration.  How do I identify the
shielding trace?  If it helps, Newegg has decent pictures of the card
at

http://www.newegg.com/Product/ShowImage.aspx?Image=15-260-005-17.jpg%2c15-260-005-10.jpg%2c15-260-005-11.jpg%2c15-260-005-12.jpg%2c15-260-005-13.jpg%2c15-260-005-14.jpg%2c15-260-005-15.jpg%2c15-260-005-16.jpg&S7ImageFlag=0&WaterMark=1&Item=N82E16815260005&Depa=0&Description=KWORLD PlusTV HD PCI-115 TV Tuner ATSC 115

or 

http://tinyurl.com/amkk6e

On Mon, Feb 23, 2009 at 07:05:17PM -0500, Andy Walls wrote:
> On Mon, 2009-02-23 at 14:10 -0600, David Engel wrote:
> > To help clarify things, here is a rephrasing of this weekend's results:
> > 
> >   115 by itself = excessive BER
> >   115 with one or two other 115s = excessive BER
> >   115 with HDTV5 = excessive BER
> >   115 with Audigy = excessive BER
> >   115 with x50 and x50 not connected and x50 not encoding = excessive BER
> >   115 with x50 and x50 connected and x50 not encoding = low BER and no corruption
> >   115 with x50 and x50 connected and x50 encoding = low BER and minor corruption
> >   HDTV5 with anything = 0 BER and no corruption
> 
> David,
> 
> I cannot reconcile the two lines with HDTV5 as they seem to say "x" and
> "not x".

The result is for the first card listed on the line.

So, for "HDTV5 with anything = 0 BER and no corruption", the HDTV5 had
0 BER and showed no corruption.  IOW, the HDTV5 always worked no
matter what configuration I tried it in.

For "115 with HDTV5 = excessive BER", the 115 had BER of 00007ff8 when
it was tried with the HDTV5 and nothing else.

> Aside from that, here are my thoughts:
> 
> If it's not one thing, then it's two.  :)  It could be that you have
> both both an Electro-Magnetic Interference (EMI) problem and a buffer
> handling problem.  You need to work the solution to one while you have
> mitigated or controlled the effects of the other.

I believe you are right about there being two problems.  Of the two, I
consider the EMI problem more important since I'll eventually retire
the x50s and just use the 3 115s in the case.

> 1. You have indications that hooking up the PVR-x50 mitigates EMI or RF
> problems, but you don't know why.  So without knowing details about your
> signal distribution plant, I'll make some guesses as to what might be
> going on:
> 
> a. The unsplit signal is overdriving the frontend of the 115.  The
> intermodulation products that show up, due to a strong signal hitting
> non-linearities in the frontend, act as raised noise floor at other
> frequencies.
> 
> b. Without a splitter or some other device in the way, you have a
> created a ground loop between you and the cable company.  This current
> on the ground conductor shows up as EMI/a raised noise floor.  (I doubt
> a PVR-x50 on it's own would be mitigating a ground loop.)
> 
> c. You have improperly terminated connections or an impedance mistmatch
> somewhere causing signal reflections in your cabling plant, that show up
> as a raised noise floor.  On analog video you would likely see ghosting.
> 
> I could go on guessing, but instead, just make sure you're using good
> practices when it comes to RF signal distribution:
> 
> http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality

I try to follow good practices.  I think the biggest thing from your
list that I don't have is an isolation transformer.

> 2.  When multiple devices encoding leads to a corrupt stream, I'll
> assert it is the driver of the device delivering the corrupted stream
> that is mishandling buffers or DMA completion notifications.  So I
> believe the driver for the 115 (saa7134) is probably the culprit here.
> Its logic probably works on unloaded systems, but on busy systems it's
> doing the wrong thing.  Your test with the HDTV5 and PVR-x50's support
> this assertion.  It's not the ivtv driver, nor the cx88 driver that
> misbahves in a busy system; it's the saa7134 driver that doesn't do
> something right on busy system.
> 
> Does running 3 115 captures (with a PVRx50 installed and idle) cause
> corruption as well?  I'm betting it does.

I'll try this.

David
-- 
David Engel
david@istwok.net
