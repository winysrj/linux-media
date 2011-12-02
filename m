Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53533 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1LBGaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2011 01:30:00 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3 0/5] ARM: davinci: re-arrange definitions to have a
 common	davinci header
Date: Fri, 2 Dec 2011 06:29:49 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F75013C12@DBDE01.ent.ti.com>
References: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
 <DF0F476B391FA8409C78302C7BA518B60354BC@DBDE01.ent.ti.com>
In-Reply-To: <DF0F476B391FA8409C78302C7BA518B60354BC@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar,

On Wed, Nov 30, 2011 at 17:07:21, Nori, Sekhar wrote:
> Hi Manju,
> 
> On Thu, Nov 17, 2011 at 15:48:53, Hadli, Manjunath wrote:
> > Re-arrange definitions and remove unnecessary code so that we canx
> 
> These are two different things and should be done in separate patches. Sergei has already pointed out couple of instances.
Ok,  This is only subject for the cover letter and not individual patches.
The individual patches have separate modularized implementations. I will
change the cover letter subject to "remove private definitions from headers and move to C files". Is that OK?


> 
> > have a common header for all davinci platforms. This will enable
> 
> You mean all DMx platforms? DA8x and TNETVx will still have their own header files after this patch set.

Yes, DMx platforms. I will also change the common "davinci.h" to dmx.h ?

> 
> > us to share defines and enable common routines to be used without 
> > polluting hardware.h.
> >  This patch set forms the base for a later set of patches for having a 
> > common system module base address (DAVINCI_SYSTEM_MODULE_BASE).
> > 
> > Changes from previous version(As per Sergei's comments):
> > 1. Renamed davinci_common.h to davinci.h.
> > 2. Added extra line whereever appropriate.
> > 3. removed unnecessary header inclusion.
> > 
> > Manjunath Hadli (5):
> >   ARM: davinci: dm644x: remove the macros from the header to move to c
> >     file
> >   ARM: davinci: dm365: remove the macros from the header to move to c
> >     file
> >   ARM: davinci: dm646x: remove the macros from the header to move to c
> >     file
> 
> These headlines should describe the changes better. You are moving _private_ defines to C file (to reduce header file pollution). That should be clear from the headline.
> 
> >   ARM: davinci: create new common platform header for davinci
> >   ARM: davinci: delete individual platform header files and use a
> >     common header
> > 
> >  arch/arm/mach-davinci/board-dm355-evm.c      |    2 +-
> >  arch/arm/mach-davinci/board-dm355-leopard.c  |    2 +-
> >  arch/arm/mach-davinci/board-dm365-evm.c      |    2 +-
> >  arch/arm/mach-davinci/board-dm644x-evm.c     |    2 +-
> >  arch/arm/mach-davinci/board-dm646x-evm.c     |    2 +-
> >  arch/arm/mach-davinci/board-neuros-osd2.c    |    2 +-
> >  arch/arm/mach-davinci/board-sffsdr.c         |    2 +-
> >  arch/arm/mach-davinci/dm355.c                |    2 +-
> >  arch/arm/mach-davinci/dm365.c                |   18 +++++-
> >  arch/arm/mach-davinci/dm644x.c               |    9 +++-
> >  arch/arm/mach-davinci/dm646x.c               |    9 +++-
> >  arch/arm/mach-davinci/include/mach/davinci.h |   88 ++++++++++++++++++++++++++
> 
> This file should be placed in arch/arm/mach-davinci itself since the definitions are private to arch/arm/mach-davinci.
> Russell has been complaining about placing unnecessary files in include/mach.

I will just check if the file is needed from the main driver files.
If not, I will move it to mach-davinci.

> 
> Thanks,
> Sekhar
> 
> 
Thanks and Regards,
-Manju

