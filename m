Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:15023 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZCMVxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 17:53:02 -0400
Received: by fg-out-1718.google.com with SMTP id 16so903947fgg.17
        for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 14:52:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
References: <49B9BC93.8060906@nav6.org>
	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	 <49B9DECC.5090102@nav6.org>
	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
Date: Fri, 13 Mar 2009 17:52:59 -0400
Message-ID: <37219a840903131452mf8b7969h881a24fc2dd031e8@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Michael Krufky <mkrufky@linuxtv.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 13, 2009 at 5:32 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Fri, Mar 13, 2009 at 5:11 PM, Trent Piepho <xyzzy@speakeasy.org> wrote:
>> I like 8.8 fixed point a lot better.  It gives more precision.  The range
>> is more in line with that the range of real SNRs are.  Computers are
>> binary, so the math can end up faster.  It's easier to read when printed
>> out in hex, since you can get the integer part of SNR just by looking at
>> the first byte.  E.g., 25.3 would be 0x194C, 0x19 = 25 db, 0x4c = a little
>> more than quarter.  Several drivers already use it.
>
> Wow, I know you said you like that idea alot better, but I read it and
> it made me feel sick to my stomach.  Once we have a uniform format, we
> won't need to show it in hex at all.  Tools like femon and scan can
> just show the value in decimal (they show it in hex because it's
> definition varies by device).
>
> Target applications can reformat the value any way you prefer.  This
> is a kernel interface.
>
> On a separate note, do you know specifically which drivers use that
> format?  I was putting together a table of all the various
> demodulators and which format they use, so if you have demods you know
> about I would be interested in filling out that data.

LGDT330X, for both the 3302 and 3303 (although the 3302 work was a
guess -- its probably close enough)
...and both of the OREN demod drivers.

-Mike
