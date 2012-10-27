Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab2J0Ums (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:48 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgmiA019909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:48 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 64/68] [media] au0828-dvb: ret is never tested. Get rid of it
Date: Sat, 27 Oct 2012 18:41:22 -0200
Message-Id: <1351370486-29040-65-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/au0828/au0828-dvb.c:275:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/au0828/au0828-dvb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index b328f65..9a6f156 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -272,7 +272,6 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
 	struct au0828_dev *dev = container_of(work, struct au0828_dev,
 					      restart_streaming);
 	struct au0828_dvb *dvb = &dev->dvb;
-	int ret;
 
 	if (dev->urb_streaming == 0)
 		return;
@@ -282,7 +281,7 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
 	mutex_lock(&dvb->lock);
 
 	/* Stop transport */
-	ret = stop_urb_transfer(dev);
+	stop_urb_transfer(dev);
 	au0828_write(dev, 0x608, 0x00);
 	au0828_write(dev, 0x609, 0x00);
 	au0828_write(dev, 0x60a, 0x00);
@@ -293,7 +292,7 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
 	au0828_write(dev, 0x609, 0x72);
 	au0828_write(dev, 0x60a, 0x71);
 	au0828_write(dev, 0x60b, 0x01);
-	ret = start_urb_transfer(dev);
+	start_urb_transfer(dev);
 
 	mutex_unlock(&dvb->lock);
 }
-- 
1.7.11.7

