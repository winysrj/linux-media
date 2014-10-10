Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47764 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbaJJO1H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 10:27:07 -0400
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <nikhil.nd@ti.com>
Subject: [RFC PATCH 0/4] ti-vpe: VPE improvements
Date: Fri, 10 Oct 2014 19:56:59 +0530
Message-ID: <1412951223-4711-1-git-send-email-nikhil.nd@ti.com>
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
  [media] ti-vpe: Use line average de-interlacing for first 2 frames

Nikhil Devshatwar (3):
  [media] ti-vpe: Use data offset for getting dma_addr for a plane
  [media] ti-vpe: Do not perform job transaction atomically
  [media] ti-vpe: Add support for SEQ_TB buffers

 drivers/media/platform/ti-vpe/vpe.c |  193 +++++++++++++++++++++++++++--------
 1 file changed, 153 insertions(+), 40 deletions(-)

-- 
1.7.9.5

