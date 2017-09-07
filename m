Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48755 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbdIGHdr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 03:33:47 -0400
Date: Thu, 7 Sep 2017 08:33:45 +0100
From: Sean Young <sean@mess.org>
To: =?iso-8859-1?B?Ik9saXZlciBN/GxsZXIi?= <oliver.mueller85@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: BUGREPORT: IR keytable 1.12.3
Message-ID: <20170907073345.oths2wgfurnxv7i2@gofer.mess.org>
References: <trinity-e1aa6ee8-e9cc-4001-8e19-92255757329d-1504725614678@3c-app-gmx-bs76>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-e1aa6ee8-e9cc-4001-8e19-92255757329d-1504725614678@3c-app-gmx-bs76>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

On Wed, Sep 06, 2017 at 09:20:14PM +0200, "Oliver Müller" wrote:
> BUG IR keytable 1.12.3
>  
> OS: Distributor ID:    Debian
>     Description:    Debian GNU/Linux 9.1 (stretch)
>     Release:    9.1
>     Codename:    stretch
>  
> Kernel: 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u3 (2017-08-06) x86_64 GNU/Linux
>  
> Programversion: IR keytable control version 1.12.3
>  
> IR-Device: I: Bus=0003 Vendor=0471 Product=20cc Version=0100
>            N: Name="PHILIPS MCE USB IR Receiver- Spinel plus"
>            P: Phys=usb-0000:06:00.0-2/input0
>            S: Sysfs=/devices/pci0000:00/0000:00:15.2/0000:06:00.0/usb1/1-2/1-2:1.0/0003:0471:20CC.0006/input/input14
>            U: Uniq=
>            H: Handlers=sysrq kbd leds event3
>            B: PROP=0
>            B: EV=120013
>            B: KEY=c0000 40000000000 0 58000 8001f84000c004 e0beffdf01cfffff fffffffffffffffe
>            B: MSC=10
>            B: LED=1f
>  
> ir-keytable gives /sys/class/rc/: No such file or directory

Could you please post the output of dmesg (or journalctl -b -k), it would be
useful to see the output of the usb probe.

> using ir-keytable -d /dev/input/event3 I get this output with no mention of the protocol(s):
> Name: PHILIPS MCE USB IR Receiver- Spi
> bus: 3, vendor/product: 0471:20cc, version: 0x0100
>
> if I use ir-keytable -s rc0 instead it comes back to /sys/class/rc/: No such file or directory which is also true
>  
> ir-keytable -d /dev/input/event3 -t works, ir-keytable -d /dev/input/event3 -r also works
>  
> after I introduce the new keymap, like so ir-keytable -d /dev/input/event3 -c -w /etc/rc_keymaps/rc6_mce_zotac_zbox-ad05br it doesn't work. I can't read the newly introduced keymap nor can I test it. Of course can't I be sure which protocol to use because it's not displayed in the initial output.
>  
> thx in advance

Thanks

Sean
