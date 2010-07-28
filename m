Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61195 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0G1U1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 16:27:48 -0400
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Jon Smirl <jonsmirl@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
In-Reply-To: <4C508F87.6050906@redhat.com>
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
	 <1280341109.26286.38.camel@morgan.silverblock.net>
	 <4C508F87.6050906@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 23:27:25 +0300
Message-ID: <1280348845.8891.4.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-07-28 at 17:13 -0300, Mauro Carvalho Chehab wrote: 
> Andy,
> 
> Em 28-07-2010 15:18, Andy Walls escreveu:
> > On Wed, 2010-07-28 at 13:35 -0400, Jon Smirl wrote:
> >> On Wed, Jul 28, 2010 at 1:02 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> >>> On Wed, 2010-07-28 at 12:42 -0300, Mauro Carvalho Chehab wrote:
> >>>> Em 28-07-2010 11:53, Jon Smirl escreveu:
> >>>>> On Wed, Jul 28, 2010 at 10:38 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> >>>>>> On Wed, 2010-07-28 at 09:46 -0400, Jon Smirl wrote:
> >>>
> >>>>> I recommend that all decoders initially follow the strict protocol
> >>>>> rules. That will let us find bugs like this one in the ENE driver.
> >>>>
> >>>> Agreed.
> >>>
> >>> Well...
> >>>
> >>> I'd possibly make an exception for the protocols that have long-mark
> >>> leaders.  The actual long mark measurement can be far off from the
> >>> protocol's specification and needs a larger tolerance (IMO).
> >>>
> >>> Only allowing 0.5 to 1.0 of a protocol time unit tolerance, for a
> >>> protocol element that is 8 to 16 protocol time units long, doesn't make
> >>> too much sense to me.  If the remote has the basic protocol time unit
> >>> off from our expectation, the error will likely be amplified in a long
> >>> protocol elements and very much off our expectation.
> >>
> >> Do you have a better way to differentiate JVC and NEC protocols? They
> >> are pretty similar except for the timings.
> > 
> > Yes: Invoke the 80/20 rule and don't try.
> 
> At the room where my computers is located, I have two wide fluorescent lamps
> each with 20W. If I don't hide the IR sensors bellow my desk, those lamps
> are enough to generate random flickers at the sensors. With the more relaxed
> driver we used to have at saa7134, it ended by producing random scancodes,
> or, even worse, random repeat codes. So, lots of false-positive events. It is
> a way worse to have false-positive than having a false-negative events.
> 
> So, I don't think it is a good idea to use a "relaxed" mode by default.
> 
> 
> > Enable NEC and disable JVC by
> > default.  Let the users know so as to properly manage user expectations.
> > (Maxim's original question was about expectation.)
> 
> We should discuss a little bit about RC subsystem evolution during LPC/2010, 
> but, from my point of view, we should soon deprecate the in-kernel keymap tables
> on some new kernel version, using, instead, the ir-keycode application to 
> dynamically load the keycode tables via UDEV. Of course, after some time,
> we may end by removing all those tables from the kernel.
/me is very happy about it.
The reason isn't even about size or some principle.
These keymaps just increase compilation time too much...

> 
> So, assuming that we follow this patch, what we'll have for a newer device is:
> 
> For most devices, the keymap configuration table (rc_maps.cfg) will associate
> all known devices with their corresponding keytable (we still need to generate
> a default rc_maps.cfg that corresponds to the current in-kernel mapping, but
> this is trivial).
> 
> As ir-keytable disables all protocols but the one(s) needed by a given device,
> in practice, if the scancode table specifies a NEC keymap table, JVC will be disabled.
> If the table is for JVC, NEC will be disabled.
> 
> So, this already happens in a practical scenario, as all decoders will be enabled 
> only before loading a keymap (or if the user explicitly enable the other decoders).
> 
> So, the device will be in some sort of "training" mode, e. g. it will try every
> possible decoder, and will be generating the scancodes for some userspace application
> that will be learning the keycodes and creating a keymap table.
> 
> IMO, we should have a way to tell the RC and/or the decoding subsystem to work on a
> "relaxed" mode only when the user (or the userspace app) detects that there's something
> wrong with that device.
> 
> > When the user knows NEC isn't working, or he suspects JVC may work, he
> > can bind that protocol to the particular IR receiver.
> > 
> > Trying to solve the discrimination problem with blindly parallel
> > decoding all the possible protocols is a big waste of effort IMO:
> > 
> > a. Many remotes are sloppy and out of spec, and get worse with weak
> > batteries.
> > 
> > b. The IR receiver driver knows what remotes possibly came bundled with
> > the hardware.  (For the case of the MCE USB, it's almost always an RC-6
> > 6A remote.)
> > 
> > c. The user can tell the kernel about his remote unambiguously.
> > 
> > There's no burning need to wear a blindfold, AFAICT, so let's not.
> > 
> > Why bother to solve a hard problem (discrimination of protocols from out
> > of spec remotes), when it raises the error rate of solving the simple
> > one (properly decoding a single protocol)?
> > 
> > Doing many things poorly is worse than doing one thing well.
> > Non-adaptive protocol discovery (i.e. blind parallel decoding) should
> > not be the default if it leads to problems or inflated expectations for
> > the user.
> > 
> > 
> >>  What happened in this case
> >> was that the first signals matched the NEC protocol. Then we shifted
> >> to bits that matched JVC protocol.
> >>
> >> The NEC bits are 9000/8400 = 7% longer. If we allow more than a 3.5%
> >> error in the initial bit you can't separate the protocols.
> >>
> >> In general the decoders are pretty lax and the closest to the correct
> >> one with decode the stream. The 50% rule only comes into play between
> >> two very similar protocols.
> >>
> >> One solution would be to implement NEC/JVC in the same engine. Then
> >> apply the NEC consistency checks. If the consistency check pass
> >> present the event on the NEC interface. And then always present the
> >> event on the JVC interface.
> > 
> > It's just too simple to have the user:
> > 
> > a. Try NEC
> > b. Try JVC
> > c. Make a judgment and stick with the one he perceives works.
> > 
> > 
> > To have reliable discrimination in the general case between two
> > protocols, given the variables out of our control (i.e. the remote
> > control implementation) would require some sort of data collection and
> > adaptive algorithm to go on inside the kernel.  I don't think you can
> > get reliable discrimination in one key press.  Maybe by looking at the
> > key press and the repeats together might up the probability of correct
> > discrimination (that's one criterion you examined to make a
> > determination in your earlier email).
> 
> Cheers,
> Mauro.


