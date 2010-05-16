Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53790 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab0EPM5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 08:57:24 -0400
Message-ID: <4BEFEBAE.8020600@infradead.org>
Date: Sun, 16 May 2010 09:57:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: hermann pitton <hermann-pitton@arcor.de>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	e9hack <e9hack@googlemail.com>
Subject: Re: av7110 and budget_av are broken!
References: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl> <AANLkTimRAmxOL_eilVew3E9cabznR0_H2QZsvAXWM-bk@mail.gmail.com> <1273974828.3200.12.camel@pc07.localdom.local> <201005160622.00278@orion.escape-edv.de>
In-Reply-To: <201005160622.00278@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oliver Endriss wrote:
> On Sunday 16 May 2010 03:53:48 hermann pitton wrote:
>> Am Samstag, den 15.05.2010, 22:33 -0300 schrieb Douglas Schilling
>> Landgraf:
>>> Hello Oliver,
>>>
>>> On Sat, May 15, 2010 at 8:06 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
>>>> On Wednesday 21 April 2010 11:44:16 Oliver Endriss wrote:
>>>>> On Wednesday 21 April 2010 08:37:39 Hans Verkuil wrote:
>>>>>>> Am 22.3.2010 20:34, schrieb e9hack:
>>>>>>>> Am 20.3.2010 22:37, schrieb Hans Verkuil:
>>>>>>>>> On Saturday 20 March 2010 17:03:01 e9hack wrote:
>>>>>>>>> OK, I know that. But does the patch I mailed you last time fix this
>>>>>>>>> problem
>>>>>>>>> without causing new ones? If so, then I'll post that patch to the list.
>>>>>>>> With your last patch, I've no problems. I'm using a a TT-C2300 and a
>>>>>>>> Budget card. If my
>>>>>>>> VDR does start, currently I've no chance to determine which module is
>>>>>>>> load first, but it
>>>>>>>> works. If I unload all modules and load it again, I've no problem. In
>>>>>>>> this case, the
>>>>>>>> modules for the budget card is load first and the modules for the FF
>>>>>>>> loads as second one.
>>>>>>> Ping!!!!!!
>>>>>> It's merged in Mauro's fixes tree, but I don't think those pending patches
>>>>>> have been pushed upstream yet. Mauro, can you verify this? They should be
>>>>>> pushed to 2.6.34!
>>>>> What about the HG driver?
>>>>> The v4l-dvb HG repository is broken for 7 weeks...
>>>> Hi guys,
>>>>
>>>> we have May 16th, and the HG driver is broken for 10 weeks now!
>>>>
>>>> History:
>>>> - The changeset which caused the mess was applied on March 2nd:
>>>>  http://linuxtv.org/hg/v4l-dvb/rev/2eda2bcc8d6f
>>>>
>>>> - A fix is waiting at fixes.git since March 24th:
>>>>  http://git.linuxtv.org/fixes.git?a=commitdiff_plain;h=40358c8b5380604ac2507be2fac0c9bbd3e02b73
>>>>
>>>> Are there any plans to bring v4ldvb HG to an usable state?
>>> Yes, Now I will collect patches from devel and fixes tree. At least
>>> until we achieve a better approach on it.
>>> Sorry the delay.
>>>
>>> Sounds good? Any other suggestion?
>>>
>>> Let me work on it.
>>>
>>> Cheers
>>> Douglas
>>
>> Hi, Douglas and Oliver,
>>
>> just as a small comment.
>>
>> I have not been on latest rc1 and such rcs close to a release for some
>> time.
>>
>> But I was for a long time and v4l-dvb can't be a substitute for such.
> 
> Sorry, I do not want to cope with experimental kernels and their bugs on
> my systems. I need a stable and reliable platform, so that I can
> concentrate on 'my' bugs.
> 
> Usually I update the kernel every 3..4 releases (which causes enough
> trouble due to changed features, interfaces etc).

I used to do it, but, in fact updating every release and following stable
worked better for me, since there are less changes at the features, making
easier to compile a new kernel that won't break anything.

Anyway, it is up to you to use whatever works better for you.

> 
>> Despite of getting more users for testing, on _that_ front does not
>> happen such much currently, keeping v4l-dvb is mostly a service for
>> developers this time.
>>
>> So, contributing on the backports and helping Douglas with such is
>> really welcome.
> 
> I confess that I do not know much about the tree handling procedures of
> the kernel. Imho it sounds crazy to have separate 'fixes' and
> 'development' trees.

I'll change the procedures for 2.6.35. I'll basically opt for having
topic branches (for example, having a "ngene" branch), where all ngene patches
will be applied, updating "master" only after having those patches in kernel.
I'll likely create a stable branch, with the latest kernel, plus all patches
(like v2.6.34-v4l-dvb), to help people that want to develop using git.

The big problem when handling patches upstream is caused by rebasing a patch,
and the higher number of patches in a tree, the higher is the probability that
a rebase will needed to avoid breaking compilation on a bisect.

To give you an example, one big series of patches moved slab.h into each 
driver that uses malloc. If a new driver or c file that needs this include
on our series were added, to avoid breaking bisect, we need to go to the patch
that introduced this code, and add the include there. All patches after this
one needs to be rebased, when submitting upstream.

So, let's say that the original patch has 05a43 has, and the new patch has
a0342 (fictional numbers).

So, in the development branches, this patch is known as 05a43, where, on
upstream, this patch will be known as a0342.

If I rebase the development tree, all developers using git would need to rebase
their trees. If I don't rebase, after merging from upstream, this patch will
appear 2 times at the master branch history: as 05a43 and as a0342. To be worse,
on the next time I need to send patches upstream, this patch will appear again
on my pile of patches to be submitted, and I'll need to manually drop it.
Due to 2.6.33 merge, this problem is already present on our master branch. So,
I'll need to drop a big pile of patches on my next upstream pull request.
At each new kernel release, things would become worse.

With topic branches, things will hopefully become easier, as people can base their
trees on a topic branch. Also, we may have some topic branches based on a stable
release, and others based on upstream, but it will require me to maintain separate
development branches with all merging patches per kernel release.

> 
> A developer's tree (no matter whether HG or GIT) must also include the
> fixes, otherwise it is unusable. You cannot wait until applied fixes
> flow back from the kernel.
> 
> Btw, the v4ldvb HG repositories contain tons of disabled code (marked
> '#if 0'), which was stripped for submission to the kernel.
> Even if we would switch to GIT completely, we need a separate GIT
> repository which would hold the original code.

This is due to a policy we had at -hg time: not pollute upstream with
dead code garbage. Maybe we may have a topic branch with all those dead code, 
but I think that, before adding those code on kernel, we need to review what 
will be added there: there are _lots_ of such #if 0 code that is there for 
years and were never touched (in a matter of fact, this is the typical
case). It seems valuable to do a cleanup first, at -hg, removing the ones that
are there for ages and that nobody is interested on working it, and just
drop at -hg. It will still be there forever, at -hg history, but the source
files will be cleaner without those useless code.

In the specific case of ngene, where stoth and devin are working to enable most
of those dead code, I'll seek for an approach that will add those #if 0 code
before applying the patches that will fix that code, in order to have a better
history at -git, when they submit their next pull request.


-- 

Cheers,
Mauro
