Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/10] [media] siano: print a message if DVB register succeeds
Date: Sun, 22 Feb 2015 13:11:40 -0300
Message-Id: <1424621501-17466-10-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, this is a debug message, misplaced. Promote it
to an info message, as it helps to discover if something
bad happened during device init.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smsdvb-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index e6c41a4941f4..b121f4f262ec 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1182,7 +1182,6 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	client->event_unc_state = -1;
 	sms_board_dvb3_event(client, DVB3_EVENT_HOTPLUG);
 
-	pr_debug("success\n");
 	sms_board_setup(coredev);
 
 	if (smsdvb_debugfs_create(client) < 0)
@@ -1190,6 +1189,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 
 	dvb_create_media_graph(coredev->media_dev);
 
+	pr_info("DVB interface registered.\n");
 	return 0;
 
 client_error:
-- 
2.1.0

