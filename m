Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:25794 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEHG2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 02:28:42 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5800I23SNSH390@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 May 2014 15:28:40 +0900 (KST)
From: Changbing Xiong <cb.xiong@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, dheitmueller@kernellabs.com
Subject: [PATCH 2/2] au0828: Cancel stream-restart operation if frontend is
 disconnected
Date: Thu, 08 May 2014 14:28:23 +0800
Message-id: <1399530503-6820-1-git-send-email-cb.xiong@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the tuner is already disconnected, It is meaningless to go on doing the
stream-restart operation, It is better to cancel this operation.

Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 878f66f..6995309 100755
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -422,6 +422,8 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 	dvb_unregister_frontend(dvb->frontend);
 	dvb_frontend_detach(dvb->frontend);
 	dvb_unregister_adapter(&dvb->adapter);
+
+	cancel_work_sync(&dev->restart_streaming);
 }

 /* All the DVB attach calls go here, this function get's modified
--
1.7.9.5

