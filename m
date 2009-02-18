Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:35281 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZBRFTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 00:19:55 -0500
Date: Tue, 17 Feb 2009 23:19:45 -0600
From: David Engel <david@istwok.net>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090218051945.GA12934@opus.istwok.net>
References: <20090217155335.GB6196@opus.istwok.net> <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net> <499B1E19.80302@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499B1E19.80302@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 17, 2009 at 03:29:13PM -0500, Steven Toth wrote:
> David Engel wrote:
>> On Tue, Feb 17, 2009 at 11:05:40AM -0500, Steven Toth wrote:
>>>> Does anyone know what might be going on?  These very same tuner cards
>>>> worked fine in the old system (Intel P4 3.0GHz CPU and Abit IC7
>>>> motherboard) for close to two years.
>>> Determine whether this is an RF issue, or a DMA corruption issue:
>>
>> Ahh, I didn't even think of RF.  I didn't have any RF problems in the
>> old system (that I know of) so that didn't even cross my mind.  I
>> actually was, and still am, more afraid of DMA issues, though.
>>
>>> 1. Check the RF SNR of the digital cards using femon, anything odd 
>>> going on when the PVR250 is running? Does it fall out of lock or SNR 
>>> dip dangerously low, bursts of BER's?
>>
>> Here are some 10 second captures from femon.  Card1 and Card2 are ATSC
>> 115s.  Card4 and Card5 are PVR x50s.
>>
>> Card1 recording by itself:
>>
>> status SCVYL | signal fe90 | snr e4dc | ber 000000b8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e682 | ber 00000038 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe60 | snr e682 | ber 00000078 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe80 | snr e624 | ber 000000a0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e682 | ber 000000d8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe70 | snr e598 | ber 00000140 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe90 | snr e654 | ber 00000078 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e6b2 | ber 00000090 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe70 | snr e654 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe60 | snr e654 | ber 000000d8 | unc 00000000 | FE_HAS_LOCK
>>
>> Card1 and Card4 recording:
>>
>> status SCVYL | signal fe80 | snr e5c6 | ber 000000b8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe90 | snr e682 | ber 00000100 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e53a | ber 000000c8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e568 | ber 00000130 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e624 | ber 000000b8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe80 | snr e654 | ber 000000c0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe20 | snr e6b2 | ber 000000c0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e682 | ber 00000028 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe60 | snr e654 | ber 000000d8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe90 | snr e624 | ber 000000c8 | unc 00000000 | FE_HAS_LOCK
>>
>> Card1 and Card5 recording:
>>
>> status SCVYL | signal fe40 | snr e624 | ber 00000120 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe80 | snr e654 | ber 000000d0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e598 | ber 00000238 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe90 | snr e682 | ber 000000c8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal feb0 | snr e654 | ber 00000068 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe90 | snr e654 | ber 00000118 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal feb0 | snr e6e0 | ber 00000038 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe50 | snr e4dc | ber 00000060 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe50 | snr e44e | ber 00000058 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fea0 | snr e5c6 | ber 000000d0 | unc 00000000 | FE_HAS_LOCK
>>
>> Card2 recording by itself:
>>
>> status SCVYL | signal fe20 | snr e53a | ber 00000130 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe20 | snr e53a | ber 000000b0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe30 | snr e3c0 | ber 00000128 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe20 | snr e3c0 | ber 000000a8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe40 | snr e568 | ber 00000060 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe00 | snr e4dc | ber 00000058 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe10 | snr e53a | ber 00000098 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fde0 | snr e4dc | ber 00000118 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe10 | snr e568 | ber 00000168 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fdf0 | snr e53a | ber 000001a0 | unc 00000000 | FE_HAS_LOCK
>>
>> Card2 and Card4 recording:
>>
>> status SCVYL | signal fe40 | snr e4ac | ber 000000d8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe50 | snr e624 | ber 000001b8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe70 | snr e598 | ber 000000a8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe40 | snr e5c6 | ber 000000b0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe40 | snr e53a | ber 000000d8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe50 | snr e50a | ber 00000098 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe10 | snr e50a | ber 000000a0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe10 | snr e598 | ber 000000b0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe30 | snr e5f6 | ber 000000c0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe60 | snr e568 | ber 00000180 | unc 00000000 | FE_HAS_LOCK
>>
>> Card2 and Card5 recording
>>
>> status SCVYL | signal fe70 | snr e4ac | ber 000000b8 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe50 | snr e598 | ber 00000190 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe40 | snr e598 | ber 00000118 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe80 | snr e5c6 | ber 00000008 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe50 | snr e568 | ber 000000c0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe70 | snr e5c6 | ber 00000178 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe40 | snr e53a | ber 00000120 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe70 | snr e50a | ber 00000168 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe60 | snr e598 | ber 000000b0 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe40 | snr e5c6 | ber 000000f8 | unc 00000000 | FE_HAS_LOCK
>>
>> I don't see anything significant there.
>
> The BER looks buggy in this driver, assuming these readings are false.
>
> Me neither, other than the dvb cards are reporting bit-errors. This feels 
> like a driver bug not a generic card problem. If these ber's area real 
> then this will account for your video issues, but that would be unrelated 
> to the PVR250.
>
> It'd personally remove the PVR250's and get your DVB statistics to report 
> 0 for BER before continuing.
>
>>
>>> 2. Move the two cards as far apart as possible in the slots in the 
>>> system and repeat the test above, any better?
>>>
>>> What happens?
>>
>> This will require rmoving cards.  The old system had 5 PCI slots and I
>> had a small ethernet NIC between the pair of 115s and x50s.  The new
>> system only has 4 PCI slots so both pairs are in adjacent slots.  I'll
>> try pulling the x50s one at a time this evening when I get home.
>
> Fold some thick cardboard and place it in between the PVR and the DVB 
> boards, this will block some RF which may be coming from the encoder 
> directly into your demod.
>
> Does this help?

