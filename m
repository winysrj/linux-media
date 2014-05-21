Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaEUSUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 1/8] [media] au0828: Cancel stream-restart operation if frontend is disconnected
Date: Wed, 21 May 2014 15:19:55 -0300
Message-Id: <1400696402-1805-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Changbing Xiong <cb.xiong@samsung.com>

X-Patchwork-Delegate: mchehab@redhat.com
If the tuner is already disconnected, It is meaningless to go on doing the
stream-restart operation, It is better to cancel this operation.

Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c | 2 ++
 1 file changed, 2 insertions(+)
 mode change 100644 => 100755 drivers/media/usb/au0828/au0828-dvb.c

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
old mode 100644
new mode 100755
index 4ae8b1074649..2019e4a168b2
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -471,6 +471,8 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 	if (dvb->frontend == NULL)
 		return;
 
+	cancel_work_sync(&dev->restart_streaming);
+
 	dvb_net_release(&dvb->net);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
-- 
1.9.0

