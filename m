Return-path: <mchehab@pedra>
Received: from alia.ip-minds.de ([84.201.38.2]:55480 "EHLO alia.ip-minds.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab1CKXD6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 18:03:58 -0500
To: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: WinTV 1400 broken with recent =?UTF-8?Q?versions=3F?=
MIME-Version: 1.0
Date: Sat, 12 Mar 2011 00:04:10 +0100
From: <jean.bruenn@ip-minds.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
In-Reply-To: <81E0AF02-0837-4DF8-BFEA-94A654FFF471@wilsonet.com>
References: <20110309175231.16446e92.jean.bruenn@ip-minds.de> <76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com> <ba12e998349efa465be466a4d7f9d43f@localhost> <3AF3951C-11F6-48E4-A0EE-85179B013AFC@wilsonet.com> <81E0AF02-0837-4DF8-BFEA-94A654FFF471@wilsonet.com>
Message-ID: <af7d57a1bb478c0edac4cd7afdfd6f41@localhost>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hey,

i tried to revert that patch manually (e.g. switching into the directory,
vim cx23885-i2c.c, removing the stuff which was added), then "make clean"
"make distclean" followed by "./build.sh" then make rmmod, then plugged in
the card, dmesg shows it loaded the card correctly, all fine, then i did
./scan Scanlist.txt and i get the same i2c related errors. Did a reboot
just to verify, still getting those, scan gives no results always "tuning
failed". 

Then i reverted another patch (just to make sure..
http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commit;h=f4acb3c4ccca74f5448354308f917e87ce83505a)
- However, this didn't help. So, the problem might be somewhere else. 

I did some more research and it seems i'm not the only one with those
issues, tho nearly none gets answers regarding this trouble, e.g.:

(same card - also expresscard, december 2010)
http://www.spinics.net/lists/linux-media/msg27042.html
(not the same card, tho similar error, hvr 1500, i got hvr 1400 - februar
2009)
http://www.linuxtv.org/pipermail/linux-dvb/2009-February/031839.html

I'm running out of ideas where the problem might be located. i also tried
to switch the firmware by extracting the firmware manually, didn't help.
There's a low power version and another one available, tried to replace,
didn't work neither.

So it seems, this driver is broken at least since december 2010. Totally
weird why there's such a mess, i know for sure that this WAS working.

Anyone, any idea? Maybe something wrong configured in kernel? Might
running native 64bit the cause (no multilib/32bit compat libs here)?

> I knew this all seemed too familiar... :)
> 
>
http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commit;h=67914b5c400d6c213f9e56d7547a2038ab5c06f4
> 
> Its already being reverted for 2.6.38 final (hopefully -- Mauro included
> that in the pull req sent to Linus today).
