Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:50170 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZDYQI0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2009 12:08:26 -0400
Received: by ewy24 with SMTP id 24so1466983ewy.37
        for <linux-media@vger.kernel.org>; Sat, 25 Apr 2009 09:08:24 -0700 (PDT)
Date: Sat, 25 Apr 2009 18:08:18 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
cc: DVB mailin' list thingy <linux-dvb@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] RFC - Flexcop Streaming watchdog (VDSB)
In-Reply-To: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
Message-ID: <alpine.DEB.2.00.0903312017420.10133@ybpnyubfg.ybpnyqbznva>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for digging out an old message.  But...  (I also started
to write this a couple weeks back, then set it aside to do
more observation, so dates referenced may be inaccurate)


I've been intending for some time to gradually migrate my
production machine from its 2005-era solid-like-rock kernel,
to something more recent which has proved reasonably stable,
to make better use of new hardware.

This production server has one Flexcop PCI SkyStar card, and
three USB devices, with too many hacks to get things working.
The SkyStar card has been my primary card, and out of hundreds
of uses, only about two times has it failed to tune, with the
2.6.14-to-15-era kernel.

The kernel I've updated to is a 2.6.27-rc4, with patches for
things which have broken for me in a several month test period
to see if this kernel crashes on a test box.  In the meantime,
I tried an older 2.6.26-era kernel, as well as newer ones, to
the git-snapshot of the day at the time.

Unfortunately, my testing on the new kernel today on the
production server showed none of the stability I expected of
the older kernel.  I still need to do more work and verify
my observations, but my disappointment with the SkyStar on
the more recent kernel reminded me of this message, which I
had to dig out...



On Fri, 16 Jan 2009, Patrick Boettcher wrote:

> Hi lists,
> 
> For years there has been the Video Data Stream Borken-error with VDR and
> Technisat cards: The error occured randomly and unfrequently. A work-around
> for that problem was to restart VDR and let the driver reset the pid-filtering
> and streaming interface.
> 
> In fact it turned out, that the problem is worse with setups not based on VDR
> and the "VDSB-error" could be really easily reproduced (I'm not sure if this
> applies to all generations on SkyStar2-card). I'm skipping the description of
> the problem here...

Unfortunately, this (and later messages in this thread) is not
related to what I'm now seeing, oh well...


Anyway, to describe what I observed a couple weeks ago, when
swapping out a USB stick with the old 2.6.14-ish OS/kernel for
a reasonably fresh OS/kernel, without changing anything else
with the hardware:

The problem I'm experiencing is apparently DiSEqC-related, as
I'm switching between four positions.  Position 1 is Astra 19E2,
and I've noticed the problem too often with position 3, Astra 28E.

