Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:52359 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZDTUqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 16:46:24 -0400
Received: by bwz7 with SMTP id 7so1432577bwz.37
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 13:46:22 -0700 (PDT)
Message-ID: <49ECDF10.7000701@gmail.com>
Date: Mon, 20 Apr 2009 22:46:08 +0200
From: David Lister <foceni@gmail.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] SkyStar HD2 issues, signal sensitivity, etc.
References: <621110570904131518w220106d7u67934966dbb8c7dd@mail.gmail.com> <49E3D16E.3070307@gmail.com> <49E3D21D.7010406@gmail.com>
In-Reply-To: <49E3D21D.7010406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I took my time with this reply to gather verified data and information.
I wanted to be sure of my facts and have pristine HW for testing (you
mentioned the possibility of broken/fake HW).

1) My cards are 100% genuine - confirmed by Twinhan.
2) I had one of the cards replaced for tests using new mantis-v4l S2API
3) Testing was conducted using mantis-v4l exclusively, with a single
card and with both cards connected (same results).

Manu Abraham wrote:
> Manu Abraham wrote:
>> Dave Lister wrote:
>>>> On Sat, Apr 11, 2009 at 5:47 AM, Dave Lister <foceni@gmail.com> wrote:
>>>>> RESULTS (using "s2" dvb-apps):
>>>>> - scanning DVB-S works
>>>>> - scanning DVB-S2 doesn't work
>>>>> - zapping DVB-S is fast
>>>>>
>>> For other SkyStar HD2 users, this is a summary as of 2009.04.14:
>>>   - kernel 2.6.29 + mantis-v4l works (except DiSEqC as far as I can tell)
>>
>> Diseqc works fine over here, with the VP-1041 and other cards, using
>> the mantis-v4l tree.

You were right, DiSEqC is working. The reason was forgotten loop through
my STB. Once removed from the cable, DiSEqC started working.

>> The s2-liplianin tree doesn't use an updated tree for the mantis
>> based devices unfortunately. It is stuck with older changesets of
>> the mantis tree.

Driver mantis-v4l suffers from the same issues as s2-liplianin (see the
next paragraph).

>>> Common issues:
>>>   - zapping DVB-S2 channel causes tuner HW lockup (loss of signal until reboot)
>>>   - zap DVB-S2 channel => AWFUL ultra-high pitched noise emitted from
>>> the card (capacitors or coils?) - makes your head hurt in about 30mins
>>>   - very poor TS (picture data) quality; signal = 95%, SNR = 70%,
>>> STB/TV gives superb picture, but SkyStar/PC picture is corrupted every
>>> few seconds, sound glitches, etc. (as if the signal was like 40% on
>>> STB) - confirmed in VDR (Xine), MythTV, mplayer.

- Unusable DVB-S2 is a fact. It locks up the card and prevents further
usage. Some S2 transponders cannot be locked even after reboot, which
means this card is basically just DVB-S. There are MANY better supported
DVB-S and even DVB-S2 cards out there.

- High-pitched noise is NOT present with the new card + mantis-v4l. That
might have been HW or s2-liplianin issue.

- Poor TS quality is a fact. This card doesn't even have freq. shielding
on the board, which might be the reason on its own.

>> * If you had those changes on your hardware and your card was
>> susceptible to such issues, then that could be a possible reason.
>> * There are quite some hardware pirates, as noted here ..

Not possible, I have a new card (verified by Twinhan as genuine), which
has been used with mantis-v4l only and has the same issues.

>> In any of your cases, If you have hardware related issues please
>> contact to your supplier to have it checked/replaced by them.

My problems are not caused by defective or fake HW. This has been
confirmed above all suspicions.

>> NOTE: Always try to stick with a tree that's a mainline tree or the
>> development tree, rather than tree's with unknown changes.

When there are 3-4 different driver trees of various maturity, none of
which is working properly, one has no other alternative than to try
everything. Not to mention that mantis-v4l was first uploaded several
day AFTER I began installations. Back then, s2-liplianin was the only
S2API choice.

My signal is now at 95-99% and SNR reported by the STB is 70%. With
SkyStar I can see these numbers:

# femon -a0
FE: STB0899 Multistandard (DVBS)
Problem retrieving frontend information: Operation not supported
status  CVYL | signal 014c | snr 006b | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
Problem retrieving frontend information: Operation not supported
status  CVYL | signal 014c | snr 006b | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
Problem retrieving frontend information: Operation not supported
status  CVYL | signal 014c | snr 006a | ber 00000000 | unc 00000000 |
FE_HAS_LOCK

>From other people reports, I can only conclude that this is an
exceptionally good signal and almost ideal conditions. Unfortunately,
SkyStar is unable to provide acceptable picture. VDR reports "TS
continuity errors" every few seconds and MPlayer is spouting warnings
like these all the time:

[mpeg2video @ 0x8963220]ac-tex damaged at 12 22 43  3%  1%  5.2% 0 0



[mpeg2video @ 0x8963220]Warning MVs not available



[mpeg2video @ 0x8963220]concealing 495 DC, 495 AC, 495 MV errors



[mpeg2video @ 0x8963220]concealing 0 DC, 0 AC, 0 MV errors 16.3% 0 0



[mpeg2video @ 0x8963220]Warning MVs not available7  3%  0% 18.0% 0 0



[mpeg2video @ 0x8963220]concealing 0 DC, 0 AC, 0 MV errors



[mpeg2video @ 0x8963220]concealing 0 DC, 0 AC, 0 MV errors 18.6% 0 0



[mpeg2video @ 0x8963220]concealing 0 DC, 0 AC, 0 MV errors 18.9% 0 0



[mpeg2video @ 0x8963220]concealing 0 DC, 0 AC, 0 MV errors 20.6% 0 0



[mpeg2video @ 0x8963220]ac-tex damaged at 29 8/745  3%  0% 22.6% 0 0



[mpeg2video @ 0x8963220]concealing 0 DC, 0 AC, 0 MV errors



[mpeg2video @ 0x8963220]00 motion_type at 26 34/1097  3%  0% 32.9% 6 0



[mpeg2video @ 0x8963220]concealing 0 DC, 0 AC, 0 MV errors



[mpeg2video @ 0x8963220]skipped MB in I frame at 17 1 3%  0% 36.7% 22 0



[mpeg2video @ 0x8963220]ac-tex damaged at 0 24

The practical result of this is a picture corrupted like every 20sec and
terrible mpeg-esque sound "blips" (e.g. short loud bursts of white
noise). Another fine point with this card is MythTV. I've tried packaged
version, compiled 0.21-fixes and even my personal fork of MythTV SVN
version. Couldn't recommend. It kinda works, but "kinda" is not what I
expect from my sealed HTPC!

I've been working on a solution for almost 2 weeks now, to no avail -
and I know what I'm doing; I'm a programmer who's been using Linux
exclusively since '98. I've written tons of code, incl. open source and
a mainstream Linux kernel driver. I mean, how is a /regular/ BFU
supposed to cope with this disaster?

In short, Linux support for this card sucks. It _almost_ works, but not
really. SkyStar HD2 is not stable, not dependable, not any damn good. I
don't know and I don't care whether it's the driver or HW. I don't have
access to a Windows PC to test it. Luckily, I've managed to return the
cards and GOOD RIDDANCE too!

Regards,

-- 
Dave
