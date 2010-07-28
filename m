Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:30217 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170Ab0G1STF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 14:19:05 -0400
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Andy Walls <awalls@md.metrocast.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTikotLLPcCvwwNFEe+80sV6w9F0pa_fx3f_jdK77@mail.gmail.com>
References: <1280269990.21278.15.camel@maxim-laptop>
	 <1280273550.32216.4.camel@maxim-laptop>
	 <AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
	 <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
	 <1280298606.6736.15.camel@maxim-laptop>
	 <AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>
	 <4C502CE6.80106@redhat.com>
	 <AANLkTinCs7f6zF-tYZqJ49CAjNWF=2MPGh0VRuU=VLzq@mail.gmail.com>
	 <1280327929.11072.24.camel@morgan.silverblock.net>
	 <AANLkTikFfXx4NBB2z2UXNt5Kt-2QrvTfvK0nQhSSqw8v@mail.gmail.com>
	 <4C504FDB.4070400@redhat.com>
	 <1280336530.19593.52.camel@morgan.silverblock.net>
	 <AANLkTikotLLPcCvwwNFEe+80sV6w9F0pa_fx3f_jdK77@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 14:18:29 -0400
Message-ID: <1280341109.26286.38.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-07-28 at 13:35 -0400, Jon Smirl wrote:
> On Wed, Jul 28, 2010 at 1:02 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > On Wed, 2010-07-28 at 12:42 -0300, Mauro Carvalho Chehab wrote:
> >> Em 28-07-2010 11:53, Jon Smirl escreveu:
> >> > On Wed, Jul 28, 2010 at 10:38 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> >> On Wed, 2010-07-28 at 09:46 -0400, Jon Smirl wrote:
> >
> >> > I recommend that all decoders initially follow the strict protocol
> >> > rules. That will let us find bugs like this one in the ENE driver.
> >>
> >> Agreed.
> >
> > Well...
> >
> > I'd possibly make an exception for the protocols that have long-mark
> > leaders.  The actual long mark measurement can be far off from the
> > protocol's specification and needs a larger tolerance (IMO).
> >
> > Only allowing 0.5 to 1.0 of a protocol time unit tolerance, for a
> > protocol element that is 8 to 16 protocol time units long, doesn't make
> > too much sense to me.  If the remote has the basic protocol time unit
> > off from our expectation, the error will likely be amplified in a long
> > protocol elements and very much off our expectation.
> 
> Do you have a better way to differentiate JVC and NEC protocols? They
> are pretty similar except for the timings.

Yes: Invoke the 80/20 rule and don't try.  Enable NEC and disable JVC by
default.  Let the users know so as to properly manage user expectations.
(Maxim's original question was about expectation.)

When the user knows NEC isn't working, or he suspects JVC may work, he
can bind that protocol to the particular IR receiver.


Trying to solve the discrimination problem with blindly parallel
decoding all the possible protocols is a big waste of effort IMO:

a. Many remotes are sloppy and out of spec, and get worse with weak
batteries.

b. The IR receiver driver knows what remotes possibly came bundled with
the hardware.  (For the case of the MCE USB, it's almost always an RC-6
6A remote.)

c. The user can tell the kernel about his remote unambiguously.

There's no burning need to wear a blindfold, AFAICT, so let's not.

Why bother to solve a hard problem (discrimination of protocols from out
of spec remotes), when it raises the error rate of solving the simple
one (properly decoding a single protocol)?

Doing many things poorly is worse than doing one thing well.
Non-adaptive protocol discovery (i.e. blind parallel decoding) should
not be the default if it leads to problems or inflated expectations for
the user.


>  What happened in this case
> was that the first signals matched the NEC protocol. Then we shifted
> to bits that matched JVC protocol.
> 
> The NEC bits are 9000/8400 = 7% longer. If we allow more than a 3.5%
> error in the initial bit you can't separate the protocols.
> 
> In general the decoders are pretty lax and the closest to the correct
> one with decode the stream. The 50% rule only comes into play between
> two very similar protocols.
> 
> One solution would be to implement NEC/JVC in the same engine. Then
> apply the NEC consistency checks. If the consistency check pass
> present the event on the NEC interface. And then always present the
> event on the JVC interface.

It's just too simple to have the user:

a. Try NEC
b. Try JVC
c. Make a judgment and stick with the one he perceives works.


To have reliable discrimination in the general case between two
protocols, given the variables out of our control (i.e. the remote
control implementation) would require some sort of data collection and
adaptive algorithm to go on inside the kernel.  I don't think you can
get reliable discrimination in one key press.  Maybe by looking at the
key press and the repeats together might up the probability of correct
discrimination (that's one criterion you examined to make a
determination in your earlier email).

Regards,
Andy


