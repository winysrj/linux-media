Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43282 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab3DYNJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 09:09:15 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT006DXB744Y80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 14:09:13 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
References: <000b01ce41ad$f5f6c160$e1e44420$%debski@samsung.com>
 <20130425094523.52ce633e@redhat.com>
In-reply-to: <20130425094523.52ce633e@redhat.com>
Subject: RE: [GIT PULL] m2m: Time stamp related fixes
Date: Thu, 25 Apr 2013 15:09:08 +0200
Message-id: <000c01ce41b6$12c24d20$3846e760$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> Sent: Thursday, April 25, 2013 2:45 PM
> 
> Em Thu, 25 Apr 2013 14:11:04 +0200
> Kamil Debski <k.debski@samsung.com> escreveu:
> 
> > Hi Mauro,
> >
> > Sorry for posting this so late. The patches in this pull request add
> > timestamp_type handling to mem2mem drivers.
> >
> > Best wishes,
> >--
> 
> Kamil,
> 
> Not sure what your emailer is doing, but both patchwork and my emailer
> thinks that your message ends with "--". That causes pwclient to not
> get anything below it, forcing me to manually cut and paste the
> remaining parts of it.
> 
> Could you please fix it?

I am sorry. Next time I will make sure it does not have any spurious dashes.
 
> Thanks!
> Mauro
> 
> > Kamil Debski
> > Linux Platform Group
> > Samsung Poland R&D Center
> >
> > The following changes since commit
> 5f3f254f7c138a22a544b80ce2c14a3fc4ed711e:
> >
> >   [media] media/rc/imon.c: kill urb when send_packet() is interrupted
> > (2013-04-23 17:50:34 -0300)
> >
> > are available in the git repository at:
> >
> >   git://git.linuxtv.org/kdebski/media.git media_tree
> >
> > for you to fetch changes up to
> 3a9e65ae54131b8d4568a9e1b0695c37fffb37a2:
> >
> >   mem2mem_testdev: set timestamp_type and add debug param (2013-04-25
> > 13:51:13 +0200)
> >
> > ----------------------------------------------------------------
> > Hans Verkuil (1):
> >       mem2mem_testdev: set timestamp_type and add debug param
> >
> > Kamil Debski (7):
> >       s5p-g2d: Add copy time stamp handling
> >       s5p-jpeg: Add copy time stamp handling
> >       s5p-mfc: Optimize copy time stamp handling
> >       coda: Add copy time stamp handling
> >       exynos-gsc: Add copy time stamp handling
> >       m2m-deinterlace: Add copy time stamp handling
> >       mx2-emmaprp: Add copy time stamp handling
> >
> >  drivers/media/platform/coda.c               |    5 +++++
> >  drivers/media/platform/exynos-gsc/gsc-m2m.c |    5 +++++
> >  drivers/media/platform/m2m-deinterlace.c    |    5 +++++
> >  drivers/media/platform/mem2mem_testdev.c    |   12 +++++++++++-
> >  drivers/media/platform/mx2_emmaprp.c        |    5 +++++
> >  drivers/media/platform/s5p-g2d/g2d.c        |    5 +++++
> >  drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc.c    |   10 ++++------
> >  8 files changed, 45 insertions(+), 7 deletions(-)
> >
> >
> >
> >

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


