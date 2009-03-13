Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:41464 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZCMXzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 19:55:42 -0400
Date: Fri, 13 Mar 2009 16:55:40 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
cc: Ang Way Chuang <wcang@nav6.org>, VDR User <user.vdr@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
In-Reply-To: <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org>  <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
  <49B9DECC.5090102@nav6.org>  <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
  <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Mar 2009, Devin Heitmueller wrote:
> On Fri, Mar 13, 2009 at 5:11 PM, Trent Piepho <xyzzy@speakeasy.org> wrote:
> > I like 8.8 fixed point a lot better.  It gives more precision.  The range
> > is more in line with that the range of real SNRs are.  Computers are
> > binary, so the math can end up faster.  It's easier to read when printed
> > out in hex, since you can get the integer part of SNR just by looking at
> > the first byte.  E.g., 25.3 would be 0x194C, 0x19 = 25 db, 0x4c = a little
> > more than quarter.  Several drivers already use it.
>
> Wow, I know you said you like that idea alot better, but I read it and
> it made me feel sick to my stomach.  Once we have a uniform format, we
> won't need to show it in hex at all.  Tools like femon and scan can

But if you do see it in hex, it's easier to understand.  If it's not shown
in hex, you still have better precision and better math.  What advantage is
there to using something that's 4.1 decimal fixed point on a binary
computer?

> On a separate note, do you know specifically which drivers use that
> format?  I was putting together a table of all the various

or51211, or51132, and lgdt330x at least.  Don't know about the other lg
demods.  The dvb match code they all use makes it's easy to get the snr in
8.8 fixed point with the typical log caclulations required.
