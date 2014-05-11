Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:31825 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757832AbaEKLNb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:13:31 -0400
Date: 11 May 2014 07:13:30 -0400
Message-ID: <20140511111330.14626.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 03/10] ati_remote: Delete superfluous input_sync()
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's not necessary, and since both events happen "at the same time"
in response to a single input event, the input device framework prefers
not to have it there.

(It's not a big deal one way or the other, but deleting cruft
is generally a good thing.)

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/media/rc/ati_remote.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index b92da56e9a..933d614475 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -632,7 +632,6 @@ static void ati_remote_input_report(struct urb *urb)
 
 		input_event(dev, ati_remote_tbl[index].type,
 			ati_remote_tbl[index].code, 1);
-		input_sync(dev);
 		input_event(dev, ati_remote_tbl[index].type,
 			ati_remote_tbl[index].code, 0);
 		input_sync(dev);
-- 
1.9.2

