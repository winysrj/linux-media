Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:4189 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbbLJOAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 09:00:40 -0500
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH] tc358743: Print timings only when debug level is set
Date: Thu, 10 Dec 2015 15:00:31 +0100
Message-Id: <1449756031-456-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
---
 drivers/media/i2c/tc358743.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index cc38896..e9129d1 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -857,15 +857,16 @@ static void tc358743_format_change(struct v4l2_subdev *sd)
 	if (tc358743_get_detected_timings(sd, &timings)) {
 		enable_stream(sd, false);
 
-		v4l2_dbg(1, debug, sd, "%s: Format changed. No signal\n",
+		v4l2_dbg(1, debug, sd, "%s: No signal\n",
 				__func__);
 	} else {
 		if (!v4l2_match_dv_timings(&state->timings, &timings, 0, false))
 			enable_stream(sd, false);
 
-		v4l2_print_dv_timings(sd->name,
-				"tc358743_format_change: Format changed. New format: ",
-				&timings, false);
+		if (debug)
+			v4l2_print_dv_timings(sd->name,
+					"tc358743_format_change: New format: ",
+					&timings, false);
 	}
 
 	if (sd->devnode)
-- 
2.5.0

