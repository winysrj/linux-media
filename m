Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:47931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0KJEdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 23:33:49 -0500
Message-ID: <4CDA2093.7010101@infradead.org>
Date: Wed, 10 Nov 2010 02:33:23 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
References: <20101102201733.12010.30019.stgit@localhost.localdomain>	<AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com>	<4CD9FA59.9020702@infradead.org> <AANLkTik4s2vaAYu-A7VwDGRdeDDd=QZkUYN-p6yrFeqR@mail.gmail.com>
In-Reply-To: <AANLkTik4s2vaAYu-A7VwDGRdeDDd=QZkUYN-p6yrFeqR@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-11-2010 01:25, Jarod Wilson escreveu:
> On Tue, Nov 9, 2010 at 8:50 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> ...
>> Sorry for giving you a late feedback about those patches. I was busy the last two
>> weeks, due to my trip to US for KS/LPC.
>>
>> I've applied patches 1 to 3 (in fact, I got the patches from the previous version -
>> unfortunately, patchwork do a very bad job when someone sends a new series that superseeds
>> the previous patches).
>>
>> I didn't like patch 4 for some reasons: instead of just doing rename, it is a
>> all-in-one patch, doing several things at the same time. It is hard to analyse it by
>> just looking at the diffs, as it is not a pure rename patch. Also, it doesn't rename
>> /drivers/media/IR into something else.
>>
>> Btw, the patch is currently broken:
> 
> Hm, the series applied cleanly against 2.6.37-rc1 a bit ago:
> 
> http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-ir.git;a=shortlog;h=refs/heads/staging

Probably, some other RC patch broke it. It doesn't apply cleanly 
against staging/for_v2.6.38.

Cheers,
Mauro

