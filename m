Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:51297 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZDMX5q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 19:57:46 -0400
Message-ID: <49E3D16E.3070307@gmail.com>
Date: Tue, 14 Apr 2009 03:57:34 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Dave Lister <foceni@gmail.com>
CC: VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] SkyStar HD2 issues, signal sensitivity, etc.
References: <621110570904131518w220106d7u67934966dbb8c7dd@mail.gmail.com>
In-Reply-To: <621110570904131518w220106d7u67934966dbb8c7dd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dave Lister wrote:
> 2009/4/12 VDR User <user.vdr@gmail.com>:
>> On Sat, Apr 11, 2009 at 5:47 AM, Dave Lister <foceni@gmail.com> wrote:
>>> 2009/4/11 VDR User <user.vdr@gmail.com>:
>>>> There is a new mantis tree being uploaded at:
>>>> http://jusst.de/hg/mantis-v4l
>>>>
>>>> Please try this tree.  The upload should finish within 2 hours and is
>>>> using DVB api 5 (aka s2api).
>>> RESULTS (using "s2" dvb-apps):
>>> - scanning DVB-S works
>>> - scanning DVB-S2 doesn't work
>>> - zapping DVB-S is fast
>>>
>> Can you please try a fresh clone of the tree?  I believe the fixes
>> have now been applied.  Thanks!
>>
> 
> Ok, I did and it seems fine. I mean for a Linux DVB-S2 card. :)
> Compared to liplianin driver, only minus is non-working DiSEqC.
> Because I am using a multiswitch,  I had to switch to liplianin. I am
> sorry, but I'm definitely keeping an eye on your driver as well and
> will be testing it as it gets updated!
> 
> For other SkyStar HD2 users, this is a summary as of 2009.04.14:
>   - kernel 2.6.29 + mantis-v4l works (except DiSEqC as far as I can tell)


Diseqc works fine over here, with the VP-1041 and other cards, using
the mantis-v4l tree.


>   - kernel 2.6.29 + s2-liplianin works just as reliably + DiSEqC


The s2-liplianin tree doesn't use an updated tree for the mantis
based devices unfortunately. It is stuck with older changesets of
the mantis tree.

The s2-liplianin tree contains (ed) ? some clock related changes
which were not favourable for the STB0899 demodulator, which is
capable of causing potential hardware damage.


> Common issues:
>   - zapping DVB-S2 channel causes tuner HW lockup (loss of signal until reboot)
>   - zap DVB-S2 channel => AWFUL ultra-high pitched noise emitted from
> the card (capacitors or coils?) - makes your head hurt in about 30mins
>   - very poor TS (picture data) quality; signal = 95%, SNR = 70%,
> STB/TV gives superb picture, but SkyStar/PC picture is corrupted every
> few seconds, sound glitches, etc. (as if the signal was like 40% on
> STB) - confirmed in VDR (Xine), MythTV, mplayer.
> 
> These issues are present with both of my two SkyStar cards, which
> hopefully eliminates faulty HW. To be frank, 

The cards what i have don't have the issues whatsoever you mention.

There could be multiple causes, since the cards that i have don't
have the troubles whatsoever you mention.

* If you had those changes on your hardware and your card was
susceptible to such issues, then that could be a possible reason.

* There are quite some hardware pirates, as noted here ..

In any of your cases, If you have hardware related issues please
contact to your supplier to have it checked/replaced by them.

NOTE: Always try to stick with a tree that's a mainline tree or the
development tree, rather than tree's with unknown changes.

Regards,
Manu

