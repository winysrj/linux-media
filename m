Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49748 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbbIRX6f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 19:58:35 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com
Cc: mchehab@osg.samsung.com, linux-arm-kernel@lists.infradead.org,
	kernel@stlinux.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] [media] c8sectpfe: Fix uninitialized return in load_c8sectpfe_fw_step1()
Date: Sat, 19 Sep 2015 01:57:37 +0200
Message-Id: <1442620657-31671-1-git-send-email-cengelma@gmx.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of failure loading the firmware, function
load_c8sectpfe_fw_step1() uses the uninitialized variable ret as return
value instead of the retrieved error value. Make sure the result is
deterministic. Detected by Coverity CID 1324230.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested only. Applies against linux-next.
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 486aef50d99b..16aa494f22be 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -1192,7 +1192,6 @@ err:
 
 static int load_c8sectpfe_fw_step1(struct c8sectpfei *fei)
 {
-	int ret;
 	int err;
 
 	dev_info(fei->dev, "Loading firmware: %s\n", FIRMWARE_MEMDMA);
@@ -1207,7 +1206,7 @@ static int load_c8sectpfe_fw_step1(struct c8sectpfei *fei)
 	if (err) {
 		dev_err(fei->dev, "request_firmware_nowait err: %d.\n", err);
 		complete_all(&fei->fw_ack);
-		return ret;
+		return err;
 	}
 
 	return 0;
-- 
1.9.1

