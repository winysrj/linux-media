Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab1HFMRL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2011 08:17:11 -0400
Message-ID: <4E3D30C0.9040509@redhat.com>
Date: Sat, 06 Aug 2011 09:17:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: DVB-T issues w/ kernel 3.0
References: <201107271630.51411.toralf.foerster@gmx.de> <CAGoCfixnuanGSK4YGPo_fCJ5_pJUPAGL-6fpamBRMXHWKcYzdQ@mail.gmail.com> <201108061132.45505.toralf.foerster@gmx.de>
In-Reply-To: <201108061132.45505.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2011 06:32, Toralf Förster escreveu:
> 
> Devin Heitmueller wrote at 16:37:46
>> 2011/7/27 Toralf Förster <toralf.foerster@gmx.de>:
>>> Hello,
>>>
>>> I'm wondering, whether there are known issues with the new kernel version
>>> just b/c of https://forums.gentoo.org/viewtopic.php?p=6766690#6766690
>>> and https://bugs.kde.org/show_bug.cgi?id=278561
>>
>> Hello Toralf,
>>
>> I don't think you're the first person to report this issue.  That
>> said, I don't think any developers have seen it, so it would be a very
>> useful exercise if you could bisect the kernel
> Well - rather a nightmare  - b/c it can't be automated, needs reboots, login 
> into KDE, start of the necessary apps, finding a movie which starts not within 
> next 5 minutes - and nevertheless - hoping, that the tested kernel version 
> don't have awefully side effects on my machine ...
> 
> I did bisect a lot in the past and willl do it in the future - but this issue 
> needs too much resources - no chance within near future I think.
> 
> OTOH cherry-picking a suspicious commit - yes, that I probably can do.
>  
>> Once we know what patch introduced the problem we will have a much
>> better idea what action needs to be taken to address it.
> ofc
> 
> 
> BTW, kernel 3.0, 3.0.1 and current git tree suffers from another DVB-T problem 
> too (2.6.39.4 works fine) : if I record something or sometimes its just enough 
> that the DVB-T stick is plugged in - s2ram doesn't work. In additon magic 
> SysRq keys aren't working, nothing to see and the console except a blinking 
> cursor even if booted with no_console_suspend.


There's a know issue with dib0700 driver and some patches applied at 3.0.
I'll be merging the fixes from Patrick git tree today. They should solve
the issue.
> 
> 
> MfG/Sincerely
> Toralf Förster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

