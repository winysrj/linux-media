Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbeJEVYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 17:24:03 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Oliver Freyermuth <o.freyermuth@googlemail.com>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>,
        stable@vger.kernel.org
Subject: [PATCH] Revert "media: dvbsky: use just one mutex for serializing device R/W ops"
Date: Fri,  5 Oct 2018 10:25:01 -0400
Message-Id: <b39aa816886da2b57ecdfad85f06b4940bcb5d02.1538749479.git.mchehab+samsung@kernel.org>
In-Reply-To: <d0042374-b508-7cb2-cb93-5f4a1951ec95@googlemail.com>
References: <d0042374-b508-7cb2-cb93-5f4a1951ec95@googlemail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed at:
	https://bugzilla.kernel.org/show_bug.cgi?id=199323

This patch causes a bad effect on RPi. I suspect that the root
cause is at the USB RPi driver, with uses high priority
interrupts instead of normal ones. Anyway, as this patch
is mostly a cleanup, better to revert it.

This reverts commit 7d95fb746c4eece67308f1642a666ea1ebdbd2cc.

Cc: stable@vger.kernel.org # For Kernel 4.18
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 1aa88d94e57f..e28bd8836751 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -31,6 +31,7 @@ MODULE_PARM_DESC(disable_rc, "Disable inbuilt IR receiver.");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct dvbsky_state {
+	struct mutex stream_mutex;
 	u8 ibuf[DVBSKY_BUF_LEN];
 	u8 obuf[DVBSKY_BUF_LEN];
 	u8 last_lock;
@@ -67,17 +68,18 @@ static int dvbsky_usb_generic_rw(struct dvb_usb_device *d,
 
 static int dvbsky_stream_ctrl(struct dvb_usb_device *d, u8 onoff)
 {
+	struct dvbsky_state *state = d_to_priv(d);
 	int ret;
-	static u8 obuf_pre[3] = { 0x37, 0, 0 };
-	static u8 obuf_post[3] = { 0x36, 3, 0 };
+	u8 obuf_pre[3] = { 0x37, 0, 0 };
+	u8 obuf_post[3] = { 0x36, 3, 0 };
 
-	mutex_lock(&d->usb_mutex);
-	ret = dvb_usbv2_generic_rw_locked(d, obuf_pre, 3, NULL, 0);
+	mutex_lock(&state->stream_mutex);
+	ret = dvbsky_usb_generic_rw(d, obuf_pre, 3, NULL, 0);
 	if (!ret && onoff) {
 		msleep(20);
-		ret = dvb_usbv2_generic_rw_locked(d, obuf_post, 3, NULL, 0);
+		ret = dvbsky_usb_generic_rw(d, obuf_post, 3, NULL, 0);
 	}
-	mutex_unlock(&d->usb_mutex);
+	mutex_unlock(&state->stream_mutex);
 	return ret;
 }
 
@@ -606,6 +608,8 @@ static int dvbsky_init(struct dvb_usb_device *d)
 	if (ret)
 		return ret;
 	*/
+	mutex_init(&state->stream_mutex);
+
 	state->last_lock = 0;
 
 	return 0;
-- 
2.17.1
