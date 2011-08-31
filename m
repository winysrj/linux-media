Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54793 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1HaKAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 06:00:05 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQS00FH1EG0R020@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 11:00:01 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQS0094SEEC0K@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 10:59:01 +0100 (BST)
Date: Wed, 31 Aug 2011 11:56:05 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] MAINTAINERS: add entries for s5p-mfc and s5p-tv drivers
In-reply-to: <005a01cc67b9$02315560$06940020$%park@samsung.com>
To: jtp.park@samsung.com, linux-media@vger.kernel.org
Cc: kgene.kim@samsung.com, 'Kamil Debski' <k.debski@samsung.com>,
	younglak1004.kim@samsung.com, kyungmin.park@samsung.com
Message-id: <012401cc67c4$33acdf00$9b069d00$%szyprowski@samsung.com>
Content-language: pl
References: <1312968749-15988-1-git-send-email-m.szyprowski@samsung.com>
 <005a01cc67b9$02315560$06940020$%park@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wednesday, August 31, 2011 10:36 AM Jeongtae Park wrote:

> Authors of the code definitely should be maintainers.
> I think everyone will agree.

Ok, I will update the patch.

> 
> Best Regards
> /jtpark
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of
Marek
> Szyprowski
> > Sent: Wednesday, August 10, 2011 6:32 PM
> > To: linux-media@vger.kernel.org
> > Cc: Marek Szyprowski; Kyungmin Park; Kamil Debski; Tomasz Stanislawski
> > Subject: [PATCH] MAINTAINERS: add entries for s5p-mfc and s5p-tv drivers
> >
> > Both driver has been merged to v3.1-rc1, so add its authors as maintainers.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  MAINTAINERS |   18 ++++++++++++++++++
> >  1 files changed, 18 insertions(+), 0 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 51d42fb..0618d9a 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -1084,6 +1084,24 @@ F:	arch/arm/plat-s5p/dev-fimc*
> >  F:	arch/arm/plat-samsung/include/plat/*fimc*
> >  F:	drivers/media/video/s5p-fimc/
> >
> > +ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
> > +M:	Kyungmin Park <kyungmin.park@samsung.com>
> > +M:	Kamil Debski <k.debski@samsung.com>
> 
> M:	Jeongtae Park<jtp.park@samsung.com>
> 
> > +L:	linux-arm-kernel@lists.infradead.org
> > +L:	linux-media@vger.kernel.org
> > +S:	Maintained
> > +F:	arch/arm/plat-s5p/dev-mfc.c
> > +F:	drivers/media/video/s5p-mfc/
> > +
> > +ARM/SAMSUNG S5P SERIES TV SUBSYSTEM SUPPORT
> > +M:	Kyungmin Park <kyungmin.park@samsung.com>
> > +M:	Tomasz Stanislawski <t.stanislaws@samsung.com>
> > +L:	linux-arm-kernel@lists.infradead.org
> > +L:	linux-media@vger.kernel.org
> > +S:	Maintained
> > +F:	arch/arm/plat-s5p/dev-tv.c
> > +F:	drivers/media/video/s5p-tv/
> > +
> >  ARM/SHMOBILE ARM ARCHITECTURE
> >  M:	Paul Mundt <lethal@linux-sh.org>
> >  M:	Magnus Damm <magnus.damm@gmail.com>

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



