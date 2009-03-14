Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58466 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZCNCnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 22:43:46 -0400
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
From: Andy Walls <awalls@radix.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0903131828340.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org>
	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	 <49B9DECC.5090102@nav6.org>
	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
	 <1236991416.3290.56.camel@palomino.walls.org>
	 <Pine.LNX.4.58.0903131828340.28292@shell2.speakeasy.net>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 22:44:48 -0400
Message-Id: <1236998689.3290.169.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-03-13 at 18:34 -0700, Trent Piepho wrote:
> On Fri, 13 Mar 2009, Andy Walls wrote:
> > On Fri, 2009-03-13 at 10:27 -0400, Devin Heitmueller wrote:
> > > On Fri, Mar 13, 2009 at 12:19 AM, Ang Way Chuang <wcang@nav6.org> wrote:
> > > >
> > > > Yes, please :)
> > >
> > > Yeah, Michael Krufky and I were discussing it in more detail yesterday
> > > on the #linuxtv ML.  Essentially there are a few issues:
> > >
> > > 1.  Getting everyone to agree on the definition of "SNR", and what
> > > units to represent it in.  It seems like everybody I have talked to
> > > has no issue with doing in 0.1 dB increments, so for example an SNR of
> > > 25.3 would be presented as 0x00FD.
> >
> > +/- 0.1 dB indicates increases or decreases of about 2.3% which should
> > be just fine as a step size.
> 
> I've found that the extra precision helps when trying to align an antenna.
> I turn the antenna a few degrees and then measure snr for a while.  Then
> make a plot of snr vs antenna rotation.  With the extra precision you can
> see the average snr change as you fine tune to rotation.  Rounding off the
> extra digit makes it harder to see.

Ah good point.  Peaking meters are nice.  My antenna is in my attic and
trusses limit rotations. :(


> What is the advantage to using base 10 fixed point on binary computer?

None really.  From my work experience doing link budgets (i.e.
predictions) going less than 0.1 dB is silly.  But I wasn't thinking
actual measurement.

I agree, more prescision is good for measured quantities *and* acting on
them.  If the user isn't going to act on the measurments, then, of
course, I'm not sure what good the extra precision is.


Regards,
Andy

