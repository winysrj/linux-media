Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:61443 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753829AbaK0DOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 22:14:48 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>, <g.liakhovetski@gmx.de>,
	<s.nawrocki@samsung.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] media: v4l2-image-sizes.h: correct the SVGA height definition
Date: Thu, 27 Nov 2014 11:15:01 +0800
Message-ID: <1417058101-2798-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SVGA height should be 600 not 680.

Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
Hi, Mauro

There a typo in my previous patch, so this patch is the fix for that.
Sorry for the incovenience.

Best Regards,
Josh Wu

 include/media/v4l2-image-sizes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/v4l2-image-sizes.h b/include/media/v4l2-image-sizes.h
index c70c917..a07d7a6 100644
--- a/include/media/v4l2-image-sizes.h
+++ b/include/media/v4l2-image-sizes.h
@@ -26,7 +26,7 @@
 #define QVGA_HEIGHT	240
 
 #define SVGA_WIDTH	800
-#define SVGA_HEIGHT	680
+#define SVGA_HEIGHT	600
 
 #define SXGA_WIDTH	1280
 #define SXGA_HEIGHT	1024
-- 
1.9.1

