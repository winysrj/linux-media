Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbcBDP6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 10:58:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/7] [media] siano: remove get_frontend stub
Date: Thu,  4 Feb 2016 13:57:27 -0200
Message-Id: <a210c751a95453321d7e9204633785c32158d9cc.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's nothing at siano's get_frontend() callback. So,
remove it, as the core will handle it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smsdvb-main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index d31f468830cf..9148e14c9d07 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1015,12 +1015,6 @@ static int smsdvb_set_frontend(struct dvb_frontend *fe)
 	}
 }
 
-/* Nothing to do here, as stats are automatically updated */
-static int smsdvb_get_frontend(struct dvb_frontend *fe)
-{
-	return 0;
-}
-
 static int smsdvb_init(struct dvb_frontend *fe)
 {
 	struct smsdvb_client_t *client =
@@ -1069,7 +1063,6 @@ static struct dvb_frontend_ops smsdvb_fe_ops = {
 	.release = smsdvb_release,
 
 	.set_frontend = smsdvb_set_frontend,
-	.get_frontend = smsdvb_get_frontend,
 	.get_tune_settings = smsdvb_get_tune_settings,
 
 	.read_status = smsdvb_read_status,
-- 
2.5.0


