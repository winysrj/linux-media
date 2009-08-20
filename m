Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44696 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZHTEdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 00:33:38 -0400
Date: Thu, 20 Aug 2009 01:33:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
 capture driver
Message-ID: <20090820013306.696e5dd9@pedra.chehab.org>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401548C23A5@dlee06.ent.ti.com>
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
	<A69FA2915331DC488A831521EAE36FE40145300FC7@dlee06.ent.ti.com>
	<200908180849.14003.hverkuil@xs4all.nl>
	<200908180851.06222.hverkuil@xs4all.nl>
	<A69FA2915331DC488A831521EAE36FE401548C1E27@dlee06.ent.ti.com>
	<20090818142817.26de0893@pedra.chehab.org>
	<A69FA2915331DC488A831521EAE36FE401548C23A5@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Aug 2009 10:32:07 -0500
"Karicheri, Muralidharan" <m-karicheri2@ti.com> escreveu:

> Mauro,
> 
> Kevin has approved the architecture part of this patch. When can I expect these to be merged to linux-next?
> 
> Thanks.
> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> email: m-karicheri2@ti.com
> 
> >-----Original Message-----
> >From: Karicheri, Muralidharan
> >Sent: Tuesday, August 18, 2009 5:51 PM
> >To: 'Mauro Carvalho Chehab'
> >Cc: Mauro Carvalho Chehab; linux-media@vger.kernel.org; davinci-linux-open-
> >source@linux.davincidsp.com; khilman@deeprootsystems.com; Hans Verkuil
> >Subject: RE: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
> >capture driver
> >
> >Mauro,
> >
> >Here are the patches from Chaithrika that I am referring to.
> >http://www.mail-archive.com/linux-media@vger.kernel.org/msg08254.html

There's something wrong with this patch:

$ patch -p1 -i 12453a.patch
patching file arch/arm/mach-davinci/board-dm646x-evm.c
Reversed (or previously applied) patch detected!  Assume -R? [n] y
Hunk #1 succeeded at 52 (offset -11 lines).
Hunk #2 succeeded at 218 with fuzz 1 (offset -70 lines).
Hunk #3 succeeded at 286 with fuzz 2 (offset -14 lines).
Hunk #4 FAILED at 293.
Hunk #5 succeeded at 254 (offset -79 lines).
1 out of 5 hunks FAILED -- saving rejects to file arch/arm/mach-davinci/board-dm646x-evm.c.rej
patching file arch/arm/mach-davinci/dm646x.c
Hunk #1 succeeded at 40 with fuzz 2 (offset 8 lines).
Hunk #2 succeeded at 550 with fuzz 1 (offset -145 lines).
Hunk #3 succeeded at 866 with fuzz 1 (offset 12 lines).
patching file arch/arm/mach-davinci/include/mach/dm646x.h
Hunk #1 succeeded at 47 with fuzz 2 (offset 18 lines).

It seems that this patch is not based on my linux-next -git tree. Probably,
this patch is dependent on some patch at Kevin tree.

Kevin,

As this patch touches only arch/arm/ stuff, I suspect that we'll have less
conflicts if you could merge this one. From my side:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> >http://www.mail-archive.com/linux-media@vger.kernel.org/msg07676.html

Hmm... the second patch shows that bisect will be broken with the platform
changes. This patch should be fold with the one that renamed the field, or
before Kconfig/Makefile changes.

I've applied this one on my tree, just before the Kbuild patch.

Due to the DaVinci dependency order, I'll need to hold the DaVinci patches at
the next upstream window to happen after Russell/Kevin trees, to avoid bisect
troubles



Cheers,
Mauro
