Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62736 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KJDZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 22:25:56 -0500
Received: by iwn10 with SMTP id 10so222854iwn.19
        for <linux-media@vger.kernel.org>; Tue, 09 Nov 2010 19:25:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CD9FA59.9020702@infradead.org>
References: <20101102201733.12010.30019.stgit@localhost.localdomain>
	<AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com>
	<4CD9FA59.9020702@infradead.org>
Date: Tue, 9 Nov 2010 22:25:56 -0500
Message-ID: <AANLkTik4s2vaAYu-A7VwDGRdeDDd=QZkUYN-p6yrFeqR@mail.gmail.com>
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Nov 9, 2010 at 8:50 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
...
> Sorry for giving you a late feedback about those patches. I was busy the last two
> weeks, due to my trip to US for KS/LPC.
>
> I've applied patches 1 to 3 (in fact, I got the patches from the previous version -
> unfortunately, patchwork do a very bad job when someone sends a new series that superseeds
> the previous patches).
>
> I didn't like patch 4 for some reasons: instead of just doing rename, it is a
> all-in-one patch, doing several things at the same time. It is hard to analyse it by
> just looking at the diffs, as it is not a pure rename patch. Also, it doesn't rename
> /drivers/media/IR into something else.
>
> Btw, the patch is currently broken:

Hm, the series applied cleanly against 2.6.37-rc1 a bit ago:

http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-ir.git;a=shortlog;h=refs/heads/staging

-- 
Jarod Wilson
jarod@wilsonet.com
