Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42476 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964995AbaKNLUz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 06:20:55 -0500
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id sAEBKs8G021140
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 05:20:54 -0600
Received: from DLEE70.ent.ti.com (dlee70.ent.ti.com [157.170.170.113])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id sAEBKssA018288
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 05:20:54 -0600
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: <nikhil.nd@ti.com>
Subject: [PATCH v2 0/4] VPE improvements
Date: Fri, 14 Nov 2014 16:50:48 +0530
Message-ID: <1415964052-30351-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds following improvements for the ti-vpe driver.
* Support SEQ_TB format for interlaced buffers
	Some of the video decoders generate interlaced content in SEQ_TB format
	Y top, T bottom in one plane and UV top, UV bottom in another
* Improve multi instance latency
	Improve m2m job scheduling in multi instance use cases
	Start processing even if all buffers aren't present
* N frame de-interlace support
	For N input fields, generate N progressive frames

Archit Taneja (1):
  media: ti-vpe: Use line average de-interlacing for first 2 frames

Nikhil Devshatwar (3):
  media: ti-vpe: Use data offset for getting dma_addr for a plane
  media: ti-vpe: Do not perform job transaction atomically
  media: ti-vpe: Add support for SEQ_TB buffers

 drivers/media/platform/ti-vpe/vpe.c |  193 ++++++++++++++++++++++++++++-------
 1 file changed, 155 insertions(+), 38 deletions(-)

-- 
1.7.9.5

