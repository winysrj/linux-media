Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:48491 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbbFQKXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2015 06:23:17 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] media: atmel-isi: increase timeout to disable/enable isi
Date: Wed, 17 Jun 2015 18:27:08 +0800
Message-ID: <1434536828-21621-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If ISI is working on a 1024x768 or higher resolution, it needs longer
time to disable ISI. So this patch will increase timeout to 500ms.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 1482af2..354b7db 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -219,7 +219,7 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
 	}
 
 	timeout = wait_for_completion_timeout(&isi->complete,
-			msecs_to_jiffies(100));
+			msecs_to_jiffies(500));
 	if (timeout == 0)
 		return -ETIMEDOUT;
 
-- 
1.9.1

