Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbBWPVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:21:18 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Ole Ernst <olebowle@gmx.com>
Subject: [PATCH v2] [media] dvb core: only start media entity if not NULL
Date: Mon, 23 Feb 2015 12:21:06 -0300
Message-Id: <2b8b4fd77adde4a1284ffe72dd47e0eec95c364f.1424704848.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic there tries to start the media entity even if it
doesn't exist, causing this bug:

	[  314.356162] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
	[  314.356202] IP: [<ffffffffa02ef74c>] media_entity_pipeline_start+0x1c/0x390 [media]

Reported-by: Gert-Jan van der Stroom <gjstroom@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index d7d390c5c7c3..882ca417f328 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -714,7 +714,7 @@ static int dvb_frontend_thread(void *data)
 		/* FIXME: return an error if it fails */
 		dev_info(fe->dvb->device,
 			"proceeding with FE task\n");
-	} else {
+	} else if (fepriv->pipe_start_entity) {
 		ret = media_entity_pipeline_start(fepriv->pipe_start_entity,
 						  &fepriv->pipe);
 		if (ret)
@@ -832,7 +832,8 @@ restart:
 	}
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	media_entity_pipeline_stop(fepriv->pipe_start_entity);
+	if (fepriv->pipe_start_entity)
+		media_entity_pipeline_stop(fepriv->pipe_start_entity);
 	fepriv->pipe_start_entity = NULL;
 #endif
 
-- 
2.1.0

