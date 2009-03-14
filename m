Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:46461 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763452AbZCNBeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 21:34:08 -0400
Date: Fri, 13 Mar 2009 18:34:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
In-Reply-To: <1236991416.3290.56.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0903131828340.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org>  <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
  <49B9DECC.5090102@nav6.org>  <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
 <1236991416.3290.56.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Mar 2009, Andy Walls wrote:
> On Fri, 2009-03-13 at 10:27 -0400, Devin Heitmueller wrote:
> > On Fri, Mar 13, 2009 at 12:19 AM, Ang Way Chuang <wcang@nav6.org> wrote:
> > >
> > > Yes, please :)
> >
> > Yeah, Michael Krufky and I were discussing it in more detail yesterday
> > on the #linuxtv ML.  Essentially there are a few issues:
> >
> > 1.  Getting everyone to agree on the definition of "SNR", and what
> > units to represent it in.  It seems like everybody I have talked to
> > has no issue with doing in 0.1 dB increments, so for example an SNR of
> > 25.3 would be presented as 0x00FD.
>
> +/- 0.1 dB indicates increases or decreases of about 2.3% which should
> be just fine as a step size.

I've found that the extra precision helps when trying to align an antenna.
I turn the antenna a few degrees and then measure snr for a while.  Then
make a plot of snr vs antenna rotation.  With the extra precision you can
see the average snr change as you fine tune to rotation.  Rounding off the
extra digit makes it harder to see.

What is the advantage to using base 10 fixed point on binary computer?
