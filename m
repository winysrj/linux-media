Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37499 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbaHYRMQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/12] rtl2832_sdr: remove unneeded spinlock irq flags initialization
Date: Mon, 25 Aug 2014 20:11:56 +0300
Message-Id: <1408986718-3881-10-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to init flags before calling spin_lock_irqsave().
spin_lock_irqsave is macro which stores value to 'flags'

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 023e0f4..ba305a0 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -329,7 +329,7 @@ static int rtl2832_sdr_rd_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
 static struct rtl2832_sdr_frame_buf *rtl2832_sdr_get_next_fill_buf(
 		struct rtl2832_sdr_state *s)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 	struct rtl2832_sdr_frame_buf *buf = NULL;
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
@@ -570,7 +570,7 @@ static int rtl2832_sdr_alloc_urbs(struct rtl2832_sdr_state *s)
 /* Must be called with vb_queue_lock hold */
 static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_state *s)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
@@ -659,7 +659,7 @@ static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
 	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vb->vb2_queue);
 	struct rtl2832_sdr_frame_buf *buf =
 			container_of(vb, struct rtl2832_sdr_frame_buf, vb);
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	/* Check the device has not disconnected between prep and queuing */
 	if (!s->udev) {
-- 
http://palosaari.fi/

