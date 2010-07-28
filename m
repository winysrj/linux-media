Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56836 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab0G1GaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 02:30:14 -0400
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	linux-input <linux-input@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
References: <1280269990.21278.15.camel@maxim-laptop>
	 <1280273550.32216.4.camel@maxim-laptop>
	 <AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
	 <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 09:30:06 +0300
Message-ID: <1280298606.6736.15.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-07-27 at 22:33 -0400, Jarod Wilson wrote: 
> On Tue, Jul 27, 2010 at 9:29 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> > On Tue, Jul 27, 2010 at 7:32 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> On Wed, 2010-07-28 at 01:33 +0300, Maxim Levitsky wrote:
> >>> Hi,
> >>>
> >>> I ported my ene driver to in-kernel decoding.
> >>> It isn't yet ready to be released, but in few days it will be.
> >>>
> >>> Now, knowing about wonders of in-kernel decoding, I try to use it, but
> >>> it just doesn't work.
> >>>
> >>> Mind you that lircd works with this remote.
> >>> (I attach my lircd.conf)
> >>>
> >>> Here is the output of mode2 for a single keypress:
> >
> >    8850     4350      525     1575      525     1575
> >     525      450      525      450      525      450
> >     525      450      525     1575      525      450
> >     525     1575      525      450      525     1575
> >     525      450      525      450      525     1575
> >     525      450      525      450      525    23625
> >
> > That decodes as:
> > 1100 0010 1010 0100
> >
> > In the NEC protocol the second word is supposed to be the inverse of
> > the first word and it isn't. The timing is too short for NEC protocol
> > too.
No its not, its just extended NEC.

This lirc generic config matches that output quite well:
NEC-short-pulse.conf:

begin remote

  name  NEC
  bits           16
  flags SPACE_ENC|CONST_LENGTH
  eps            30
  aeps          100

  header        9000 4500
  one           563  1687
  zero          563   562
  ptrail        563
  pre_data_bits 16
# just a guess
  gap          108000

  repeat        9000 2250

  frequency    38000
  duty_cycle   33

      begin codes
      end codes

end remote



