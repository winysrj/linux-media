Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:22328 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121Ab0GPLjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 07:39:09 -0400
Date: Fri, 16 Jul 2010 20:39:10 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 04/10 v2] v4l: Add Samsung FIMC (video postprocessor) driver
In-reply-to: <1279185041-6004-5-git-send-email-s.nawrocki@samsung.com>
To: 'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org
Message-id: <012601cb24db$84fb2380$8ef16a80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1279185041-6004-1-git-send-email-s.nawrocki@samsung.com>
 <1279185041-6004-5-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sylwester Nawrocki wrote:
> 
Hi,

Samsung S.LSI hardly recommends DMA mode to implement the feature not FIFO
mode because of H/W limitation.

> This driver exports two video device nodes per each FIMC device,
> one for for memory to memory (color conversion, image resizing,
> flipping and rotation) operations and one for direct
> V4L2 output interface to framebuffer.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/Kconfig                  |   20 +
>  drivers/media/video/Makefile                 |    1 +
>  drivers/media/video/samsung/fimc/Makefile    |    3 +
>  drivers/media/video/samsung/fimc/fimc-core.c | 1664
> ++++++++++++++++++++++++++
>  drivers/media/video/samsung/fimc/fimc-core.h |  541 +++++++++
>  drivers/media/video/samsung/fimc/fimc-fifo.c |  814 +++++++++++++
>  drivers/media/video/samsung/fimc/fimc-reg.c  |  585 +++++++++
>  include/linux/videodev2.h                    |    1 +
>  8 files changed, 3629 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/samsung/fimc/Makefile
>  create mode 100644 drivers/media/video/samsung/fimc/fimc-core.c
>  create mode 100644 drivers/media/video/samsung/fimc/fimc-core.h
>  create mode 100644 drivers/media/video/samsung/fimc/fimc-fifo.c
>  create mode 100644 drivers/media/video/samsung/fimc/fimc-reg.c
> 

(snip)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