Here's the configuration I started with:

slot 1: ATSC 115
slot 2: ATSC 115
slot 3: PVR 250
slot 4: PVR 350
slot 5: empty PCIe
slot 6: empty PCIe
slot 7: GF6200 PCIe

I reconfirmed the previous results - clean QAM recordings when no x50
in use and some corruption when either x50 in use.

I wedged a 33-page, 5x7 inch, motherboard manual between the 115 in
slot 2 and the 250 in slot 3.  There was no change.

I then removed the 250 from slot 3 leaving the 350 in slot 4.  There
was no change.

I then replaced the 350 in slot 4 with the 250.  There was no change.

During all of the above testing, the femon output was comparable to
waht I sent earlier.  BTW, I wonder if the ber counts are the result
of the massive signal spltting I am doing.  I have a powered,
aplifying, 4-way splitter in the mix.  Two of the outputs from the
4-way splitter are split again in two to feed the pairs of 115s and
x50s.  Also, a possible explanation for the unc always being 0 is the
clear QAM streams I am recording are all retransmissions of OTA
streams so I believe there is a lot of redundancy and error correction
information included in them.

Anyway, here is where things got weird until I eventually figured out
why.

I then removed the 250 from slot 4 leaving the 115s in slots 1 and 2.
The ber was through the roof and the recorded strams were filled with
errors and were barely playable at best.

I then removed the 115 from slot 2 leaving just one 115 in slot 1.
Same severe errors as above.  I moved the remaining 115 to the other
slots.  Same severe errors.

I put the x50s back, this time in slots 1 and 2 with the 115s in slots
3 and 4.  The results were back to what I had been getting -- clean
when no x50 in use and some corruption when either x50 in use.

I then put things back how I started, screwed everything back in and
closed the case.  

It then dawned on my why the 115-only results were so bad.  I had left
the 4-way splitter output used for the x50s unterminated.  Sure
enough, if I disconnected the x50s, I reproduced the severe errors.  I
didn't tear everything back apart to verify it, but I believe the 115s
would work fine by themselves if I terminated the cables properly.

So what does all of this indicate?  My original hunch was that it's a
problem with the x50 hardware or driver (at least in combination with
my motherboard).  I think I'm back to that conclusion.

BTW, in my testing last night, I tried changing the PCI latency timer
on the x50 cards.  I thought maybe it was holding off access to the
115 cards.  Changing that had no effect.

David
-- 
David Engel
david@istwok.net
