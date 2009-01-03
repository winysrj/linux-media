Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03GBIcm014671
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 11:11:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n03GB2T6003795
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 11:11:02 -0500
Date: Sat, 3 Jan 2009 14:10:29 -0200 (BRST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0901031415060.3955@axis700.grange>
Message-ID: <alpine.LRH.2.00.0901031400260.3513@caramujo.chehab.org>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
	<Pine.LNX.4.64.0901031415060.3955@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] pxa-camera: fix redefinition warnings and missing DMA
 definitions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, 3 Jan 2009, Guennadi Liakhovetski wrote:

> On Sat, 3 Jan 2009, Mauro Carvalho Chehab wrote:
>
>> On Fri, 2 Jan 2009 16:59:36 +0100 (CET)
>> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>>
>>> On Fri, 2 Jan 2009, Eric Miao wrote:
>>>
>>>> 1. now pxa_camera.c uses ioremap() for register access, pxa_camera.h is
>>>>    totally useless. Remove it.
>>>>
>>>> 2. <asm/dma.h> does no longer include <mach/dma.h>, include the latter
>>>>    file explicitly
>>>>
>>>> Signed-off-by: Eric Miao <eric.miao@marvell.com>
>>>
>>> Mauro, it looks like the drivers/media/video/pxa_camera.h part of
>>> http://linuxtv.org/hg/~gliakhovetski/v4l-dvb/rev/30773c067724 has been
>>> dropped on its way to
>>> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=5ca11fa3e0025864df930d6d97470b87c35919ed
>>>
>>> Your hg tree also includes the header hunks, so, it disappeared between
>>> your hg tree and the git tree. Looks like you also lost this hunk
>>>
>>>  #include <asm/arch/camera.h>
>>>  #endif
>>>
>>> -#include "pxa_camera.h"
>>> -
>>>  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
>>>  #define PXA_CAM_DRV_NAME "pxa27x-camera"
>>>
>>> so that now registers are defined twice - by including the header and
>>> directly in .c. What shall we do now? I presume, we cannot roll back
>>> git-tree(s) any more, so, we have to somehow synchronise our hg-trees
>>> now. (how much easier this would be in a perfect world without partial
>>> hg-trees...)
>>
>> I had to manually solve some merging conflicts when updating the upstream
>> driver. Maybe someone else's patch changed something there and we didn't
>> backport the patch.
>
> Sorry, which exactly upstream driver you mean? And which changes
>
>> Yet, I always run a script here to check for the
>> differences between our tree and Linus one.
>>
>> Git annotate points this patch as the responsible for adding this header:
>>
>> 013132ca        ( Eric Miao     2008-11-28 09:16:52 +0800       41)#include "pxa_camera.h"

The changeset 013132ca went on kernel from another tree. This changeset 
added the header you're complaining. This is a typical merge conflict that 
sometimes happen when two trees touch at the same file. Easy to fix: Just 
make a patch with the correct code.

>> A today check for differences, pointed the enclosed changes.
>>
>> I think that the better procedure is just to backport those upstream changes
>> into -hg. Then, you can write a patch fixing the issues, and I'll send it
>> upstream.
>
> Mauro, I am afraid, what you have done isn't quite right. I'll try to
> explain again. In a fresh clone of your hg-tree commit 1070 contains a
> "kernel-sync:" tag, because it went in via ARM tree, and adds the
>
> +
> +#include "pxa_camera.h"
>
> hunk to pxa_camera.c. Commit 1071 doesn't contain that tag, because I
> pulled it via my tree, and removes that header and the above #include
> line. This is also how we want it to be eventually. So, your hg-tree was
> _correct_, and didn't have to be fixed. Whereas in your git-tree commit
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-2.6.git;a=commitdiff;h=5ca11fa3e0025864df930d6d97470b87c35919ed
> is a _corrupted_ version of hg-commit 1071 in your hg-tree - it is missing
> the removal of the header-include. Now instead of removing it in your
> git-tree, you re-added that include again...

At the way your patches were on -hg, they didn't apply upstream. I had to 
do some manual work to make them apply.

> hunk comes from yet another commit...
>
> Can we pleeeeease somehow consider possibilities to move to a complete
> kernel-tree development, or at least allow both.

I _do_ allow both. If you prefer, you may send your patches against my 
-git tree.

>  Whereas I personally see no good way to have both.

Agreed. This means more work to me.

> I really don't understand why you think, that
> v4l users are not intelligent enough to compile complete kernel trees.
> IMHO it is simpler, than compiling external drivers, but that's subjective
> of course.

Several v4l users are linux newbies that just want to have their distro 
kernel working with their hardware. Trying to convince they to have the 
latest unstable -git tree would just make things worse.

So, for sure we need a tree that allows compiling against old kernels.

Maybe we can do what -alsa did: they now use -git for development, and 
create daily snapshots with alsa code that can be compiled against older 
kernels.

Yet, this means to change the entire upstream and development procedure, 
and to find a way to generate those snaps.

I think we need to do this, but it is not so easy to make it happen. I 
intend to work on it this year.

Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
