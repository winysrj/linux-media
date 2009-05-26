Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.oregonstate.edu ([128.193.15.36])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <akeym@onid.orst.edu>) id 1M95Q5-0002LZ-ND
	for linux-dvb@linuxtv.org; Wed, 27 May 2009 00:46:54 +0200
Received: from localhost (localhost [127.0.0.1])
	by smtp2.oregonstate.edu (Postfix) with ESMTP id D19763C54A
	for <linux-dvb@linuxtv.org>; Tue, 26 May 2009 15:46:15 -0700 (PDT)
Received: from smtp2.oregonstate.edu ([127.0.0.1])
	by localhost (smtp.oregonstate.edu [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id oMPU4O0VZ4tJ for <linux-dvb@linuxtv.org>;
	Tue, 26 May 2009 15:46:15 -0700 (PDT)
Received: from spike.nws.oregonstate.edu (spike.nws.oregonstate.edu
	[10.192.126.45])
	by smtp2.oregonstate.edu (Postfix) with ESMTP id AD55F3C30A
	for <linux-dvb@linuxtv.org>; Tue, 26 May 2009 15:46:15 -0700 (PDT)
Message-ID: <4A1C7093.30408@onid.orst.edu>
Date: Tue, 26 May 2009 15:43:31 -0700
From: Michael Akey <akeym@onid.orst.edu>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Nextwave NXT2004 Firmware (found)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

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

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
