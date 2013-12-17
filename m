Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1267 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3LQNQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 08:16:42 -0500
Message-ID: <52B04E3E.2040400@xs4all.nl>
Date: Tue, 17 Dec 2013 14:14:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 16/15] adv7604: return immediately if the new timings
 are equal to what is configured
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl> <785a2a2445d00fa190ea7cea4671c43fb68e2da5.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <785a2a2445d00fa190ea7cea4671c43fb68e2da5.1386681716.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index cfeaaaf..a1fa9a0 100644
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
1.8.4.rc3


