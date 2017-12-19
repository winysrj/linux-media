Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49981 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762318AbdLSLnm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:43:42 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH] media: s5c73m3-core: fix logic on a timeout condition
Date: Tue, 19 Dec 2017 06:43:37 -0500
Message-Id: <fca33cac3228e9424663705f35f4376b9763f643.1513683814.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/i2c/s5c73m3/s5c73m3-core.c:268 s5c73m3_check_status() error: uninitialized symbol 'status'.

if s5c73m3_check_status() is called too late, time_is_after_jiffies(end)
will return 0, causing the while to abort before reading status.

The current code will do the wrong thing here, as it will still
check if status != value. The right fix here is to change
the logic to ensure that it will always read the status.

Suggested-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index cdc4f2392ef9..ce196b60f917 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -248,17 +248,17 @@ static int s5c73m3_check_status(struct s5c73m3 *state, unsigned int value)
 {
 	unsigned long start = jiffies;
 	unsigned long end = start + msecs_to_jiffies(2000);
-	int ret = 0;
+	int ret;
 	u16 status;
 	int count = 0;
 
-	while (time_is_after_jiffies(end)) {
+	do {
 		ret = s5c73m3_read(state, REG_STATUS, &status);
 		if (ret < 0 || status == value)
 			break;
 		usleep_range(500, 1000);
 		++count;
-	}
+	} while (time_is_after_jiffies(end));
 
 	if (count > 0)
 		v4l2_dbg(1, s5c73m3_dbg, &state->sensor_sd,
-- 
2.14.3
