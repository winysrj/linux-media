Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbbJAWRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 18:17:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 2/7] [media] s5c73m3: fix a sparse warning
Date: Thu,  1 Oct 2015 19:17:24 -0300
Message-Id: <c84a71c85b9f37abe029c600ffc02f440829df55.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/s5c73m3/s5c73m3-core.c:170:39: warning: incorrect type in argument 1 (different base types)
drivers/media/i2c/s5c73m3/s5c73m3-core.c:170:39:    expected restricted __be16 const [usertype] *p
drivers/media/i2c/s5c73m3/s5c73m3-core.c:170:39:    got unsigned short [usertype] *<noident>

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 53c5ea89f0b9..51b26010403c 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -167,7 +167,7 @@ static int s5c73m3_i2c_read(struct i2c_client *client, u16 addr, u16 *data)
 	 */
 	ret = i2c_transfer(client->adapter, msg, 2);
 	if (ret == 2) {
-		*data = be16_to_cpup((u16 *)rbuf);
+		*data = be16_to_cpup((__be16 *)rbuf);
 		v4l2_dbg(4, s5c73m3_dbg, client,
 			 "%s: addr: 0x%04x, data: 0x%04x\n",
 			 __func__, addr, *data);
-- 
2.4.3


