Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35888 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932660AbeCFRqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 12:46:42 -0500
Received: by mail-wr0-f194.google.com with SMTP id v111so21817957wrb.3
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 09:46:41 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 1/2] [media] ngene: move the tsin_exchange() stripcopy block into a function
Date: Tue,  6 Mar 2018 18:46:36 +0100
Message-Id: <20180306174637.24618-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180306174637.24618-1-d.scheller.oss@gmail.com>
References: <20180306174637.24618-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Move the copy logic that will skip previously inserted TS NULL frames when
moving data to the DVB ring buffers into an own function. This is done to
not duplicate code all over the place with the following TS offset shift
fixup patch.

While we're touching this part of the code, get rid of the DEBUG_CI_XFER
debug-ifdeffery. This could be toggleable either by a Kconfig or a module
param, but in the end this will accidentally be enabled and cause lots
of kernel log messages, and such devel debug shouldn't be there anyway.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
Changed since https://www.spinics.net/lists/linux-media/msg129616.html:
* DEBUG_CI_XFER ifdeffery removed

 drivers/media/pci/ngene/ngene-dvb.c | 39 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index 65c79f1b36f7..93a07a370cfd 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -139,12 +139,15 @@ static void swap_buffer(u32 *p, u32 len)
 /* start of filler packet */
 static u8 fill_ts[] = { 0x47, 0x1f, 0xff, 0x10, TS_FILLER };
 
-/* #define DEBUG_CI_XFER */
-#ifdef DEBUG_CI_XFER
-static u32 ok;
-static u32 overflow;
-static u32 stripped;
-#endif
+static inline void tsin_copy_stripped(struct ngene *dev, void *buf)
+{
+	if (memcmp(buf, fill_ts, sizeof(fill_ts)) != 0) {
+		if (dvb_ringbuffer_free(&dev->tsin_rbuf) >= 188) {
+			dvb_ringbuffer_write(&dev->tsin_rbuf, buf, 188);
+			wake_up(&dev->tsin_rbuf.queue);
+		}
+	}
+}
 
 void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 {
@@ -157,28 +160,8 @@ void *tsin_exchange(void *priv, void *buf, u32 len, u32 clock, u32 flags)
 
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
-
-			if (ok % 100 == 0 && overflow)
-				dev_warn(&dev->pci_dev->dev,
-					 "%s: ok %u overflow %u dropped %u\n",
-					 __func__, ok, overflow, stripped);
-#endif
+			tsin_copy_stripped(dev, buf);
+
 			buf += 188;
 			len -= 188;
 		}
-- 
2.16.1
