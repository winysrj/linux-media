Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40828 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1DUPVK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 11:21:10 -0400
Date: Thu, 21 Apr 2011 17:21:01 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4] Add v4l2 subdev driver for S5P MIPI-CSI receivers
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kgene.kim@samsung.com, sungchun.kang@samsung.com,
	jonghun.han@samsung.com
Message-id: <1303399264-3849-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

this is a fourth version of the subdev driver for MIPI-CSI2 receivers
present on S5PVx10 and EXYNOS4 SoCs.
This patch set also adds a V4L2_MBUS_FMT_JPEG_1X8 media bus format
and moves the s5p-fimc driver to Video Capture Devices kconfig group.

I don't expect this driver to undergo any major changes and hope to have
it added in kernel 2.6.40.
 
Any comments are welcome!

Changes since v1:
 - added runtime PM support
 - conversion to the pad ops

Changes since v2:
 - added reference counting in s_stream op to allow the mipi-csi subdev
   to be shared by multiple FIMC instances
 - added support for TRY format in pad get_fmt op
 - added pm_runtime* calls in s_stream op to avoid a need for explicit
   s_power(1) call
 - corrected locking around the pad ops, minor bug fixes

Changes since v3:
 - slighty reworked the power management part
 - removed a reference counting in s_stream op as this should be handled
   on a media device and the pipeline level
 - s5p_csis_ prefix renamed to s5pcsis_
 - updated the help text in Kconfig

 [PATCH 1/3] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
 [PATCH v4 2/3] v4l: Move S5P FIMC driver into Video Capture Devices
 [PATCH v4 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI Receiver

 Documentation/DocBook/v4l/subdev-formats.xml |   46 ++
  drivers/media/video/Kconfig                  |   28 +-
  drivers/media/video/s5p-fimc/Makefile        |    6 +-
  drivers/media/video/s5p-fimc/mipi-csis.c     |  745 ++++++++++++++++++++++++++
  drivers/media/video/s5p-fimc/mipi-csis.h     |   22 +
  include/linux/v4l2-mediabus.h                |    3 +
  6 files changed, 840 insertions(+), 10 deletions(-)

--
Regards,
Sylwester Nawrocki
Samsung Poland R&D Center

