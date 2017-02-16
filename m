Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37190 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754297AbdBPNFw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 08:05:52 -0500
Received: by mail-wm0-f52.google.com with SMTP id v77so14670907wmv.0
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 05:05:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEsFdVMb+-iTGKnBXi1MkB+_ihb5AwG2LZnRfXzEf4Hru33T0g@mail.gmail.com>
References: <20161123123851.GB14257@shambles.local> <20161123223419.GA25515@gofer.mess.org>
 <20161124121253.GA17639@shambles.local> <20161124133459.GA32385@gofer.mess.org>
 <CAEsFdVPbKm1cDmAynL+-PFC=hQ=+-gAcJ04ykXVM6Y6bappcUA@mail.gmail.com>
 <20161127193510.GA20548@gofer.mess.org> <20161130090229.GB639@shambles.local>
 <CAEsFdVOb8tWN=6OfnpdJqb9BZ4s-DARF53zgbyhz-_a0zac0Gg@mail.gmail.com>
 <20170202233533.GA14357@gofer.mess.org> <CAEsFdVMhbxb3d=_ugYjfYSCRZsQMhtt=kmsqX81x-6UjTYc-bg@mail.gmail.com>
 <20170204191050.GA31779@gofer.mess.org> <CAEsFdVM14VngTM5X=qWTitgwox+4yD8heUqjULe8C=3z2P+h3Q@mail.gmail.com>
 <CAEsFdVMb+-iTGKnBXi1MkB+_ihb5AwG2LZnRfXzEf4Hru33T0g@mail.gmail.com>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Fri, 17 Feb 2017 00:05:50 +1100
Message-ID: <CAEsFdVOfGFJ9HYav2h0gNkpdhYzbnVxnPbOaZW+HpO3KE1S9-w@mail.gmail.com>
Subject: Re: ir-keytable: infinite loops, segfaults
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again

after you kindly fixed media_build for me I applied the nec protocol
patch and tried again.

$ sudo ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
        Driver imon, table rc-imon-mce
        Supported protocols: rc-6
        Enabled protocols: rc-6
        Name: iMON Remote (15c2:ffdc)
        bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
        Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc1/ (/dev/input/event11) with:
        Driver dvb_usb_cxusb, table rc-dvico-mce
        Supported protocols: nec
        Enabled protocols:
        Name: IR-receiver inside an USB DVB re
        bus: 3, vendor/product: 0fe9:db78, version: 0x827b
        Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc2/ (/dev/input/event16) with:
        Driver dvb_usb_af9035, table rc-empty
        Supported protocols: nec
        Enabled protocols:
        Name: Leadtek WinFast DTV Dongle Dual
        bus: 3, vendor/product: 0413:6a05, version: 0x0200
        Repeat delay = 500 ms, repeat period = 125 ms

$ sudo ir-keytable -v --sysdev rc1
Found device /sys/class/rc/rc0/
Found device /sys/class/rc/rc1/
Found device /sys/class/rc/rc2/
Input sysfs node is /sys/class/rc/rc0/input8/
Event sysfs node is /sys/class/rc/rc0/input8/event5/
Parsing uevent /sys/class/rc/rc0/input8/event5/uevent
/sys/class/rc/rc0/input8/event5/uevent uevent MAJOR=13
/sys/class/rc/rc0/input8/event5/uevent uevent MINOR=69
/sys/class/rc/rc0/input8/event5/uevent uevent DEVNAME=input/event5
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-imon-mce
/sys/class/rc/rc0/uevent uevent DRV_NAME=imon
input device is /dev/input/event5
/sys/class/rc/rc0/protocols protocol rc-6 (enabled)
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
        Driver imon, table rc-imon-mce
        Supported protocols: rc-6
        Enabled protocols: rc-6
        Name: iMON Remote (15c2:ffdc)
        bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
        Repeat delay = 500 ms, repeat period = 125 ms
