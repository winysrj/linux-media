Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2LTR0O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Dec 2012 12:26:14 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBKHQE7i028313
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Dec 2012 12:26:14 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] tm6000-video.c: warning fix
Date: Thu, 20 Dec 2012 15:25:52 -0200
Message-Id: <1356024352-22235-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/tm6000/tm6000-video.c: In function '__check_keep_urb':
drivers/media/usb/tm6000/tm6000-video.c:1926:1: warning: return from incompatible pointer type [enabled by default]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/tm6000/tm6000-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 8296801..1edc251 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -57,7 +57,7 @@
 static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
 static int video_nr = -1;		/* /dev/videoN, -1 for autodetect */
 static int radio_nr = -1;		/* /dev/radioN, -1 for autodetect */
-static int keep_urb;			/* keep urb buffers allocated */
+static bool keep_urb;			/* keep urb buffers allocated */
 
 /* Debug level */
 int tm6000_debug;
-- 
1.7.11.7

