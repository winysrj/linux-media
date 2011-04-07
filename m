Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58780 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1DGQrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 12:47:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 07 Apr 2011 18:47:32 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2] Add v4l2 subdev driver for S5P MIPI-CSI receivers
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kgene.kim@samsung.com, sungchun.kang@samsung.com,
	jonghun.han@samsung.com
Message-id: <1302194855-29205-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

the following is a v4l2 subdev driver for MIPI-CSI2 receivers
available in S5PVx10 and EXYNOS4 SoCs. The MIPI-CSIS module 
(MIPI CSI Slave) works closely with the FIMC IP, i.e. it is its 
frontend for the MIPI CSI serial bus.

Other than that the following patch set moves the s5p-fimc driver
under Video Capture Devices in kconfig and adds a V4L2_MBUS_FMT_JPEG_1X8
media bus format.
To follow are patches converting s5p-fimc to the pad ops and
adding a media device for precisely managing all available FIMC and
MIPI CSIS entities and image sensors. However this still needs
a bit of work.

As usual, review comments are welcome!

Changes since v1:
 - added runtime PM support
 - conversion to the pad ops

The patch series contains:

 [PATCH 1/3] v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
 [PATCH 2/3] v4l: Move S5P FIMC driver into Video Capture Devices
 [PATCH 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI Receiver

--
Regards,
Sylwester Nawrocki
Samsung Poland R&D Center
