Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:60027 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030262AbdIZNe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 09:34:59 -0400
Subject: [PATCH 1/2] [media] dmxdev: Use common error handling code in
 dvb_dmxdev_start_feed()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Devendra Sharma <devendra.sharma9091@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <5f169dcb-b834-5ca3-2195-668e5295a7ca@users.sourceforge.net>
Message-ID: <2c7d9cb4-983c-154c-6c0c-9d6a41bb82e1@users.sourceforge.net>
Date: Tue, 26 Sep 2017 15:34:45 +0200
MIME-Version: 1.0
In-Reply-To: <5f169dcb-b834-5ca3-2195-668e5295a7ca@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 15:12:47 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-core/dmxdev.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 45e91add73ba..f8bf7459d5ca 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -594,18 +594,18 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 	tsfeed->priv = filter;
 
 	ret = tsfeed->set(tsfeed, feed->pid, ts_type, ts_pes, timeout);
-	if (ret < 0) {
-		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
-		return ret;
-	}
+	if (ret < 0)
+		goto release_feed;
 
 	ret = tsfeed->start_filtering(tsfeed);
-	if (ret < 0) {
-		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
-		return ret;
-	}
+	if (ret < 0)
+		goto release_feed;
 
 	return 0;
+
+release_feed:
+	dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
+	return ret;
 }
 
 static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
-- 
2.14.1
