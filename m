Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50469 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963AbaLMLyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:54:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 09/10] s5k6aa: fix sparse warnings
Date: Sat, 13 Dec 2014 12:52:59 +0100
Message-Id: <1418471580-26510-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/i2c/s5k6aa.c:351:16: warning: cast to restricted __be16
drivers/media/i2c/s5k6aa.c:351:16: warning: cast to restricted __be16
drivers/media/i2c/s5k6aa.c:351:16: warning: cast to restricted __be16
drivers/media/i2c/s5k6aa.c:351:16: warning: cast to restricted __be16

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5k6aa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 2851581..c98dec3 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -348,7 +348,7 @@ static int s5k6aa_i2c_read(struct i2c_client *client, u16 addr, u16 *val)
 	msg[1].buf = rbuf;
 
 	ret = i2c_transfer(client->adapter, msg, 2);
-	*val = be16_to_cpu(*((u16 *)rbuf));
+	*val = be16_to_cpu(*((__be16 *)rbuf));
 
 	v4l2_dbg(3, debug, client, "i2c_read: 0x%04X : 0x%04x\n", addr, *val);
 
-- 
2.1.3

