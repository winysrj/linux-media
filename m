Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56411 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbbGTJs3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 05:48:29 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8DD732A0095
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 11:47:23 +0200 (CEST)
Message-ID: <55ACC3AB.8050204@xs4all.nl>
Date: Mon, 20 Jul 2015 11:47:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tc358743: remove unused variable
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bt pointer was never used, remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 4e8811c..9447d88 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1316,7 +1316,6 @@ static int tc358743_s_dv_timings(struct v4l2_subdev *sd,
 				 struct v4l2_dv_timings *timings)
 {
 	struct tc358743_state *state = to_state(sd);
-	struct v4l2_bt_timings *bt;
 
 	if (!timings)
 		return -EINVAL;
@@ -1330,8 +1329,6 @@ static int tc358743_s_dv_timings(struct v4l2_subdev *sd,
 		return 0;
 	}
 
-	bt = &timings->bt;
-
 	if (!v4l2_valid_dv_timings(timings,
 				&tc358743_timings_cap, NULL, NULL)) {
 		v4l2_dbg(1, debug, sd, "%s: timings out of range\n", __func__);
