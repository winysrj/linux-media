Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35154 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbcKRMOj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 07:14:39 -0500
Received: by mail-pf0-f196.google.com with SMTP id i88so13489259pfk.2
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2016 04:14:38 -0800 (PST)
Date: Fri, 18 Nov 2016 23:14:25 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161118121422.GA1986@shambles.local>
References: <20161116105256.GA9998@shambles.local>
 <20161117134526.GA8485@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161117134526.GA8485@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 17, 2016 at 01:45:26PM +0000, Sean Young wrote:
> On Wed, Nov 16, 2016 at 09:52:58PM +1100, Vincent McIntyre wrote:
> > I have a fairly old dvico dual digital 4 tuner and remote.
> > There seem to be some issues with support for it, can I help fix them?
> > 
> > I am using ir-keytable 1.10.0-1 on Ubuntu 16.04 LTS,
> > with kernel 4.4.0-47-generic (package version 4.4.0-47-generic)
> > 
> > The remote's keymapping is the one in /lib/udev/rc_keymaps/dvico_mce;
> > kernel support for the device is in media/usb/dvb-usb/cxusb.c.
> > 
> > Mostly it works, in that I get correct keycodes back from evtest
> > and ir-keytable -t. But I want to change some of the keycode mappings
> > and that is not working.
> 
> I suspect the problem here is rc-core is not used and 
> legacy_dvb_usb_setkeycode has a bug (it has several problems).
> 
> It would be nicer if we could move it rc-core, but for that to work
> we need to know what scancodes remote sends (and in what protocol).
> A scancode of 0xfe47 is not a valid RC5 scancode.
 
So are you saying that the hex codes in the rc_map_dvico_mce_table
struct are invalid (at least in some cases)?

How can I tell what protocol is in use?
0x00010001 doesn't mean much to me; I did search the linux source
for the code but didn't find any helpful matches.

> Would it be possible to test the remote with another device (say an
> usb mce receiver or so) and see what scancodes it sends? Then we can
> translate the keymap to a real one and make the cxusb driver send
> correct scancodes to rc-core.

Great idea. Do you mean something like [1]?
Or the (presumably generic) receiver that comes with [2]?
Would a FLIRC work?

Probably dumb question - in this machine I also have
an iMon Remote (152c:ffdc)
and Leadtek WinFast DTV Dongle Dual
Do you think either of those would be helpful?
I tried evtest with them and the remote, no responses.

# ir-keytable
Found /sys/class/rc/rce0/ (/dev/input/event5) with:
    Driver imon, table rc-imon-mce
    Supported protocols: rc-6 
    Enabled protocols: rc-6 
    Name: iMON Remote (15c2:ffdc)
    bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
    Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc1/ (/dev/input/event16) with:
    Driver dvb_usb_af9035, table rc-empty
    Supported protocols: nec 
    Enabled protocols: 
    Name: Leadtek WinFamst DTV Dongle Dual
    bus: 3, vendor/product: 0413:6a05, version: 0x0200
    Repeat delay = 500 mss, repeat period = 125 ms

Thanks
Vince

[1] http://www.ebay.com.au/itm/New-HP-USB-MCE-IR-Wireless-Receiver-Windows-7-Vista-/261127073131
[2] https://www.jaycar.com.au/home-theatre-pc-remote-control/p/XC4939

