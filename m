Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.trendhosting.net ([195.8.117.5]:41163 "EHLO
	thp003.trendhosting.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZAXLiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 06:38:25 -0500
Received: from mail.trendhosting.net (mail.trendhosting.net [195.8.117.7])
	by thp003.trendhosting.net (Postfix) with ESMTP id CB9C0150C1
	for <linux-media@vger.kernel.org>; Sat, 24 Jan 2009 11:27:16 +0000 (GMT)
Received: from localhost (localhost [127.0.0.1])
	by mail.trendhosting.net (Postfix) with ESMTP id 5F8B3A95E7
	for <linux-media@vger.kernel.org>; Sat, 24 Jan 2009 11:28:09 +0000 (GMT)
Received: from mail.trendhosting.net ([127.0.0.1])
	by localhost (th4.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Jbh0mRdGYhMX for <linux-media@vger.kernel.org>;
	Sat, 24 Jan 2009 11:27:50 +0000 (GMT)
Received: from [82.69.192.89] (82-69-192-89.dsl.in-addr.zen.co.uk [82.69.192.89])
	by mail.trendhosting.net (Postfix) with ESMTP id 9DECCA95E6
	for <linux-media@vger.kernel.org>; Sat, 24 Jan 2009 11:27:50 +0000 (GMT)
Message-ID: <497AFB36.90203@pocock.com.au>
Date: Sat, 24 Jan 2009 11:27:50 +0000
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: initial experiences with DVB-S
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi,

Consulting the DVB wiki, I found a lot more options for PCI than USB.  
Having a PC with few PCI slots (it has some of the PCIe slots instead), 
I prefer to avoid using anything in a PCI slot unless absolutely essential.

I couldn't find a source to purchase any of the supported USB devices 
(The Pinnacle PCTV looked interesting, but the company appears to have 
been bought out by another vendor, and the link to purchase their 
product doesn't work), so I decided to try a Technotrend S-1500 in my 
PCI slot.

The card worked immediately with the Debian lenny (amd64) kernel and the 
`scan' utility found all the channels, and xine worked immediately too.

Now for the issues:

- Any recommendation on a USB solution?  What to buy, and where to buy it.

- The Technotrend card causes a constant increase in the power usage - 
even when I'm not watching anything.  This makes my PSU noisier, not 
good for a multi-media experience.  Maybe the device list needs a column 
with info about power usage?  In comparison, plugging in my DVB-T USB 
stick makes no noticeable difference in PSU fan noise.  I wouldn't mind 
paying more for a solution without the noise issue.

- I decided to try watching a HD channel with xine.  Although the 
channel is picked up immediately, it either works erratically or 
crashes.  xine warns about CPU usage.  My PC has a Pentium D 940 (dual 
core), and while one core is being used at 100%, the other is at less 
than 20%.  There is no other load on the CPU, other than xine.

- Another HD issue - are all HD broadcasts in Dolby Digital 5.1, and do 
I need any extra config to benefit from it?  When watching the channel I 
tested, my amp reported only 2 channels.  My xine is correctly 
configured for 5.1 through my optical output (tested with DVDs)

- Does the choice of video card make any difference?  I'm currently 
using a Matrox P650 in a 16x PCIe slot.  The TV-Out doesn't work (Matrox 
proprietary driver issue), a few people have suggested I try NVidia 
cards, but looking at their web site I see a lot of options.

Regards,

Daniel
