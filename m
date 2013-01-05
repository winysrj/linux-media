Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab3AEDfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 22:35:00 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r053Z0vo005981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jan 2013 22:35:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] em28xx: declare em28xx_stop_streaming as static
Date: Sat,  5 Jan 2013 01:34:27 -0200
Message-Id: <1357356867-4644-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That fixes the following warning:
	drivers/media/usb/em28xx/em28xx-video.c:611:5: warning: no previous prototype for 'em28xx_stop_streaming' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 40b96d1..75027e3 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -608,7 +608,7 @@ fail:
 	return rc;
 }
 
-int em28xx_stop_streaming(struct vb2_queue *vq)
+static int em28xx_stop_streaming(struct vb2_queue *vq)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_dmaqueue *vidq = &dev->vidq;
-- 
1.7.11.7

