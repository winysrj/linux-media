Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46247 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdGPAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 15/16] [media] dvb-core/dvb_ca_en50221.c: Fixed style issues on the whole file
Date: Sun, 16 Jul 2017 02:43:16 +0200
Message-Id: <1500165797-16987-16-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

- Running "checkpatch.pl -strict -f ..." gave more checks to fix.
  * Blank lines aren't necessary after an open brace '{'
  * Comparison to NULL written as "!<var>"
  * CHECK: Blank lines aren't necessary before a close brace '}'

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 24e2b0c..fa5f5ef 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -89,7 +89,6 @@ MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");
 
 /* Information on a CA slot */
 struct dvb_ca_slot {
-
 	/* current state of the CAM */
 	int slot_state;
 
@@ -548,7 +547,7 @@ static int dvb_ca_en50221_parse_attributes(struct dvb_ca_private *ca, int slot)
 
 	/* check it contains the correct DVB string */
 	dvb_str = findstr((char *)tuple, tuple_length, "DVB_CI_V", 8);
-	if (dvb_str == NULL)
+	if (!dvb_str)
 		return -EINVAL;
 	if (tuple_length < ((dvb_str - (char *)tuple) + 12))
 		return -EINVAL;
@@ -640,7 +639,6 @@ static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
 
 	/* fine! */
 	return 0;
-
 }
 
 
@@ -670,7 +668,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 	dprintk("%s\n", __func__);
 
 	/* check if we have space for a link buf in the rx_buffer */
-	if (ebuf == NULL) {
+	if (!ebuf) {
 		int buf_free;
 
 		if (!sl->rx_buffer.data) {
@@ -688,7 +686,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 
 	if (ca->pub->read_data &&
 	    (sl->slot_state != DVB_CA_SLOTSTATE_LINKINIT)) {
-		if (ebuf == NULL)
+		if (!ebuf)
 			status = ca->pub->read_data(ca->pub, slot, buf,
 						    sizeof(buf));
 		else
@@ -699,7 +697,6 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		if (status == 0)
 			goto exit;
 	} else {
-
 		/* check if there is data available */
 		status = ca->pub->read_cam_control(ca->pub, slot,
 						   CTRLIF_STATUS);
@@ -724,7 +721,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 		bytes_read |= status;
 
 		/* check it will fit */
-		if (ebuf == NULL) {
+		if (!ebuf) {
 			if (bytes_read > sl->link_buf_size) {
 				pr_err("dvb_ca adapter %d: CAM tried to send a buffer larger than the link buffer size (%i > %i)!\n",
 				       ca->dvbdev->adapter->num, bytes_read,
@@ -777,7 +774,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
 	 * OK, add it to the receive buffer, or copy into external buffer if
 	 * supplied
 	 */
-	if (ebuf == NULL) {
+	if (!ebuf) {
 		if (!sl->rx_buffer.data) {
 			status = -EIO;
 			goto exit;
@@ -1052,7 +1049,6 @@ EXPORT_SYMBOL(dvb_ca_en50221_frda_irq);
  */
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca)
 {
-
 	dprintk("%s\n", __func__);
 
 	ca->wakeup = 1;
@@ -1662,7 +1658,6 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user *buf,
 	/* wait for some data */
 	status = dvb_ca_en50221_io_read_condition(ca, &result, &slot);
 	if (status == 0) {
-
 		/* if we're in nonblocking mode, exit immediately */
 		if (file->f_flags & O_NONBLOCK)
 			return -EWOULDBLOCK;
-- 
2.7.4
