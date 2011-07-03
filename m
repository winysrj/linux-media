Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:49690 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751340Ab1GCRFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 13:05:51 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 16/16] ngene: Strip dummy packets inserted by the driver
Date: Sun, 3 Jul 2011 19:04:46 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031904.48044@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As the CI requires a continuous data stream, the driver inserts dummy
packets when necessary. Do not pass these packets to userspace anymore.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/ngene/ngene-core.c |    2 +-
 drivers/media/dvb/ngene/ngene-dvb.c  |   42 +++++++++++++++++++++++++++++-----
 drivers/media/dvb/ngene/ngene.h      |    2 +
 3 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index df0f0bd..f129a93 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -507,7 +507,7 @@ void FillTSBuffer(void *Buffer, int Length, u32 Flags)
 {
 	u32 *ptr = Buffer;
 
-	memset(Buffer, 0xff, Length);
+	memset(Buffer, TS_FILLER, Length);
 	while (Length > 0) {
 		if (Flags & DF_SWAP32)
 			*ptr = 0x471FFF10;
diff --git a/drivers/media/dvb/ngene/ngene-dvb.c b/drivers/media/dvb/ngene/ngene-dvb.c
index ba209cb..fcb16a6 100644
--- a/drivers/media/dvb/ngene/ngene-dvb.c
+++ b/drivers/media/dvb/ngene/ngene-dvb.c
@@ -118,6 +118,16 @@ static void swap_buffer(u32 *p, u32 len)
 	}
 }
 
+/* start of filler packet */
+static u8 fill_ts[] = { 0x47, 0x1f, 0xff, 0x10, TS_FILLER };
+
+/* #define DEBUG_CI_XFER */
+#ifdef DEBUG_CI_XFER
+static u32 ok;
+static u32 overflow;
+static u32 stripped;
+#endif
+
 void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 {
 	struct ngene_channel *chan = priv;
@@ -126,21 +136,41 @@ void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 
 	if (flags & DF_SWAP32)
 		swap_buffer(buf, len);
+
 	if (dev->ci.en && chan->number == 2) {
-		if (dvb_ringbuffer_free(&dev->tsin_rbuf) > len) {
-			dvb_ringbuffer_write(&dev->tsin_rbuf, buf, len);
-			wake_up_interruptible(&dev->tsin_rbuf.queue);
+		while (len >= 188) {
+			if (memcmp(buf, fill_ts, sizeof fill_ts) != 0) {
+				if (dvb_ringbuffer_free(&dev->tsin_rbuf) >= 188) {
+					dvb_ringbuffer_write(&dev->tsin_rbuf, buf, 188);
+					wake_up(&dev->tsin_rbuf.queue);
+#ifdef DEBUG_CI_XFER
+					ok++;
+#endif
+				}
+#ifdef DEBUG_CI_XFER
+				else
+					overflow++;
+#endif
+			}
+#ifdef DEBUG_CI_XFER
+			else
+				stripped++;
+
+			if (ok % 100 == 0 && overflow)
+				printk(KERN_WARNING "%s: ok %u overflow %u dropped %u\n", __func__, ok, overflow, stripped);
+#endif
+			buf += 188;
+			len -= 188;
 		}
-		return 0;
+		return NULL;
 	}
+
 	if (chan->users > 0)
 		dvb_dmx_swfilter(&chan->demux, buf, len);
 
 	return NULL;
 }
 
-u8 fill_ts[188] = { 0x47, 0x1f, 0xff, 0x10 };
-
 void *tsout_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 {
 	struct ngene_channel *chan = priv;
diff --git a/drivers/media/dvb/ngene/ngene.h b/drivers/media/dvb/ngene/ngene.h
index 90fa136..5443dc0 100644
--- a/drivers/media/dvb/ngene/ngene.h
+++ b/drivers/media/dvb/ngene/ngene.h
@@ -789,6 +789,8 @@ struct ngene {
 	u8                    uart_rbuf[UART_RBUF_LEN];
 	int                   uart_rp, uart_wp;
 
+#define TS_FILLER  0x6f
+
 	u8                   *tsout_buf;
 #define TSOUT_BUF_SIZE (512*188*8)
 	struct dvb_ringbuffer tsout_rbuf;
-- 
1.7.4.1

