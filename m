Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:45831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab0KJMtR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 07:49:17 -0500
Message-ID: <4CDA94C6.2010506@infradead.org>
Date: Wed, 10 Nov 2010 10:49:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] rc-core: ir-core to rc-core conversion
References: <20101102201733.12010.30019.stgit@localhost.localdomain> <AANLkTi=z2yU568sEs0RNuQ6gZUzJQeHajTZ_0LeXS-2D@mail.gmail.com> <4CD9FA59.9020702@infradead.org> <33c8487ce0141587f695d9719289467e@hardeman.nu>
In-Reply-To: <33c8487ce0141587f695d9719289467e@hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-11-2010 07:24, David Härdeman escreveu:
> On Tue, 09 Nov 2010 23:50:17 -0200, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> Hi David,
>>
>> Em 02-11-2010 18:26, Jarod Wilson escreveu:
>>> On Tue, Nov 2, 2010 at 4:17 PM, David Härdeman <david@hardeman.nu>
>>> wrote:
>>>> This is my current patch queue, the main change is to make struct
> rc_dev
>>>> the primary interface for rc drivers and to abstract away the fact
> that
>>>> there's an input device lurking in there somewhere.
>>>>
>>>> In addition, the cx88 and winbond-cir drivers are converted to use
>>>> rc-core.
>>>>
>>>> The patchset is now based on current linux-2.6 upstream git tree since
>>>> it
>>>> carries both the v4l patches from the staging/for_v2.6.37-rc1 branch,
>>>> large
>>>> scancode support and bugfixes.
>>>>
>>>> Given the changes, these patches touch every single driver. Obviously
> I
>>>> haven't tested them all due to a lack of hardware (I have made sure
> that
>>>> all drivers compile without any warnings and I have tested the end
>>>> result
>>>> on mceusb and winbond-cir hardware, Jarod Wilson has tested
> nuvoton-cir,
>>>> imon and several mceusb devices).
>>>
>>> And streamzap! :)
>>>
>>> Mauro's at the kernel summit, but I had a brief moment to talk to him
>>> earlier today. He had a few issues he wanted to give feedback on, but
>>> I didn't get any specifics yet, other than him not liking the rc-map.c
>>> bits merged into rc-main.c, mainly because part of the plan is to
>>> remove in-kernel maps entirely in 2.6.38. It doesn't make a big
>>> difference to me either way, and rc-main.c is still only 1300-ish
>>> lines, and would be even less once rc-map.c bits are ripped out...
>>
>> Sorry for giving you a late feedback about those patches. I was busy the
>> last two
>> weeks, due to my trip to US for KS/LPC.
>>
>> I've applied patches 1 to 3 (in fact, I got the patches from the
> previous
>> version - 
>> unfortunately, patchwork do a very bad job when someone sends a new
> series
>> that superseeds
>> the previous patches).
> 
> Kinda makes it pointless to refresh patchsets, doesn't it?

Yes.
>  
>> I didn't like patch 4 for some reasons: instead of just doing rename, it
>> is a
>> all-in-one patch, doing several things at the same time. It is hard to
>> analyse it by
>> just looking at the diffs, as it is not a pure rename patch.
> 
> It was an almost pure merge + rename (it added only the things that follow
> from the merger...forward declarations and making functions static).
> 
> The real problem is that, since it includes the removal of files, those
> files need to be identical.
> 
>> Also, it
>> doesn't rename
>> /drivers/media/IR into something else.
> 
> No, of course not, that would have made the patch even larger for little
> gain.
> 
> I see that you've included a renaming patch in your patchset sent to the
> list, but wouldn't it be easier to apply it after all the other patches
> rather than before?

When such change is done as I did, git is smart enough to do the right thing. So,
even if the file suffered changes, it is still a rename operation there, even
if the file had changes.

> 
>> Btw, the patch is currently broken:
>>
>> $ quilt push
>> Applying patch
>> patches/lmml_298052_4_6_ir_core_merge_and_rename_to_rc_core.patch
>> patching file drivers/media/IR/Makefile
>> patching file drivers/media/IR/ir-core-priv.h
>> patching file drivers/media/IR/ir-keytable.c
>> Hunk #1 FAILED at 1.
>> File drivers/media/IR/ir-keytable.c is not empty after patch, as
> expected
>> 1 out of 1 hunk FAILED -- rejects in file drivers/media/IR/ir-keytable.c
> 
> Not sure if you used the most recent version of patch 4/6 or not.
> 
> If you used the most recent, it's based on 2.6.37-rc1 upstream which has
> both the large-input-scancodes patches as well as two important bugfixes to
> ir-keytable.c, so since your staging/for_v2.6.38 is based on 2.6.36 plus
> the staging/for_v2.6.37-rc1 branch, it won't apply.

Gah! Yeah, my tree is based on 2.6.36, but we need to be based on .37-rc1.
I'll merge .37-rc1.

> If you used to second most recent, then it's based on the
> input-large-scancodes being merged but not the two upstream bugfixes which
> followed it.
> 
> Whichever way you choose, those two bugfixes should not get lost in the
> noise.

Yeah, sure. The git renaming patches will probably do the right thing. I'll
double check.

>> patching file drivers/media/IR/ir-raw-event.c
>> patching file drivers/media/IR/ir-sysfs.c
>> patching file drivers/media/IR/rc-main.c
>> patching file drivers/media/IR/rc-map.c
>> patching file drivers/media/IR/rc-raw.c
>> patching file include/media/ir-core.h
>> Patch patches/lmml_298052_4_6_ir_core_merge_and_rename_to_rc_core.patch
>> does not apply (enforce with -f)
>>
>> I think that the better is if I write a few patches doing the basic
> rename
>> stuff, based on my
>> current tip, and then we can discuss about merging things into a fewer
>> number of files, as 
>> you're proposing, and apply patch 5/6 and 6/6.
>>
>> Not sure why, but patchwork didn't seem to catch patch 6/6. I suspect
> that
>> it is because your
>> name is not encoded with UTF-8 inside the driver. I've picked it
> manually
>> here, and fixed
>> the naming stuff, but it needs patch 5/6, in order to work.
> 
> My name used to be UTF-8 encoded in winbond-cir, and it was changed
> upstream (not by me), so I'm not going to revert it.

Patchwork handles very badly charset encodings, due to Python. I sent several
patches for it to fix several problems I noticed there.
Basically, Python kills any script if the an invalid character is inserted
on a string. E. g., if your emailer says that the email is encoded as UTF-8, and
a non-UTF-8 character is found on any part of the email, the script will die, as
it will try to write the email contents on some vars. 

Due to that, a patch/email with an invalid character on his 
charset will be silently discarded by patchwork, as the script will die.

I suspect that your emailer might be doing some bad things also, as I need 
to manually fix your author's name every time. In general the SOB on your
emails have one encoding, while the From: has another encoding.
 
>> I'll be pushing the renaming stuff soon at ML. I'll try to use your
> naming
>> convention and, if
>> I do it well, maybe I can apply patches 5/6 and 6/6 on it without
>> rebasing. Well, let's see.
> 
> I'll wait for more feedback then?

I'm pulling from 2.6.37-rc1 on my tree. I prefer to keep my approach of using the
git rename stuff on separate patches, as the patches become smaller and easier
to review, and git should probably handle it well, when merged upstream.

So, I'll try to merge the pending patches from your tree. I'll let you know if
I have any problems.

Cheers,
Mauro
> 

