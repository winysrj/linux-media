Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:8827 "EHLO
	cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbcAOFOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2016 00:14:16 -0500
From: Xiubo Li <lixiubo@cmss.chinamobile.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: [PATCH 3/3] [media] dvbdev: remove useless parentheses after return
Date: Fri, 15 Jan 2016 13:15:00 +0800
Message-Id: <1452834900-28360-4-git-send-email-lixiubo@cmss.chinamobile.com>
In-Reply-To: <1452834900-28360-1-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1452834900-28360-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parentheses are not required after return, and just remove it.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/media/dvb-core/dvbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 3b6e79e..a6c26b5 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -352,7 +352,7 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 	ret = media_device_register_entity(dvbdev->adapter->mdev,
 					   dvbdev->entity);
 	if (ret)
-		return (ret);
+		return ret;
 
 	printk(KERN_DEBUG "%s: media entity '%s' registered.\n",
 		__func__, dvbdev->entity->name);
-- 
1.8.3.1



