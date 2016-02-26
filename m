Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:50691 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbcBZLyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 06:54:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] em28xx: restore lost #ifdef
Date: Fri, 26 Feb 2016 12:53:22 +0100
Message-Id: <1456487606-3912264-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cleanup that changed the em28xx driver to use v4l2_mc_create_media_graph
instead of its own implementation causes a build error when CONFIG_MEDIA_CONTROLLER
is disabled:

drivers/media/usb/em28xx/em28xx-video.c: In function 'em28xx_v4l2_init':
drivers/media/usb/em28xx/em28xx-video.c:2717:38: error: 'struct em28xx' has no member named 'media_dev'

This puts the new code inside the same #ifdef that controls the presence
of the 'media_dev' member, and that the old code was in.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: de39078779cb ("[media] em2xx: use v4l2_mc_create_media_graph()")
---
 drivers/media/usb/em28xx/em28xx-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index f772e2612608..44834b2eff55 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2714,12 +2714,14 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Init entities at the Media Controller */
 	em28xx_v4l2_create_entities(dev);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_mc_create_media_graph(dev->media_dev);
 	if (ret) {
 		em28xx_errdev("failed to create media graph\n");
 		em28xx_v4l2_media_release(dev);
 		goto unregister_dev;
 	}
+#endif
 
 	em28xx_info("V4L2 video device registered as %s\n",
 		    video_device_node_name(&v4l2->vdev));
-- 
2.7.0

