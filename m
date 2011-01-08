Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40139 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1AHGG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 01:06:27 -0500
Received: by qyk12 with SMTP id 12so20425668qyk.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 22:06:26 -0800 (PST)
Subject: Re: Debug code in HG repositories
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>
Date: Sat, 8 Jan 2011 01:06:23 -0500
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <69E0D86D-A145-4C0B-976C-481E1776B892@wilsonet.com>
References: <201101072053.37211@orion.escape-edv.de> <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 7, 2011, at 3:13 PM, Devin Heitmueller wrote:

> On Fri, Jan 7, 2011 at 2:53 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
>> Hi guys,
>> 
>> are you aware that there is a lot of '#if 0' code in the HG repositories
>> which is not in GIT?
>> 
>> When drivers were submitted to the kernel from HG, the '#if 0' stuff was
>> stripped, unless it was marked as 'keep'...
>> 
>> This was fine, when development was done with HG.
>> 
>> As GIT is being used now, that code will be lost, as soon as the HG
>> repositories have been removed...
>> 
>> Any opinions how this should be handled?
>> 
>> CU
>> Oliver
> 
> I complained about this months ago.  The problem is that when we were
> using HG, the HG repo was a complete superset of what went into Git
> (including development/debug code).  But now that we use Git, neither
> is a superset of the other.
> 
> If you base your changes on Git, you have to add back in all the
> portability code (and any "#if 0" you added as the maintainer for
> development/debugging).  Oh, and regular users cannot test any of your
> changes because they aren't willing to upgrade their entire kernel.
> 
> If you base your changes on Hg, nothing merges cleanly when submitted
> upstream so your patches get rejected.
> 
> Want to know why we are seeing regressions all over the place?
> Because *NOBODY* is testing the code until after the kernel goes
> stable (since while many are willing to install a v4l-dvb tree, very
> few will are willing to upgrade their entire kernel just to test one
> driver).  We've probably lost about 98% of our user base of testers.

What Hans said re: media_build. I've been pointing quite a few people on
the mythtv-users mailing list in that direction for updated drivers on
top of their distro kernels.

Additionally, the current Fedora 14 kernels (which are 2.6.35.10-based)
carry a patchset developed using media_build with essentially the 2.6.38
rc1 snapshot code, so a fair number of Fedora users *are* testing this
code long before its in a stable upstream kernel release.


-- 
Jarod Wilson
jarod@wilsonet.com



