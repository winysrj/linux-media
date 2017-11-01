Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58815 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933372AbdKAVGJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH v2 05/26] media: s5c73m3-core: fix logic on a timeout condition
Date: Wed,  1 Nov 2017 17:05:42 -0400
Message-Id: <efde81ad75a734a715436c1cf08b06dd73c66f17.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/i2c/s5c73m3/s5c73m3-core.c:268 s5c73m3_check_status() error: uninitialized symbol 'status'.

if s5c73m3_check_status() is called too late, time_is_after_jiffies(end)
will return 0, causing the while to abort before reading status.

The current code will do the wrong thing here, as it will still
check if status != value. The right fix here is to just change
the initial state of ret to -ETIMEDOUT. This way, if the
routine is called too late, it will skip the flawed check
and return that a timeout happened.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index cdc4f2392ef9..45345f8b27a5 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -248,7 +248,7 @@ static int s5c73m3_check_status(struct s5c73m3 *state, unsigned int value)
 {
 	unsigned long start = jiffies;
 	unsigned long end = start + msecs_to_jiffies(2000);
-	int ret = 0;
+	int ret = -ETIMEDOUT;
 	u16 status;
 	int count = 0;
 
-- 
2.13.6
