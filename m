Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64748 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1CKXVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 18:21:50 -0500
Received: by eyx24 with SMTP id 24so1084597eyx.19
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 15:21:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <af7d57a1bb478c0edac4cd7afdfd6f41@localhost>
References: <20110309175231.16446e92.jean.bruenn@ip-minds.de>
	<76A39CFB-2838-4AD7-B353-49971F9F7DFF@wilsonet.com>
	<ba12e998349efa465be466a4d7f9d43f@localhost>
	<3AF3951C-11F6-48E4-A0EE-85179B013AFC@wilsonet.com>
	<81E0AF02-0837-4DF8-BFEA-94A654FFF471@wilsonet.com>
	<af7d57a1bb478c0edac4cd7afdfd6f41@localhost>
Date: Fri, 11 Mar 2011 18:21:49 -0500
Message-ID: <AANLkTimqGxS6OYNarqQwZNxFk+rccPn40UcK+6Oo72SC@mail.gmail.com>
Subject: Re: WinTV 1400 broken with recent versions?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: jean.bruenn@ip-minds.de
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Mar 11, 2011 at 6:04 PM,  <jean.bruenn@ip-minds.de> wrote:
>
> Hey,
>
> i tried to revert that patch manually (e.g. switching into the directory,
> vim cx23885-i2c.c, removing the stuff which was added), then "make clean"
> "make distclean" followed by "./build.sh" then make rmmod, then plugged in
> the card, dmesg shows it loaded the card correctly, all fine, then i did
> ./scan Scanlist.txt and i get the same i2c related errors. Did a reboot
> just to verify, still getting those, scan gives no results always "tuning
> failed".
>
> Then i reverted another patch (just to make sure..
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commit;h=f4acb3c4ccca74f5448354308f917e87ce83505a)
> - However, this didn't help. So, the problem might be somewhere else.
>
> I did some more research and it seems i'm not the only one with those
> issues, tho nearly none gets answers regarding this trouble, e.g.:
>
> (same card - also expresscard, december 2010)
> http://www.spinics.net/lists/linux-media/msg27042.html
> (not the same card, tho similar error, hvr 1500, i got hvr 1400 - februar
> 2009)
> http://www.linuxtv.org/pipermail/linux-dvb/2009-February/031839.html
>
> I'm running out of ideas where the problem might be located. i also tried
> to switch the firmware by extracting the firmware manually, didn't help.
> There's a low power version and another one available, tried to replace,
> didn't work neither.
>
> So it seems, this driver is broken at least since december 2010. Totally
> weird why there's such a mess, i know for sure that this WAS working.

Doesn't seem weird to me at all.  This is a pretty uncommon card, so
it is entirely possible that many revisions could go by without
someone noticing a regression.  I know for example that the HVR-1500Q
(the US version of that board) was broken for months and nobody
noticed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
