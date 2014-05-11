Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:54053 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757832AbaEKLM4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 07:12:56 -0400
Date: 11 May 2014 07:12:55 -0400
Message-ID: <20140511111255.14584.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: james.hogan@imgtec.com, linux-media@vger.kernel.org,
	linux@horizon.com, m.chehab@samsung.com
Subject: [PATCH 02/10] ati_remote: Shrink ati_remote_tbl structure
In-Reply-To: <20140511111113.14427.qmail@ns.horizon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The variable types are simply larger than they need to be.
Shrink to signed and unsigned chars.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 drivers/media/rc/ati_remote.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 3ddd66a23d..b92da56e9a 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -289,11 +289,11 @@ struct ati_remote {
 
 /* Translation table from hardware messages to input events. */
 static const struct {
-	short kind;
+	unsigned char kind;
 	unsigned char data;
-	int type;
-	unsigned int code;
-	int value;
+	unsigned char type;
+	unsigned short code;
+	signed char value;
 }  ati_remote_tbl[] = {
 	/* Directional control pad axes */
 	{KIND_ACCEL,   0x70, EV_REL, REL_X, -1},   /* left */
-- 
1.9.2

