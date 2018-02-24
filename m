Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36763 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbeBXSzs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 13:55:48 -0500
Received: by mail-wr0-f194.google.com with SMTP id v111so5017618wrb.3
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 10:55:48 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 11/12] [media] ngene: move the tsin_exchange() stripcopy block into a function
Date: Sat, 24 Feb 2018 19:55:33 +0100
Message-Id: <20180224185534.13792-12-d.scheller.oss@gmail.com>
In-Reply-To: <20180224185534.13792-1-d.scheller.oss@gmail.com>
References: <20180224185534.13792-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Move the copy logic that will skip previously inserted TS NULL frames when
moving data to the DVB ring buffers into an own function. This is done to
not duplicate code all over the place with the following TS offset shift
fixup patch.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-dvb.c | 48 +++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index f71fd41c762c..6d72b9f69418 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -123,6 +123,32 @@ static u32 overflow;
 static u32 stripped;
 #endif
 
+static inline void tsin_copy_stripped(struct ngene *dev, void *buf)
+{
+	if (memcmp(buf, fill_ts, sizeof(fill_ts)) != 0) {
+		if (dvb_ringbuffer_free(&dev->tsin_rbuf) >= 188) {
+			dvb_ringbuffer_write(&dev->tsin_rbuf, buf, 188);
+			wake_up(&dev->tsin_rbuf.queue);
+#ifdef DEBUG_CI_XFER
+			ok++;
+#endif
+		}
+#ifdef DEBUG_CI_XFER
+		else
+			overflow++;
+#endif
+	}
+#ifdef DEBUG_CI_XFER
+	else
+		stripped++;
+
+	if (ok % 100 == 0 && overflow)
+		dev_warn(&dev->pci_dev->dev,
+			 "%s: ok %u overflow %u dropped %u\n",
+			 __func__, ok, overflow, stripped);
+#endif
+}
+
 void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 {
 	struct ngene_channel *chan = priv;
@@ -134,28 +160,8 @@ void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 
 	if (dev->ci.en && chan->number == 2) {
 		while (len >= 188) {
-			if (memcmp(buf, fill_ts, sizeof fill_ts) != 0) {
-				if (dvb_ringbuffer_free(&dev->tsin_rbuf) >= 188) {
-					dvb_ringbuffer_write(&dev->tsin_rbuf, buf, 188);
-					wake_up(&dev->tsin_rbuf.queue);
-#ifdef DEBUG_CI_XFER
-					ok++;
-#endif
-				}
-#ifdef DEBUG_CI_XFER
-				else
-					overflow++;
-#endif
-			}
-#ifdef DEBUG_CI_XFER
-			else
-				stripped++;
+			tsin_copy_stripped(dev, buf);
 
-			if (ok % 100 == 0 && overflow)
-				dev_warn(&dev->pci_dev->dev,
-					 "%s: ok %u overflow %u dropped %u\n",
-					 __func__, ok, overflow, stripped);
-#endif
 			buf += 188;
 			len -= 188;
 		}
-- 
2.16.1
