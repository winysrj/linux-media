Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:54077 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751508AbdBBXff (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 18:35:35 -0500
Date: Thu, 2 Feb 2017 23:35:33 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20170202233533.GA14357@gofer.mess.org>
References: <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
 <20161122092043.GA8630@gofer.mess.org>
 <20161123123851.GB14257@shambles.local>
 <20161123223419.GA25515@gofer.mess.org>
 <20161124121253.GA17639@shambles.local>
 <20161124133459.GA32385@gofer.mess.org>
 <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
 <20161127193510.GA20548@gofer.mess.org>
 <20161130090229.GB639@shambles.local>
 <CAEsFdVOb8tWN=6OfnpdJqb9BZ4s-DARF53zgbyhz-_a0zac0Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsFdVOb8tWN=6OfnpdJqb9BZ4s-DARF53zgbyhz-_a0zac0Gg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vincent,

On Thu, Feb 02, 2017 at 10:18:52PM +1100, Vincent McIntyre wrote:
> On 11/30/16, Vincent McIntyre <vincent.mcintyre@gmail.com> wrote:
> > On Sun, Nov 27, 2016 at 07:35:10PM +0000, Sean Young wrote:
> >>
> >> > I wanted to mention that the IR protocol is still showing as unknown.
> >> > Is there anything that can be done to sort that out?
> >>
> >> It would be nice if that could be sorted out, although that would be
> >> a separate patch.
> >>
> >> So all we know right now is what scancode the IR receiver hardware
> >> produces but we have no idea what IR protocol is being used. In order to
> >> figure this out we need a recording of the IR the remote sends, for which
> >> a different IR receiver is needed. Neither your imon nor your
> >> dvb_usb_af9035 can do this, something like a mce usb IR receiver would
> >> be best. Do you have access to one? One with an IR emitter would be
> >> best.
> >>
> >> So with that we can have a recording of the IR the remote sends, and
> >> with the emitter we can see which IR protocols the IR receiver
> >> understands.
> >
> > Haven't been able to find anything suitable. I would order something
> > but I won't be able to follow up for several weeks.
> > I'll ask on the myth list to see if anyone is up for trying this.
> >
> 
> I bought one of these, but I am not sure how to make the recording:
> 
> # lsusb -d 1934:5168 -v
> 
> Bus 008 Device 003: ID 1934:5168 Feature Integration Technology Inc.
> (Fintek) F71610A or F71612A Consumer Infrared Receiver/Transceiver
-snip-
> Poking around I see lirc has an irrecord program. Is that what I need?

That's great. There are a couple of ways of doing this, and none of them
is straightforward. It's a bit of reading tea leaves (that's one of the
motivations for my lirc-scancodes patches, but I digress).

Method 1:
echo "+rc-5 +nec +rc-6 +jvc +sony +rc-5-sz +sanyo +sharp +xmp" > /sys/class/rc/rc3/protocols
echo 1 > /sys/module/rc_core/parameters/debug
journal -f -k 
# press button on remote

Now look for "scancode" somewhere in there.

Method 2:
Either use lirc's mode2 or "ir-ctl -r -d /dev/lircX" (from v4l-utils 1.12),
and post the output here.

Thanks!

Sean
