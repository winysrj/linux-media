Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:6679 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZDMWSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 18:18:49 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2385710yxl.1
        for <linux-media@vger.kernel.org>; Mon, 13 Apr 2009 15:18:47 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Apr 2009 00:18:47 +0200
Message-ID: <621110570904131518w220106d7u67934966dbb8c7dd@mail.gmail.com>
Subject: Re: [linux-dvb] SkyStar HD2 issues, signal sensitivity, etc.
From: Dave Lister <foceni@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/4/12 VDR User <user.vdr@gmail.com>:
> On Sat, Apr 11, 2009 at 5:47 AM, Dave Lister <foceni@gmail.com> wrote:
>> 2009/4/11 VDR User <user.vdr@gmail.com>:
>>> There is a new mantis tree being uploaded at:
>>> http://jusst.de/hg/mantis-v4l
>>>
>>> Please try this tree.  The upload should finish within 2 hours and is
>>> using DVB api 5 (aka s2api).
>>
>> RESULTS (using "s2" dvb-apps):
>> - scanning DVB-S works
>> - scanning DVB-S2 doesn't work
>> - zapping DVB-S is fast
>>
>
> Can you please try a fresh clone of the tree?  I believe the fixes
> have now been applied.  Thanks!
>

Ok, I did and it seems fine. I mean for a Linux DVB-S2 card. :)
Compared to liplianin driver, only minus is non-working DiSEqC.
Because I am using a multiswitch,  I had to switch to liplianin. I am
sorry, but I'm definitely keeping an eye on your driver as well and
will be testing it as it gets updated!

For other SkyStar HD2 users, this is a summary as of 2009.04.14:
  - kernel 2.6.29 + mantis-v4l works (except DiSEqC as far as I can tell)
  - kernel 2.6.29 + s2-liplianin works just as reliably + DiSEqC

Common issues:
  - zapping DVB-S2 channel causes tuner HW lockup (loss of signal until reboot)
  - zap DVB-S2 channel => AWFUL ultra-high pitched noise emitted from
the card (capacitors or coils?) - makes your head hurt in about 30mins
  - very poor TS (picture data) quality; signal = 95%, SNR = 70%,
STB/TV gives superb picture, but SkyStar/PC picture is corrupted every
few seconds, sound glitches, etc. (as if the signal was like 40% on
STB) - confirmed in VDR (Xine), MythTV, mplayer.

These issues are present with both of my two SkyStar cards, which
hopefully eliminates faulty HW. To be frank, I am appalled by the
overall quality of PC DVB tuner cards (if HD2 is a representative
sample). My last analog Hauppauge PVR-500 (dual tuner card) was better
in every aspect. Digital age indeed!

I was going to buy new DVB components for my MythTV HTPC, but after
these experiences I don't think it is realistic. I'm gonna ask around
for other HW recommendations and continue to search for SkyStar tuning
tips (I'm stuck with these cards), but I'm losing hope. My old STB
with two smarcard readers costs half the price of one SkyStar HD2 and
is apparently technically superior. I don't get it. Anyway, sorry for
my rambling, just wanted to leave a note for other people who, like
me, search mailing lists before buying HW for Linux.

I'd like to ask other SkyStar HD2 users if they have similar
experiences, especially about the low signal sensitivity. Please, let
me know!!


Best regards,

-- 
David Lister
