Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4284 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3LTJcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 28/50] adv7842: properly enable/disable the irqs.
Date: Fri, 20 Dec 2013 10:31:21 +0100
Message-Id: <1387531903-20496-29-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

The method of disabling the irq-output pin caused many "empty"
interrupts. Instead, actually disable/enable the interrupts by
changing the interrupt masks.

Also enable STORE_MASKED_IRQ in INT1 configuration, otherwise when HDMI
events happen while the interrupt is masked those events will be ignored
when the interrupt is unmasked.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 6434a93..cbbfa77 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1786,10 +1786,8 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	struct adv7842_state *state = to_state(sd);
 	u8 fmt_change_cp, fmt_change_digital, fmt_change_sdp;
 	u8 irq_status[5];
-	u8 irq_cfg = io_read(sd, 0x40);
 
-	/* disable irq-pin output */
-	io_write(sd, 0x40, irq_cfg | 0x3);
+	adv7842_irq_enable(sd, false);
 
 	/* read status */
 	irq_status[0] = io_read(sd, 0x43);
@@ -1810,6 +1808,8 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	if (irq_status[4])
 		io_write(sd, 0x9e, irq_status[4]);
 
+	adv7842_irq_enable(sd, true);
+
 	v4l2_dbg(1, debug, sd, "%s: irq %x, %x, %x, %x, %x\n", __func__,
 		 irq_status[0], irq_status[1], irq_status[2],
 		 irq_status[3], irq_status[4]);
@@ -1845,9 +1845,6 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	if (handled)
 		*handled = true;
 
-	/* re-enable irq-pin output */
-	io_write(sd, 0x40, irq_cfg);
-
 	return 0;
 }
 
@@ -2446,7 +2443,7 @@ static int adv7842_core_init(struct v4l2_subdev *sd,
 	io_write(sd, 0x33, 0x40);
 
 	/* interrupts */
-	io_write(sd, 0x40, 0xe2); /* Configure INT1 */
+	io_write(sd, 0x40, 0xf2); /* Configure INT1 */
 
 	adv7842_irq_enable(sd, true);
 
-- 
1.8.4.4

