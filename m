Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:60873 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752712AbdBTRgm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 12:36:42 -0500
Date: Mon, 20 Feb 2017 17:13:09 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20170220171309.GA26632@gofer.mess.org>
References: <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
 <20161127193510.GA20548@gofer.mess.org>
 <20161130090229.GB639@shambles.local>
 <CAEsFdVOb8tWN=6OfnpdJqb9BZ4s-DARF53zgbyhz-_a0zac0Gg@mail.gmail.com>
 <20170202233533.GA14357@gofer.mess.org>
 <CAEsFdVMhbxb3d=_ugYjfYSCRZsQMhtt=kmsqX81x-6UjTYc-bg@mail.gmail.com>
 <20170204191050.GA31779@gofer.mess.org>
 <CAEsFdVM14VngTM5X=qWTitgwox+4yD8heUqjULe8C=3z2P+h3Q@mail.gmail.com>
 <CAEsFdVMb+-iTGKnBXi1MkB+_ihb5AwG2LZnRfXzEf4Hru33T0g@mail.gmail.com>
 <CAEsFdVOfGFJ9HYav2h0gNkpdhYzbnVxnPbOaZW+HpO3KE1S9-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsFdVOfGFJ9HYav2h0gNkpdhYzbnVxnPbOaZW+HpO3KE1S9-w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vincent,

Thanks for testing this.

