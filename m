Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53456 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1LLRpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW300CFKQN2KS90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:02 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3001DMQN1FG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:02 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:44 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 00/14] m5mols camera driver updates
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This changset includes optimization for M-5MOLS booting time and
changes needed for proper support of subdev user space interface.

The last patch enables subdev node at s5p-csis MIPI receiver.

This series depends on http://patchwork.linuxtv.org/patch/8694/
which adds framesamples field to the media bus format data structure.

HeungJun Kim (4):
  m5mols: Extend the busy wait helper
  m5mols: Improve the interrupt handling routines
  m5mols: Add support for the system initialization interrupt
  m5mols: Optimize the capture set up sequence

Sylwester Nawrocki (10):
  m5mols: Simplify the I2C registers definition
  m5mols: Add buffer size configuration support for compressed streams
  m5mols: Remove mode_save field from struct m5mols_info
  m5mols: Change the end of frame v4l2_subdev notification id
  m5mols: Don't ignore v4l2_ctrl_handler_setup() return value
  m5mols: Move the control handler initialization to probe()
  m5mols: Do not reset the configured pixel format when unexpected
  m5mols: Change auto exposure control default value to AUTO
  m5mols: Enable v4l subdev device node
  s5p-csis: Enable v4l subdev device node

 drivers/media/video/m5mols/m5mols.h         |   51 +++--
 drivers/media/video/m5mols/m5mols_capture.c |   87 +++-----
 drivers/media/video/m5mols/m5mols_core.c    |  303 ++++++++++++++++-----------
 drivers/media/video/m5mols/m5mols_reg.h     |  248 +++++++++-------------
 drivers/media/video/s5p-fimc/mipi-csis.c    |   22 ++
 drivers/media/video/s5p-fimc/mipi-csis.h    |    3 +
 6 files changed, 364 insertions(+), 350 deletions(-)

-- 
1.7.8

--
Thanks,

Sylwester



