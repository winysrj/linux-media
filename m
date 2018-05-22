Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41877 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbeEVJwz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 05:52:55 -0400
Date: Tue, 22 May 2018 10:52:53 +0100
From: Sean Young <sean@mess.org>
To: just me <jod35fan@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable protocol setup broken and no ir events
Message-ID: <20180522095253.6myq6gpkpllxuk2b@gofer.mess.org>
References: <CAE1XbD34QGBnjh-Gqh_U8q5xBr7ODen5eXrcwg-7GzMHJshoww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1XbD34QGBnjh-Gqh_U8q5xBr7ODen5eXrcwg-7GzMHJshoww@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 21, 2018 at 11:37:10AM +0300, just me wrote:
> Package: ir-keytable
> Version: 1.14.2-1, 1.12.3-1
> System:
>   Host: ryzenpc Kernel: 4.16.0-rc7+ x86_64 bits: 64 Desktop: Xfce
> 4.12.4 Distro: Debian GNU/Linux buster/sid
> 
> I have 3 usb dvb-t sticks: Alink DTU ( driver dvb_usb_af9035), MSI
> DigiVox mini II (driver dvb_usb_af9015) and Realtek RTL2832U (driver
> dvb_usb_rtl28xx)
> 
> None of the remote controllers does not work. They did work with Debian
> Jessie a couple of years ago. I tested the remote controller of Alink
> DTU with a programmable remote control and I can record events with it.
> 
> With ir-keytable the protocal can not be set and it shows no protocols
> although the protocol is defined in the keytable file.
> 
> xfce@ryzenpc:~$ sudo ir-keytable
> Found /sys/class/rc/rc1/ (/dev/input/event19) with:
> Name: Realtek RTL2832U reference design
> Driver: dvb_usb_rtl28xxu, table: rc-empty
> Supported protocols: rc-5 rc-5-sz jvc sony nec sanyo mce_kbd
> rc-6 sharp xmp Enabled protocols:

No lirc? Would you mind posting the kernel config and dmesg please.

> bus: 3, vendor/product: 0bda:2838, version: 0x0100
> Repeat delay = 500 ms, repeat period = 125 ms

> Found /sys/class/rc/rc0/ (/dev/input/event18) with:
> Name: ITE 9135(9006) Generic
> Driver: dvb_usb_af9035, table: rc-it913x-v1
> Supported protocols:
> Enabled protocols:

Very strange, it's like it hasn't detected the IR on line:

https://github.com/torvalds/linux/blob/master/drivers/media/usb/dvb-usb-v2/af9035.c?utf8=%E2%9C%93#L1880

> bus: 3, vendor/product: 048d:9006, version: 0x0200
> Repeat delay = 500 ms, repeat period = 125 ms
> 
> 
> xfce@ryzenpc:~$ sudo ir-keytable -p NEC -d /dev/input/event18
> Invalid protocols selected
> Couldn't change the IR protocols
> 
> xfce@ryzenpc:~$ sudo ir-keytable -p NEC -d /dev/input/event19
> Invalid protocols selected
> Couldn't change the IR protocols

Would you mind retrying that with "sudo ir-keytable -s rc0 -p nec" (or rc1),
I'm not sure it will work by selecting input device.

> No events shown with evtest and ir-keytable -t.
> 
> I am using the amd-staging-drm-next kernel.  I tested also with the
> stock Debian  kernel 4.15. I tested also with the latest Manjaro Linux.

A git bisect would be ideal. I did not spot anything from looking at the
code.

Thanks,

Sean
