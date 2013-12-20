Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4820 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3LTJb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 05/50] adv7511: disable register reset by HPD
Date: Fri, 20 Dec 2013 10:30:58 +0100
Message-Id: <1387531903-20496-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Whenever the hotplug pin is pulled low the chip resets a whole bunch
of registers. It turns out that this can be turned off on the adv7511.
Do so, as this 'feature' introduces race conditions in setting up
registers, particular when the hotplug pin bounces a lot.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 7c8d971..89ea266 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1038,6 +1038,12 @@ static void adv7511_init_setup(struct v4l2_subdev *sd)
 
 	/* clear all interrupts */
 	adv7511_wr(sd, 0x96, 0xff);
+	/*
+	 * Stop HPD from resetting a lot of registers.
+	 * It might leave the chip in a partly un-initialized state,
+	 * in particular with regards to hotplug bounces.
+	 */
+	adv7511_wr_and_or(sd, 0xd6, 0x3f, 0xc0);
 	memset(edid, 0, sizeof(struct adv7511_state_edid));
 	state->have_monitor = false;
 	adv7511_set_isr(sd, false);
-- 
1.8.4.4

