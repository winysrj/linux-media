Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36277 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758484AbZKZE1K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 23:27:10 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <4B0DA885.7010601@redhat.com>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
	 <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
	 <829197380911251020y6f330f15mba32920ac63e97d3@mail.gmail.com>
	 <4B0DA885.7010601@redhat.com>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 23:26:02 -0500
Message-Id: <1259209562.3060.92.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-11-25 at 22:58 +0100, Gerd Hoffmann wrote:
> On 11/25/09 19:20, Devin Heitmueller wrote:
> > On Wed, Nov 25, 2009 at 1:07 PM, Jarod Wilson<jarod@wilsonet.com>
> > wrote:
> >> Took me a minute to figure out exactly what you were talking
> >> about. You're referring to the current in-kernel decoding done on
> >> an ad-hoc basis for assorted remotes bundled with capture devices,
> >> correct?
> >>
> >> Admittedly, unifying those and the lirc driven devices hasn't
> >> really been on my radar.
> 
> I think at the end of the day we'll want to have all IR drivers use the
> same interface.  The way the current in-kernel input layer drivers work
> obviously isn't perfect too, so we *must* consider both worlds to get a
> good solution for long-term ...
> 
> > This is one of the key use cases I would be very concerned with. For
> > many users who have bought tuner products, the bundled remotes work
> > "out-of-the-box", regardless of whether lircd is installed.
> 
> I bet this simply isn't going to change.
> 
> > I have no objection so much as to saying "well, you have to install
> > the lircd service now", but there needs to be a way for the driver to
> >  automatically tell lirc what the default remote control should be,
> > to avoid a regression in functionality.
> 
> *Requiring* lircd for the current in-kernel drivers doesn't make sense
> at all.  Allowing lircd being used so it can do some more advanced stuff 
> makes sense though.
> 
> > This is why I think we really should put together a list of use
> > cases, so that we can see how any given proposal addresses those use
> > cases. I offered to do such, but nobody seemed really interested in
> > this.
> 
> Lets have a look at the problems the current input layer bits have 
> compared to lirc:
> 
> 
> (1) ir code (say rc5) -> keycode conversion looses information.
> 
> I think this can easily be addressed by adding a IR event type to the 
> input layer, which could look like this:
> 
>    input_event->type  = EV_IR
>    input_event->code  = IR_RC5
>    input_event->value = <rc5 value>
> 
> In case the 32bit value is too small we might want send two events 
> instead, with ->code being set to IR_<code>_1 and IR_<code>_2

RC-6 Mode 6A can be up to 67 bits:

http://www.picbasic.nl/frameload_uk.htm?http://www.picbasic.nl/rc5-rc6_transceiver_uk.htm

(This page is slightly wrong, there is some data coded in the header
such as the RC-6 Mode, but I can't remeber if it's biphase or not.)

> Advantages:
>    * Applications (including lircd) can get access to the unmodified
>      rc5/rc6/... codes.
>    * All the ir-code -> keycode mapping magic can be handled by the
>      core input layer then.  All the driver needs to do is to pass on
>      the information which keymap should be loaded by default (for the
>      bundled remote if any).  The configuration can happen in userspace
>      (sysfs attribute + udev + small utility in tools/ir/).
>    * lirc drivers which get ir codes from the hardware can be converted
>      to pure input layer drivers without regressions.  lircd is not
>      required any more.
> 
> (2) input layer doesn't give access to the raw samples.
> 
> Not sure how to deal with that best.  Passing them through the input 
> layer would certainly be possible to hack up.  But what would be the 
> point?  The input layer wouldn't do any processing on them.  It wouldn't 
> buy us much.  So we might want to simply stick with todays lirc 
> interface for the raw samples.
> 
> Drivers which support both ir codes (be it by hardware or by in-kernel 
> decoding) and raw samples would register two devices then, one input 
> device and one lirc device.  It would probably a good idea to stop 
> sending events to the input layer as soon as someone (most likely lircd) 
> opens the lirc device to avoid keystrokes showing up twice.
> 
> By default the in-kernel bits will be at work, but optionally you can 
> have lircd grab the raw samples and do fancy advanced decoding.

(2a) Input layer doesn't help with raw samples:

So now what about devices that don't produce codes at all, but simply
pulse width measurements?  Where's the infrastrucutre to perform low
pass filtering to get rid of glitches and to perform oversampling to
deal with pulse jitter, so that adding a new IR device isn't a pain
incurred per driver?

I was quite dismayed at how much I had to reimplement here, just for
RC-5 for the sake of the input layer and having a remote "Just Work":

http://linuxtv.org/hg/v4l-dvb/file/74ad936bcca2/linux/drivers/media/video/cx23885/cx23885-input.c

lirc does all that stuff in spades.


> (3) input layer doesn't allow transmitting IR codes.
> 
> If we keep the lirc interface for raw samples anyway, then we can keep 
> it for sending too, problem solved ;)  How does sending hardware work 
> btw?  Do they all accept just raw samples?  Or does some hardware also 
> accept ir-codes?

The Conexant chips' integrated IR Tx hardware expects a series of pulse
widths and a flag for mark or space with each width.

I'd have to research other implementations.

Regards,
Andy

> cheers,
>    Gerd


