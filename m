Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.wa.amnet.net.au ([203.161.124.51]:45593 "EHLO
	smtp2.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0AWP3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 10:29:35 -0500
Message-ID: <4B5B0E12.3090706@barber-family.id.au>
Date: Sat, 23 Jan 2010 22:56:18 +0800
From: Francis Barber <fedora@barber-family.id.au>
MIME-Version: 1.0
To: stoth@kernellabs.com
CC: linux-media@vger.kernel.org
Subject: New Hauppauge HVR-2200 Revision?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steven,

Firstly, thanks for writing the drivers for HVR-2200.  I'd would be 
delighted if you have some time help me get my hardware supported.  I 
bought an HVR-2200 today. I built the latest from 
http://linuxtv.org/hg/v4l-dvb/, but the device is not yet known:

[15596.718263] CORE saa7164[0]: subsystem: 0070:8940, board: Unknown 
[card=0,autodetected]
[15596.718270] saa7164[0]/0: found at 0000:03:00.0, rev: 129, irq: 19, 
latency: 0, mmio: 0xfe800000

I'm a confused by 8940 because this isn't listed in the hcw89.inf file 
on the CD that shipped with the product (driver version 7.6.1.27118).  
They list 8900, 8901, 8980, 8991, 8993, 89A0, and 89A1.  I downloaded 
the latest drivers from the website (7.6.27.27223) and this adds 8951 
and 8953, but still not 8940.

The firmware shipped with 7.6.1.27118 is the same as is available on 
your website, although they have updated it for 7.6.27.27223.

Some details available by looking at the card:
- WinTV-HVR-2200 DVB-T, MULTI-PAL, 89619 LF, REV D3F2.
- Has two NXP TDA10048HN, POS963, 00 01, EPD09322.
- NXP SAA7064E/3, P1A571.00, 07, ESD09372Y.
- SAMSUNG 916 that someone seems to have written on with pencil (?!) so 
I can't read it properly.
- Made in Indonesia 2009/08/20.

If there is any other information that would be helpful please let me know.

Many thanks,
Frank.

