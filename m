Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:34169 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbcKRWBW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 17:01:22 -0500
Received: by mail-pg0-f53.google.com with SMTP id x23so104175835pgx.1
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2016 14:01:22 -0800 (PST)
Date: Sat, 19 Nov 2016 09:01:10 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161118220107.GA3510@shambles.local>
References: <20161116105256.GA9998@shambles.local>
 <20161117134526.GA8485@gofer.mess.org>
 <20161118121422.GA1986@shambles.local>
 <20161118174034.GA6167@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161118174034.GA6167@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 18, 2016 at 05:40:34PM +0000, Sean Young wrote:
> >  
> > So are you saying that the hex codes in the rc_map_dvico_mce_table
> > struct are invalid (at least in some cases)?
> 
> Most likely the remote produces IR in a standard protocol (e.g. rc5, rc6). 
> If we first get the keymap right then the remote can be used with any 
> IR receiver that can deal with its protocol; conversely, if we know 
> what protocol the IR receiver can receive, and we make it produce the 
> scancodes in the right format, it can then be used with any remote that 
> uses the protocol it understands.
> 
> So at the moment we don't know what protocol it is, and even if it is 
> rc5 then some bit shifting might be needed to make it into a proper
> rc5 scancode (both driver and keymap).
> 
> > How can I tell what protocol is in use?
> > 0x00010001 doesn't mean much to me; I did search the linux source
> > for the code but didn't find any helpful matches.
> 
> At the moment it's not easy to determine what protocol an remote uses;
> I would like to change that but for now, the following is probably
> the easiest way.
> 
> cd /sys/class/rc/rc1 # replace rc1 with your receiver
> for i in $(<protocols); do echo +$i > protocols; done
> echo 3 > /sys/module/rc_core/parameters/debug
> journal -f -k
 
Ah. Here we have a problem. The device (/dev/input/event15)
doesn't have a corresponding rcX node, see ir-keytable output below.
I had it explained to me like this:

  A "HID" device is basically any input device that resembles
  a keyboard or mouse (Human Interface Device). The label may also cover
  things like joysticks, etc. It does /not/ include remotes, so it
  seems, since "remote" can cover a wide variety of input devices.

  Some remotes can emulate fully or partially keyboard keypresses
  which is why they can be treated as HID devices. Of course, not all
  the keys may be mapped correctly or at all.


> Protocol numbers are defined in enum rc_type, see include/media/rc-map.h
> 
> > > Would it be possible to test the remote with another device (say an
> > > usb mce receiver or so) and see what scancodes it sends? Then we can
> > > translate the keymap to a real one and make the cxusb driver send
> > > correct scancodes to rc-core.
> > 
> > Great idea. Do you mean something like [1]?
> 
> Yes, it would be a receiver like that.
> 
> > Or the (presumably generic) receiver that comes with [2]?
> 
> It's not clear what usb receiver it uses.
> 
> > Would a FLIRC work?
> 
> I hadn't heard of flirc, looks like it doesn't have a kernel driver. Maybe
> I'll go and get one. :)
> 
> > Probably dumb question - in this machine I also have
> > an iMon Remote (152c:ffdc)
> > and Leadtek WinFast DTV Dongle Dual
> > Do you think either of those would be helpful?
> > I tried evtest with them and the remote, no responses.
> > 
> > # ir-keytable
> > Found /sys/class/rc/rce0/ (/dev/input/event5) with:
> >     Driver imon, table rc-imon-mce
> >     Supported protocols: rc-6 
> >     Enabled protocols: rc-6 
> >     Name: iMON Remote (15c2:ffdc)
> >     bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
> >     Repeat delay = 500 ms, repeat period = 125 ms
> > Found /sys/class/rc/rc1/ (/dev/input/event16) with:
> >     Driver dvb_usb_af9035, table rc-empty
> >     Supported protocols: nec 
> >     Enabled protocols: 
> >     Name: Leadtek WinFamst DTV Dongle Dual
> >     bus: 3, vendor/product: 0413:6a05, version: 0x0200
> >     Repeat delay = 500 mss, repeat period = 125 ms
> 
> Looks like it's neither rc6 nor nec then.
> 
> If you don't have the right receiver then all of this a bit academic.
> Maybe it's possible to port to rc-core with the existing scancodes.

I may have given bad information here - I need to check whether the
IR receivers for these devices are properly connected. That might be
why there was no response...

Thanks for your help so far
Vince
