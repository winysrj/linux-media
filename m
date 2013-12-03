Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57121 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab3LCLvS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 06:51:18 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>
CC: <linux-omap@vger.kernel.org>, <hverkuil@xs4all.nl>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 0/2] v4l: ti-vpe: Some VPE fixes
Date: Tue, 3 Dec 2013 17:21:11 +0530
Message-ID: <1386071473-10808-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series fixes 2 issues in the VPE driver. The first fix allows us to use
UYVY color format for source and destination buffers. The second fix makes sure
we don't set pixel format widths which the VPDMA HW can't support. None of these
fixes are fatal, so they don't necessarily need to go in for the 3.13-rc fixes.

Archit Taneja (2):
  v4l: ti-vpe: Fix the data_type value for UYVY VPDMA format
  v4l: ti-vpe: make sure VPDMA line stride constraints are met

 drivers/media/platform/ti-vpe/vpdma.c      |  4 +--
 drivers/media/platform/ti-vpe/vpdma.h      |  5 ++-
 drivers/media/platform/ti-vpe/vpdma_priv.h |  2 +-
 drivers/media/platform/ti-vpe/vpe.c        | 53 ++++++++++++++++++++++--------
 4 files changed, 47 insertions(+), 17 deletions(-)

-- 
1.8.3.2

