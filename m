Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17007 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbaAHLwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:52:15 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ200BIBZN1D4A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 11:52:13 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	shaik.ameer@samsung.com
Cc: linux-media@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>
References: <014501cf008e$364ee590$a2ecb0b0$%debski@samsung.com>
 <20140102184937.0837e4a0@samsung.com>
In-reply-to: <20140102184937.0837e4a0@samsung.com>
Subject: RE: [GIT PULL for v3.14] mem2mem patches
Date: Wed, 08 Jan 2014 12:52:12 +0100
Message-id: <049b01cf0c68$11daae70$35900b50$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Shaik,

I had consulted our local DT expert, Tomasz Figa, about this.

His interpretation is in line with my opinion that this is 
a trivial DT binding. It uses only existing properties and does
not introduce new things.

If you insist on having an ack from a DT maintainer then I will
sent you a new pull request without Shaiks' patches.

Shaik could you try to get an ack from a DT maintainer for this
patch?

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:m.chehab@samsung.com]
> Sent: Thursday, January 02, 2014 9:50 PM
> To: Kamil Debski
> Cc: linux-media@vger.kernel.org
> Subject: Re: [GIT PULL for v3.14] mem2mem patches
> 
> Em Tue, 24 Dec 2013 10:55:00 +0100
> Kamil Debski <k.debski@samsung.com> escreveu:
> 
> > The following changes since commit
> 7d459937dc09bb8e448d9985ec4623779427d8a5:
> >
> >   [media] Add driver for Samsung S5K5BAF camera sensor (2013-12-21
> > 07:01:36
> > -0200)
> >
> > are available in the git repository at:
> >
> >   git://linuxtv.org/kdebski/media.git master
> >
> > for you to fetch changes up to
> 0f6616ebb7a04219ad7aa84dd9ff9c7ac9323529:
> >
> >   s5p-mfc: Add controls to set vp8 enc profile (2013-12-24 10:37:27
> > +0100)
> >
> > ----------------------------------------------------------------
> > Arun Kumar K (1):
> >       s5p-mfc: Add QP setting support for vp8 encoder
> >
> > Kiran AVND (1):
> >       s5p-mfc: Add controls to set vp8 enc profile
> >
> > Marek Szyprowski (1):
> >       media: s5p_mfc: remove s5p_mfc_get_node_type() function
> >
> > Shaik Ameer Basha (4):
> >       exynos-scaler: Add new driver for Exynos5 SCALER
> >       exynos-scaler: Add core functionality for the SCALER driver
> >       exynos-scaler: Add m2m functionality for the SCALER driver
> 
> >       exynos-scaler: Add DT bindings for SCALER driver
> 
> This one is missing DT maintainer's ack.
> 
> >
> >  Documentation/DocBook/media/v4l/controls.xml       |   41 +
> >  .../devicetree/bindings/media/exynos5-scaler.txt   |   22 +
> >  drivers/media/platform/Kconfig                     |    8 +
> >  drivers/media/platform/Makefile                    |    1 +
> >  drivers/media/platform/exynos-scaler/Makefile      |    3 +
> >  drivers/media/platform/exynos-scaler/scaler-m2m.c  |  787
> > +++++++++++++  drivers/media/platform/exynos-scaler/scaler-regs.c |
> > 336 ++++++  drivers/media/platform/exynos-scaler/scaler-regs.h |  331
> ++++++
> >  drivers/media/platform/exynos-scaler/scaler.c      | 1238
> > ++++++++++++++++++++
> >  drivers/media/platform/exynos-scaler/scaler.h      |  375 ++++++
> >  drivers/media/platform/s5p-mfc/s5p_mfc.c           |   28 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   14 +-
> >  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   55 +
> >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   26 +-
> >  drivers/media/v4l2-core/v4l2-ctrls.c               |    5 +
> >  include/uapi/linux/v4l2-controls.h                 |    5 +
> >  16 files changed, 3241 insertions(+), 34 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/media/exynos5-scaler.txt
> >  create mode 100644 drivers/media/platform/exynos-scaler/Makefile
> >  create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
> >  create mode 100644 drivers/media/platform/exynos-scaler/scaler-
> regs.c
> >  create mode 100644 drivers/media/platform/exynos-scaler/scaler-
> regs.h
> >  create mode 100644 drivers/media/platform/exynos-scaler/scaler.c
> >  create mode 100644 drivers/media/platform/exynos-scaler/scaler.h
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> 
> Cheers,
> Mauro

