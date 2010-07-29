Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57130 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0G2UEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 16:04:51 -0400
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: awalls@md.metrocast.net, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	mchehab@redhat.com
In-Reply-To: <BTlNJJN3jFB@christoph>
References: <1280424946.32069.11.camel@maxim-laptop> <BTlNJJN3jFB@christoph>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 23:04:47 +0300
Message-ID: <1280433887.2523.11.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-07-29 at 21:35 +0200, Christoph Bartelmus wrote: 
> Hi!
> 
> Maxim Levitsky "maximlevitsky@gmail.com" wrote:
> [...]
> >>>>> Could you explain exactly how timeout reports work?
> [...]
> >>> So, timeout report is just another sample, with a mark attached, that
> >>> this is last sample? right?
> >>
> >> No, a timeout report is just an additional hint for the decoder that a
> >> specific amount of time has passed since the last pulse _now_.
> >>
> >> [...]
> >>> In that case, lets do that this way:
> >>>
> >>> As soon as timeout is reached, I just send lirc the timeout report.
> >>> Then next keypress will start with pulse.
> >>
> >> When timeout reports are enabled the sequence must be:
> >> <pulse> <timeout> <space> <pulse>
> >> where <timeout> is optional.
> >>
> >> lircd will not work when you leave out the space. It must know the exact
> >> time between the pulses. Some hardware generates timeout reports that are
> >> too short to distinguish between spaces that are so short that the next
> >> sequence can be interpreted as a repeat or longer spaces which indicate
> >> that this is a new key press.
> 
> > Let me give an example to see if I got that right.
> >
> >
> > Suppose we have this sequence of reports from the driver:
> >
> > 500 (pulse)
> > 200000 (timeout)
> > 100000000 (space)
> > 500 (pulse)
> >
> >
> > Is that correct that time between first and second pulse is
> > '100200000' ?
> 
> No, it's 100000000. The timeout is optional and just a hint to the decoder  
> how much time has passed already since the last pulse. It does not change  
> the meaning of the next space.

its like a carrier report then I guess.
Its clear to me now.

So, I really don't need to send/support timeout reports because hw
doesn't support that.

I can however support timeout (LIRC_SET_REC_TIMEOUT) and and use it to
adjust threshold upon which I stop the hardware, and remember current
time.
I can put that in generic function for ene like hardware
(hw that sends small packs of samples very often)


Best regards,
Maxim Levitsky




