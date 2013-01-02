Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57757 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3ABDex (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 22:34:53 -0500
Received: by mail-pb0-f54.google.com with SMTP id wz12so7621262pbc.27
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 19:34:52 -0800 (PST)
Message-ID: <50E3AAD8.6080703@gmail.com>
Date: Tue, 01 Jan 2013 20:34:48 -0700
From: Nathan Friess <nathan.friess@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge 2250 IR support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Is there any support for the IR port on Hauppauge WinTV-HVR-2250 cards 
at this time?

After a lot of googling, there seems to be some reports that the IR did 
work at some point using the ir-kbd-i2c driver, but most results are 
from 2010 or older.  Loading that driver on a 3.7.1 kernel doesn't seem 
to do anything (nothing shows up in dmesg and no devices in /dev/input/ 
appear).  I also have the latest media_tree from git, built it, and 
tried it with no success.

The saa7164 module which is used for the video components does seem to 
make some i2c buses available, as shown in /sys/bus/i2c/devices:

i2c-2 -> ../../../devices/pci0000:00/0000: 
00:1c.3/0000:03:00.0/i2c-2
i2c-3 -> ../../../devices/pci0000:00/0000: 
00:1c.3/0000:03:00.0/i2c-3
i2c-4 -> ../../../devices/pci0000:00/0000: 
00:1c.3/0000:03:00.0/i2c-4

but it seems that no devices are detected on the bus.  Am I missing a 
step, or is IR support on this card not possible?

Thanks,

Nathan
