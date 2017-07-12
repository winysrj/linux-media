Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54595 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750775AbdGLXBm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:01:42 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 2/9] [media] dvb-core/dvb_ca_en50221.c: New function dvb_ca_en50221_poll_cam_gone
Date: Thu, 13 Jul 2017 01:00:51 +0200
Message-Id: <1499900458-2339-3-git-send-email-jasmin@anw.at>
In-Reply-To: <1499900458-2339-1-git-send-email-jasmin@anw.at>
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

The CAM poll code for the budget-av is exactly the same on several
places. Extracting the code to a new function improves maintainability.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 63 ++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 19d0e9a..66a58ed 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1064,6 +1064,36 @@ static void dvb_ca_en50221_thread_update_delay(struct dvb_ca_private *ca)
 }
 
 /**
+ * Poll if the CAM is gone.
+ *
+ * @ca: CA instance.
+ * @slot: Slot to process.
+ * @return: 0 .. no change
+ *          1 .. CAM state changed
+ */
+
+static int dvb_ca_en50221_poll_cam_gone(struct dvb_ca_private *ca, int slot)
+{
+	int changed = 0;
+	int status;
+
+	/* we need this extra check for annoying interfaces like the
+	 * budget-av
+	 */
+	if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
+	    && (ca->pub->poll_slot_status)) {
+		status = ca->pub->poll_slot_status(ca->pub, slot, 0);
+		if (!(status &
+			DVB_CA_EN50221_POLL_CAM_PRESENT)) {
+			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
+			dvb_ca_en50221_thread_update_delay(ca);
+			changed = 1;
+		}
+	}
+	return changed;
+}
+
+/**
  * Thread state machine for one CA slot to perform the data transfer.
  *
  * @ca: CA instance.
@@ -1074,7 +1104,6 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 {
 	struct dvb_ca_slot *sl = &ca->slot_info[slot];
 	int flags;
-	int status;
 	int pktcount;
 	void *rxbuf;
 
@@ -1123,20 +1152,8 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 
 	case DVB_CA_SLOTSTATE_VALIDATE:
 		if (dvb_ca_en50221_parse_attributes(ca, slot) != 0) {
-			/* we need this extra check for annoying interfaces like
-			 * the budget-av
-			 */
-			if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
-			    && (ca->pub->poll_slot_status)) {
-				status = ca->pub->poll_slot_status(ca->pub,
-								   slot, 0);
-				if (!(status &
-				      DVB_CA_EN50221_POLL_CAM_PRESENT)) {
-					sl->slot_state = DVB_CA_SLOTSTATE_NONE;
-					dvb_ca_en50221_thread_update_delay(ca);
-					break;
-				}
-			}
+			if (dvb_ca_en50221_poll_cam_gone(ca, slot))
+				break;
 
 			pr_err("dvb_ca adapter %d: Invalid PC card inserted :(\n",
 			       ca->dvbdev->adapter->num);
@@ -1185,20 +1202,8 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 
 	case DVB_CA_SLOTSTATE_LINKINIT:
 		if (dvb_ca_en50221_link_init(ca, slot) != 0) {
-			/* we need this extra check for annoying interfaces like
-			 * the budget-av
-			 */
-			if ((!(ca->flags & DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE))
-			    && (ca->pub->poll_slot_status)) {
-				status = ca->pub->poll_slot_status(ca->pub,
-								   slot, 0);
-				if (!(status &
-					DVB_CA_EN50221_POLL_CAM_PRESENT)) {
-					sl->slot_state = DVB_CA_SLOTSTATE_NONE;
-					dvb_ca_en50221_thread_update_delay(ca);
-					break;
-				}
-			}
+			if (dvb_ca_en50221_poll_cam_gone(ca, slot))
+				break;
 
 			pr_err("dvb_ca adapter %d: DVB CAM link initialisation failed :(\n",
 			       ca->dvbdev->adapter->num);
-- 
2.7.4
