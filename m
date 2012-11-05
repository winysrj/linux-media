Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.work.de ([212.12.40.178]:38229 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab2KEPuI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 10:50:08 -0500
From: Julian Scheel <julian@jusst.de>
To: linux-media@vger.kernel.org
Cc: Julian Scheel <julian@jusst.de>
Subject: [PATCH] tm6000-dvb: Fix module unload.
Date: Mon,  5 Nov 2012 16:51:05 +0100
Message-Id: <1352130665-10795-1-git-send-email-julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_unregister_frontend has to be called before detach. Otherwise the
unregister call will segfault. This made tm6000-dvb module unload unusable.

Signed-off-by: Julian Scheel <julian@jusst.de>
---
 drivers/media/usb/tm6000/tm6000-dvb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index e1f3f66..9fc1e94 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -360,8 +360,8 @@ dvb_dmx_err:
 	dvb_dmx_release(&dvb->demux);
 frontend_err:
 	if (dvb->frontend) {
-		dvb_frontend_detach(dvb->frontend);
 		dvb_unregister_frontend(dvb->frontend);
+		dvb_frontend_detach(dvb->frontend);
 	}
 adapter_err:
 	dvb_unregister_adapter(&dvb->adapter);
@@ -384,8 +384,8 @@ static void unregister_dvb(struct tm6000_core *dev)
 
 /*	mutex_lock(&tm6000_driver.open_close_mutex); */
 	if (dvb->frontend) {
-		dvb_frontend_detach(dvb->frontend);
 		dvb_unregister_frontend(dvb->frontend);
+		dvb_frontend_detach(dvb->frontend);
 	}
 
 	dvb_dmxdev_release(&dvb->dmxdev);
-- 
1.8.0

