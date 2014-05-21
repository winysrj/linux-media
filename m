Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaEUSUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/8] [media] au0828: Improve debug messages for urb_completion
Date: Wed, 21 May 2014 15:19:56 -0300
Message-Id: <1400696402-1805-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes, it helps to know how much data was received by
urb_completion. Add that information to the optional debug
log.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 2019e4a168b2..ab5f93643021 100755
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -114,16 +114,20 @@ static void urb_completion(struct urb *purb)
 	int ptype = usb_pipetype(purb->pipe);
 	unsigned char *ptr;
 
-	dprintk(2, "%s()\n", __func__);
+	dprintk(2, "%s: %d\n", __func__, purb->actual_length);
 
-	if (!dev)
+	if (!dev) {
+		dprintk(2, "%s: no dev!\n", __func__);
 		return;
+	}
 
-	if (dev->urb_streaming == 0)
+	if (dev->urb_streaming == 0) {
+		dprintk(2, "%s: not streaming!\n", __func__);
 		return;
+	}
 
 	if (ptype != PIPE_BULK) {
-		printk(KERN_ERR "%s() Unsupported URB type %d\n",
+		printk(KERN_ERR "%s: Unsupported URB type %d\n",
 		       __func__, ptype);
 		return;
 	}
-- 
1.9.0

