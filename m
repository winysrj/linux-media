Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2537 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3LJMLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 07:11:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/6] adv7511: disable register reset by HPD
Date: Tue, 10 Dec 2013 13:08:53 +0100
Message-Id: <3b89b738d53272474fc1de43bf4e61b21d771faa.1386677238.git.hans.verkuil@cisco.com>
In-Reply-To: <1386677334-20953-1-git-send-email-hverkuil@xs4all.nl>
References: <1386677334-20953-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5857a9bc34d88ef46d61c9d25d11117ac874afc4.1386677238.git.hans.verkuil@cisco.com>
References: <5857a9bc34d88ef46d61c9d25d11117ac874afc4.1386677238.git.hans.verkuil@cisco.com>
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
1.8.4.rc3

