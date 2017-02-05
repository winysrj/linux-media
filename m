Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:36955 "EHLO
        mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbdBEPIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2017 10:08:00 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH 1/2] [media] cxusb: Use a dma capable buffer also for reading
Date: Sun, 5 Feb 2017 15:57:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <b638428812af41e080ccfc7cf7ad6963@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 17ce039b4e54 ("[media] cxusb: don't do DMA on stack")
added a kmalloc'ed bounce buffer for writes, but missed to do the same
for reads. As the read only happens after the write is finished, we can
reuse the same buffer.

As dvb_usb_generic_rw handles a read length of 0 by itself, avoid calling
it using the dvb_usb_generic_read wrapper function.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
 drivers/media/usb/dvb-usb/cxusb.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 9b8c82d94b3f..8f28a63597bd 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -59,23 +59,24 @@ static int cxusb_ctrl_msg(struct dvb_usb_device *d,
 			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	struct cxusb_state *st = d->priv;
-	int ret, wo;
+	int ret;
 
 	if (1 + wlen > MAX_XFER_SIZE) {
 		warn("i2c wr: len=%d is too big!\n", wlen);
 		return -EOPNOTSUPP;
 	}
 
-	wo = (rbuf == NULL || rlen == 0); /* write-only */
+	if (rlen > MAX_XFER_SIZE) {
+		warn("i2c rd: len=%d is too big!\n", rlen);
+		return -EOPNOTSUPP;
+	}
 
 	mutex_lock(&d->data_mutex);
 	st->data[0] = cmd;
 	memcpy(&st->data[1], wbuf, wlen);
-	if (wo)
-		ret = dvb_usb_generic_write(d, st->data, 1 + wlen);
-	else
-		ret = dvb_usb_generic_rw(d, st->data, 1 + wlen,
-					 rbuf, rlen, 0);
+	ret = dvb_usb_generic_rw(d, st->data, 1 + wlen, st->data, rlen, 0);
+	if (!ret && rbuf && rlen)
+		memcpy(rbuf, st->data, rlen);
 
 	mutex_unlock(&d->data_mutex);
 	return ret;
-- 
2.11.0

