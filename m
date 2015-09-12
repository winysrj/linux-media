Return-path: <linux-media-owner@vger.kernel.org>
Received: from server7.websitehostserver.net ([173.236.25.210]:40315 "EHLO
	server7.websitehostserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbbILNvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2015 09:51:07 -0400
Received: from localhost ([127.0.0.1]:43086 helo=tomdaley.org)
	by server7.websitehostserver.net with esmtpa (Exim 4.85)
	(envelope-from <tom@tomdaley.org>)
	id 1Zakqj-001bKh-J2
	for linux-media@vger.kernel.org; Sat, 12 Sep 2015 08:28:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Sep 2015 07:28:13 -0600
From: Tom Daley <tom@tomdaley.org>
To: linux-media@vger.kernel.org
Subject: Kworld UB435-Q, can't use 2 simultaneously
Message-ID: <bc073b3a9e6e00bae5fc209fac5fc4a5@tomdaley.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Linux system running MythTV and previously used 2 Hauppauge 
950Q USB tuners and was able to use both tuners at the same time (watch 
from one while the other was recording).  Due to issues with the 
Hauppauge tuners, I recently switched to Kworld UB435-Q tuners and they 
work great until I attempt to use both tuners at the same time.  If I 
attempt to use both at the same time, both tuners freeze up.  The one 
that was activated first has most of the picture that was there and gets 
some disturbance and the tuner that was activated second has a mostly 
black picture with a few big square pixels and the sound on both is just 
a buzz.  If I stop one of the tuners the other will recover and work.   
This appears to be some sort of resource or locking issue in the driver, 
but that is just speculation on my part.

For the past few months I have been upgrading my kernel, in case a fix 
has gone in, but the problem persists.  I have tried 4.0.4, 4.1.5, and 
4.2.0.

My system is mostly Slackware64-14.1, with a current kernel.

I am a software developer by trade and have been working with Linux 
since 0.97p13 (a long time).  I am not familiar with video drivers, so I 
would need some pointers to get started working on this (if someone 
isn't already).

Is this a known issue?
I am willing and able to try things if needed or dig in and do the work 
myself.

Both tuners are plugged into a USB 2.0 port:
$ lsusb
Bus 003 Device 002: ID 1b80:e34c Afatech
Bus 003 Device 003: ID 1b80:e34c Afatech
Bus 004 Device 002: ID 051d:0002 American Power Conversion 
Uninterruptible Power Supply
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Kernel boot messages:
em28xx: New device  USB 2875 Device @ 480 Mbps (1b80:e34c, interface 0, 
class 0)
em28xx: DVB interface 0 found: bulk
em28xx: chip ID is em2874
em2874 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5d3e97ab
em2874 #0: EEPROM info:
em2874 #0:      microcode start address = 0x0004, boot configuration = 
0x01
em2874 #0:      AC97 audio (5 sample rates)
em2874 #0:      500mA max power
em2874 #0:      Table at offset 0x24, strings=0x206a, 0x048a, 0x0000
em2874 #0: Identified as KWorld USB ATSC TV Stick UB435-Q V3 (card=93)
em2874 #0: dvb set to bulk mode.
em2874 #1: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5d3e97ab
em2874 #1: EEPROM info:
em2874 #1:      microcode start address = 0x0004, boot configuration = 
0x01
em2874 #1:      AC97 audio (5 sample rates)
em2874 #1:      500mA max power
em2874 #1:      Table at offset 0x24, strings=0x206a, 0x048a, 0x0000
em2874 #1: Identified as KWorld USB ATSC TV Stick UB435-Q V3 (card=93)
em2874 #1: dvb set to bulk mode.
usbcore: registered new interface driver em28xx
em2874 #0: Binding DVB extension
tda18212 1-0060: NXP TDA18212HN/M successfully identified
DVB: registering new adapter (em2874 #0)
usb 3-2: DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3305 
VSB/QAM Frontend)...
em2874 #0: DVB extension successfully initialized
em2874 #1: Binding DVB extension
tda18212 3-0060: NXP TDA18212HN/M successfully identified
DVB: registering new adapter (em2874 #1)
usb 3-4: DVB: registering adapter 1 frontend 0 (LG Electronics LGDT3305 
VSB/QAM Frontend)...
em2874 #1: DVB extension successfully initialized
em28xx: Registered (Em28xx dvb Extension) extension

Thanks

