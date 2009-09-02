Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36739 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752033AbZIBIQp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 04:16:45 -0400
Date: Wed, 2 Sep 2009 10:16:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] SH: fix ap325rxa compilation breakage
Message-ID: <Pine.LNX.4.64.0909021014190.4416@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An unfortunate typo in an earlier patch broke ap325rxa compilation. Fix it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Mauro, I understand, we'll have to add this as an incremental patch and 
live with the temporary ap325rxa breakage, right? Or would you be rebasing 
the -next git? Sorry about this.

 arch/sh/boards/board-ap325rxa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index b633b25..48ab77e 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -359,8 +359,8 @@ static void ap325rxa_camera_del(struct soc_camera_link *icl)
 		return;
 
 	platform_device_unregister(&camera_device);
-	memset(&migor_camera_device.dev.kobj, 0,
-	       sizeof(migor_camera_device.dev.kobj));
+	memset(&camera_device.dev.kobj, 0,
+	       sizeof(camera_device.dev.kobj));
 }
 #endif /* CONFIG_I2C */
 
-- 
1.6.2.4

