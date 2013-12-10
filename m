Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1504 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3LJPGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/22] adv7842: properly enable/disable the irqs.
Date: Tue, 10 Dec 2013 16:03:49 +0100
Message-Id: <ab300a849c957080e2a962b73865103d6b26d0c5.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

The method of disabling the irq-output pin caused many "empty"
interrupts. Instead, actually disable/enable the interrupts by
changing the interrupt masks.

Also enable STORE_MASKED_IRQ in INT1 configuration.

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
1.8.4.rc3

