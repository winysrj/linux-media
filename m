Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:47568 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757719AbaEKLQQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:16:16 -0400
Date: 11 May 2014 07:16:15 -0400
Message-ID: <20140511111615.14946.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 07/10] ati_remote: Use non-alomic __set_bit
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason to use a LOCK prefix here.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/media/rc/ati_remote.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 69d7912e03..8536eef918 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -739,7 +739,7 @@ static void ati_remote_input_init(struct ati_remote *ati_remote)
 	for (i = 0; ati_remote_tbl[i].kind != KIND_END; i++)
 		if (ati_remote_tbl[i].kind == KIND_LITERAL ||
 		    ati_remote_tbl[i].kind == KIND_FILTERED)
-			set_bit(ati_remote_tbl[i].code, idev->keybit);
+			__set_bit(ati_remote_tbl[i].code, idev->keybit);
 
 	input_set_drvdata(idev, ati_remote);
 
-- 
1.9.2

