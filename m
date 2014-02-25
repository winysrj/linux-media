Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1789 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaBYKQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 07/13] mem2mem_testdev: use 40ms default transfer time.
Date: Tue, 25 Feb 2014 11:15:57 +0100
Message-Id: <1393323363-30058-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The default of 1 second is a bit painful, switch to a 25 Hz framerate.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 08e2437..35b2327 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -60,9 +60,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
 #define MEM2MEM_VID_MEM_LIMIT	(16 * 1024 * 1024)
 
 /* Default transaction time in msec */
-#define MEM2MEM_DEF_TRANSTIME	1000
-/* Default number of buffers per transaction */
-#define MEM2MEM_DEF_TRANSLEN	1
+#define MEM2MEM_DEF_TRANSTIME	40
 #define MEM2MEM_COLOR_STEP	(0xff >> 4)
 #define MEM2MEM_NUM_TILES	8
 
@@ -801,10 +799,10 @@ static const struct v4l2_ctrl_config m2mtest_ctrl_trans_time_msec = {
 	.id = V4L2_CID_TRANS_TIME_MSEC,
 	.name = "Transaction Time (msec)",
 	.type = V4L2_CTRL_TYPE_INTEGER,
-	.def = 1001,
+	.def = MEM2MEM_DEF_TRANSTIME,
 	.min = 1,
 	.max = 10001,
-	.step = 100,
+	.step = 1,
 };
 
 static const struct v4l2_ctrl_config m2mtest_ctrl_trans_num_bufs = {
-- 
1.9.0

