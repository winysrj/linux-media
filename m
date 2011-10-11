Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46643 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1JKMvu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 08:51:50 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LSW00MG8JQCG9@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Oct 2011 13:51:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LSW00F1NJQC4O@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Oct 2011 13:51:48 +0100 (BST)
Date: Tue, 11 Oct 2011 14:51:31 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH 0/1] ARM: EXYNOS4: JPEG: driver initial release
To: linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1318337492-21354-1-git-send-email-andrzej.p@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear All,

This patch contains a driver for the JPEG codec integrated peripheral found
in the Samsung Exynos4 SoC.

The driver is implemented within the V4L2 framework as a mem-to-mem device.

It presents two video nodes to userspace, one for the encoding part, and one
for the decoding part.

>From a userspace point of view the encoding process is typical (S_FMT, REQBUF,
optionally QUERYBUF, QBUF, STREAMON, DQBUF) for both the source and destination
queues. The decoding process requires that the source queue performs S_FMT,
REQBUF, (QUERYBUF), QBUF and STREAMON. After STREAMON on the source queue,
it is possible to perform G_FMT on the destination queue to find out the
processed image width and height in order to be able to allocate an appropriate
buffer - it is assumed that the user does not pass the compressed image width
and height but instead this information is parsed from the jpeg input. Although
this is done in kernel, there seems no better way since the JPEG IP in this SoC
cannot stop after it parses the jpeg input header, so once it starts operation,
it needs to already have an appropriately-sized buffer to store decompression
results. Then REQBUF, QBUF and STREAMON on the destination queue complete the
decoding and it is possible to DQBUF from both queues and finish the operation.

During encoding the available formats are: V4L2_PIX_FMT_RGB565X and
V4L2_PIX_FMT_YUYV for source and V4L2_PIX_FMT_YUYV and V4L2_PIX_FMT_YUV420 for
destination.

During decoding the available formats are: V4L2_PIX_FMT_JPEG for source and
V4L2_PIX_FMT_YUYV and V4L2_PIX_FMT_YUV420 for destination.

In order for the driver to work a separate board definition and device
registration patch is required; it is sent to linux-samsung-soc mailing list.

Andrzej Pietrasiewicz

Andrzej Pietrasiewicz (1):
  ARM: EXYNOS4: JPEG: driver initial release

 drivers/media/video/Kconfig              |    8 +
 drivers/media/video/Makefile             |    1 +
 drivers/media/video/s5p-jpeg/Makefile    |    3 +
 drivers/media/video/s5p-jpeg/jpeg-core.c | 1381 ++++++++++++++++++++++++++++++
 drivers/media/video/s5p-jpeg/jpeg-core.h |  116 +++
 drivers/media/video/s5p-jpeg/jpeg-hw.h   |  766 +++++++++++++++++
 drivers/media/video/s5p-jpeg/jpeg-regs.h |  280 ++++++
 7 files changed, 2555 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-jpeg/Makefile
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-core.c
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-core.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-hw.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-regs.h

