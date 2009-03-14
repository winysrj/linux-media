Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51817 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760848AbZCNAnU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 20:43:20 -0400
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Ang Way Chuang <wcang@nav6.org>, VDR User <user.vdr@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
References: <49B9BC93.8060906@nav6.org>
	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	 <49B9DECC.5090102@nav6.org>
	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 20:43:36 -0400
Message-Id: <1236991416.3290.56.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-03-13 at 10:27 -0400, Devin Heitmueller wrote:
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

+/- 0.1 dB indicates increases or decreases of about 2.3% which should
be just fine as a step size.


> 2.  Getting everyone to agree on the definition of "Strength".  Is
> this the field strength? 

Field strength E is proportional to S^(1/2) and S is proportional to
S/N, so E is proportional to (S/N)^(1/2).

I wouldn't use field strength, there's really no additional information.


>  Is this some coefficient of the SNR compared
> to an arbitrary scale?


No.  For digital signals what you really want is something that conveys
*margin* not strength.  For example:

	Margin = Received SNR - Threshold SNR

(the above values in dB.)  Where "Threshold SNR" is the required SNR for
a certain block error rate with that modulation technique and FEC or a
certain BER with that modulation technique.

That lets the user know how close his signal is to crapping out - that's
what a user cares about.  (Or I suppose how far a user is from getting a
useable signal in the case of negative margin.)


The amount of AGC headroom you currently have can also be considered an
amount of margin.  That SNR margin combined with the receiver's current
AGC headroom can give you composite a measure of "signal quality".  One
snag with this is if your AGC turns all the way down because you're
overdriving the front end, then intermodulation products can degrade
your SNR yet you have maximum AGC headroom, so one has to be careful
about composite measures including AGC.


>   Is it a percentage?  If it's a percentage, is
> it 0-100 or 0-65535?

Composite quality measures are likely best left as device specific.  A
device driver specific value scaled from 0 to 100 is fine, but likely
still too granular.  Where would the "not working threshold" be? 0, 25,
33, 50?



Absolute measures (measures with no context) are typically useless, it's
the realtive measures that usually have meaning.

Regards,
Andy


> 3.  Deciding on what return codes to use for "device does not support
> SNR info", "device cannot provide SNR currently" (such as occurs for
> some devices if there is no lock).  Right now, devices return zero if
> not supported, and it would be good for apps to know the difference
> between "no signal" and the various reasons a chip cannot provide the
> information.
> 
> 4.  Converting all the drivers to use the same representation.  How
> difficult this is varies by chip, since for some chips we know exactly
> how SNR is represented and for some chips it is completely reverse
> engineered.
> 
> After the discussion I had yesterday, I have some renewed energy for
> this.  My plan is to put together a formal definition of the two API
> calls (SNR and Strength) and solicit comments.  If I get some
> agreement, I will start converting all the ATSC devices to support the
> API (and submit patches to Kaffeine).
> 
> Devin


