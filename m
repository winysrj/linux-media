Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55977 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaK2K1n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Nov 2014 05:27:43 -0500
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id sATARgWW025963
	for <linux-media@vger.kernel.org>; Sat, 29 Nov 2014 04:27:42 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id sATARgMi004574
	for <linux-media@vger.kernel.org>; Sat, 29 Nov 2014 04:27:42 -0600
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: <nikhil.nd@ti.com>
Subject: [PATCH v3 0/4] VPE improvements
Date: Sat, 29 Nov 2014 15:57:35 +0530
Message-ID: <1417256860-20233-1-git-send-email-nikhil.nd@ti.com>
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

 drivers/media/platform/ti-vpe/vpe.c |  191 ++++++++++++++++++++++++++++-------
 1 file changed, 154 insertions(+), 37 deletions(-)

-- 
1.7.9.5

