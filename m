Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34795 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab0G2WHH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 18:07:07 -0400
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	awalls@md.metrocast.net, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	mchehab@redhat.com
In-Reply-To: <AANLkTi=a_kii4g2EPVJukxRsWkoqBGK9gLv2yNh4YJxH@mail.gmail.com>
References: <1280424946.32069.11.camel@maxim-laptop> <BTlNJJN3jFB@christoph>
	 <1280433887.2523.11.camel@maxim-laptop> <20100729212836.GD7507@redhat.com>
	 <AANLkTi=a_kii4g2EPVJukxRsWkoqBGK9gLv2yNh4YJxH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 01:07:01 +0300
Message-ID: <1280441221.2523.15.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 17:57 -0400, Jarod Wilson wrote: 
> On Thu, Jul 29, 2010 at 5:28 PM, Jarod Wilson <jarod@redhat.com> wrote:
> > On Thu, Jul 29, 2010 at 11:04:47PM +0300, Maxim Levitsky wrote:
> >> On Thu, 2010-07-29 at 21:35 +0200, Christoph Bartelmus wrote:
> >> > Hi!
> >> >
> >> > Maxim Levitsky "maximlevitsky@gmail.com" wrote:
> >> > [...]
> >> > >>>>> Could you explain exactly how timeout reports work?
> >> > [...]
> >> > >>> So, timeout report is just another sample, with a mark attached, that
> >> > >>> this is last sample? right?
> >> > >>
> >> > >> No, a timeout report is just an additional hint for the decoder that a
> >> > >> specific amount of time has passed since the last pulse _now_.
> >> > >>
> >> > >> [...]
> >> > >>> In that case, lets do that this way:
> >> > >>>
> >> > >>> As soon as timeout is reached, I just send lirc the timeout report.
> >> > >>> Then next keypress will start with pulse.
> >> > >>
> >> > >> When timeout reports are enabled the sequence must be:
> >> > >> <pulse> <timeout> <space> <pulse>
> >> > >> where <timeout> is optional.
> >> > >>
> >> > >> lircd will not work when you leave out the space. It must know the exact
> >> > >> time between the pulses. Some hardware generates timeout reports that are
> >> > >> too short to distinguish between spaces that are so short that the next
> >> > >> sequence can be interpreted as a repeat or longer spaces which indicate
> >> > >> that this is a new key press.
> >> >
> >> > > Let me give an example to see if I got that right.
> >> > >
> >> > >
> >> > > Suppose we have this sequence of reports from the driver:
> >> > >
> >> > > 500 (pulse)
> >> > > 200000 (timeout)
> >> > > 100000000 (space)
> >> > > 500 (pulse)
> >> > >
> >> > >
> >> > > Is that correct that time between first and second pulse is
> >> > > '100200000' ?
> >> >
> >> > No, it's 100000000. The timeout is optional and just a hint to the decoder
> >> > how much time has passed already since the last pulse. It does not change
> >> > the meaning of the next space.
> >>
> >> its like a carrier report then I guess.
> >> Its clear to me now.
> >>
> >> So, I really don't need to send/support timeout reports because hw
> >> doesn't support that.
> >>
> >> I can however support timeout (LIRC_SET_REC_TIMEOUT) and and use it to
> >> adjust threshold upon which I stop the hardware, and remember current
> >> time.
> >> I can put that in generic function for ene like hardware
> >> (hw that sends small packs of samples very often)
> >
> > So... I presume this means a v3 patchset? And/or, is it worth merging
> > patches 1, 2, 3, 6 and 7 now, then having you work on top of that?
> 
> This branch is a as-of-a-few-minutes-ago, up-to-date linuxtv
> staging/other plus a few outstanding patches and your patches 1, 2, 3,
> 6 and 7:

I am surely send V3 and likely V4.
I changed many of my patches, 

I now  am chasing a very strange leak of samples I see. (sometimes,
randomaly a sample goes missing, and that breaks in-kernel decoding...)
It appears to be not my driver fault, nor fifo overflow...

Best regards,
Maxim Levitsky

