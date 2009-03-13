Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:18294 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759564AbZCMVc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 17:32:29 -0400
Received: by yw-out-2324.google.com with SMTP id 5so434137ywh.1
        for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 14:32:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org>
	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	 <49B9DECC.5090102@nav6.org>
	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
Date: Fri, 13 Mar 2009 17:32:27 -0400
Message-ID: <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Ang Way Chuang <wcang@nav6.org>, VDR User <user.vdr@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 13, 2009 at 5:11 PM, Trent Piepho <xyzzy@speakeasy.org> wrote:
> I like 8.8 fixed point a lot better.  It gives more precision.  The range
> is more in line with that the range of real SNRs are.  Computers are
> binary, so the math can end up faster.  It's easier to read when printed
> out in hex, since you can get the integer part of SNR just by looking at
> the first byte.  E.g., 25.3 would be 0x194C, 0x19 = 25 db, 0x4c = a little
> more than quarter.  Several drivers already use it.

Wow, I know you said you like that idea alot better, but I read it and
it made me feel sick to my stomach.  Once we have a uniform format, we
won't need to show it in hex at all.  Tools like femon and scan can
just show the value in decimal (they show it in hex because it's
definition varies by device).

Target applications can reformat the value any way you prefer.  This
is a kernel interface.

On a separate note, do you know specifically which drivers use that
format?  I was putting together a table of all the various
demodulators and which format they use, so if you have demods you know
about I would be interested in filling out that data.

>> 2.  Getting everyone to agree on the definition of "Strength".  Is
>> this the field strength?  Is this some coefficient of the SNR compared
>> to an arbitrary scale?  Is it a percentage?  If it's a percentage, is
>> it 0-100 or 0-65535?
>
> The problem with strength is that practically no hardware can measure true
> signal strength.

I'm fine being a little more flexible on the definition of "strength",
as long as the resulting value is presented in a uniform format.
While SNR should have a strict definition, I'm fine with having
strength being something like "0-100%, scaled up to 0xffff".  For
drivers that only have SNR, they can just scale up the SNR based on a
fixed maximum (some ATSC drivers for example, consider 35 dB to be
100%).  Or drivers that have field strength measuring capabilities can
return that value.

In my mind, the goal isn't being able to compare different devices
between each other, so much as being able to get a uniform way for
users to know about what the signal quality is.  I want users of
Kaffeine to be able to go to the signal monitor section and see the
"strength" indicator show a value from 0-100%, regardless of which
device they are using.

Certainly though, I want to get enough logic in there for devices to
be able to indicate that the driver does not support returning the
value (instead of returning zero), and be able to indicate that it
cannot return the valid value right now (for example, many chips
cannot return a valid value when there is no signal lock).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
