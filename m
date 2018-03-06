Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44151 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750836AbeCFTPH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:07 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 5/8] cx231xx: Set mfe_shared if second frontend found
Date: Tue,  6 Mar 2018 13:14:59 -0600
Message-Id: <1520363702-25536-6-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
References: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If frontend[1] exists, then enable the dvb adapter mfe lock system.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index c3b2d69..9d326a0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -504,6 +504,9 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 				dev->name, result);
 			goto fail_frontend1;
 		}
+
+		/* MFE lock */
+		dvb->adapter.mfe_shared = 1;
 	}
 
 	/* register demux stuff */
-- 
2.7.4