Also, while I had no new problems with position 1/4, at least
half of my attempts to use position 3/4 simply failed to tune,
so I had to stop using this card for that position.  (Positions
2/4 and 4/4 see infrequent use, exclusively with a different
device as it's only radio there of interest)


Another thing to notice is that according to `dmesg' the card
was identified incorrectly, although that did not stop it from
working:


[   14.802703] b2c2-flexcop:B2C2 FlexcopII/II(b)/III digital TV 
receiver chip loaded successfully
[   15.352877] flexcop-pci: will use the HW PID filter.
[   15.353082] flexcop-pci: card revision 2
[   15.392836] DVB: registering new adapter (FlexCop Digital TV device)
[   15.400031] b2c2-flexcop: MAC address = 00:d0:d7:0c:75:7a
[   18.683487] b2c2-flexcop: found 'ST STV0299 DVB-S' .
[   18.683787] DVB: registering adapter 1 frontend 0 (ST STV0299 DVB-S)...
[   18.685308] b2c2-flexcop: initialization of 'Air2PC/AirStar 2 
ATSC 3rd generation (HD5000)' at the 'PCI' bus controlled by a 
'FlexCopIIb' complete

I have no ATSC card!  Lawdy, have mercy!

Anyway, this appears to have been IRQ or similarly-related, as
when I swapped in a different PCI-USB adapter which didn't work
so I had to exchange its position with a sound card to get the
IRQs recognized, then things started working:

[   14.250005] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV 
receiver chip loaded successfully
[   15.469994] flexcop-pci: will use the HW PID filter.
[   15.469994] flexcop-pci: card revision 2
[   15.509998] DVB: registering new adapter (FlexCop Digital TV 
device)
[   15.519996] b2c2-flexcop: MAC address = 00:d0:d7:0c:75:7a
[   15.519996] b2c2-flexcop: i2c master_xfer failed
[   15.519996] b2c2-flexcop: i2c master_xfer failed
[   15.519996] CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
[   15.519996] CX24123: wrong demod revision: 87
** [   15.519996] b2c2-flexcop: now doing stv0299_attach...
** [   18.710000] b2c2-flexcop: stv0299_attach succeeded...
[   18.710000] b2c2-flexcop: found 'ST STV0299 DVB-S' .
[   18.710000] DVB: registering frontend 1 (ST STV0299 DVB-S)...
[   18.710000] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 
DVB-S' at the 'PCI' bus controlled by a 'FlexCopIIb' complete

** debuggery I added expecting it to fail


Now, while it's properly identified, it still fails to tune
reliably to position 3/4.  The following was noted when it was
identified wrong, in the same hardware configuration which worked
fine with 2.6.14-ish


Apparently with the newer kernel, the SkyStar isn't sending a
reliable DiSEqC signal all the time for position 3, and often it
slips back to receiving from position 1.

The main BBC TV services at 28E are on the same frequency as a
19E2 transponder with polish (I believe) services.  Several
attempts to get a stream from BBC One and Two (plus PMT and
related data) resulted in PID 0 from 19E with the list of
services and PIDs.

The BBC radio services are on the same frequency as ZDF, so
that often when tuning the radio, I'd get a lock, but no audio
data (the PIDs aren't shared).

A channel scan on position 3/4 showed the problem when `diff'ed 
against an older scan -- the card also is known to have problems 
at the low and high frequency extremes in my present setup, and 
sometime will be replaced...


   Scanning 10714250    h       22000
-Channel 4:10714:h:3:22000:2315:2319:9211
[...]

   Scanning 10729000    v       22000
-E4+1:10729:v:3:22000:2364:2365:8300
[...]
Did not manage to lock these two frequencies.  These are both
analogue services at 19E in case it failed to tune position 3.
Strangely, while I've had some difficulty with reliable
reception of More4 at a higher frequency, I was able to tune
directly to Channel 4 and get a minute worth of flawless stream.

   Scanning 10906000    v       22000
-ITV Channel Is:10906:v:3:22000:3328:3329:10200
Again, utterly failed to lock this transponder/position, though
it's within my problem-free range.

   Scanning 11565380 V 27500
-### SCRAMBLED!!!  #KOOPID ABB:11565:v:3:27500:0:0:8006
   Scanning 11584620 H 27500
-### SCRAMBLED!!!  #Racing UK:11584:h:3:27500:2315:2316:50600
Failed to lock these two, as well as
   Scanning 11875500    h       27500
-6200:11875:h:3:27500:0:0:6200

   Scanning 11895000    v       27500
-### SCRAMBLED!!!  #MTV ONE:11895:v:3:27500:2323:2306:7001
[...]
+### SCRAMBLED!!!  #CINECINEMA CLUB:11895:v:3:27500:166:104:8351
+### SCRAMBLED!!!  #MCM:11895:v:3:27500:161:84:8352
+### SCRAMBLED!!!  #MCM POP:11895:v:3:27500:164:96:8354
+### SCRAMBLED!!!  #TELE MAISON:11895:v:3:27500:169:116:8355
+### SCRAMBLED!!!  #VIRGIN 17:11895:v:3:27500:168:112:8358

Now this is messed up.  Instead of tuning position 3, it's
receiving the french services from 19E, position 1.

   Scanning 11953500    h       27500
-BBC NEWS:11953:h:3:27500:5000:5001:6704
Here it failed to lock this, but at the same time, it did
not lock the ZDF transponder, so I'm not sure which output
was active.

Skipping some other transponders that got no results, another
example of german Premiere appearing instead of BSkyB...

-### SCRAMBLED!!!  #Smash Hits!:12070:h:3:27500:512:660:50000
-### SCRAMBLED!!!  #FOX News:12070:h:3:27500:518:666:50007
-### SCRAMBLED!!!  #DCS24:12070:h:3:27500:0:0:50190
+### SCRAMBLED!!!  #PREMIERE START:12070:h:3:27500:3071:3072:8
+### SCRAMBLED!!!  #HEIMATKANAL:12070:h:3:27500:1279:1280:22
+### SCRAMBLED!!!  #RTL CRIME:12070:h:3:27500:1791:1792:27
also,
-### SCRAMBLED!!!  #Games Slot 1:12285:v:3:27500:0:3022:8192
+### SCRAMBLED!!!  #AB MOTEURS:12285:v:3:27500:160:80:17020
and
-### SCRAMBLED!!!  #ITV1 Central SW:12402:v:3:27500:3348:3349:12140
-ITVi Quad:12402:v:3:27500:3352:3353:12150
-12198:12402:v:3:27500:0:0:12198
-12199:12402:v:3:27500:3348:3349:12199
+### SCRAMBLED!!!  #EQUIDIA INFO:12402:v:3:27500:160:80:8701
+### SCRAMBLED!!!  #COMEDIE !:12402:v:3:27500:161:84:8702
+### SCRAMBLED!!!  #13EME RUE:12402:v:3:27500:162:88:8703
and
-Brit Hits:12480:v:3:27500:2340:2341:12080
-Brit Asia TV:12480:v:3:27500:2342:2343:12081
-Asian Star:12480:v:3:27500:0:2344:12082
+Sonnenklar TV:12480:v:3:27500:2303:2304:32
+HSE24:12480:v:3:27500:1279:1280:40


This actually seems a bit similar to what others were seeing
with other hardware I have, though in limited testing, the
same other cards are working mostly as expected for me.


Now, that above scan was a few weeks old.  I performed another
scan at position 3/4 with the kernel/hardware where the card
was properly identified.  In this case, a handful of position
3/4 transponders failed to tune, again.  However, in no cases
were services received from position 1/4 during this scan


What I still haven't done, but I could do:

* scan with the frequency lists of the four positions, but on
  a different DiSEqC input, to see if the wrong switch position
  is activated and what pattern there may be (all fail to pos.
  1/4, or failures to a random input?)
* swap the PCI slot of this card as well, and play musical
  chairs until all PCI cards are found and work
* pull my hair out and wail and moan and gnash teeth
* bisect my way back to where the SkyStar stopped tuning the
  other positions reliably
* drink beer until I forget my woe and misery and blast my brane
  with dubstep until I lose the capability of emotions
* give up on this card/server and put it in a different machine
  and see if the noted problems persist

The last option is most likely, as it's my long-term goal.  The
200MHz machine is struggling with more than one full Transport
Stream on the USB inputs, and sadly can't take as many PCI
cards as I'd like.  Also, the combination of newer kernel and
OS is taking around 10MB more of the 64MB max memory, so it's
no longer as lightweight to run swapless.


The above observations are so far, just observations, and I
don't expect anyone to be able to `fix' anything

The other DVB devices have no problems tuning reliably to the
different DiSEqC inputs with the recent kernels.  Pity that
I've identified about half a dozen things that have been
broken that I need to fix before I can consider it a plug-in
replacement for the 2005-era server.

hey, thanks for listening
barry bouwsma
