Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23813 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab0IJDWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 23:22:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8I004F9HD5UT50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Sep 2010 04:22:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8I0086FHD4U6@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Sep 2010 04:22:17 +0100 (BST)
Date: Fri, 10 Sep 2010 12:20:14 +0900
From: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
In-reply-to: <4C891F0D.2060103@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <4C89A3EE.8040503@samsung.com>
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
 <4C891F0D.2060103@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello Mauro,

On 09/10/2010 02:53 AM, Mauro Carvalho Chehab wrote:
> Em 09-09-2010 06:19, Pawel Osciak escreveu:
> > Hello,
> >
> > These patches add a new driver framework for Video for Linux 2 driver
> > - Videobuf2.
>
> I didn't test the patches, but, from a source code review, they seem
> on a good shape. I did a few comments on some patches. There are a few
> missing features for them to be used with real drivers:
>

Thank you for review. I will address your in-code comments in a bit, now
for general comments.

> 1) it lacks implementation of read() method. This means that vivi driver
> has a regression, as it currently supports it.

Yes, read() is not yet implemented. I guess it is not a feature that would
be deprecated, right? There are some problems with read that are 
problematic:
- not every device / memory type will be able to use it, as we need a way
to allocate kernel memory for an operation and not every memory type may
support it
- there is no way to use it with multi-planar API, as it is not possible
to read from multiple memory buffers (having multiple pointers) with read...

But I guess it it could be added to work as before with single-planar 
buffers
only, for compatibility.

Also I am thinking about where read() should be implemented. It is something
that will have to be emulated on top of normal streaming, as it is now done
in videobuf1. So maybe a more generic read implementation would be a good
idea? A separate layer that would be implementing read on top of streaming?
It would not have to be limited to videobuf only then, drivers that support
streaming but not using videobuf would be able to use it too.

> 2) it lacks OVERLAY mode. We can probably mark this feature as deprecated,
> avoiding the need of implementing it on videobuf2, but we need a patch
> for Documentation/feature-removal-schedule.txt,  in order to allow the
> migration of the existing drivers like bttv and saa7134, where this 
> feature
> is implemented, of course if people agree that this is the better way;

If you think this feature can be deprecated, it might be a good idea. If 
not,
I guess I will be able to take a stab at it when working with saa7134 and
bttv, right? Should not require too much work to add. I just did not have
a device to test it on, so I did not add it.

It would be great if you could make the decision about what to do with this.
I will try to follow your opinion and suggestions.

> 3) it lacks the implementation of videobuf-dvb;

Yes... I have no experience with DVB, but I guess I can just get a DVB card
and start hacking. Could you recommend a card? Technisat SkyStar 2?

> 4) it lacks an implementation for DMA S/G.

Yes, I am planning to work on this next, I will be testing on saa7134 
and maybe
something else as well, probably a bttv. Please let me know if you have any
suggestions or recommendations on which drivers I should be focusing.

I am also hoping for Laurent's comments on this, since he was working on SG
much more than I did.

> We need to address all the above issues, in order to use it, otherwise the
> migration of existing drivers would cause regressions, as features will be
> missing.

Right, of course. Videobuf2 is a long time effort and I hope it will be 
evolving
gradually. What I would like to assure you about is that I will not 
abandon it
and will not limit myself to working only on embedded or Samsung device 
support.

Videobuf2 is not only my in-Samsung project and I intend to be working on it
"outside my work responsibilities" as well, supporting desktop and other
platforms, as my time permits.

I would like to address whatever you and others think is necessary and make
videobuf2 useful for as many devices as possible. This is also why I am 
posting
it earlier rather than later. I hope for people to point out features 
they would
require and give their opinions early. I think that working together on 
this we
will be able to gradually come up with a solution that would be useful and
satisfying for most people.


I would like to ask about your idea for the strategy of its development and
inclusion. We will be posting a few drivers based on videobuf2 soon. Do 
you think
it could be merged gradually, as features are added?

It would be great if we could work on it and merge it gradually. Some 
people could
already start using it in new drivers, others could start adding 
features to it,
the API would be stabilizing and we would be having a solid base to work 
on. This is
a long-term effort for many months or maybe years. It goes without 
saying that it
will be harder to add everything in one go.

Others might not be eager to adopt it if it is not an official effort 
either.
And I cannot deny it, it would also make my job easier. As I said, I do 
not intend
to leave it as it is now nor work on embedded support only.

Also, we do not have to migrate all old drivers in one go, but that also 
goes without
saying. As we discussed, videobuf1 will not go away anytime soon.

I think we should consider new drivers as well here. It is troublesome 
when they
provide their custom code instead of using a framework, as is the case 
with some
drivers that have been posted in the previous months and some ongoing 
ones, but this
is also obvious.

Please let me know your opinion. It would be good if we could come up 
with a list
of features that have to be added before merging and others that could 
be added
gradually and a general plan for development of videbuf2.

Thank you!

-- 
Best regards,
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
