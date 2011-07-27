Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47819 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1G0PB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 11:01:29 -0400
Received: by ewy4 with SMTP id 4so1305048ewy.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 08:01:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFk738Ej-Qst8au4WXGXBAsmcrMBkRRB=MEgAcWSS1R=C81w5Q@mail.gmail.com>
References: <201107271630.51411.toralf.foerster@gmx.de>
	<CAGoCfixnuanGSK4YGPo_fCJ5_pJUPAGL-6fpamBRMXHWKcYzdQ@mail.gmail.com>
	<CAFk738Ej-Qst8au4WXGXBAsmcrMBkRRB=MEgAcWSS1R=C81w5Q@mail.gmail.com>
Date: Wed, 27 Jul 2011 11:01:27 -0400
Message-ID: <CAGoCfiz-Pkdd3cy6yMygNU0iWTmS2STszN_OEmVwGdTmVO-TtQ@mail.gmail.com>
Subject: Re: DVB-T issues w/ kernel 3.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steffen Barszus <steffenbpunkt@googlemail.com>
Cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 27, 2011 at 10:57 AM, Steffen Barszus
<steffenbpunkt@googlemail.com> wrote:
> Quote:
> "The drivers from 2011-02-05 does not run, but the drivers from
> 2010-10-16 runs perfectly. "
>
> should give at least a startingpoint/timeframe for bisecting ...
> allthough would be more usefull if based linuxtv git.

Bear in mind the user was using the "s2-liplianin" branch and *not*
the mainline linux_media tree.  Hence anybody who does a bisect should
be sure the starting/ending points are accurate.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
