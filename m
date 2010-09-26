Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:60967 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0IZQzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 12:55:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OzuVE-000796-F5
	for linux-media@vger.kernel.org; Sun, 26 Sep 2010 18:55:04 +0200
Received: from 67.55.0.99 ([67.55.0.99])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 26 Sep 2010 18:55:04 +0200
Received: from mike by 67.55.0.99 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 26 Sep 2010 18:55:04 +0200
To: linux-media@vger.kernel.org
From: Mike <mike@acanac.net>
Subject: TeVii S660 continuity errors
Date: Sun, 26 Sep 2010 18:52:06 +0200
Message-ID: <i7ntnm$ej$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Is anyone else having continuity problems with the S660? causing rare 
glitching on SD content, and glitching on HD content very often.

Turning on the `disable_rc_polling' parameter for the dvb_usb module 
seems to help, but it's hard to tell for sure. Turning on the 
`dvb_demux_tscheck' parameter for the dvb_core module shows continuity 
counter errors every few seconds in the syslog, along with a peculiar 
callback ratelimit line before each set of continuity counter errors. 
Interestingly, the `expected' value is one away from the `got' value, 
doubtful it's just by chance?

Here is a sample from the syslog:
[51302.316543] TEI detected. PID=0x1c79 data1=0xfc
[51302.316547] TS packet counter mismatch. PID=0x1c79 expected 0xd got 0xc
[51302.316550] TEI detected. PID=0x7b6 data1=0xa7
[51302.316552] TS packet counter mismatch. PID=0x7b6 expected 0x2 got 0x8
[51302.316555] TEI detected. PID=0x1e4 data1=0xe1
[51302.316558] TEI detected. PID=0x1324 data1=0xd3
[51302.316561] TS packet counter mismatch. PID=0x1324 expected 0xb got 0x0
[51302.316564] TS packet counter mismatch. PID=0x1c2c expected 0x0 got 0xf
[51302.316567] TS packet counter mismatch. PID=0x1f09 expected 0xc got 0xe
[51307.329040] __ratelimit: 397 callbacks suppressed
[51307.329044] TS packet counter mismatch. PID=0xfaf expected 0x1 got 0x0
[51307.339404] TS packet counter mismatch. PID=0x3fe expected 0x7 got 0x6
[51307.362671] TS packet counter mismatch. PID=0xfaf expected 0x1 got 0x0
[51307.367882] TS packet counter mismatch. PID=0x3fd expected 0x4 got 0x3

The bitrate is about 40 or 50Mbps, depending on what transponder is 
tuned. This is reported by the dvbcore driver in the syslog when the 
`dvb_demux_speedcheck' parameter is turned on.

I've also experienced input lag, the computer locking up for a second or 
few, seemed to be during tuning. This seems similar to something that 
was reported by someone on this list in the past. Disabling RC polling 
seems to have helped with that.

I'm using hts-tvheadend, and it reports continuity errors sometimes as 
well (though not as often as the driver does in the syslog). The 
frontend is XBMC on another computer, connected via wired ethernet.

The S660 is connected directly via USB to a MacbookPro (Nvidia MCP79 
chipset). The computer is running Debian sid 32bit (2.6.32-5-686) with 
s2-liplianin from yesterday, and the firmware from the 
100315_Beta_linux_tevii_ds3000.rar drivers from tevii.com. I've also 
tried running with the drivers from that rar, to no avail.
Everything works well (no glitching) in Windows 7 x64 with the `DVB-HD 
2020100830.rar' drivers from tevii.com

Is this some sort of timing issue? an issue with the USB bus being 
overloaded? (I've tried removing most of the usb modules, including 
ohci_hcd, hid, etc). How can I troubleshoot which driver is at fault?

Is this a firmware issue? Can new firmware be extracted from the 
20100830 Windows driver? How?

Any help/suggestions appreciated.
Thanks :)

