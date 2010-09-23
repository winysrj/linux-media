Return-path: <mchehab@pedra>
Received: from ebed.etf.cuni.cz ([195.113.5.3]:51023 "EHLO ebed.etf.cuni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab0IWMqK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 08:46:10 -0400
Date: Thu, 23 Sep 2010 12:56:23 +0200
From: Petr Tomasek <tomasek@etf.cuni.cz>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Yakumo QuickStick DVB-T doesn't load firmware
Message-ID: <20100923105623.GA28052@ebed.etf.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hello!

My "Yakumo QuickStick" suddenly stopped to work. It now doesn't load
the firmware (i.e. it stays "cold"):

XXX kernel: usb 1-3: new high speed USB device using ehci_hcd and address 10
XXX kernel: usb 1-3: New USB device found, idVendor=14ee, idProduct=0225
XXX kernel: usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
XXX dalet kernel: usb 1-3: configuration #1 chosen from 1 choice

(I tried it on two systems, where it worked before. All Firmware files
are in /lib/firmware).

Is there anything I could do? Can I debug what's going on somehow?

My current kernel:

$ uname -a
Linux dalet 2.6.32.21-166.fc12.i686.PAE #1 SMP Fri Aug 27 06:33:34 UTC 2010 i686 i686 i386 GNU/Linux

-- 
Petr Tomasek <http://www.etf.cuni.cz/~tomasek>
Jabber: butrus@jabbim.cz

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EA 355:001  DU DU DU DU
EA 355:002  TU TU TU TU
EA 355:003  NU NU NU NU NU NU NU
EA 355:004  NA NA NA NA NA
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


