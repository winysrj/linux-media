Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:59098 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3ASQdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:33:46 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@redhat.com
Cc: remi.schwartz@gmail.com, sean@mess.org, kyle@kyle.strickland.name,
	simon.farnsworth@onelan.co.uk, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 02/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:05 -0200
Message-Id: <1358613206-4274-2-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
References: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_VIDEO_SAA7134_DVB) || \
     defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
with:
 #if IS_ENABLED(CONFIG_VIDEO_SAA7134_DVB)

This change was made for: CONFIG_VIDEO_SAA7134_DVB

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/pci/saa7134/saa7134.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 0a3feaa..ace44fd 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -42,7 +42,7 @@
 #include <media/videobuf-dma-sg.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
-#if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
+#if IS_ENABLED(CONFIG_VIDEO_SAA7134_DVB)
 #include <media/videobuf-dvb.h>
 #endif
 
@@ -644,7 +644,7 @@ struct saa7134_dev {
 	struct work_struct         empress_workqueue;
 	int                        empress_started;
 
-#if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
+#if IS_ENABLED(CONFIG_VIDEO_SAA7134_DVB)
 	/* SAA7134_MPEG_DVB only */
 	struct videobuf_dvb_frontends frontends;
 	int (*original_demod_sleep)(struct dvb_frontend *fe);
-- 
1.7.11.7

