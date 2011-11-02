Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1KBUkG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 16:40:06 -0400
Date: Wed, 2 Nov 2011 16:39:58 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] ttusb2: Don't use stack variables for DMA
Message-ID: <20111102203957.GE19809@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ttusb2_msg function uses on-stack variables to submit commands to
dvb_usb_generic.  This eventually gets to the DMA api layer and will throw a
traceback if the debugging options are set.

This allocates the temporary buffer variables with kzalloc instead.

Fixes https://bugzilla.redhat.com/show_bug.cgi?id=734506

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 drivers/media/dvb/dvb-usb/ttusb2.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index ea4eab8..faed393 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -75,10 +75,18 @@ static int ttusb2_msg(struct dvb_usb_device *d, u8 cmd,
 		u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	struct ttusb2_state *st = d->priv;
-	u8 s[wlen+4],r[64] = { 0 };
+	u8 *s, *r = NULL;
 	int ret = 0;
 
-	memset(s,0,wlen+4);
+	s = kzalloc(wlen+4, GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	r = kzalloc(64, GFP_KERNEL);
+	if (!r) {
+		kfree(s);
+		return -ENOMEM;
+	}
 
 	s[0] = 0xaa;
 	s[1] = ++st->id;
@@ -94,12 +102,17 @@ static int ttusb2_msg(struct dvb_usb_device *d, u8 cmd,
 		r[2] != cmd ||
 		(rlen > 0 && r[3] != rlen)) {
 		warn("there might have been an error during control message transfer. (rlen = %d, was %d)",rlen,r[3]);
+		kfree(s);
+		kfree(r);
 		return -EIO;
 	}
 
 	if (rlen > 0)
 		memcpy(rbuf, &r[4], rlen);
 
+	kfree(s);
+	kfree(r);
+
 	return 0;
 }
 
-- 
1.7.6.4


