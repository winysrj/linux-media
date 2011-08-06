Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:33162 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753188Ab1HFJcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2011 05:32:48 -0400
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: DVB-T issues w/ kernel 3.0
Date: Sat, 6 Aug 2011 11:32:45 +0200
Cc: linux-media@vger.kernel.org
References: <201107271630.51411.toralf.foerster@gmx.de> <CAGoCfixnuanGSK4YGPo_fCJ5_pJUPAGL-6fpamBRMXHWKcYzdQ@mail.gmail.com>
In-Reply-To: <CAGoCfixnuanGSK4YGPo_fCJ5_pJUPAGL-6fpamBRMXHWKcYzdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108061132.45505.toralf.foerster@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Devin Heitmueller wrote at 16:37:46
> 2011/7/27 Toralf Förster <toralf.foerster@gmx.de>:
> > Hello,
> > 
> > I'm wondering, whether there are known issues with the new kernel version
> > just b/c of https://forums.gentoo.org/viewtopic.php?p=6766690#6766690
> > and https://bugs.kde.org/show_bug.cgi?id=278561
> 
> Hello Toralf,
> 
> I don't think you're the first person to report this issue.  That
> said, I don't think any developers have seen it, so it would be a very
> useful exercise if you could bisect the kernel
Well - rather a nightmare  - b/c it can't be automated, needs reboots, login 
into KDE, start of the necessary apps, finding a movie which starts not within 
next 5 minutes - and nevertheless - hoping, that the tested kernel version 
don't have awefully side effects on my machine ...

I did bisect a lot in the past and willl do it in the future - but this issue 
needs too much resources - no chance within near future I think.

OTOH cherry-picking a suspicious commit - yes, that I probably can do.
 
> Once we know what patch introduced the problem we will have a much
> better idea what action needs to be taken to address it.
ofc


BTW, kernel 3.0, 3.0.1 and current git tree suffers from another DVB-T problem 
too (2.6.39.4 works fine) : if I record something or sometimes its just enough 
that the DVB-T stick is plugged in - s2ram doesn't work. In additon magic 
SysRq keys aren't working, nothing to see and the console except a blinking 
cursor even if booted with no_console_suspend.


MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
