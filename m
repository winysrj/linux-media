Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42474 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbaHYRMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/12] airspy: remove unneeded spinlock irq flags initialization
Date: Mon, 25 Aug 2014 20:11:50 +0300
Message-Id: <1408986718-3881-4-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to init flags before calling spin_lock_irqsave().
spin_lock_irqsave is a macro which stores value to 'flags'.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/airspy/airspy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index de9fc52..994c991 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -223,7 +223,7 @@ err:
 /* Private functions */
 static struct airspy_frame_buf *airspy_get_next_fill_buf(struct airspy *s)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 	struct airspy_frame_buf *buf = NULL;
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
@@ -446,7 +446,7 @@ static int airspy_alloc_urbs(struct airspy *s)
 /* Must be called with vb_queue_lock hold */
 static void airspy_cleanup_queued_bufs(struct airspy *s)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	dev_dbg(s->dev, "\n");
 
@@ -506,7 +506,7 @@ static void airspy_buf_queue(struct vb2_buffer *vb)
 	struct airspy *s = vb2_get_drv_priv(vb->vb2_queue);
 	struct airspy_frame_buf *buf =
 			container_of(vb, struct airspy_frame_buf, vb);
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (unlikely(!s->udev)) {
-- 
http://palosaari.fi/

