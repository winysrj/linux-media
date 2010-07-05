Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:45312 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0GEKMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 06:12:45 -0400
Received: by pxi14 with SMTP id 14so1625385pxi.19
        for <linux-media@vger.kernel.org>; Mon, 05 Jul 2010 03:12:44 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: g.liakhovetski@gmx.de
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-media@vger.kernel.org
Date: Mon, 05 Jul 2010 19:12:59 +0900
Message-Id: <20100705101259.23155.79936.sendpatchset@t400s>
Subject: [PATCH] V4L/DVB: soc-camera: module_put() fix
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Magnus Damm <damm@opensource.se>

Avoid calling module_put() if try_module_get() has
been skipped.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/media/video/soc_camera.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 0001/drivers/media/video/soc_camera.c
+++ work/drivers/media/video/soc_camera.c	2010-06-23 13:43:05.000000000 +0900
@@ -1034,7 +1034,8 @@ eiufmt:
 		soc_camera_free_i2c(icd);
 	} else {
 		icl->del_device(icl);
-		module_put(control->driver->owner);
+		if (control && control->driver && control->driver->owner)
+			module_put(control->driver->owner);
 	}
 enodrv:
 eadddev:
