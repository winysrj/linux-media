Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:2867 "EHLO
	cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbcAOFXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2016 00:23:17 -0500
From: Xiubo Li <lixiubo@cmss.chinamobile.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: [PATCH 1/3] [media] dvbdev: replace kcalloc with kzalloc
Date: Fri, 15 Jan 2016 13:14:58 +0800
Message-Id: <1452834900-28360-2-git-send-email-lixiubo@cmss.chinamobile.com>
In-Reply-To: <1452834900-28360-1-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1452834900-28360-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the number of elements equals to 1, so just use kzalloc to
simplify the code and make it more readable.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/media/dvb-core/dvbdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 560450a..f38fabe 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -620,8 +620,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 			return -ENOMEM;
 		adap->conn = conn;
 
-		adap->conn_pads = kcalloc(1, sizeof(*adap->conn_pads),
-					    GFP_KERNEL);
+		adap->conn_pads = kzalloc(sizeof(*adap->conn_pads), GFP_KERNEL);
 		if (!adap->conn_pads)
 			return -ENOMEM;
 
-- 
1.8.3.1



