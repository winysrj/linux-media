Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:39184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab0KJBuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 20:50:24 -0500
Message-ID: <4CD9FA59.9020702@infradead.org>
Date: Tue, 09 Nov 2010 23:50:17 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
References: <20101102201733.12010.30019.stgit@localhost.localdomain> <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com>
In-Reply-To: <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi David,

Em 02-11-2010 18:26, Jarod Wilson escreveu:
> On Tue, Nov 2, 2010 at 4:17 PM, David Härdeman <david@hardeman.nu> wrote:
>> This is my current patch queue, the main change is to make struct rc_dev
>> the primary interface for rc drivers and to abstract away the fact that
>> there's an input device lurking in there somewhere.
>>
>> In addition, the cx88 and winbond-cir drivers are converted to use rc-core.
>>
>> The patchset is now based on current linux-2.6 upstream git tree since it
>> carries both the v4l patches from the staging/for_v2.6.37-rc1 branch, large
>> scancode support and bugfixes.
>>
>> Given the changes, these patches touch every single driver. Obviously I
>> haven't tested them all due to a lack of hardware (I have made sure that
>> all drivers compile without any warnings and I have tested the end result
>> on mceusb and winbond-cir hardware, Jarod Wilson has tested nuvoton-cir,
>> imon and several mceusb devices).
> 
> And streamzap! :)
> 
> Mauro's at the kernel summit, but I had a brief moment to talk to him
> earlier today. He had a few issues he wanted to give feedback on, but
> I didn't get any specifics yet, other than him not liking the rc-map.c
> bits merged into rc-main.c, mainly because part of the plan is to
> remove in-kernel maps entirely in 2.6.38. It doesn't make a big
> difference to me either way, and rc-main.c is still only 1300-ish
> lines, and would be even less once rc-map.c bits are ripped out...

Sorry for giving you a late feedback about those patches. I was busy the last two
weeks, due to my trip to US for KS/LPC.

I've applied patches 1 to 3 (in fact, I got the patches from the previous version - 
unfortunately, patchwork do a very bad job when someone sends a new series that superseeds
the previous patches).

I didn't like patch 4 for some reasons: instead of just doing rename, it is a
all-in-one patch, doing several things at the same time. It is hard to analyse it by
just looking at the diffs, as it is not a pure rename patch. Also, it doesn't rename
/drivers/media/IR into something else.

Btw, the patch is currently broken:

$ quilt push
Applying patch patches/lmml_298052_4_6_ir_core_merge_and_rename_to_rc_core.patch
patching file drivers/media/IR/Makefile
patching file drivers/media/IR/ir-core-priv.h
patching file drivers/media/IR/ir-keytable.c
Hunk #1 FAILED at 1.
File drivers/media/IR/ir-keytable.c is not empty after patch, as expected
1 out of 1 hunk FAILED -- rejects in file drivers/media/IR/ir-keytable.c
patching file drivers/media/IR/ir-raw-event.c
patching file drivers/media/IR/ir-sysfs.c
patching file drivers/media/IR/rc-main.c
patching file drivers/media/IR/rc-map.c
patching file drivers/media/IR/rc-raw.c
patching file include/media/ir-core.h
Patch patches/lmml_298052_4_6_ir_core_merge_and_rename_to_rc_core.patch does not apply (enforce with -f)

I think that the better is if I write a few patches doing the basic rename stuff, based on my
current tip, and then we can discuss about merging things into a fewer number of files, as 
you're proposing, and apply patch 5/6 and 6/6.

Not sure why, but patchwork didn't seem to catch patch 6/6. I suspect that it is because your
name is not encoded with UTF-8 inside the driver. I've picked it manually here, and fixed
the naming stuff, but it needs patch 5/6, in order to work.

I'll be pushing the renaming stuff soon at ML. I'll try to use your naming convention and, if
I do it well, maybe I can apply patches 5/6 and 6/6 on it without rebasing. Well, let's see.

Cheers,
Mauro





