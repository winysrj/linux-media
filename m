Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756600AbdEGWEl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:41 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 01/11] [media] dvb-core/dvb_ca_en50221.c: Rename STATUSREG_??
Date: Sun,  7 May 2017 23:23:24 +0200
Message-Id: <1494192214-20082-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Rename STATUSREG_?? -> STATREG_?? to reduce the line length.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 34 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index cc709c9..b978246 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -72,11 +72,11 @@ MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");
 #define CMDREG_DAIE   0x80	/* Enable DA interrupt */
 #define IRQEN (CMDREG_DAIE)
 
-#define STATUSREG_RE     1	/* read error */
-#define STATUSREG_WE     2	/* write error */
-#define STATUSREG_FR  0x40	/* module free */
-#define STATUSREG_DA  0x80	/* data available */
-#define STATUSREG_TXERR (STATUSREG_RE|STATUSREG_WE)	/* general transfer error */
+#define STATREG_RE     1	/* read error */
+#define STATREG_WE     2	/* write error */
+#define STATREG_FR  0x40	/* module free */
+#define STATREG_DA  0x80	/* data available */
+#define STATREG_TXERR (STATREG_RE|STATREG_WE)	/* general transfer error */
 
 
 #define DVB_CA_SLOTSTATE_NONE           0
@@ -347,7 +347,7 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	/* read the buffer size from the CAM */
 	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SR)) != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_DA, HZ)) != 0)
+	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATREG_DA, HZ)) != 0)
 		return ret;
 	if ((ret = dvb_ca_en50221_read_data(ca, slot, buf, 2)) != 2)
 		return -EIO;
@@ -366,7 +366,7 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	/* write the buffer size to the CAM */
 	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SW)) != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_FR, HZ / 10)) != 0)
+	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATREG_FR, HZ / 10)) != 0)
 		return ret;
 	if ((ret = dvb_ca_en50221_write_data(ca, slot, buf, 2)) != 2)
 		return -EIO;
@@ -661,7 +661,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 		/* check if there is data available */
 		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 			goto exit;
-		if (!(status & STATUSREG_DA)) {
+		if (!(status & STATREG_DA)) {
 			/* no data */
 			status = 0;
 			goto exit;
@@ -713,7 +713,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 		/* check for read error (RE should now be 0) */
 		if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 			goto exit;
-		if (status & STATUSREG_RE) {
+		if (status & STATREG_RE) {
 			ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 			status = -EIO;
 			goto exit;
@@ -778,8 +778,8 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	   process the data if necessary. */
 	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 		goto exitnowrite;
-	if (status & (STATUSREG_DA | STATUSREG_RE)) {
-		if (status & STATUSREG_DA)
+	if (status & (STATREG_DA | STATREG_RE)) {
+		if (status & STATREG_DA)
 			dvb_ca_en50221_thread_wakeup(ca);
 
 		status = -EAGAIN;
@@ -794,7 +794,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	/* check if interface is still free */
 	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 		goto exit;
-	if (!(status & STATUSREG_FR)) {
+	if (!(status & STATREG_FR)) {
 		/* it wasn't free => try again later */
 		status = -EAGAIN;
 		goto exit;
@@ -815,8 +815,8 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	if (status < 0)
 		goto exit;
 
-	if (status & (STATUSREG_DA | STATUSREG_RE)) {
-		if (status & STATUSREG_DA)
+	if (status & (STATREG_DA | STATREG_RE)) {
+		if (status & STATREG_DA)
 			dvb_ca_en50221_thread_wakeup(ca);
 
 		status = -EAGAIN;
@@ -839,7 +839,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	/* check for write error (WE should now be 0) */
 	if ((status = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS)) < 0)
 		goto exit;
-	if (status & STATUSREG_WE) {
+	if (status & STATREG_WE) {
 		ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 		status = -EIO;
 		goto exit;
@@ -952,7 +952,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 	switch (ca->slot_info[slot].slot_state) {
 	case DVB_CA_SLOTSTATE_LINKINIT:
 		flags = ca->pub->read_cam_control(pubca, slot, CTRLIF_STATUS);
-		if (flags & STATUSREG_DA) {
+		if (flags & STATREG_DA) {
 			dprintk("CAM supports DA IRQ\n");
 			ca->slot_info[slot].da_irq_supported = 1;
 		}
@@ -1166,7 +1166,7 @@ static int dvb_ca_en50221_thread(void *data)
 				}
 
 				flags = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
-				if (flags & STATUSREG_FR) {
+				if (flags & STATREG_FR) {
 					ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_LINKINIT;
 					ca->wakeup = 1;
 				}
-- 
2.7.4
