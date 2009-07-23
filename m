Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:56428 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZGWN4v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 09:56:51 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n6NDuYC9026174
	for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 16:56:40 +0300
From: tuukka.o.toivonen@nokia.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	tuukka.o.toivonen@nokia.com
Subject: [PATCH] isp: do not force buffer size to be multiple of PAGE_SIZE
Date: Thu, 23 Jul 2009 16:56:26 +0300
Message-Id: <1248357387-14720-3-git-send-email-tuukka.o.toivonen@nokia.com>
In-Reply-To: <1248357387-14720-2-git-send-email-tuukka.o.toivonen@nokia.com>
References: <1248357387-14720-1-git-send-email-tuukka.o.toivonen@nokia.com>
 <1248357387-14720-2-git-send-email-tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>


Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
---
 drivers/media/video/isp/isp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
index ab40110..809b846 100644
--- a/drivers/media/video/isp/isp.c
+++ b/drivers/media/video/isp/isp.c
@@ -1309,8 +1309,7 @@ static int isp_try_pipeline(struct device *dev,
 	}
 
 	pix_output->field = V4L2_FIELD_NONE;
-	pix_output->sizeimage =
-		PAGE_ALIGN(pix_output->bytesperline * pix_output->height);
+	pix_output->sizeimage = pix_output->bytesperline * pix_output->height;
 	pix_output->priv = 0;
 
 	for (ifmt = 0; ifmt < NUM_ISP_CAPTURE_FORMATS; ifmt++) {
-- 
1.5.4.3

