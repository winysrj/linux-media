Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:54708 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZJXPi0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 11:38:26 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH] pxa_camera: Fix missing include for wake_up
Date: Sat, 24 Oct 2009 17:38:21 +0200
Message-Id: <1256398701-7369-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function wake_up() needs include sched.h.
Apparently, commit d43c36dc6b357fa1806800f18aa30123c747a6d1
changed the include chain, removing linux/sched.h

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

--
Kernelversion: v2.6.32-rc5
---
 drivers/media/video/pxa_camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 6952e96..5d01dcf 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/sched.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
-- 
1.6.0.4

