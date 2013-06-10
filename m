Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53495 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3FJM75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 08:59:57 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MO600F3YHFWGQM0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 21:59:56 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH 0/6] s5p-mfc: Add support for MFC v7 firmware
Date: Mon, 10 Jun 2013 18:53:00 +0530
Message-id: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds MFC v7 firmware support to the Exynos
MFC driver. MFC v7 is present in 5420 SoC which has support
for VP8 encoding and many other features.

Arun Kumar K (6):
  [media] s5p-mfc: Update v6 encoder buffer sizes
  [media] s5p-mfc: Add register definition file for MFC v7
  [media] s5p-mfc: Core support for MFC v7
  [media] s5p-mfc: Update driver for v7 firmware
  [media] V4L: Add VP8 encoder controls
  [media] s5p-mfc: Add support for VP8 encoder

 Documentation/DocBook/media/v4l/controls.xml    |  145 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    4 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h    |   58 +++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   32 +++++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   21 +++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  100 +++++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  129 ++++++++++++++++++--
 drivers/media/v4l2-core/v4l2-ctrls.c            |   38 ++++++
 include/uapi/linux/v4l2-controls.h              |   30 ++++-
 10 files changed, 545 insertions(+), 15 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v7.h

-- 
1.7.9.5

