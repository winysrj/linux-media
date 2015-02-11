Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57231 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbbBKU66 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 15:58:58 -0500
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, zzam@gentoo.org, hans.verkuil@cisco.com,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] [media] si2165: Fix possible leak in si2165_upload_firmware()
Date: Wed, 11 Feb 2015 21:58:23 +0100
Message-Id: <1423688303-31894-1-git-send-email-cengelma@gmx.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of an error function si2165_upload_firmware() releases the already
requested firmware in the exit path. However, there is one deviation where
the function directly returns. Use the correct cleanup so that the firmware
memory gets freed correctly. Detected by Coverity CID 1269120.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested only. Applies against linux-next.
---
 drivers/media/dvb-frontends/si2165.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 98ddb49ad52b..4cc5d10ed0d4 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -505,7 +505,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	/* reset crc */
 	ret = si2165_writereg8(state, 0x0379, 0x01);
 	if (ret)
-		return ret;
+		goto error;
 
 	ret = si2165_upload_firmware_block(state, data, len,
 					   &offset, block_count);
-- 
1.9.1

