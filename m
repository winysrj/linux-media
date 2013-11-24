Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab3KXUoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 15:44:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 89A7240BB3
	for <linux-media@vger.kernel.org>; Sun, 24 Nov 2013 21:44:08 +0100 (CET)
Date: Sun, 24 Nov 2013 21:44:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RESEND] V4L2: remove myself as a maintainer of two drivers
Message-ID: <Pine.LNX.4.64.1311242142570.23650@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since I'm currently unable to dedicate sufficient time to the maintainership
of these two drivers update their status to "orphan" until new maintainers
appear.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Sorry, didn't send to the media list originally.

 MAINTAINERS |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e37e8c0..f7d6b05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7654,15 +7654,13 @@ F:	drivers/media/usb/siano/
 F:	drivers/media/mmc/siano/
 
 SH_VEU V4L2 MEM2MEM DRIVER
-M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/media/platform/sh_veu.c
 
 SH_VOU V4L2 OUTPUT DRIVER
-M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-S:	Odd Fixes
+S:	Orphan
 F:	drivers/media/platform/sh_vou.c
 F:	include/media/sh_vou.h
 
-- 
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
