Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2605 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3LTJcC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 23/50] adv7604: return immediately if the new timings are equal to what is configured
Date: Fri, 20 Dec 2013 10:31:16 +0100
Message-Id: <1387531903-20496-24-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 912c59e..0bc9e1a 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1423,6 +1423,11 @@ static int adv7604_s_dv_timings(struct v4l2_subdev *sd,
 	if (!timings)
 		return -EINVAL;
 
+	if (v4l2_match_dv_timings(&state->timings, timings, 0)) {
+		v4l2_dbg(1, debug, sd, "%s: no change\n", __func__);
+		return 0;
+	}
+
 	bt = &timings->bt;
 
 	if ((is_analog_input(sd) && bt->pixelclock > 170000000) ||
-- 
1.8.4.4

