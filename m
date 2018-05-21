Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:53831 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbeEUIhM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:37:12 -0400
Received: by mail-it0-f41.google.com with SMTP id n64-v6so20175226itb.3
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 01:37:11 -0700 (PDT)
MIME-Version: 1.0
From: just me <jod35fan@gmail.com>
Date: Mon, 21 May 2018 11:37:10 +0300
Message-ID: <CAE1XbD34QGBnjh-Gqh_U8q5xBr7ODen5eXrcwg-7GzMHJshoww@mail.gmail.com>
Subject: ir-keytable protocol setup broken and no ir events
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Package: ir-keytable
Version: 1.14.2-1, 1.12.3-1
System:
  Host: ryzenpc Kernel: 4.16.0-rc7+ x86_64 bits: 64 Desktop: Xfce
4.12.4 Distro: Debian GNU/Linux buster/sid

I have 3 usb dvb-t sticks: Alink DTU ( driver dvb_usb_af9035), MSI
DigiVox mini II (driver dvb_usb_af9015) and Realtek RTL2832U (driver
dvb_usb_rtl28xx)

None of the remote controllers does not work. They did work with Debian
Jessie a couple of years ago. I tested the remote controller of Alink
DTU with a programmable remote control and I can record events with it.

With ir-keytable the protocal can not be set and it shows no protocols
although the protocol is defined in the keytable file.

xfce@ryzenpc:~$ sudo ir-keytable
Found /sys/class/rc/rc1/ (/dev/input/event19) with:
Name: Realtek RTL2832U reference design
Driver: dvb_usb_rtl28xxu, table: rc-empty
Supported protocols: rc-5 rc-5-sz jvc sony nec sanyo mce_kbd
rc-6 sharp xmp Enabled protocols:
bus: 3, vendor/product: 0bda:2838, version: 0x0100
Repeat delay = 500 ms, repeat period = 125 ms
Found /sys/class/rc/rc0/ (/dev/input/event18) with:
Name: ITE 9135(9006) Generic
Driver: dvb_usb_af9035, table: rc-it913x-v1
Supported protocols:
Enabled protocols:
bus: 3, vendor/product: 048d:9006, version: 0x0200
Repeat delay = 500 ms, repeat period = 125 ms


xfce@ryzenpc:~$ sudo ir-keytable -p NEC -d /dev/input/event18
Invalid protocols selected
Couldn't change the IR protocols

xfce@ryzenpc:~$ sudo ir-keytable -p NEC -d /dev/input/event19
Invalid protocols selected
Couldn't change the IR protocols

No events shown with evtest and ir-keytable -t.

I am using the amd-staging-drm-next kernel.  I tested also with the
stock Debian  kernel 4.15. I tested also with the latest Manjaro Linux.

BR,
Eero
