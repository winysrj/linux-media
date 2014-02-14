Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37462 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaBNJnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 04:43:14 -0500
Received: by mail-pa0-f52.google.com with SMTP id bj1so12034957pad.25
        for <linux-media@vger.kernel.org>; Fri, 14 Feb 2014 01:43:14 -0800 (PST)
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-media@vger.kernel.org>
Subject: [RFC v3,1/3] v4l2-controls.h: add addtional Flash fault bits
Date: Fri, 14 Feb 2014 18:43:03 +0900
Message-Id: <1392370983-32510-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add addtional falult bits for FLASH
V4L2_FLASH_FAULT_UNDER_VOLTAGE	: UVLO
V4L2_FLASH_FAULT_INPUT_VOLTAGE	: input voltage is adjusted by IVFM
V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE : NTC Trip point is crossed.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 include/uapi/linux/v4l2-controls.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2cbe605..1d662f6 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -812,6 +812,9 @@ enum v4l2_flash_strobe_source {
 #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)
 #define V4L2_FLASH_FAULT_OVER_CURRENT		(1 << 4)
 #define V4L2_FLASH_FAULT_INDICATOR		(1 << 5)
+#define V4L2_FLASH_FAULT_UNDER_VOLTAGE		(1 << 6)
+#define V4L2_FLASH_FAULT_INPUT_VOLTAGE		(1 << 7)
+#define V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE	(1 << 8)
 
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
-- 
1.7.9.5

