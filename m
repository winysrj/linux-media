Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:48686 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754137AbcI1VU4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:20:56 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 08/35] media: ti-vpe: Increasing max buffer height and width
Date: Wed, 28 Sep 2016 16:20:54 -0500
Message-ID: <20160928212054.26637-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Harinarayan Bhatta <harinarayan@ti.com>

Increasing max buffer height and width to allow for padded buffers.

Signed-off-by: Harinarayan Bhatta <harinarayan@ti.com>
Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d6a2f07c592e..2a4deceea17d 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -53,8 +53,8 @@
 /* minimum and maximum frame sizes */
 #define MIN_W		32
 #define MIN_H		32
-#define MAX_W		1920
-#define MAX_H		1080
+#define MAX_W		2048
+#define MAX_H		1184
 
 /* required alignments */
 #define S_ALIGN		0	/* multiple of 1 */
-- 
2.9.0

