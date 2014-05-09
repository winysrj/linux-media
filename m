Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62657 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEIEy3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 00:54:29 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5A008X1IYSNA40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 May 2014 13:54:28 +0900 (KST)
From: Changbing@vger.kernel.org, Xiong@vger.kernel.org
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, dheitmueller@kernellabs.com,
	Changbing Xiong <cb.xiong@samsung.com>
Subject: [PATCH] au0828: Cancel stream-restart operation if frontend is
 disconnected
Date: Fri, 09 May 2014 12:54:11 +0800
Message-id: <1399611251-7746-1-git-send-email-cb.xiong@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Changbing Xiong <cb.xiong@samsung.com>

If the tuner is already disconnected, It is meaningless to go on doing the
stream-restart operation, It is better to cancel this operation.

Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c |    2 ++
 1 file changed, 2 insertions(+)
 mode change 100644 => 100755 drivers/media/usb/au0828/au0828-dvb.c

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
old mode 100644
new mode 100755
index 9a6f156..fd8e798
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -403,6 +403,8 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 	if (dvb->frontend == NULL)
 		return;

+	cancel_work_sync(&dev->restart_streaming);
+
 	dvb_net_release(&dvb->net);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
--
1.7.9.5