Input sysfs node is /sys/class/rc/rc1/input17/
Event sysfs node is /sys/class/rc/rc1/input17/event11/
Parsing uevent /sys/class/rc/rc1/input17/event11/uevent
/sys/class/rc/rc1/input17/event11/uevent uevent MAJOR=13
/sys/class/rc/rc1/input17/event11/uevent uevent MINOR=75
/sys/class/rc/rc1/input17/event11/uevent uevent DEVNAME=input/event11
Parsing uevent /sys/class/rc/rc1/uevent
/sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
/sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
input device is /dev/input/event11
/sys/class/rc/rc1/protocols protocol nec (disabled)
Found /sys/class/rc/rc1/ (/dev/input/event11) with:
        Driver dvb_usb_cxusb, table rc-dvico-mce
        Supported protocols: nec
        Enabled protocols:
        Name: IR-receiver inside an USB DVB re
        bus: 3, vendor/product: 0fe9:db78, version: 0x827b
        Repeat delay = 500 ms, repeat period = 125 ms
Input sysfs node is /sys/class/rc/rc2/input19/
Event sysfs node is /sys/class/rc/rc2/input19/event16/
Parsing uevent /sys/class/rc/rc2/input19/event16/uevent
/sys/class/rc/rc2/input19/event16/uevent uevent MAJOR=13
/sys/class/rc/rc2/input19/event16/uevent uevent MINOR=80
/sys/class/rc/rc2/input19/event16/uevent uevent DEVNAME=input/event16
Parsing uevent /sys/class/rc/rc2/uevent
/sys/class/rc/rc2/uevent uevent NAME=rc-empty
/sys/class/rc/rc2/uevent uevent DRV_NAME=dvb_usb_af9035
input device is /dev/input/event16
/sys/class/rc/rc2/protocols protocol nec (disabled)
Found /sys/class/rc/rc2/ (/dev/input/event16) with:
        Driver dvb_usb_af9035, table rc-empty
        Supported protocols: nec
        Enabled protocols:
        Name: Leadtek WinFast DTV Dongle Dual
        bus: 3, vendor/product: 0413:6a05, version: 0x0200
        Repeat delay = 500 ms, repeat period = 125 ms

So only rc0 has any protocols enabled. Let's try to enable nec on rc1

$ sudo /usr/bin/ir-keytable -s rc1 -c
Old keytable cleared
$ sudo /usr/bin/ir-keytable -s rc1 -w /etc/rc_keymaps/dvico-remote
Read dvico_mce table
Wrote 45 keycode(s) to driver
Invalid protocols selected
Couldn't change the IR protocols
$ sudo /usr/bin/ir-keytable -s rc1 -p nec -v
Found device /sys/class/rc/rc0/
Found device /sys/class/rc/rc1/
Found device /sys/class/rc/rc2/
Input sysfs node is /sys/class/rc/rc1/input17/
Event sysfs node is /sys/class/rc/rc1/input17/event11/
Parsing uevent /sys/class/rc/rc1/input17/event11/uevent
/sys/class/rc/rc1/input17/event11/uevent uevent MAJOR=13
/sys/class/rc/rc1/input17/event11/uevent uevent MINOR=75
/sys/class/rc/rc1/input17/event11/uevent uevent DEVNAME=input/event11
Parsing uevent /sys/class/rc/rc1/uevent
/sys/class/rc/rc1/uevent uevent NAME=rc-dvico-mce
/sys/class/rc/rc1/uevent uevent DRV_NAME=dvb_usb_cxusb
input device is /dev/input/event11
/sys/class/rc/rc1/protocols protocol nec (disabled)
Opening /dev/input/event11
Input Protocol version: 0x00010001
/sys/class/rc/rc1//protocols: Invalid argument
Couldn't change the IR protocols

$ sudo cat /sys/class/rc/rc1/protocols
nec
$ sudo sh
# echo "+rc-5 +nec +rc-6 +jvc +sony +rc-5-sz +sanyo +sharp +xmp" >
/sys/class/rc/rc1/protocols
bash: echo: write error: Invalid argument
# cat  /sys/class/rc/rc1/protocols
nec
In kern.log I got:
kernel: [ 2293.491534] rc_core: Normal protocol change requested
kernel: [ 2293.491538] rc_core: Protocol switching not supported

# echo "+nec" > /sys/class/rc/rc1/protocols
bash: echo: write error: Invalid argument
kernel: [ 2390.832476] rc_core: Normal protocol change requested
kernel: [ 2390.832481] rc_core: Protocol switching not supported

dmesg during bootup is attached.
Cheers
Vince
