Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44766 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751433AbdFYVha (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:37:30 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH v2 1/7] [media] dvb-core/dvb_ca_en50221.c: State UNINITIALISED instead of INVALID
Date: Sun, 25 Jun 2017 23:37:05 +0200
Message-Id: <1498426631-17376-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1498426631-17376-1-git-send-email-jasmin@anw.at>
References: <1498426631-17376-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ralph Metzler <rjkm@metzlerbros.de>

In case of a linkinit failure change to state UNINITIALISED to re-init
the CAM.

Original code change by Ralph Metzler, modified by Jasmin Jessich to match
Kernel code style.

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index af694f2..80edbe8 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1176,7 +1176,8 @@ static int dvb_ca_en50221_thread(void *data)
 
 					pr_err("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n",
 					       ca->dvbdev->adapter->num);
-					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_INVALID;
+					ca->slot_info[slot].slot_state =
+						DVB_CA_SLOTSTATE_UNINITIALISED;
 					dvb_ca_en50221_thread_update_delay(ca);
 					break;
 				}
-- 
2.7.4
