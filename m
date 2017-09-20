Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50311
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751728AbdITTMA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:12:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH 18/25] media: dvb_frontend: get rid of dtv_get_property_dump()
Date: Wed, 20 Sep 2017 16:11:43 -0300
Message-Id: <770f2fb8fba1930ca728ae6e713de86e2c6b95c8.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1505933919.git.mchehab@s-opensource.com>
References: <cover.1505933919.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the get property handling and move it to the existing
code at dtv_property_process_get() directly.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 43 ++++++++++-------------------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index b7094c7a405f..607eaf3db052 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1107,36 +1107,6 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_STAT_TOTAL_BLOCK_COUNT, 0, 0),
 };
 
-static void dtv_get_property_dump(struct dvb_frontend *fe,
-			      struct dtv_property *tvp)
-{
-	int i;
-
-	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
-		dev_warn(fe->dvb->device, "%s: GET tvp.cmd = 0x%08x undefined\n"
-				, __func__,
-				tvp->cmd);
-		return;
-	}
-
-	dev_dbg(fe->dvb->device, "%s: GET tvp.cmd    = 0x%08x (%s)\n", __func__,
-		tvp->cmd,
-		dtv_cmds[tvp->cmd].name);
-
-	if (dtv_cmds[tvp->cmd].buffer) {
-		dev_dbg(fe->dvb->device, "%s: tvp.u.buffer.len = 0x%02x\n",
-			__func__, tvp->u.buffer.len);
-
-		for(i = 0; i < tvp->u.buffer.len; i++)
-			dev_dbg(fe->dvb->device,
-					"%s: tvp.u.buffer.data[0x%02x] = 0x%02x\n",
-					__func__, i, tvp->u.buffer.data[i]);
-	} else {
-		dev_dbg(fe->dvb->device, "%s: tvp.u.data = 0x%08x\n", __func__,
-				tvp->u.data);
-	}
-}
-
 /* Synchronise the legacy tuning parameters into the cache, so that demodulator
  * drivers can use a single set_frontend tuning function, regardless of whether
  * it's being used for the legacy or new API, reducing code and complexity.
@@ -1529,7 +1499,18 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	dtv_get_property_dump(fe, tvp);
+	if (!dtv_cmds[tvp->cmd].buffer)
+		dev_dbg(fe->dvb->device,
+			"%s: GET cmd 0x%08x (%s) = 0x%08x\n",
+			__func__, tvp->cmd, dtv_cmds[tvp->cmd].name,
+			tvp->u.data);
+	else
+		dev_dbg(fe->dvb->device,
+			"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
+			__func__,
+			tvp->cmd, dtv_cmds[tvp->cmd].name,
+			tvp->u.buffer.len,
+			tvp->u.buffer.len, tvp->u.buffer.data);
 
 	return 0;
 }
-- 
2.13.5
