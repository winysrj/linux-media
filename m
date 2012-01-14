Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62530 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2ANUlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 15:41:40 -0500
Received: by mail-bk0-f46.google.com with SMTP id w12so741691bku.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 12:41:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1326572518.1243.43.camel@palomino.walls.org>
References: <CAEN_-SDUfyu34YSV6Lr4yADkNmr6=+TALN0xvrCODFPeRedkFA@mail.gmail.com>
	<1326572518.1243.43.camel@palomino.walls.org>
Date: Sat, 14 Jan 2012 21:41:39 +0100
Message-ID: <CAEN_-SD2UrAZZebJv8RD5ZiAHUkpzRCYLSwqQpAOwwN8o1tLSQ@mail.gmail.com>
Subject: Re: cx25840: improve audio for cx2388x drivers
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Dne 14. ledna 2012 21:21 Andy Walls <awalls@md.metrocast.net> napsal(a):
> On Sat, 2012-01-14 at 19:44 +0100, Miroslav Slugeò wrote:
>> Searching for testers, this patch is big one, it was more then week of
>> work and testing, so i appriciate any comments and recommendations.
>
> Hi Miroslav,
>
> I have not exhaustively revied this patch, but some general comments:
>
> 1. This patch manipulates some video signal tracking behavior (chroma
> lock speed), that is not mentioned in the commit message, and is likely
> not related to audio detection.  Why?

1. cx23885_initialize
a) changing order of Luma and Crhoma setting to nost set this before
completing PLL setup (0x414 and 0x420)
b) moving format auto detection and Chroma AGC with Chroma killer with
same reason
c) 0x13c reseting is necessary not only for cx25840_initialize but
also for cx23885_initialize, i tested this and on some cards it will
fail to autodetect correct video standard without proper reset, it is
also mentioned in datasheet.
d) reseting video decoder for same reason 0x4a4 and 0x402
e) 0x401 - removing fast lock is mentioned in datasheet and it is also
behavior for original card drivers, i don't why it was active

2. set_input function with writing to video registers, everything is
exactly like from datasheet old implementation was just for NTSC
format detection, there was no PAL and SECAM behavior.

That should be reasons for writing to video register, i know that it
is better to split this patch to 2 or more small patches, but it is
all about detection of analog standards.

>
> 2. I myself, have multiple types of cards supported by the cx25840
> module in my machine: PVR-150, PVR-500, HVR-1850, etc.  Having a module
> parameter, "audio_standard_force", that applies globally, instead of per
> card model, is not the right thing to do.

This is easy to do, but real purpose of such option is only for
testing, for broken cards there should be always setting in main
driver like pvr150_workaround.

>
> 3. You have to be very careful when changing anything in the cx25840
> module.  It is very easy to introduce a regression for other boards.
>
> The A/V core and microcontroller firmware in the CX2584[0123] and
> CX23418 chips are similar to each other.
>
> The A/V core and microcontroller firmware in the CX2388[578] and
> CX2310[012] chips are similar to each other.
>
> However, the differences between these two groups of chips are
> noticable.  When in doubt, you cannot rely on information in the
> CX25840/1/2/3 data sheet to apply to the CX2388[578] and CX2310[012]
> chips.
>
> (To ease code maintence and regression testing, I have wanted to split
> the support for the CX2310[012] and CX2388[578] chips out to another
> module.  Such a split eased code maintenance and testing for the cx18
> driver and CX23418 boards.  However, I haven't had any time. :( )

Real changes for cx2310x driver is only in audio part and PAL + SECAM
detection, everything else should be intact.

>
> 4. The CX2584x chips have differences in audio decoding capability:
>
>        CX25843 Worldwide Audio Decoding
>        CX25842 A2, NICAM, FM, AM Audio Decoding
>        CX25841 BTSC (with DBX), EIA-J Audio Decoding
>        CX25840 BTSC (without DBX), EIA-J Audio Decoding
>
> (I have seen all but the CX25840 used in actual board designs.)
>
> Does your patch consider the chips with limited broadcast audio
> decoding?

I  think no, but only real difference is in set_input function which
could set unsupported mode when user requested this.

>
> 5. Even though the CX2583[67] chips do not have audio, some board
> designs still use the AUX_PLL clock normally used for the audio clock in
> the other chips.  Make sure it AUX_PLL setup is not affected for the
> CX2483[67] chips.  (I don't think you did, but I only skimmed the
> patch).

No changes to AUX_PLL settings at all.

>
> Regards,
> Andy
>

M.
