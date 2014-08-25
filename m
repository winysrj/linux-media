Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48837 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbaHYRMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/12] msi2500: remove unneeded spinlock irq flags initialization
Date: Mon, 25 Aug 2014 20:11:54 +0300
Message-Id: <1408986718-3881-8-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to init flags before calling spin_lock_irqsave().
spin_lock_irqsave is macro which stores value to 'flags'.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 5e3be0e..9e160e8 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -160,7 +160,7 @@ struct msi2500_state {
 static struct msi2500_frame_buf *msi2500_get_next_fill_buf(
 		struct msi2500_state *s)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 	struct msi2500_frame_buf *buf = NULL;
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
@@ -559,7 +559,7 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 /* Must be called with vb_queue_lock hold */
 static void msi2500_cleanup_queued_bufs(struct msi2500_state *s)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	dev_dbg(s->dev, "\n");
 
@@ -635,7 +635,7 @@ static void msi2500_buf_queue(struct vb2_buffer *vb)
 	struct msi2500_state *s = vb2_get_drv_priv(vb->vb2_queue);
 	struct msi2500_frame_buf *buf =
 			container_of(vb, struct msi2500_frame_buf, vb);
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!s->udev)) {
-- 
http://palosaari.fi/

