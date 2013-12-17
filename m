Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3597 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3LQNSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 08:18:55 -0500
Message-ID: <52B04EC5.5080303@xs4all.nl>
Date: Tue, 17 Dec 2013 14:16:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 23/22] adv7842: return 0 if no change in s_dv_timings
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl> <9e9eaa702db4b0e0626dbf7200578e66d8281312.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <9e9eaa702db4b0e0626dbf7200578e66d8281312.1386687810.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return 0 if the new timings are equal to the current timings as
it caused extra cp-loss/lock interrupts.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index bafe3b5..82c57d7 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1453,6 +1453,11 @@ static int adv7842_s_dv_timings(struct v4l2_subdev *sd,
 	if (state->mode == ADV7842_MODE_SDP)
 		return -ENODATA;
 
+	if (v4l2_match_dv_timings(&state->timings, timings, 0)) {
+		v4l2_dbg(1, debug, sd, "%s: no change\n", __func__);
+		return 0;
+	}
+
 	bt = &timings->bt;
 
 	if (!v4l2_valid_dv_timings(timings, adv7842_get_dv_timings_cap(sd),
-- 
1.8.4.rc3


