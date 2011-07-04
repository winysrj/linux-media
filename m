Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:57859 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1GDFKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 01:10:02 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 4 Jul 2011 10:39:54 +0530
Subject: RE: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
Message-ID: <19F8576C6E063C45BE387C64729E739404E34857AE@dbde02.ent.ti.com>
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
 <4E0E1683.8080002@redhat.com>
In-Reply-To: <4E0E1683.8080002@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> Sent: Saturday, July 02, 2011 12:19 AM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org
> Subject: Re: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
> 
> Em 22-06-2011 16:32, hvaibhav@ti.com escreveu:
> > The following changes since commit
> af0d6a0a3a30946f7df69c764791f1b0643f7cd6:
> >   Linus Torvalds (1):
> >         Merge branch 'x86-urgent-for-linus' of
> git://git.kernel.org/.../tip/linux-2.6-tip
> >
> > are available in the git repository at:
> >
> >   git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-
> linux-media
> >
> 
> > Archit Taneja (3):
> >       OMAP_VOUT: CLEANUP: Move generic functions and macros to common
> files
> >       OMAP_VOUT: CLEANUP: Make rotation related helper functions more
> descriptive
> >       OMAP_VOUT: Create separate file for VRFB related API's
> 
> Those are cleanup patches. NACK for 3.0. Cleanups should be sent to -next
> kernel (3.1).
> 
[Hiremath, Vaibhav] Ok, will queue it for 3.1.


> > Vaibhav Hiremath (2):
> >       OMAP_VOUT: Change hardcoded device node number to -1
> >       omap_vout: Added check in reqbuf & mmap for buf_size allocation
> >
> > Vladimir Pantelic (1):
> >       OMAP_VOUTLIB: Fix wrong resizer calculation
> 
> The 3 above patches are ok for 3.0. Added.
> 
[Hiremath, Vaibhav] Thanks,

Thanks,
Vaibhav

> Thanks,
> Mauro.
