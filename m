Return-path: <linux-media-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:37130 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbbFFUKc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 16:10:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [media] airspy: add missing include of linux/mm.h
Date: Sat,  6 Jun 2015 22:10:27 +0200
Message-Id: <1433621427-31226-1-git-send-email-hauke@hauke-m.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

airspy uses PAGE_ALIGN() which is defined in linux/mm.h, but this file
is not directly included just indirectly thought some other include
file.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/media/usb/airspy/airspy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 4069234..d182dd2 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <media/v4l2-device.h>
-- 
2.1.4

