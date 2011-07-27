Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:57617 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1G0Oht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 10:37:49 -0400
Received: by eye22 with SMTP id 22so1966798eye.2
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 07:37:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107271630.51411.toralf.foerster@gmx.de>
References: <201107271630.51411.toralf.foerster@gmx.de>
Date: Wed, 27 Jul 2011 10:37:46 -0400
Message-ID: <CAGoCfixnuanGSK4YGPo_fCJ5_pJUPAGL-6fpamBRMXHWKcYzdQ@mail.gmail.com>
Subject: Re: DVB-T issues w/ kernel 3.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/7/27 Toralf Förster <toralf.foerster@gmx.de>:
> Hello,
>
> I'm wondering, whether there are known issues with the new kernel version just
> b/c of https://forums.gentoo.org/viewtopic.php?p=6766690#6766690 and
> https://bugs.kde.org/show_bug.cgi?id=278561

Hello Toralf,

I don't think you're the first person to report this issue.  That
said, I don't think any developers have seen it, so it would be a very
useful exercise if you could bisect the kernel and figure out which
patch introduced the problem.

Once we know what patch introduced the problem we will have a much
better idea what action needs to be taken to address it.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
