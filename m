Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40621 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0KJJ2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 04:28:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 10 Nov 2010 10:28:09 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
In-Reply-To: <AANLkTik4s2vaAYu-A7VwDGRdeDDd=QZkUYN-p6yrFeqR@mail.gmail.com>
References: <20101102201733.12010.30019.stgit@localhost.localdomain> <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com> <4CD9FA59.9020702@infradead.org> <AANLkTik4s2vaAYu-A7VwDGRdeDDd=QZkUYN-p6yrFeqR@mail.gmail.com>
Message-ID: <210c15166347a1923a18871afe1965bd@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 9 Nov 2010 22:25:56 -0500, Jarod Wilson <jarod@wilsonet.com>
wrote:
> On Tue, Nov 9, 2010 at 8:50 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> ...
>> Sorry for giving you a late feedback about those patches. I was busy
the
>> last two
>> weeks, due to my trip to US for KS/LPC.
>>
>> I've applied patches 1 to 3 (in fact, I got the patches from the
>> previous version -
>> unfortunately, patchwork do a very bad job when someone sends a new
>> series that superseeds
>> the previous patches).
>>
>> I didn't like patch 4 for some reasons: instead of just doing rename,
it
>> is a
>> all-in-one patch, doing several things at the same time. It is hard to
>> analyse it by
>> just looking at the diffs, as it is not a pure rename patch. Also, it
>> doesn't rename
>> /drivers/media/IR into something else.
>>
>> Btw, the patch is currently broken:
> 
> Hm, the series applied cleanly against 2.6.37-rc1 a bit ago:
> 
>
http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-ir.git;a=shortlog;h=refs/heads/staging

Still does, and it's no wonder it doesn't apply to staging/for_v2.6.38
since it's a franken-branch of 2.6.36 + staging/for_v2.6.37 + some more
patches.

-- 
David Härdeman