On Fri, Feb 17, 2017 at 12:05:50AM +1100, Vincent McIntyre wrote:
> Hi again
> 
> after you kindly fixed media_build for me I applied the nec protocol
> patch and tried again.
> 
> $ sudo ir-keytable
> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
>         Driver imon, table rc-imon-mce
>         Supported protocols: rc-6
>         Enabled protocols: rc-6
>         Name: iMON Remote (15c2:ffdc)
>         bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
>         Repeat delay = 500 ms, repeat period = 125 ms
> Found /sys/class/rc/rc1/ (/dev/input/event11) with:
>         Driver dvb_usb_cxusb, table rc-dvico-mce
>         Supported protocols: nec
>         Enabled protocols:
>         Name: IR-receiver inside an USB DVB re
>         bus: 3, vendor/product: 0fe9:db78, version: 0x827b
>         Repeat delay = 500 ms, repeat period = 125 ms
> Found /sys/class/rc/rc2/ (/dev/input/event16) with:
>         Driver dvb_usb_af9035, table rc-empty
>         Supported protocols: nec
>         Enabled protocols:
>         Name: Leadtek WinFast DTV Dongle Dual
>         bus: 3, vendor/product: 0413:6a05, version: 0x0200
>         Repeat delay = 500 ms, repeat period = 125 ms
> 
> $ sudo ir-keytable -v --sysdev rc1
> Found device /sys/class/rc/rc0/
> Found device /sys/class/rc/rc1/
> Found device /sys/class/rc/rc2/
> Input sysfs node is /sys/class/rc/rc0/input8/
> Event sysfs node is /sys/class/rc/rc0/input8/event5/
> Parsing uevent /sys/class/rc/rc0/input8/event5/uevent
> /sys/class/rc/rc0/input8/event5/uevent uevent MAJOR=13
> /sys/class/rc/rc0/input8/event5/uevent uevent MINOR=69
> /sys/class/rc/rc0/input8/event5/uevent uevent DEVNAME=input/event5
> Parsing uevent /sys/class/rc/rc0/uevent
> /sys/class/rc/rc0/uevent uevent NAME=rc-imon-mce
> /sys/class/rc/rc0/uevent uevent DRV_NAME=imon
> input device is /dev/input/event5
> /sys/class/rc/rc0/protocols protocol rc-6 (enabled)
> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
>         Driver imon, table rc-imon-mce
>         Supported protocols: rc-6
>         Enabled protocols: rc-6
>         Name: iMON Remote (15c2:ffdc)
>         bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
>         Repeat delay = 500 ms, repeat period = 125 ms
> Input sysfs node is /sys/class/rc/rc1/input17/
> Event sysfs node is /sys/class/rc/rc1/input17/event11/
> Parsing uevent /sys/class/rc/rc1/input17/event11/uevent
> /sys/class/rc/rc1/input17/event11/uevent uevent MAJOR=13
> /sys/class/rc/rc1/input17/event11/uevent uevent MINOR=75
> /sys/class/rc/rc1/input17/event11/uevent uevent DEVNAME=input/event11
> Parsing uevent /sys/class/rc/rc1/uevent
> /sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
> /sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
> input device is /dev/input/event11
> /sys/class/rc/rc1/protocols protocol nec (disabled)
> Found /sys/class/rc/rc1/ (/dev/input/event11) with:
>         Driver dvb_usb_cxusb, table rc-dvico-mce
>         Supported protocols: nec
>         Enabled protocols:
>         Name: IR-receiver inside an USB DVB re
>         bus: 3, vendor/product: 0fe9:db78, version: 0x827b
>         Repeat delay = 500 ms, repeat period = 125 ms
> Input sysfs node is /sys/class/rc/rc2/input19/
> Event sysfs node is /sys/class/rc/rc2/input19/event16/
> Parsing uevent /sys/class/rc/rc2/input19/event16/uevent
> /sys/class/rc/rc2/input19/event16/uevent uevent MAJOR=13
> /sys/class/rc/rc2/input19/event16/uevent uevent MINOR=80
> /sys/class/rc/rc2/input19/event16/uevent uevent DEVNAME=input/event16
> Parsing uevent /sys/class/rc/rc2/uevent
> /sys/class/rc/rc2/uevent uevent NAME=rc-empty
> /sys/class/rc/rc2/uevent uevent DRV_NAME=dvb_usb_af9035
> input device is /dev/input/event16
> /sys/class/rc/rc2/protocols protocol nec (disabled)
> Found /sys/class/rc/rc2/ (/dev/input/event16) with:
>         Driver dvb_usb_af9035, table rc-empty
>         Supported protocols: nec
>         Enabled protocols:
>         Name: Leadtek WinFast DTV Dongle Dual
>         bus: 3, vendor/product: 0413:6a05, version: 0x0200
>         Repeat delay = 500 ms, repeat period = 125 ms
> 
> So only rc0 has any protocols enabled. Let's try to enable nec on rc1
> 
> $ sudo /usr/bin/ir-keytable -s rc1 -c
> Old keytable cleared
> $ sudo /usr/bin/ir-keytable -s rc1 -w /etc/rc_keymaps/dvico-remote
> Read dvico_mce table
> Wrote 45 keycode(s) to driver
> Invalid protocols selected
> Couldn't change the IR protocols
> $ sudo /usr/bin/ir-keytable -s rc1 -p nec -v
> Found device /sys/class/rc/rc0/
> Found device /sys/class/rc/rc1/
> Found device /sys/class/rc/rc2/
> Input sysfs node is /sys/class/rc/rc1/input17/
> Event sysfs node is /sys/class/rc/rc1/input17/event11/
> Parsing uevent /sys/class/rc/rc1/input17/event11/uevent
> /sys/class/rc/rc1/input17/event11/uevent uevent MAJOR=13
> /sys/class/rc/rc1/input17/event11/uevent uevent MINOR=75
> /sys/class/rc/rc1/input17/event11/uevent uevent DEVNAME=input/event11
> Parsing uevent /sys/class/rc/rc1/uevent
> /sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
> /sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
> input device is /dev/input/event11
> /sys/class/rc/rc1/protocols protocol nec (disabled)
> Opening /dev/input/event11
> Input Protocol version: 0x00010001
> /sys/class/rc/rc1//protocols: Invalid argument
> Couldn't change the IR protocols

On the cxusb the protocol is now nec, and that is the only protocol it
supports, you can't change it.

> $ sudo cat /sys/class/rc/rc1/protocols
> nec
> $ sudo sh
> # echo "+rc-5 +nec +rc-6 +jvc +sony +rc-5-sz +sanyo +sharp +xmp" >
> /sys/class/rc/rc1/protocols
> bash: echo: write error: Invalid argument
> # cat  /sys/class/rc/rc1/protocols
> nec
> In kern.log I got:
> kernel: [ 2293.491534] rc_core: Normal protocol change requested
> kernel: [ 2293.491538] rc_core: Protocol switching not supported
> 
> # echo "+nec" > /sys/class/rc/rc1/protocols
> bash: echo: write error: Invalid argument
> kernel: [ 2390.832476] rc_core: Normal protocol change requested
> kernel: [ 2390.832481] rc_core: Protocol switching not supported

That is expected. Does the the keymap actually work? 

ir-keytable -r -t

Thanks,

Sean