> >
> > Valid NEC...
> > 1100 0011 1010 0101
> >
> > Maybe JVC protocol but it is longer than normal.
> >
> > The JVC decoder was unable to get started decoding it.  I don't think
> > the JVC decoder has been tested much. Take a look at it and see why it
> > couldn't get out of state 0.
> 
> Personally, I haven't really tried much of anything but RC-6(A) and
> RC-5 while working on mceusb, so they're the only ones I can really
> vouch for myself at the moment. It seems that I don't have many
> remotes that aren't an RC-x variant, outside of universals, which I
> have yet to get around to programming for various other modes to test
> any of the protocol decoders. I assume that David Hardeman already did
> that much before submitting each of the ir protocol decoders with his
> name one them (which were, if I'm not mistaken, based at least
> partially on Jon's earlier work), but its entirely possible there are
> slight variants of each that aren't handled properly just yet. That
> right there is one of the major reasons I saw for writing the lirc
> bridge driver plugin in the first place -- the lirc userspace decoder
> has been around for a LOT longer, and thus is likely to know how to
> handle more widely varying IR signals.

In fact its dead easy to test a lot of remotes, by using an universal
remote. These remotes are designed to tech literate persons for a
reason....

On my remote, all I have to do is press TV + predefined number + OK to
make remote mimic a random remote.
Unill now, kernel decoding couldn't pick anything but one mode....


Here is a table I created long ago on my remote showing all kinds of
protocols there:

Heck, hardware isn't very accurate, I know, but streamzap receiver
according to what I have heard it even worse...

Best regards,
Maxim Levitsky


08 - NEC short pulse / SANYO (38 khz), [15 - NEC]
     9440     4640      620      550      620      550      620      550      620      550      620      550
      620      550      620     1720      610      550      610     1720      620     1720      620     1720
      620     1720      610     1730      610     1720      620      550      620     1720      620      550
      620      550      620      550      620      550      620      550      620      550      610      550
      610      550      610     1720      620     1720      620     1720      620     1720      620     1720
      610     1720      620     1720      620     1720      620    41540     9440     2300      620   100110
    (9440     2300      610   100110)
---------------------------------------------------------------------------------------------------------------
02 - Philips (RC5): (36 khz)
      990      890      970      890     1920      890      970      890      970      890      970      890
      970      890      970      890      970      890      970      890      970      890      970      890
      970    94190
---------------------------------------------------------------------------------------------------------------
25 - Philips (RECS-80): (38 khz)
      200     7720      170     7720      170     7700      200     7690      200     7720      170     5090
      160     7730      170     5090      170     5090      160     5090      170     5090      170
---------------------------------------------------------------------------------------------------------------
01 - JVC: (38 khz)
     8840     4370      590     1600      590     1600      590      500      590      500      590      500
      590      500      590      510      590      510      590      500      590      500      590      500
      590     1600      590      500      590     1600      590      500      590      500      590    25730
---------------------------------------------------------------------------------------------------------------
07 - Sony (SIRC): (40 khz)
     2550      600     1260      600      630      600      630      600     1260      600      630      600
      630      600      630      600     1260      600      630      600      630      600      630      600
      630    27450    <rep>
---------------------------------------------------------------------------------------------------------------
19 - MOTOROLLA:
      610     2730      550      550      580      520      580      520      580      490      600      520
      580      520      580      520      580      520      580      520      580    21240

     (600     2720      580     1070      580      520      580      520      580      520     1130     1070
      580      490      580      540      550      540      580   126890)
---------------------------------------------------------------------------------------------------------------
06 - Sharp (denon): (38 khz)
      370     1870      340      750      340      760      340      750      340      750      340      750
      340     1870      340      750      340     1870      340      760      340      760      340      760
      340      760      340     1870      340      750      340    48940

      370     1870      340      750      340      760      340      760      340      750      340     1870
      340      750      340     1870      340      760      340     1870      340     1870      340     1870
      340     1870      340      760      340     1870      340    44610
---------------------------------------------------------------------------------------------------------------
30 - Nokia NRC17:
      580     2590      550      990     1100      490      550      480      550      480      550      480
      550      480      550      490      550      480      550      480      550      490      550      480
      550      490      550      480      550      480      550      480      550    20230

      580     2580      560      990      550      490     1100      480      550      990      550      480
      550      490      550      480      550      480     1100      990     1100      490      550      990
     1100      990      550    84380

      580     2580      550      990      550      490     1100      480      550      990      550      490
      550      480      550      480      550      480     1100      990     1100      480      550      990
     1100      990      550    84380
---------------------------------------------------------------------------------------------------------------
03 - Mitsubishi:
      350     2220      320     2220      320     2220      320      950      320      950      340      920
      320     2220      320      950      320     2220      320      950      350      920      320     2220
      320      950      320      950      320      950      320      950      320    27630      <rep>
---------------------------------------------------------------------------------------------------------------
04 - Panasonic:
     3600     3460      950      820      960      820      950      820      950      820      950      820
      960     2570      960      820      950      820      950     2580      950     2580      950      820
      950     2580      950     2580      950     2580      950     2580      950     2580      950      820
      950     2580      950     2580      960      820      960      820      950     2570      960    39070
      <rep>
---------------------------------------------------------------------------------------------------------------
11 - Panasonic:
     3700     1780      490      410      500     1320      490      410      490      410      490      410
      500      410      490      410      490      410      500      410      490      410      490      410
      490      410      490      410      490     1320      490      410      500      410      490      410
      490      410      490      410      500      410      490      410      490      410      500      410
      490     1320      490      410      490      410      500      410      490      410      490      410
      490      410      490      410      490      410      490     1320      500      410      490      410
      490     1320      500     1310      500      410      490      410      490      410      490     1320
      490      410      490      410      490     1320      490     1320      490      410      490      410
      490     1320      500    <rep>
---------------------------------------------------------------------------------------------------------------
05 - unknown:
    20950     4110      620     1990      590     2020      580     2020      580     2020      590      980
      580      980      580     2020      590     2020      580      980      580      980      590      980
      590      980      580      980      580      980      580      980      580      980      580     2020
      580     2020      590      980      580      980      580     2020      590     2020      580     2020
      580     2020     1070
---------------------------------------------------------------------------------------------------------------
09 - unknown:
      590      480      560     4230      560      480      560     4230      560     5260      560     5260
      560      480      560     4230      560     5260      560      480      560     4220      560     5260
      560      480      560     4220      560     5260      560      480      560   126450    <rep>
---------------------------------------------------------------------------------------------------------------
12 - RCA?
     4740     4650      620     1720      620     1720      620     1720      620      550      610      550
      610      550      610      550      620      550      620     1720      620     1720      620     1720
      620      550      620      550      620      550      620      550      620      550      620     1720
      620      550      620      550      610      550      610     1730      610      550      610      550
      610      550      620      550      620     1720      620     1720      620     1720      620      550
      620     1720      620     1720      620     1720      620
---------------------------------------------------------------------------------------------------------------
26 - junk -(thomson) - unsuppored/no carrier
27 - junk -(unknown) - unsuppored/no carrier
28 - junk -ITT  - unsuppored/no carrier





> 


