Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbbBMW6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:19 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv4 22/25] [media] dvbdev: enable DVB-specific links
Date: Fri, 13 Feb 2015 20:58:05 -0200
Message-Id: <05cc37e063d1a95972db38b6211b0f20551a9f00.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For now, let's keep the DVB-specific media controller links enabled
by default. On most devices, this is fixed anyway, so no big issue.

Ok, the demux actually have dynamic links based on the filters, but
we don't represent them yet, as the media controller currently lacks
the capability of dynamically create/delete entities.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index a991819ed1e1..0af9d0c5f889 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -414,13 +414,13 @@ void dvb_create_media_graph(struct media_device *mdev)
 		media_entity_create_link(tuner, 0, fe, 0, 0);
 
 	if (fe && demux)
-		media_entity_create_link(fe, 1, demux, 0, 0);
+		media_entity_create_link(fe, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
 
 	if (demux && dvr)
-		media_entity_create_link(demux, 1, dvr, 0, 0);
+		media_entity_create_link(demux, 1, dvr, 0, MEDIA_LNK_FL_ENABLED);
 
 	if (demux && ca)
-		media_entity_create_link(demux, 1, ca, 0, 0);
+		media_entity_create_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
 #endif
 }
 EXPORT_SYMBOL_GPL(dvb_create_media_graph);
-- 
2.1.0

