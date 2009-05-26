Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.oregonstate.edu ([128.193.15.35]:60229 "EHLO
	smtp1.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbZEZXJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 19:09:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp1.oregonstate.edu (Postfix) with ESMTP id 08F313C204
	for <linux-media@vger.kernel.org>; Tue, 26 May 2009 15:48:35 -0700 (PDT)
Received: from smtp1.oregonstate.edu ([127.0.0.1])
	by localhost (smtp.oregonstate.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZKnNXlSCSeFP for <linux-media@vger.kernel.org>;
	Tue, 26 May 2009 15:48:34 -0700 (PDT)
Received: from spike.nws.oregonstate.edu (spike.nws.oregonstate.edu [10.192.126.45])
	by smtp1.oregonstate.edu (Postfix) with ESMTP id DBFD93C1E6
	for <linux-media@vger.kernel.org>; Tue, 26 May 2009 15:48:34 -0700 (PDT)
Message-ID: <4A1C711E.3070408@onid.orst.edu>
Date: Tue, 26 May 2009 15:45:50 -0700
From: Michael Akey <akeym@onid.orst.edu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Nextwave NXT2004 Firmware (found)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(posting to proper mailing list as per linux-dvb@linuxtv.org's 
auto-response)

I recently acquired an ATI HDTV Wonder PCI card from a friend of mine
and decided to test it out on my satellite TV transcoding server to also
get OTA channels.  I am using a generic linux kernel version 2.6.29.2,
and it detects the card just fine, but needed a firmware file for the
front-end.

I checked the get_dvb_firmware script, but it failed because the driver
pack from AVerMedia is no longer available.  I then tried to get the
latest drivers from them by hand for the A180 card, which also has the
nxt2004 demod/frontend..  but the driver package refused to install on
my WinXP system.  After some quick googling and not finding the nxt2004
firmware downloadable online, I tried to find it in the AMD/ATI driver
package instead.  It was not readily apparent which file had the
firmware, and the only files in the package were windows
executable/system files.

So I figured it was embedded in one of these files..  I was able to find
the nxt2002 firmware file, and compare it to the contents of the file
"atidtuxx.sys."  In this file, I fiddled around with offsets and dumping
8kb chunks out and feeding it to my linux machine's kernel, and
magically got my tuner card to APPEAR to work properly with it, but I do
not know the firmware's actual size, so there's a distinct possibility
that I'm sending it extra garbage it doesn't need.


Default extraction path from nullsoft installer:
C:\ATI\SUPPORT\6-1_hdtv_83-2036wdm\WDM_XP

Firmware appears to be in ATIDTUXX.SYS at offset 0x681E, taken as a
8192byte chunk.

To help me with my findings, does anybody have a known working version
of dvb-fe-nxt2004.fw that I can use for comparison?  Thanks!

And if I have found the correct firmware, the get_dvb_firmware script
can be updated to pull this from the ATI drivers now.. If I did this the
hard way, you may feel free to point this out as well :)

--Mike

