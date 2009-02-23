Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:57278 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZBWULB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 15:11:01 -0500
Date: Mon, 23 Feb 2009 14:10:54 -0600
From: David Engel <david@istwok.net>
To: Steven Toth <stoth@linuxtv.org>
Cc: CityK <cityk@rogers.com>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090223201054.GA14056@opus.istwok.net>
References: <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net> <499B1E19.80302@linuxtv.org> <20090218051945.GA12934@opus.istwok.net> <499C218D.7050406@linuxtv.org> <20090218153422.GC15359@opus.istwok.net> <20090219162820.GA23759@opus.istwok.net> <49A1A8E4.8030307@rogers.com> <20090223183946.GA13608@opus.istwok.net> <49A2F3D0.9080508@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A2F3D0.9080508@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 23, 2009 at 02:06:56PM -0500, Steven Toth wrote:
> David Engel wrote:
>> On Sun, Feb 22, 2009 at 02:35:00PM -0500, CityK wrote:
>>> David Engel wrote:
>>>> I'll start with what worked.
>>>>
>>>> ... [test results of BER and UNC under varying configurations ] ...
>>>>   
>>> Steven Toth wrote:
>>>> I think CityK confirmed that the nxt2004 driver statistics are
>>>> probably bogus so I doubt you're going to get your 115's running with
>>>> BER 0 regardless, which is unfortunate. 
>>> FWIW:
>>>
>>> I'm not seeing any UNC, just the BER (which seems consistent to most,
>>> but not all, of David's results with varying configurations).
>>>
>>> Presently (and a situation that is unlikely to change), I don't have an
>>> older kernel built/installed with which I can test/confirm, but from
>>> memory, IIRC, I believe that it must have been from around ~2.6.22 that
>>> I recall error free femon output.
>>
>> I've used 2.6.27.17 in most my testing, either with stock drivers or
>> with drivers from Mercurial.  I tried 2.6.26, .25 and .24 on Saturday,
>> but it made no difference.  After seeing this message, I tried 2.6.22
>> and .21 yesterday (Sunday).  Again, it made no difference.  I think
>> the ATSC 115s are just going to always report at least some level of
>> BER.
>>
>> Anyway, here are the other results of more testing over the weekend.
>>
>> I tried an ATSC 115 with a PVR 250 in my desktop system.  Like with my
>> MythTV backend, the 115 digital recordings were slightly corrupted
>> when the x50 was active.  The corruption appeared to be a little less
>> frequent, though.  Instead of some corruption occuring every couple of
>> seconds, it was more like every 4 or 5 seconds.
>>
>> Both my desktop and current MythTV backend are AMD systems with Nvidia
>> chipsets.  My old backend, which didn't exhibit the corruption
>> problem, was a P4 system with an Intel chipset.
>>
>> I can't get any 115 to work in my current backend without an x50
>> installed and connected to cable.  I tried a single 115 is every slot.
>> I tried older kernels.  I tried multiple 115s in combinations.  I
>> tried a 115 with an Audigy sound card I had.  In every case, the 115
>> reports excessive BER and UNC and capture of any digital stream is
>> almost impossible.  The 115s will behave this way until I install at
>> least one x50 card and connect it the cable.
>>
>> I even tried the same 115 I had used not more than a month ago with
>> the same motherboard and graphics card as my desktop.  Only the case,
>> power suuply and disks are now different.  Could there be some kind of
>> short on the motherboard or case that could case this behavior?
>>
>> I remembered I had a DVICO FusionHDTV5 lying around.  I don't use that
>> card much because, in my past experience, the cx88 driver doesn't play
>> as well with the ivtv driver as the saa7134 driver.  See below for an
>> example (*).
>>
>> The HDTV5 does report 0 for bER:
>>
>> status SCVYL | signal fd43 | snr 22a0 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fcde | snr 2292 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fd87 | snr 22b7 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fd65 | snr 22a4 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fd65 | snr 22a4 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fd43 | snr 2292 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fda9 | snr 22c5 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe34 | snr 22c1 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fe11 | snr 22bc | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status SCVYL | signal fda9 | snr 22a0 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>
>> In addition, the HDTV5 does not have any corruption when the x50s are
>> active.  I ran one test with the HDTV5, one 115 and two x50s.  The
>> HDTV5 didn't show corruption while the 115 did.  To be sure it wasn't
>> the content, I stopped the digital recordings and restarted them so
>> the cards would be swapped.  The corruption stayed with the 115.
>>
>> To summarize, I have two problems.
>>
>> First, the 115s show corruption when an x50 is active.  This occurs on
>> two differnt systems with Nvidia chipsets, but did not occur in a
>> system with an Intel chipset.  An HDTV in the same system does not
>> show the corruption problem.
>>
>> Second, the 115s apparently can't receive a clean signal unless theer
>> is a x50 installed and connected.
>>
>> (*) About half the time I boot with the HDTV5 and x50 cards, the x50
>> tuners don't work.  The x50s will only record static until I manually
>> unload and reload the tuner modules.
>
> "In every case, the 115
> reports excessive BER and UNC and capture of any digital stream is
> almost impossible."
>
> If this this is true then it's an RF noise issue, not a DMA issue. The 
> encoders are generating noise that's finding it's way into your DVB 
> frontends.
>
> Try running the DVB + 250 side by side but disconnect the antenna input 
> to the 250 once it's running. (Ie noise is boing couple into the antenna 
> cable)
>
> Do you still see high BER and high UNC?

I won't be able to try anything more until tomorrow evening.

I think you're missing something, though, Steven.  The "In every case"
was in reference to "without an x50 installed and connected to cable".
That includes the cases where there are no x50s installed at all.  How
can the x50 encoder be causing noise when it's not even installed?

To help clarify things, here is a rephrasing of this weekend's results:

  115 by itself = excessive BER
  115 with one or two other 115s = excessive BER
  115 with HDTV5 = excessive BER
  115 with Audigy = excessive BER
  115 with x50 and x50 not connected and x50 not encoding = excessive BER
  115 with x50 and x50 connected and x50 not encoding = low BER and no corruption
  115 with x50 and x50 connected and x50 encoding = low BER and minor corruption
  HDTV5 with anything = 0 BER and no corruption

David
-- 
David Engel
david@istwok.net
