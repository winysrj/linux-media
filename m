Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11495 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab1EKPrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 11:47:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 11 May 2011 17:17:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5] Add v4l2 subdev driver for Samsung S5P MIPI-CSI receivers
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kgene.kim@samsung.com, sungchun.kang@samsung.com,
	jonghun.han@samsung.com
Message-id: <1305127030-30162-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

this is fifth version of the subdev driver for MIPI-CSI2 receivers
available on S5PVx10 and EXYNOS4 SoCs. This version is mainly to address
Laurent's review comments, the full thread can be found here:
https://patchwork.kernel.org/patch/725081/

This patch set also adds a V4L2_MBUS_FMT_JPEG_1X8 media bus format
and moves the s5p-fimc driver to Video Capture Devices kconfig group.

Changes since v4:
 - reworked set_fmt/get_fmt pad level ops
 - replaced readl/writel with s5pcsis_read/write macros
 - added initialization to default pixel format in s5pcsis_probe()
 - removed empty media pad ops
 - added missing __init attribute for s5pcsis_probe()
 - edited Kconfig descriptions for s5p-fimc and s5p-csis modules
Patch 1/3 is unchanged since v4.

Changes since v3:
 - slighty reworked the power management part
 - removed a reference counting in s_stream op as this should be handled
   on a media device and the pipeline level
 - s5p_csis_ prefix renamed to s5pcsis_
 - updated the help text in Kconfig

Changes since v2:
 - added reference counting in s_stream op to allow the mipi-csi subdev
   to be shared by multiple FIMC instances
 - added support for TRY format in pad get_fmt op
 - added pm_runtime* calls in s_stream op to avoid a need for explicit
   s_power(1) call
 - corrected locking around the pad ops, minor bug fixes

Changes since v1:
 - added runtime PM support
 - conversion to the pad ops


[PATCH 1/3] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
[PATCH 2/3] v4l: Move s5p-fimc driver into Video capture devices
[PATCH 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI

 Documentation/DocBook/v4l/subdev-formats.xml |   46 ++
 drivers/media/video/Kconfig                  |   28 +-
 drivers/media/video/s5p-fimc/Makefile        |    6 +-
 drivers/media/video/s5p-fimc/mipi-csis.c     |  722 ++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/mipi-csis.h     |   22 +
 include/linux/v4l2-mediabus.h                |    3 +
 6 files changed, 817 insertions(+), 10 deletions(-)

--
Sylwester Nawrocki
Samsung Poland R&D Center
