Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754842AbdEGWFD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:05:03 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 1/7] [media] dvb-core/dvb_ca_en50221.c: State UNINITIALISED instead of INVALID
Date: Sun,  7 May 2017 22:51:47 +0200
Message-Id: <1494190313-18557-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1494190313-18557-1-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

In case of a linkinit failure change to state UNINITIALISED to re-init
the CAM.

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index d38bf9b..9b90d3e 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1172,7 +1172,7 @@ static int dvb_ca_en50221_thread(void *data)
 
 					pr_err("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_UNINITIALISED;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
-- 
2.7.4
