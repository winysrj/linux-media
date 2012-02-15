Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60197 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079Ab2BOTVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Feb 2012 14:21:01 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Danny Kukawka <dkukawka@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt9p031.c included media/v4l2-subdev.h twice
Date: Wed, 15 Feb 2012 20:20:55 +0100
Message-Id: <1329333655-32103-1-git-send-email-danny.kukawka@bisect.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/video/mt9p031.c included 'media/v4l2-subdev.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/media/video/mt9p031.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 93c3ec7..dd937df 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -19,7 +19,6 @@
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
-#include <media/v4l2-subdev.h>
 #include <linux/videodev2.h>
 
 #include <media/mt9p031.h>
-- 
1.7.8.3

