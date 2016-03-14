Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:61475 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbcCNWlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 18:41:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [media] v4l2-mc: remove unused dtv_demod variable
Date: Mon, 14 Mar 2016 23:40:09 +0100
Message-Id: <1457995225-1199991-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1457995225-1199991-1-git-send-email-arnd@arndb.de>
References: <1457995225-1199991-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent patch removed the only user of the 'dtv_demod' variable
in v4l2_mc_create_media_graph, but did not remove the declaration,
possibly as a result of an incorrect rebase:

drivers/media/v4l2-core/v4l2-mc.c: In function 'v4l2_mc_create_media_graph':
drivers/media/v4l2-core/v4l2-mc.c:37:55: error: unused variable 'dtv_demod' [-Werror=unused-variable]

This removes the unused variable as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 840f5b0572ea ("media: au0828 disable tuner to demod link in au0828_media_device_register()")
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
2.7.0

