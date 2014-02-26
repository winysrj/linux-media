Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47898 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaBZHEZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 02:04:25 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [RFC v6 1/3] v4l2-controls.h: add addtional Flash fault bits
Date: Wed, 26 Feb 2014 16:04:09 +0900
Message-Id: <1393398251-5383-2-git-send-email-gshark.jeong@gmail.com>
In-Reply-To: <1393398251-5383-1-git-send-email-gshark.jeong@gmail.com>
References: <1393398251-5383-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Three Flash fault are added.
 V4L2_FLASH_FAULT_UNDER_VOLTAGE for the case low voltage below the min. limit.
 V4L2_FLASH_FAULT_INPUT_VOLTAGE	for the case falling input voltage and chip  
 adjust flash current not occur under voltage event.
 V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE for the case the temperature exceed
 the maximun limit

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

