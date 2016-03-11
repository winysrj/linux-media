Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbcCKPzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 10:55:22 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 2/2] [media] v4l2-mc: cleanup a warning
Date: Fri, 11 Mar 2016 12:55:16 -0300
Message-Id: <0fb1f762dc42275eac6138ee597ae0deb3d06947.1457711514.git.mchehab@osg.samsung.com>
In-Reply-To: <d14f3141901856eaed358ab049f4a3aac8fe4863.1457711514.git.mchehab@osg.samsung.com>
References: <d14f3141901856eaed358ab049f4a3aac8fe4863.1457711514.git.mchehab@osg.samsung.com>
In-Reply-To: <d14f3141901856eaed358ab049f4a3aac8fe4863.1457711514.git.mchehab@osg.samsung.com>
References: <d14f3141901856eaed358ab049f4a3aac8fe4863.1457711514.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A previous patch removing dtv_demod needed to be rebased,
but the hunk removing the data was not merged by mistake.

Fixes: 840f5b0572ea ('media: au0828 disable tuner to demod link in au0828_media_device_register()']
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 2a7b79bc90fd..2228cd3a846e 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -34,7 +34,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *if_vid = NULL, *if_aud = NULL;
-	struct media_entity *tuner = NULL, *decoder = NULL, *dtv_demod = NULL;
+	struct media_entity *tuner = NULL, *decoder = NULL;
 	struct media_entity *io_v4l = NULL, *io_vbi = NULL, *io_swradio = NULL;
 	bool is_webcam = false;
 	u32 flags;
-- 
2.5.0

