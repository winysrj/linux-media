Return-path: <linux-media-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:38499
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZBXBro (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 20:47:44 -0500
Message-ID: <49A34F88.3080708@erley.org>
Date: Mon, 23 Feb 2009 20:38:16 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: David Engel <david@istwok.net>, CityK <cityk@rogers.com>,
	V4L <video4linux-list@redhat.com>, linux-media@vger.kernel.org
Subject: Re: PVR x50 corrupts ATSC 115 streams
References: <20090218051945.GA12934@opus.istwok.net>	<20090218153422.GC15359@opus.istwok.net>	<20090219162820.GA23759@opus.istwok.net> <49A1A8E4.8030307@rogers.com>	<20090223183946.GA13608@opus.istwok.net>	<49A2F3D0.9080508@linuxtv.org>	<20090223201054.GA14056@opus.istwok.net>	<49A31AE5.5030801@linuxtv.org>	<412bdbff0902231403o3280709aq323f94a0a6acc5d0@mail.gmail.com>	<20090223224851.GA15032@opus.istwok.net> <412bdbff0902231458x41c1298cv4fd15d1f0bf5600d@mail.gmail.com>
In-Reply-To: <412bdbff0902231458x41c1298cv4fd15d1f0bf5600d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Mon, Feb 23, 2009 at 5:48 PM, David Engel <david@istwok.net> wrote:
>> The BER isn't totally unreliable.  Yes, when it's low, it does seem to
>> be meaningless.  However, when it's high, as in my recent attempts to
>> try a 115 by itself, it indicates that nothing will work.
> 
> Maybe I am missing something.  Your last summary said you had a high
> BER even the 115 is the only card in the system.  That would lead me
> to believe that it's always screwed up.
> 
>> I tried separating the cards as far as possible.  I tried shoving a
>> small manual (~1/8 inch thick) between the 115 cards and the x50 cards
>> to shield them.  Neither action had any effect.  Also, one of the
>> tests I tried yesterday had the HDTV5 between the 115 and the x50s.
>> The 115 showed corruption and the HDTV5 didn't even though it was
>> nearest to the x50s.
> 
> Different cards interfere with each other in different ways (based on
> things such as the PCB layout).  The fact that the HDTV5 doesn't have
> issues doesn't really mean *anything*.  Same goes for the fact that
> it's BER indicator is always zero.  That could just as easily indicate
> that the BER checking is properly implemented for that particular
> demod.
> 
> Anyway, I don't have the card and all my suggestions were very
> general.  If you can't find a developer with the card willing to debug
> the issue then you're probably SOL.
> 
> Devin
> 
To chime in late in this conversation...

David said that the original system died with these cards in it.  And that
the cards don't seem to work without another device in the system hooked up
to the same splitter.  This makes it sound like the shielding pin on these
cards has been disconnected some how, and when the other device (pvrx50 in
this case) is hooked up, the shielding is electrically connected through the
bus somehow.  When the pvrs start recording, they likely change the load on
the shielding in some way that causes interference for the 115 cards.  

David, do you happen to have another device you could test in the system with
the 2 115s, without the x50s?  If this case works fine, it REALLY points to
something being wrong with your 115s electrically.  I'd try ohming out the
shielding trace to the connector on the back of the board, if possible.

Pat Erley
