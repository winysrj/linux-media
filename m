Return-path: <linux-media-owner@vger.kernel.org>
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:46547
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965Ab2A1QpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jan 2012 11:45:23 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, standby24x7@gmail.com,
	trivial@kernel.org
Subject: [PATCH] media: Use KERN_ERR not KERN_ERROR in saa7164.h
Date: Sun, 29 Jan 2012 01:44:55 +0900
Message-Id: <1327769095-9036-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct "KERN_ERROR" to "KERN_ERR" in
drivers/media/video/saa7164/saa7164.h

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/video/saa7164/saa7164.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index 742b341..d6f5668 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -613,7 +613,7 @@ extern unsigned int saa_debug;
 
 #define log_err(fmt, arg...)\
 	do { \
-		printk(KERN_ERROR "%s: " fmt, dev->name, ## arg);\
+		printk(KERN_ERR "%s: " fmt, dev->name, ## arg);\
 	} while (0)
 
 #define saa7164_readl(reg) readl(dev->lmmio + ((reg) >> 2))
-- 
1.7.6.5

