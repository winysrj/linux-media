Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59562 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0GPQfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 12:35:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Date: Fri, 16 Jul 2010 18:33:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [PATCH 04/10 v2] v4l: Add Samsung FIMC (video postprocessor) driver
In-reply-to: <012601cb24db$84fb2380$8ef16a80$%kim@samsung.com>
To: 'Kukjin Kim' <kgene.kim@samsung.com>
Cc: Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Message-id: <000a01cb2504$a8007410$f8015c30$%nawrocki@samsung.com>
Content-language: en-us
References: <1279185041-6004-1-git-send-email-s.nawrocki@samsung.com>
 <1279185041-6004-5-git-send-email-s.nawrocki@samsung.com>
 <012601cb24db$84fb2380$8ef16a80$%kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Kukjin Kim [mailto:kgene.kim@samsung.com]
> Sent: Friday, July 16, 2010 1:39 PM
> To: 'Sylwester Nawrocki'; linux-samsung-soc@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Cc: p.osciak@samsung.com; m.szyprowski@samsung.com;
> kyungmin.park@samsung.com; linux-media@vger.kernel.org
> Subject: RE: [PATCH 04/10 v2] v4l: Add Samsung FIMC (video
> postprocessor) driver
> 
> Sylwester Nawrocki wrote:
> >
> Hi,
> 
> Samsung S.LSI hardly recommends DMA mode to implement the feature not
> FIFO
> mode because of H/W limitation.

Does the hardware issue occur in all SoCs or only some specific versions 
are affected?
So far we were successful with S5PC110 EVT0, however we could not make 
it work on S5PV210 (EVT1). That said I have created an option in the FIMC
variant definition (samsung_fimc_variant::fifo_capable) so that 
the V4L2 video node for FIMC FIFO operation mode is registered only 
for selected SoC variants.

> 
> > This driver exports two video device nodes per each FIMC device,
> > one for for memory to memory (color conversion, image resizing,
> > flipping and rotation) operations and one for direct
> > V4L2 output interface to framebuffer.
> >
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
> > Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/media/video/Kconfig                  |   20 +
> >  drivers/media/video/Makefile                 |    1 +
> >  drivers/media/video/samsung/fimc/Makefile    |    3 +
> >  drivers/media/video/samsung/fimc/fimc-core.c | 1664
> > ++++++++++++++++++++++++++
> >  drivers/media/video/samsung/fimc/fimc-core.h |  541 +++++++++
> >  drivers/media/video/samsung/fimc/fimc-fifo.c |  814 +++++++++++++
> >  drivers/media/video/samsung/fimc/fimc-reg.c  |  585 +++++++++
> >  include/linux/videodev2.h                    |    1 +
> >  8 files changed, 3629 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/samsung/fimc/Makefile
> >  create mode 100644 drivers/media/video/samsung/fimc/fimc-core.c
> >  create mode 100644 drivers/media/video/samsung/fimc/fimc-core.h
> >  create mode 100644 drivers/media/video/samsung/fimc/fimc-fifo.c
> >  create mode 100644 drivers/media/video/samsung/fimc/fimc-reg.c
> >
> 
> (snip)
> 
> Thanks.
> 
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.

Best regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center


