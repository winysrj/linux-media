Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2923 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3LTJcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 43/50] adv7842: enable HDMI/DVI mode irq
Date: Fri, 20 Dec 2013 10:31:36 +0100
Message-Id: <1387531903-20496-44-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 108e1b0..e6932f4 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1834,12 +1834,15 @@ static void adv7842_irq_enable(struct v4l2_subdev *sd, bool enable)
 		io_write(sd, 0x78, 0x03);
 		/* Enable SDP Standard Detection Change and SDP Video Detected */
 		io_write(sd, 0xa0, 0x09);
+		/* Enable HDMI_MODE interrupt */
+		io_write(sd, 0x69, 0x08);
 	} else {
 		io_write(sd, 0x46, 0x0);
 		io_write(sd, 0x5a, 0x0);
 		io_write(sd, 0x73, 0x0);
 		io_write(sd, 0x78, 0x0);
 		io_write(sd, 0xa0, 0x0);
+		io_write(sd, 0x69, 0x0);
 	}
 }
 
@@ -1847,7 +1850,7 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 {
 	struct adv7842_state *state = to_state(sd);
 	u8 fmt_change_cp, fmt_change_digital, fmt_change_sdp;
-	u8 irq_status[5];
+	u8 irq_status[6];
 
 	adv7842_irq_enable(sd, false);
 
@@ -1857,6 +1860,7 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	irq_status[2] = io_read(sd, 0x70);
 	irq_status[3] = io_read(sd, 0x75);
 	irq_status[4] = io_read(sd, 0x9d);
+	irq_status[5] = io_read(sd, 0x66);
 
 	/* and clear */
 	if (irq_status[0])
@@ -1869,12 +1873,14 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 		io_write(sd, 0x76, irq_status[3]);
 	if (irq_status[4])
 		io_write(sd, 0x9e, irq_status[4]);
+	if (irq_status[5])
+		io_write(sd, 0x67, irq_status[5]);
 
 	adv7842_irq_enable(sd, true);
 
-	v4l2_dbg(1, debug, sd, "%s: irq %x, %x, %x, %x, %x\n", __func__,
+	v4l2_dbg(1, debug, sd, "%s: irq %x, %x, %x, %x, %x, %x\n", __func__,
 		 irq_status[0], irq_status[1], irq_status[2],
-		 irq_status[3], irq_status[4]);
+		 irq_status[3], irq_status[4], irq_status[5]);
 
 	/* format change CP */
 	fmt_change_cp = irq_status[0] & 0x9c;
@@ -1891,22 +1897,32 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	else
 		fmt_change_digital = 0;
 
-	/* notify */
+	/* format change */
 	if (fmt_change_cp || fmt_change_digital || fmt_change_sdp) {
 		v4l2_dbg(1, debug, sd,
 			 "%s: fmt_change_cp = 0x%x, fmt_change_digital = 0x%x, fmt_change_sdp = 0x%x\n",
 			 __func__, fmt_change_cp, fmt_change_digital,
 			 fmt_change_sdp);
 		v4l2_subdev_notify(sd, ADV7842_FMT_CHANGE, NULL);
+		if (handled)
+			*handled = true;
 	}
 
-	/* 5v cable detect */
-	if (irq_status[2])
-		adv7842_s_detect_tx_5v_ctrl(sd);
-
-	if (handled)
-		*handled = true;
+	/* HDMI/DVI mode */
+	if (irq_status[5] & 0x08) {
+		v4l2_dbg(1, debug, sd, "%s: irq %s mode\n", __func__,
+			 (io_read(sd, 0x65) & 0x08) ? "HDMI" : "DVI");
+		if (handled)
+			*handled = true;
+	}
 
+	/* tx 5v detect */
+	if (irq_status[2] & 0x3) {
+		v4l2_dbg(1, debug, sd, "%s: irq tx_5v\n", __func__);
+		adv7842_s_detect_tx_5v_ctrl(sd);
+		if (handled)
+			*handled = true;
+	}
 	return 0;
 }
 
-- 
1.8.4.4

