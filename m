Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:52891 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab0KLVSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 16:18:08 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp RFC][PATCH 01/10] omap3isp: ccdc: Add support for YUV format
Date: Fri, 12 Nov 2010 15:18:04 -0600
Message-Id: <1289596693-27660-2-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
References: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

We were just supporting RAW10 formats, and we really support more
options.

Strictly speaking, CCDC needs at least to distinguish between RAW
and YUV formats for proper configuration.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/ispccdc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
index be4581e..bee2bbe 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -45,6 +45,8 @@ static const unsigned int ccdc_fmts[] = {
 	V4L2_MBUS_FMT_SRGGB10_1X10,
 	V4L2_MBUS_FMT_SBGGR10_1X10,
 	V4L2_MBUS_FMT_SGBRG10_1X10,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+	V4L2_MBUS_FMT_UYVY8_1X16,
 };
 
 /*
-- 
1.7.0.4

