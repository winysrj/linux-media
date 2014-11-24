Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52859 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaKXKYp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 05:24:45 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so11868954wgg.33
        for <linux-media@vger.kernel.org>; Mon, 24 Nov 2014 02:24:44 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 12:24:44 +0200
Message-ID: <CAAZRmGx=gTVmcY7WsiW6=+vO56tcP4ZRH6cSnaN-iWWVqoRZNQ@mail.gmail.com>
Subject: v4l-utils: possible ir-keytable bug
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've got an issue with ir-keytable when I try to use the -d parameter
to choose the device.

I've got one device:

olli@dl160:~$ sudo ir-keytable -v
Found device /sys/class/rc/rc0/
Input sysfs node is /sys/class/rc/rc0/input18/
Event sysfs node is /sys/class/rc/rc0/input18/event2/
Parsing uevent /sys/class/rc/rc0/input18/event2/uevent
/sys/class/rc/rc0/input18/event2/uevent uevent MAJOR=13
/sys/class/rc/rc0/input18/event2/uevent uevent MINOR=66
/sys/class/rc/rc0/input18/event2/uevent uevent DEVNAME=input/event2
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-terratec-slim-2
/sys/class/rc/rc0/uevent uevent DRV_NAME=em28xx
input device is /dev/input/event2
/sys/class/rc/rc0/protocols protocol rc-5 (disabled)
/sys/class/rc/rc0/protocols protocol nec (enabled)
/sys/class/rc/rc0/protocols protocol rc-6 (disabled)
Found /sys/class/rc/rc0/ (/dev/input/event2) with:
        Driver em28xx, table rc-terratec-slim-2
        Supported protocols: NEC RC-5 RC-6
        Enabled protocols: NEC
        Name: em28xx IR (em28178 #0)
        bus: 3, vendor/product: eb1a:8179, version: 0x0001
        Repeat delay = 500 ms, repeat period = 125 ms

But when I try to change the protocol using the -d parameter, I get an error:

olli@dl160:~$ sudo ir-keytable -v -p RC-6 -d /dev/input/event2
Opening /dev/input/event2
Input Protocol version: 0x00010001
Invalid protocols selected
Couldn't change the IR protocols

However, if instead of -d I use -s it works fine:

olli@dl160:~$ sudo ir-keytable -v -p RC-6 -s rc0
Found device /sys/class/rc/rc0/
Input sysfs node is /sys/class/rc/rc0/input18/
Event sysfs node is /sys/class/rc/rc0/input18/event2/
Parsing uevent /sys/class/rc/rc0/input18/event2/uevent
/sys/class/rc/rc0/input18/event2/uevent uevent MAJOR=13
/sys/class/rc/rc0/input18/event2/uevent uevent MINOR=66
/sys/class/rc/rc0/input18/event2/uevent uevent DEVNAME=input/event2
Parsing uevent /sys/class/rc/rc0/uevent
/sys/class/rc/rc0/uevent uevent NAME=rc-terratec-slim-2
/sys/class/rc/rc0/uevent uevent DRV_NAME=em28xx
input device is /dev/input/event2
/sys/class/rc/rc0/protocols protocol rc-5 (disabled)
/sys/class/rc/rc0/protocols protocol nec (enabled)
/sys/class/rc/rc0/protocols protocol rc-6 (disabled)
Opening /dev/input/event2
Input Protocol version: 0x00010001
Protocols changed to RC-6

Am I doing something daft or is there an issue?

Cheers,
-olli
