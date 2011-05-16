Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10934 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1EPMFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 08:05:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 16 May 2011 14:05:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/3 v6] Add v4l2 subdev driver for Samsung S5P MIPI-CSI
	receivers
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kgene.kim@samsung.com, sungchun.kang@samsung.com,
	jonghun.han@samsung.com
Message-id: <1305547539-13194-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I'm resending this MIPI-CSI slave device driver patch to address review comments 
and fix a few further minor issues. My apologies for spamming a mailbox to those
who are not interested.


Changes since v5:
 - slightly improved description of struct csis_state
 - moved the pad number check from __s5pcsis_get_format directly to set_fmt/get_fmt
   pad level operation handlers
 - replaced __init attribute of s5pcsis_probe() with __devinit and added
   __devexit for s5pcsis_remove()
 - fixed bug in s5pcsis_set_hsync_settle, improved set_fmt handler 

[PATCH 1/3] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
[PATCH 2/3] v4l: Move s5p-fimc driver into Video capture devices
[PATCH 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI

Documentation/DocBook/v4l/subdev-formats.xml |   46 ++
 drivers/media/video/Kconfig                  |   28 +-
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-fimc/Makefile        |    6 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |   10 +-
 drivers/media/video/s5p-fimc/mipi-csis.c     |  726 ++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/mipi-csis.h     |   22 +
 include/linux/v4l2-mediabus.h                |    3 +
 8 files changed, 827 insertions(+), 15 deletions(-)

-
Sylwester Nawrocki
Samsung Poland R&D Center
