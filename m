Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:50268 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbZCMVLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 17:11:07 -0400
Date: Fri, 13 Mar 2009 14:11:04 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
cc: Ang Way Chuang <wcang@nav6.org>, VDR User <user.vdr@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
In-Reply-To: <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org>  <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
  <49B9DECC.5090102@nav6.org> <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Mar 2009, Devin Heitmueller wrote:
> On Fri, Mar 13, 2009 at 12:19 AM, Ang Way Chuang <wcang@nav6.org> wrote:
> >
> > Yes, please :)
>
> Yeah, Michael Krufky and I were discussing it in more detail yesterday
> on the #linuxtv ML.  Essentially there are a few issues:
>
> 1.  Getting everyone to agree on the definition of "SNR", and what
> units to represent it in.  It seems like everybody I have talked to
> has no issue with doing in 0.1 dB increments, so for example an SNR of
> 25.3 would be presented as 0x00FD.

I like 8.8 fixed point a lot better.  It gives more precision.  The range
is more in line with that the range of real SNRs are.  Computers are
binary, so the math can end up faster.  It's easier to read when printed
out in hex, since you can get the integer part of SNR just by looking at
the first byte.  E.g., 25.3 would be 0x194C, 0x19 = 25 db, 0x4c = a little
more than quarter.  Several drivers already use it.

> 2.  Getting everyone to agree on the definition of "Strength".  Is
> this the field strength?  Is this some coefficient of the SNR compared
> to an arbitrary scale?  Is it a percentage?  If it's a percentage, is
> it 0-100 or 0-65535?

The problem with strength is that practically no hardware can measure true
signal strength.
