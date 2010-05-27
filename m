Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37625 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0E0LR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 07:17:26 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m-karicheri2@ti.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/3] OMAP_VOUT: Fixes for OMAP2/3 V4L2 Display Driver
Date: Thu, 27 May 2010 16:47:06 +0530
Message-Id: <1274959029-5866-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Fixes required either due to changes in OMAP DSS library or driver
implementation bug.

Vaibhav Hiremath (3):
  OMAP_VOUT:Build FIX: Rebased against latest DSS2 changes
  OMAP_VOUT:FIX:Replaced dma-sg with dma-contig
  OMAP_VOUT:FIX: Module params were not working through bootargs

 drivers/media/video/omap/Kconfig     |    4 +-
 drivers/media/video/omap/Makefile    |    4 +-
 drivers/media/video/omap/omap_vout.c |   81 ++++++++++++++-------------------
 3 files changed, 38 insertions(+), 51 deletions(-)

