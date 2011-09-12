Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:56911 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab1ILOJQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 10:09:16 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p8CE9Ct5005182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 12 Sep 2011 09:09:14 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RFC PATCH 1/4] davinci vpbe: remove unused macro.
Date: Mon, 12 Sep 2011 19:39:04 +0530
Message-ID: <1315836547-20658-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1315836547-20658-1-git-send-email-manjunath.hadli@ti.com>
References: <1315836547-20658-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

remove VPBE_DISPLAY_SD_BUF_SIZE as it is no longer used.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpbe_display.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpbe_display.c b/drivers/media/video/davinci/vpbe_display.c
index ae7add1..09a659e 100644
--- a/drivers/media/video/davinci/vpbe_display.c
+++ b/drivers/media/video/davinci/vpbe_display.c
@@ -43,7 +43,6 @@
 
 static int debug;
 
-#define VPBE_DISPLAY_SD_BUF_SIZE (720*576*2)
 #define VPBE_DEFAULT_NUM_BUFS 3
 
 module_param(debug, int, 0644);
-- 
1.6.2.4

