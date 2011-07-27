Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40932 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab1G0O54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 10:57:56 -0400
Received: by qwk3 with SMTP id 3so841676qwk.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 07:57:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixnuanGSK4YGPo_fCJ5_pJUPAGL-6fpamBRMXHWKcYzdQ@mail.gmail.com>
References: <201107271630.51411.toralf.foerster@gmx.de>
	<CAGoCfixnuanGSK4YGPo_fCJ5_pJUPAGL-6fpamBRMXHWKcYzdQ@mail.gmail.com>
Date: Wed, 27 Jul 2011 16:57:55 +0200
Message-ID: <CAFk738Ej-Qst8au4WXGXBAsmcrMBkRRB=MEgAcWSS1R=C81w5Q@mail.gmail.com>
Subject: Re: DVB-T issues w/ kernel 3.0
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27. Juli 2011 16:37 schrieb Devin Heitmueller <dheitmueller@kernellabs.com>:
> 2011/7/27 Toralf Förster <toralf.foerster@gmx.de>:
>> Hello,
>>
>> I'm wondering, whether there are known issues with the new kernel version just
>> b/c of https://forums.gentoo.org/viewtopic.php?p=6766690#6766690 and
>> https://bugs.kde.org/show_bug.cgi?id=278561
>
> Hello Toralf,
>
> I don't think you're the first person to report this issue.  That
> said, I don't think any developers have seen it, so it would be a very
> useful exercise if you could bisect the kernel and figure out which
> patch introduced the problem.
>
> Once we know what patch introduced the problem we will have a much
> better idea what action needs to be taken to address it.

It's about dib0700 driver also reported here:
http://www.spinics.net/lists/linux-media/msg35763.html few days ago.

Quote:
"The drivers from 2011-02-05 does not run, but the drivers from
2010-10-16 runs perfectly. "

should give at least a startingpoint/timeframe for bisecting ...
allthough would be more usefull if based linuxtv git.
