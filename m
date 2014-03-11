Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45748 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbaCKIfE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:35:04 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 05/14] v4l: ti-vpe: Allow usage of smaller images
Date: Tue, 11 Mar 2014 14:03:44 +0530
Message-ID: <1394526833-24805-6-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The minimum width and height for VPE input/output was kept as 128 pixels. VPE
doesn't have a constraint on the image height, it requires the image width to
be at least 16 bytes.

Change the minimum supported dimensions to 32x32. This allows us to de-interlace
qcif content. A smaller image size than 32x32 didn't make much sense, so stopped
at this.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 0e7573a..dbdc338 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -49,8 +49,8 @@
 #define VPE_MODULE_NAME "vpe"
 
 /* minimum and maximum frame sizes */
-#define MIN_W		128
-#define MIN_H		128
+#define MIN_W		32
+#define MIN_H		32
 #define MAX_W		1920
 #define MAX_H		1080
 
-- 
1.8.3.2

