Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51923 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZBXAFo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 19:05:44 -0500
Subject: Re: PVR x50 corrupts ATSC 115 streams
From: Andy Walls <awalls@radix.net>
To: David Engel <david@istwok.net>
Cc: Steven Toth <stoth@linuxtv.org>, V4L <video4linux-list@redhat.com>,
	CityK <cityk@rogers.com>, linux-media@vger.kernel.org
In-Reply-To: <20090223201054.GA14056@opus.istwok.net>
References: <499AE054.6020608@linuxtv.org>
	 <20090217201740.GA9385@opus.istwok.net> <499B1E19.80302@linuxtv.org>
	 <20090218051945.GA12934@opus.istwok.net> <499C218D.7050406@linuxtv.org>
	 <20090218153422.GC15359@opus.istwok.net>
	 <20090219162820.GA23759@opus.istwok.net> <49A1A8E4.8030307@rogers.com>
	 <20090223183946.GA13608@opus.istwok.net> <49A2F3D0.9080508@linuxtv.org>
	 <20090223201054.GA14056@opus.istwok.net>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 19:05:17 -0500
Message-Id: <1235433917.3097.77.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-02-23 at 14:10 -0600, David Engel wrote:
> On Mon, Feb 23, 2009 at 02:06:56PM -0500, Steven Toth wrote:
> > David Engel wrote:
> >> On Sun, Feb 22, 2009 at 02:35:00PM -0500, CityK wrote:
> >>> David Engel wrote:

> I won't be able to try anything more until tomorrow evening.
> 
> I think you're missing something, though, Steven.  The "In every case"
> was in reference to "without an x50 installed and connected to cable".
> That includes the cases where there are no x50s installed at all.  How
> can the x50 encoder be causing noise when it's not even installed?
> 
> To help clarify things, here is a rephrasing of this weekend's results:
> 
>   115 by itself = excessive BER
>   115 with one or two other 115s = excessive BER
>   115 with HDTV5 = excessive BER
>   115 with Audigy = excessive BER
>   115 with x50 and x50 not connected and x50 not encoding = excessive BER
>   115 with x50 and x50 connected and x50 not encoding = low BER and no corruption
>   115 with x50 and x50 connected and x50 encoding = low BER and minor corruption
>   HDTV5 with anything = 0 BER and no corruption

David,

I cannot reconcile the two lines with HDTV5 as they seem to say "x" and
"not x".

Aside from that, here are my thoughts:

If it's not one thing, then it's two.  :)  It could be that you have
both both an Electro-Magnetic Interference (EMI) problem and a buffer
handling problem.  You need to work the solution to one while you have
mitigated or controlled the effects of the other.


1. You have indications that hooking up the PVR-x50 mitigates EMI or RF
problems, but you don't know why.  So without knowing details about your
signal distribution plant, I'll make some guesses as to what might be
going on:

a. The unsplit signal is overdriving the frontend of the 115.  The
intermodulation products that show up, due to a strong signal hitting
non-linearities in the frontend, act as raised noise floor at other
frequencies.

b. Without a splitter or some other device in the way, you have a
created a ground loop between you and the cable company.  This current
on the ground conductor shows up as EMI/a raised noise floor.  (I doubt
a PVR-x50 on it's own would be mitigating a ground loop.)

c. You have improperly terminated connections or an impedance mistmatch
somewhere causing signal reflections in your cabling plant, that show up
as a raised noise floor.  On analog video you would likely see ghosting.

I could go on guessing, but instead, just make sure you're using good
practices when it comes to RF signal distribution:

http://www.ivtvdriver.org/index.php/Howto:Improve_signal_quality



2.  When multiple devices encoding leads to a corrupt stream, I'll
assert it is the driver of the device delivering the corrupted stream
that is mishandling buffers or DMA completion notifications.  So I
believe the driver for the 115 (saa7134) is probably the culprit here.
Its logic probably works on unloaded systems, but on busy systems it's
doing the wrong thing.  Your test with the HDTV5 and PVR-x50's support
this assertion.  It's not the ivtv driver, nor the cx88 driver that
misbahves in a busy system; it's the saa7134 driver that doesn't do
something right on busy system.

Does running 3 115 captures (with a PVRx50 installed and idle) cause
corruption as well?  I'm betting it does.


Regards,
Andy


> David

