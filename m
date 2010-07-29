Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55008 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013Ab0G2Cgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 22:36:31 -0400
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
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
Date: Wed, 28 Jul 2010 22:36:37 -0400
Message-ID: <1280370997.2392.75.camel@localhost>
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

So those sorts of false positiives are bad, but a glitch filter handles
those.  (Easily done in software - borrow from the LIRC userspace if
need be.)  Set the glictch filter discard pulses that are shorter than
some fraction of the expected protocol time unit.

In the cx23885-input.c file I chose to set the hardware glitch filter at
75% for RC-6 and 62.5% for NEC (I forget my reasons for those numbers
aside from being 3/4 & 5/8 respectively)


> So, I don't think it is a good idea to use a "relaxed" mode by default.

So I disagree.  We should set the default to make the most common use
case as error free as possible, reducing false detections and missed
detections, so that it "just works".

I see two conflicting goals, which force optimizations one direction or
another:

1. Optimize for good protocol discrimination
(at the expense of ability to decode from remotes/receviers that don't
meet the protocol specs).

2. Optimize for good decoding within each protocol
(at the expense of discriminating between the protocols).

My assertion that goal #1, is not important in the most common use case
and the ability have an acceptable success rate in the general case is
questionable.  There is so much information available to constrain what
IR protocols will be present on a receiver, it hardly seems worth the
effort for the normal user with 1 TV capture device and the remote that
came with it.

I'll also assert that goal #2 is easier to attain and more useful to the
general case.  Cheap remotes and poor ambient light conditions are
common occurences.  Glitch filters are simpler if you can just throw out
glitches, restarting the measurment, knowing that the tolerances will
still pull you in.  One can also start to think about adaptive decoders,
that adjust to the protocol time unit the remotes appears to be using.
(In NEC, the normal mark time indicates the remote's idea of the
protocol time unit.)


What am I going to do about it all in the end?  Probably not much. :)
(I seem to have more time to gripe than do much else nowadays. :P )



> > Enable NEC and disable JVC by
> > default.  Let the users know so as to properly manage user expectations.
> > (Maxim's original question was about expectation.)
> 
> We should discuss a little bit about RC subsystem evolution during LPC/2010,

Yes.  I'll be there.


> but, from my point of view, we should soon deprecate the in-kernel keymap tables
> on some new kernel version, using, instead, the ir-keycode application to 
> dynamically load the keycode tables via UDEV. Of course, after some time,
> we may end by removing all those tables from the kernel.
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

I like that discovery of a remote protocol and scancodes is a particular
mode, but I don't see the value of turning it on by default.  It seems
like the user-space CLI or GUI apps could just set it that way for the
receiver of interest.

I'm not sure I can develop some evil IR DoS device to take advantage of
that default, so I suppose it is only wasting CPU cycles.


> IMO, we should have a way to tell the RC and/or the decoding subsystem to work on a
> "relaxed" mode only when the user (or the userspace app) detects that there's something
> wrong with that device.


Simple glitch filters, like ones that discard measurments, would be a
case where the decoding would benefit from the decoders being less
picky.  

As an example of simple hardware glitch filter, here's an excerpt
from the public CX25480/1/2/3 datasheet on the IR low-pass (glitch)
filter that's in the hardware:

"the counter reloads using the value programmed to this register each
time a qualified edge is detected [...]. Once the reload occurs, the
counter begins decrementing. If the next programmed edge occurs before
the counter reaches 0, the pulse measurement value is discarded, the
filter modulus value is reloaded, and the next pulse measurement begins.
Thus, any pulse measurement that ends before the counter reaches 0 is
ignored."


Regards,
Andy

