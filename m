Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.oregonstate.edu ([128.193.15.36]:44776 "EHLO
	smtp2.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZE0Aeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 20:34:31 -0400
Message-ID: <4A1C89F5.1050403@onid.orst.edu>
Date: Tue, 26 May 2009 17:31:49 -0700
From: Michael Akey <akeym@onid.orst.edu>
MIME-Version: 1.0
To: jeisom@gmail.com
CC: linux-media@vger.kernel.org
Subject: [Fwd: Re: Nextwave NXT2004 Firmware (found)]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Found what I THINK to be the proper offset, with the help of the 
"proper" firmware:  0x6298, length: 9674bytes. (atidtuxx.sys) I have a 
copy set up on my system and appears to be working properly.. If anybody 
would like to test, I can send them the file off-list.  Again, this is 
for the ATI HDTV Wonder card, not the AVerMedia A180 card.  Thanks for 
you help Jon :)  I'll be doing more testing later tonight, and report 
any results/errors.  It would certainly be cool to get some feedback on 
my findings, and get the firmware script updated for others.

-------- Original Message --------
Subject: 	Re: Nextwave NXT2004 Firmware (found)
Date: 	Tue, 26 May 2009 18:13:59 -0500
From: 	Jonathan Isom <jeisom@gmail.com>
To: 	Michael Akey <akeym@onid.orst.edu>
References: 	<4A1C711E.3070408@onid.orst.edu>



On Tue, May 26, 2009 at 5:45 PM, Michael Akey <akeym@onid.orst.edu> wrote:
> (posting to proper mailing list as per linux-dvb@linuxtv.org's
> auto-response)
>
> I recently acquired an ATI HDTV Wonder PCI card from a friend of mine
> and decided to test it out on my satellite TV transcoding server to also
> get OTA channels.  I am using a generic linux kernel version 2.6.29.2,
> and it detects the card just fine, but needed a firmware file for the
> front-end.
>
> I checked the get_dvb_firmware script, but it failed because the driver
> pack from AVerMedia is no longer available.  I then tried to get the
> latest drivers from them by hand for the A180 card, which also has the
> nxt2004 demod/frontend..  but the driver package refused to install on
> my WinXP system.  After some quick googling and not finding the nxt2004
> firmware downloadable online, I tried to find it in the AMD/ATI driver
> package instead.  It was not readily apparent which file had the
> firmware, and the only files in the package were windows
> executable/system files.
>
> So I figured it was embedded in one of these files..  I was able to find
> the nxt2002 firmware file, and compare it to the contents of the file
> "atidtuxx.sys."  In this file, I fiddled around with offsets and dumping
> 8kb chunks out and feeding it to my linux machine's kernel, and
> magically got my tuner card to APPEAR to work properly with it, but I do
> not know the firmware's actual size, so there's a distinct possibility
> that I'm sending it extra garbage it doesn't need.
>
>
> Default extraction path from nullsoft installer:
> C:\ATI\SUPPORT\6-1_hdtv_83-2036wdm\WDM_XP
>
> Firmware appears to be in ATIDTUXX.SYS at offset 0x681E, taken as a
> 8192byte chunk.
>
> To help me with my findings, does anybody have a known working version
> of dvb-fe-nxt2004.fw that I can use for comparison?  Thanks!

Here you go,  Don't know if you are going about anyway wrong.

> And if I have found the correct firmware, the get_dvb_firmware script
> can be updated to pull this from the ATI drivers now.. If I did this the
> hard way, you may feel free to point this out as well :)
>
> --Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 

ASUS m3a78 mothorboard
AMD Athlon64 X2 Dual Core Processor 6000+ 3.1Ghz
4 Gigabytes of memory
Gigabyte NVidia 9400gt  Graphics adapter
Kworld ATSC 110 TV Capture Card
Kworld ATSC 115 TV Capture Card


