Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33980 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752088AbcKRX6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:58:05 -0500
Received: by mail-pg0-f67.google.com with SMTP id e9so21518971pgc.1
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2016 15:58:04 -0800 (PST)
Date: Sat, 19 Nov 2016 10:57:54 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20161118235751.GA4498@shambles.local>
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
> 
> At the moment it's not easy to determine what protocol an remote uses;
> I would like to change that but for now, the following is probably
> the easiest way.
> 
> cd /sys/class/rc/rc1 # replace rc1 with your receiver
> for i in $(<protocols); do echo +$i > protocols; done
> echo 3 > /sys/module/rc_core/parameters/debug
> journal -f -k
> 
> Protocol numbers are defined in enum rc_type, see include/media/rc-map.h

I tried this with the rc1 device as a test. I get this odd result:
# cat protocols
nec
# echo '+nec' > protocols
bash: echo: write error: Invalid argument

and ir-keytable still shows no protocols enabled
# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
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
    Name: Leadtek WinFast DTV Dongle Dual
    bus: 3, vendor/product: 0413:6a05, version: 0x0200
    Repeat delay = 500 ms, repeat period = 125 ms

I messed around some more with ir-keytable and got more segfaults
if I try to use the -d argument.

# ir-keytable -d /dev/input/event16 -p NEC -p RC6 -w /lib/udev/rc_keymaps/rc6_mce 
Read rc6_mce table
Wrote 63 keycode(s) to driver
Segmentation fault (core dumped)

-s at least doesn't segfault, but doesn't advance the cause.

# ir-keytable -s rc1 -p NEC -p RC6 -w /lib/udev/rc_keymaps/rc6_mce 
Read rc6_mce table
Wrote 63 keycode(s) to driver
/sys/class/rc/rc1//protocols: Invalid argument
Couldn't change the IR protocols


# ir-keytable -s rc1 -p NEC -w /lib/udev/rc_keymaps/winfast
Read winfast table
Wrote 56 keycode(s) to driver
/sys/class/rc/rc1//protocols: Invalid argument
Couldn't change the IR protocols

Vince
