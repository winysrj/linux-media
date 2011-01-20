Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:62534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab1ATXAl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 18:00:41 -0500
From: Martin Hostettler <martin@neutronstar.dyndns.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH] media-ctl: subdev: add Y8 format.
Date: Fri, 21 Jan 2011 00:00:29 +0100
Message-Id: <1295564429-19578-1-git-send-email-martin@neutronstar.dyndns.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

---
 subdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

This is a trivial patch for media-ctl to support monochrome 8bit video formats.


diff --git a/subdev.c b/subdev.c
index f36a8e7..6f4eb26 100644
--- a/subdev.c
+++ b/subdev.c
@@ -39,6 +39,7 @@ static struct {
 } mbus_formats[] = {
 	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
 	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
+	{ "Y8", V4L2_MBUS_FMT_Y8_1X8}, 
 	{ "SGRBG10", V4L2_MBUS_FMT_SGRBG10_1X10 },
 	{ "SGRBG10_DPCM8", V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 },
 };
-- 
1.7.1

