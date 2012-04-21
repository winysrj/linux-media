Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64546 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2DURAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 13:00:46 -0400
Received: by bkcik5 with SMTP id ik5so7782802bkc.19
        for <linux-media@vger.kernel.org>; Sat, 21 Apr 2012 10:00:44 -0700 (PDT)
Message-ID: <4F92E7BA.6010106@gmail.com>
Date: Sat, 21 Apr 2012 19:00:42 +0200
From: Michael Schmitt <tcwardrobe@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: ir-keytable / in-kernel lirc drivers confusion...
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

[  204.360019] usb 4-2: new low-speed USB device number 2 using uhci_hcd
[  204.540036] usb 4-2: New USB device found, idVendor=0471, idProduct=20cc
[  204.540041] usb 4-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[  204.540044] usb 4-2: Product: MCE USB IR Receiver- Spinel plus
[  204.540047] usb 4-2: Manufacturer: PHILIPS
[  204.603640] input: PHILIPS MCE USB IR Receiver- Spinel plus as 
/devices/pci0000:00/0000:00:1d.3/usb4/4-2/4-2:1.0/input/input13
[  204.603895] generic-usb 0003:0471:20CC.0009: input,hiddev0,hidraw4: 
USB HID v1.00 Keyboard [PHILIPS MCE USB IR Receiver- Spinel plus] on 
usb-0000:00:1d.3-2/input0
mschmitt@adrastea:~$ ir-keytable -t
/sys/class/rc/: No such file or directory
mschmitt@adrastea:~$

basically I just want this device to be used with ir-keytable. Other 
remote receivers "just work". Regardless if built-in a machine or 
plugged in via USB, in generell they get recognized, a rc-keytable is 
assigned and ir-keytable works with them automatically (I know 
ir-keytable -t only works with root privs, but I already checked that, 
the paste was done afterwards and a missing /sys/class/rc is the issue 
not privs). So what do I need to do to get ir-keytable working?

Apart from that, if one would be so kind and point me in the right 
direction for a document explaining the "Linux and RCs today" topic a 
bit. I used to use plain old lirc but the whole situation has changed as 
it seems. In genereal I know enough to get things working again IF 
ir-keytable works and /sys/class/rc IS there, but as it is missing with 
this receiver and as said I know very little about the whole "new" 
approach with in-kernel lirc / rc-stuff I have no idea where to poke / 
look. Is it a kernel issue? At least I tried a fairly recent 3.3 kernel 
and a stable 3.2 kernel (I am on Debian sid and the 3.3 kernel I got 
from "experimental)

In addition I am quite confused when a RC is recognized as a keyboard 
and keypresses are interpreted as a normal dev-input-device. How do I 
prevent that from happening?

regards
Michael
