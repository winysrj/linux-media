Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03DGDU0006323
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 08:16:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n03DFwRo032687
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 08:15:58 -0500
Date: Sat, 3 Jan 2009 11:15:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Eric Miao" <eric.y.miao@gmail.com>
Message-ID: <20090103111548.53025894@pedra.chehab.org>
In-Reply-To: <f17812d70901030504rf0fcdafmc0e3d51ddcb128e@mail.gmail.com>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
	<f17812d70901030504rf0fcdafmc0e3d51ddcb128e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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

On Sat, 3 Jan 2009 21:04:02 +0800
"Eric Miao" <eric.y.miao@gmail.com> wrote:


> > Git annotate points this patch as the responsible for adding this header:
> >
> > 013132ca        ( Eric Miao     2008-11-28 09:16:52 +0800       41)#include "pxa_camera.h"
> >
> > A today check for differences, pointed the enclosed changes.
> >
> 
> Apparently, the enclosed changes are not made in a single commit, I
> don't know much about 'hg' (I'm wondering why v4l is not using git,
> but that's another story), so anything that I can help, please let me
> know.

The changes happened on more than one changeset. Basically, the -hg tree allows
compilation against older kernels, since most of the basis of testers of
v4l/dvb drivers are not enough skilled to compile an entire new kernel.

Anyway, for the changes on arch/arm/, I just copy whatever changed there into
our tree.

The cause of the issue is that your patch were merged outside my -git tree, so,
it caused some merging conflicts, because I was not aware of your patch when I
solved pxa conflicts against linus tree.

I've already updated -hg tree to reflect what we currently have on upstream tree.

Could you or Guennadi submit me a patch fixing the duplicated registers issue?

Thanks,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
