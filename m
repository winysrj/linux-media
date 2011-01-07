Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44141 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1AGUNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 15:13:33 -0500
Received: by ewy5 with SMTP id 5so7998079ewy.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 12:13:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101072053.37211@orion.escape-edv.de>
References: <201101072053.37211@orion.escape-edv.de>
Date: Fri, 7 Jan 2011 15:13:31 -0500
Message-ID: <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>
Subject: Re: Debug code in HG repositories
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 7, 2011 at 2:53 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
> Hi guys,
>
> are you aware that there is a lot of '#if 0' code in the HG repositories
> which is not in GIT?
>
> When drivers were submitted to the kernel from HG, the '#if 0' stuff was
> stripped, unless it was marked as 'keep'...
>
> This was fine, when development was done with HG.
>
> As GIT is being used now, that code will be lost, as soon as the HG
> repositories have been removed...
>
> Any opinions how this should be handled?
>
> CU
> Oliver

I complained about this months ago.  The problem is that when we were
using HG, the HG repo was a complete superset of what went into Git
(including development/debug code).  But now that we use Git, neither
is a superset of the other.

If you base your changes on Git, you have to add back in all the
portability code (and any "#if 0" you added as the maintainer for
development/debugging).  Oh, and regular users cannot test any of your
changes because they aren't willing to upgrade their entire kernel.

If you base your changes on Hg, nothing merges cleanly when submitted
upstream so your patches get rejected.

Want to know why we are seeing regressions all over the place?
Because *NOBODY* is testing the code until after the kernel goes
stable (since while many are willing to install a v4l-dvb tree, very
few will are willing to upgrade their entire kernel just to test one
driver).  We've probably lost about 98% of our user base of testers.

Oh, and users have to git clone 500M+ of data, and not everybody in
the world has bandwidth fast enough to make that worth their time (it
took me several hours last time I did it).

Anyway, I've beaten this horse to death and it's fallen on deaf ears.
Merge overhead has reached the point where it's just not worth my
time/effort to submit anything upstream anymore.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
