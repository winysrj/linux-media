Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57299 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbbEBWAK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 May 2015 18:00:10 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: mchehab@osg.samsung.com
Cc: crope@iki.fi, benjamin@southpole.se, linux-media@vger.kernel.org,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] [media] mn88472: Fix possible leak in mn88472_init()
Date: Sat,  2 May 2015 23:59:29 +0200
Message-Id: <1430603969-7177-1-git-send-email-cengelma@gmx.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 307e95c92257 ("[media] mn88472: implement firmware parity check")
introduced the usage of exit paths that do not free the already allocated
firmware data in case the parity handling fails. Go through the correct
exit paths. Detected by Coverity CID 1295989.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested only. Applies against linux-next.
---
 drivers/staging/media/mn88472/mn88472.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index a4cfcf57c99c..6863c431c648 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -344,12 +344,12 @@ static int mn88472_init(struct dvb_frontend *fe)
 	if (ret) {
 		dev_err(&client->dev,
 				"parity reg read failed=%d\n", ret);
-		goto err;
+		goto firmware_release;
 	}
 	if (tmp & 0x10) {
 		dev_err(&client->dev,
 				"firmware parity check failed=0x%x\n", tmp);
-		goto err;
+		goto firmware_release;
 	}
 	dev_err(&client->dev, "firmware parity check succeeded=0x%x\n", tmp);
 
-- 
1.9.1

