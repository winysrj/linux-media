Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:55624 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030262AbdIZNgG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 09:36:06 -0400
Subject: [PATCH 2/2] [media] dmxdev: Improve a size determination in
 dvb_dmxdev_add_pid()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Devendra Sharma <devendra.sharma9091@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <5f169dcb-b834-5ca3-2195-668e5295a7ca@users.sourceforge.net>
Message-ID: <a25b98ec-1456-b5d8-8f41-d957555bea17@users.sourceforge.net>
Date: Tue, 26 Sep 2017 15:35:51 +0200
MIME-Version: 1.0
In-Reply-To: <5f169dcb-b834-5ca3-2195-668e5295a7ca@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 15:22:57 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-core/dmxdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index f8bf7459d5ca..8e0f91775fe4 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -809,7 +809,7 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 	    (!list_empty(&filter->feed.ts)))
 		return -EINVAL;
 
-	feed = kzalloc(sizeof(struct dmxdev_feed), GFP_KERNEL);
+	feed = kzalloc(sizeof(*feed), GFP_KERNEL);
 	if (feed == NULL)
 		return -ENOMEM;
 
-- 
2.14.1
